#!/usr/bin/env python3
"""
Phase S1 Day 1: STRING v12 Import
从STRING v12下载人源蛋白互作数据，筛选84个种子基因的2-hop邻居，导入Neo4j
"""

import os
import sys
import csv
import gzip
import time
import requests
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from shared.neo4j_utils import get_driver

# ============================================================
# 配置
# ============================================================
STRING_URL = "https://stringdb-downloads.org/download/protein.links.v12.0/9606.protein.links.v12.0.txt.gz"
STRING_INFO_URL = "https://stringdb-downloads.org/download/protein.info.v12.0/9606.protein.info.v12.0.txt.gz"
DATA_DIR = Path(__file__).parent.parent / "data" / "external" / "string_v12"
DATA_DIR.mkdir(exist_ok=True, parents=True)
SEED_GENES_FILE = Path(__file__).parent.parent / "data" / "seed_genes.csv"
CONFIDENCE_THRESHOLD = 700  # STRING scores: 0-1000, 700 = high confidence

OUTPUT_DIR = Path("output/p4_s1_string")
OUTPUT_DIR.mkdir(exist_ok=True, parents=True)

print("=" * 70)
print("Phase S1 Day 1: STRING v12 Import")
print("=" * 70)

# ============================================================
# Step 1: 读取种子基因列表
# ============================================================
print("\n[Step 1] Loading seed genes...")
seed_genes = []
with open(SEED_GENES_FILE, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        seed_genes.append(row["symbol"])
print(f"  Loaded {len(seed_genes)} seed genes")

# ============================================================
# Step 2: 下载STRING蛋白信息文件（用于Ensembl→Gene Symbol映射）
# ============================================================
print("\n[Step 2] Downloading STRING protein info (Ensembl→Symbol mapping)...")

info_file = DATA_DIR / "9606.protein.info.v12.0.txt.gz"
if not info_file.exists():
    print(f"  Downloading from {STRING_INFO_URL}...")
    try:
        resp = requests.get(STRING_INFO_URL, timeout=300, stream=True)
        resp.raise_for_status()
        total_size = int(resp.headers.get('content-length', 0))
        downloaded = 0
        with open(info_file, 'wb') as f:
            for chunk in resp.iter_content(chunk_size=8192):
                f.write(chunk)
                downloaded += len(chunk)
                if total_size > 0 and downloaded % (1024*1024*10) < 8192:
                    pct = downloaded / total_size * 100
                    print(f"    {downloaded/(1024*1024):.0f} MB / {total_size/(1024*1024):.0f} MB ({pct:.0f}%)")
        print(f"  Downloaded {info_file.stat().st_size / (1024*1024):.1f} MB")
    except Exception as e:
        print(f"  ✗ Download failed: {e}")
        sys.exit(1)
else:
    print(f"  File exists: {info_file.stat().st_size / (1024*1024):.1f} MB")

# 解析Ensembl→Symbol映射
print("  Parsing protein info...")
ensembl_to_symbol = {}
symbol_to_ensembl = {}

with gzip.open(info_file, 'rt') as f:
    for line in f:
        parts = line.strip().split('\t')
        if len(parts) >= 2:
            ensembl_id = parts[0]  # e.g., 9606.ENSP00000252519
            preferred_name = parts[1]  # e.g., LDLR
            # 去掉物种前缀
            clean_id = ensembl_id.split('.')[-1] if '.' in ensembl_id else ensembl_id
            ensembl_to_symbol[clean_id] = preferred_name
            ensembl_to_symbol[ensembl_id] = preferred_name
            if preferred_name not in symbol_to_ensembl:
                symbol_to_ensembl[preferred_name] = []
            symbol_to_ensembl[preferred_name].append(ensembl_id)

print(f"  Mapped {len(ensembl_to_symbol)} Ensembl IDs → {len(symbol_to_ensembl)} gene symbols")

# 检查种子基因的映射
mapped_seeds = [g for g in seed_genes if g in symbol_to_ensembl]
unmapped_seeds = [g for g in seed_genes if g not in symbol_to_ensembl]
print(f"  Seed genes mapped: {len(mapped_seeds)}/{len(seed_genes)}")
if unmapped_seeds:
    print(f"  Unmapped seeds: {unmapped_seeds[:10]}")

# ============================================================
# Step 3: 下载STRING互作数据
# ============================================================
print("\n[Step 3] Downloading STRING v12 protein links...")

links_file = DATA_DIR / "9606.protein.links.v12.0.txt.gz"
if not links_file.exists():
    print(f"  Downloading from {STRING_URL}...")
    try:
        resp = requests.get(STRING_URL, timeout=600, stream=True)
        resp.raise_for_status()
        total_size = int(resp.headers.get('content-length', 0))
        downloaded = 0
        with open(links_file, 'wb') as f:
            for chunk in resp.iter_content(chunk_size=8192):
                f.write(chunk)
                downloaded += len(chunk)
                if total_size > 0 and downloaded % (1024*1024*50) < 8192:
                    pct = downloaded / total_size * 100
                    print(f"    {downloaded/(1024*1024):.0f} MB / {total_size/(1024*1024):.0f} MB ({pct:.0f}%)")
        print(f"  Downloaded {links_file.stat().st_size / (1024*1024):.1f} MB")
    except Exception as e:
        print(f"  ✗ Download failed: {e}")
        sys.exit(1)
else:
    print(f"  File exists: {links_file.stat().st_size / (1024*1024):.1f} MB")

# ============================================================
# Step 4: 构建种子基因的Ensembl ID集合
# ============================================================
print("\n[Step 4] Building seed gene Ensembl ID set...")

seed_ensembl_ids = set()
for gene in seed_genes:
    if gene in symbol_to_ensembl:
        for eid in symbol_to_ensembl[gene]:
            seed_ensembl_ids.add(eid)

print(f"  Seed Ensembl IDs: {len(seed_ensembl_ids)}")

# ============================================================
# Step 5: 第一遍扫描 - 找1-hop邻居
# ============================================================
print("\n[Step 5] Scanning STRING links - finding 1-hop neighbors...")
start_time = time.time()

# 1-hop: 直接与种子基因互作的蛋白
hop1_edges = []  # (protein1, protein2, score)
hop1_proteins = set()

line_count = 0
with gzip.open(links_file, 'rt') as f:
    for line in f:
        line_count += 1
        if line_count == 1:
            # Skip header line
            continue
        if line_count % 5000000 == 0:
            elapsed = time.time() - start_time
            print(f"    Processed {line_count/1e6:.1f}M lines ({elapsed:.0f}s)...")

        parts = line.strip().split()
        if len(parts) < 3:
            continue

        protein1 = parts[0]
        protein2 = parts[1]
        try:
            score = int(parts[2])
        except ValueError:
            continue

        if score < CONFIDENCE_THRESHOLD:
            continue

        # 检查是否涉及种子基因
        if protein1 in seed_ensembl_ids:
            hop1_proteins.add(protein2)
            hop1_edges.append((protein1, protein2, score))
        elif protein2 in seed_ensembl_ids:
            hop1_proteins.add(protein1)
            hop1_edges.append((protein1, protein2, score))

elapsed = time.time() - start_time
print(f"  Scanned {line_count/1e6:.1f}M lines in {elapsed:.1f}s")
print(f"  1-hop neighbors: {len(hop1_proteins)} proteins")
print(f"  1-hop edges: {len(hop1_edges)}")

# ============================================================
# Step 6: 第二遍扫描 - 找2-hop邻居
# ============================================================
print("\n[Step 6] Scanning STRING links - finding 2-hop neighbors...")
start_time = time.time()

# 2-hop: 1-hop邻居之间的互作
hop2_edges = []
all_proteins = seed_ensembl_ids | hop1_proteins

line_count = 0
with gzip.open(links_file, 'rt') as f:
    for line in f:
        line_count += 1
        if line_count == 1:
            # Skip header line
            continue
        if line_count % 5000000 == 0:
            elapsed = time.time() - start_time
            print(f"    Processed {line_count/1e6:.1f}M lines ({elapsed:.0f}s)...")

        parts = line.strip().split()
        if len(parts) < 3:
            continue

        protein1 = parts[0]
        protein2 = parts[1]
        try:
            score = int(parts[2])
        except ValueError:
            continue

        if score < CONFIDENCE_THRESHOLD:
            continue

        # 检查是否是1-hop邻居之间的互作
        if protein1 in hop1_proteins and protein2 in hop1_proteins:
            hop2_edges.append((protein1, protein2, score))

elapsed = time.time() - start_time
print(f"  Scanned {line_count/1e6:.1f}M lines in {elapsed:.1f}s")
print(f"  2-hop edges: {len(hop2_edges)}")

# ============================================================
# Step 7: 合并所有边
# ============================================================
print("\n[Step 7] Merging all edges...")

all_edges = hop1_edges + hop2_edges

# 去重（保留最高分数）
edge_dict = {}
for p1, p2, score in all_edges:
    key = tuple(sorted([p1, p2]))
    if key not in edge_dict or score > edge_dict[key]:
        edge_dict[key] = score

all_edges_dedup = [(k[0], k[1], v) for k, v in edge_dict.items()]

# 收集所有涉及的蛋白
all_protein_ids = set()
for p1, p2, _ in all_edges_dedup:
    all_protein_ids.add(p1)
    all_protein_ids.add(p2)

print(f"  Total unique edges: {len(all_edges_dedup)}")
print(f"  Total unique proteins: {len(all_protein_ids)}")

# ============================================================
# Step 8: 解析蛋白名称
# ============================================================
print("\n[Step 8] Resolving protein names...")

protein_symbols = {}
for pid in all_protein_ids:
    if pid in ensembl_to_symbol:
        protein_symbols[pid] = ensembl_to_symbol[pid]
    else:
        protein_symbols[pid] = pid  # 使用Ensembl ID作为fallback

# 统计
named_proteins = sum(1 for pid in all_protein_ids if pid in ensembl_to_symbol)
print(f"  Proteins with gene symbols: {named_proteins}/{len(all_protein_ids)}")

# ============================================================
# Step 9: 导入Neo4j
# ============================================================
print("\n[Step 9] Importing into Neo4j...")

driver = get_driver()

# 9a. 创建STRING蛋白节点
print("  Creating STRING protein nodes...")
batch_size = 500
protein_list = list(all_protein_ids)

for i in range(0, len(protein_list), batch_size):
    batch = protein_list[i:i+batch_size]
    nodes_data = []
    for pid in batch:
        symbol = protein_symbols.get(pid, pid)
        is_seed = pid in seed_ensembl_ids
        hop = "seed" if is_seed else ("1-hop" if pid in hop1_proteins else "2-hop")
        nodes_data.append({
            "ensembl_id": pid,
            "name": symbol,
            "is_seed_gene": is_seed,
            "string_hop": hop
        })

    with driver.session() as session:
        session.run("""
            UNWIND $nodes AS node
            MERGE (n:STRINGProtein {ensembl_id: node.ensembl_id})
            SET n.name = node.name,
                n.is_seed_gene = node.is_seed_gene,
                n.string_hop = node.string_hop,
                n.source = 'STRING_v12'
        """, nodes=nodes_data)

    if (i + batch_size) % 2000 == 0:
        print(f"    Created {min(i + batch_size, len(protein_list))}/{len(protein_list)} nodes")

print(f"  ✓ Created {len(protein_list)} STRING protein nodes")

# 9b. 创建STRING互作边
print("  Creating STRING interaction edges...")
edge_batches = [all_edges_dedup[i:i+batch_size] for i in range(0, len(all_edges_dedup), batch_size)]

for batch_idx, batch in enumerate(edge_batches):
    edges_data = []
    for p1, p2, score in batch:
        edges_data.append({
            "protein1": p1,
            "protein2": p2,
            "score": score,
            "normalized_score": score / 1000.0
        })

    with driver.session() as session:
        session.run("""
            UNWIND $edges AS edge
            MATCH (a:STRINGProtein {ensembl_id: edge.protein1})
            MATCH (b:STRINGProtein {ensembl_id: edge.protein2})
            MERGE (a)-[r:STRING_INTERACTS]-(b)
            SET r.score = edge.score,
                r.normalized_score = edge.normalized_score,
                r.source = 'STRING_v12'
        """, edges=edges_data)

    if (batch_idx + 1) % 5 == 0:
        created = (batch_idx + 1) * batch_size
        print(f"    Created {min(created, len(all_edges_dedup))}/{len(all_edges_dedup)} edges")

print(f"  ✓ Created {len(all_edges_dedup)} STRING interaction edges")

# 9c. 将STRING蛋白节点与现有Molecule节点关联
print("  Linking STRING proteins to existing Molecule nodes...")
with driver.session() as session:
    result = session.run("""
        MATCH (sp:STRINGProtein)
        MATCH (m:Molecule)
        WHERE sp.name = m.name
        MERGE (sp)-[r:MAPS_TO]->(m)
        SET r.source = 'name_match'
        RETURN count(r) AS linked
    """)
    linked = result.single()['linked']
    print(f"  ✓ Linked {linked} STRING proteins to existing Molecule nodes")

# ============================================================
# Step 10: 验证扩容后的图谱
# ============================================================
print("\n[Step 10] Verifying expanded graph...")

with driver.session() as session:
    total_nodes = session.run("MATCH (n) RETURN count(n) AS c").single()['c']
    total_edges = session.run("MATCH ()-[r]->() RETURN count(r) AS c").single()['c']
    string_nodes = session.run("MATCH (n:STRINGProtein) RETURN count(n) AS c").single()['c']
    string_edges = session.run("MATCH ()-[r:STRING_INTERACTS]->() RETURN count(r) AS c").single()['c']
    linked = session.run("MATCH ()-[r:MAPS_TO]->() RETURN count(r) AS c").single()['c']

    print(f"\n  {'='*50}")
    print(f"  Expanded Graph Statistics:")
    print(f"  {'='*50}")
    print(f"  Total nodes:        {total_nodes:,} (was 419)")
    print(f"  Total edges:        {total_edges:,} (was 940)")
    print(f"  STRING proteins:    {string_nodes:,}")
    print(f"  STRING interactions:{string_edges:,}")
    print(f"  Cross-references:   {linked:,}")
    print(f"  {'='*50}")
    print(f"  Expansion factor:   {total_nodes/419:.1f}x nodes, {total_edges/940:.1f}x edges")

# ============================================================
# Step 11: 保存导入报告
# ============================================================
print("\n[Step 11] Saving import report...")

report = f"""# STRING v12 Import Report

## Date
{time.strftime('%Y-%m-%d %H:%M:%S')}

## Source
- STRING v12.0 (https://string-db.org)
- Species: Homo sapiens (9606)
- Confidence threshold: {CONFIDENCE_THRESHOLD}/1000

## Seed Genes
- Total seed genes: {len(seed_genes)}
- Mapped to STRING: {len(mapped_seeds)}
- Unmapped: {len(unmapped_seeds)} ({', '.join(unmapped_seeds[:5])})

## 1-Hop Neighbors
- Proteins: {len(hop1_proteins)}
- Edges (seed↔1-hop): {len(hop1_edges)}

## 2-Hop Neighbors
- Edges (1-hop↔1-hop): {len(hop2_edges)}

## Final Import
- Total unique proteins: {len(all_protein_ids)}
- Total unique edges: {len(all_edges_dedup)}
- Proteins with gene symbols: {named_proteins}/{len(all_protein_ids)}

## Neo4j Results
- STRING protein nodes: {string_nodes}
- STRING interaction edges: {string_edges}
- Cross-references (MAPS_TO): {linked}

## Graph Expansion
- Before: 419 nodes, 940 edges
- After: {total_nodes} nodes, {total_edges} edges
- Expansion: {total_nodes/419:.1f}x nodes, {total_edges/940:.1f}x edges
"""

with open(OUTPUT_DIR / "string_v12_import_report.md", "w") as f:
    f.write(report)

print(f"  Saved: {OUTPUT_DIR / 'string_v12_import_report.md'}")

driver.close()

print("\n" + "=" * 70)
print("✓ Phase S1 Day 1 Complete!")
print("=" * 70)
