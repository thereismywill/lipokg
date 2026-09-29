#!/usr/bin/env python3
"""
Phase S1 Day 2: KEGG + WikiPathways Import
导入KEGG胆固醇代谢通路(hsa04979)和WikiPathways脂蛋白相关通路
"""

import os
import sys
import csv
import time
import requests
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from shared.neo4j_utils import get_driver

# ============================================================
# 配置
# ============================================================
DATA_DIR = Path(__file__).parent.parent / "data" / "external"
DATA_DIR.mkdir(exist_ok=True, parents=True)
OUTPUT_DIR = Path("output/p4_s1_pathways")
OUTPUT_DIR.mkdir(exist_ok=True, parents=True)

print("=" * 70)
print("Phase S1 Day 2: KEGG + WikiPathways Import")
print("=" * 70)

# ============================================================
# Step 1: 下载KEGG hsa04979通路数据
# ============================================================
print("\n[Step 1] Downloading KEGG cholesterol metabolism pathway (hsa04979)...")

kegg_url = "https://rest.kegg.jp/get/hsa04979/kgml"
kegg_file = DATA_DIR / "kegg_hsa04979.xml"

if not kegg_file.exists():
    try:
        resp = requests.get(kegg_url, timeout=30)
        resp.raise_for_status()
        with open(kegg_file, 'w') as f:
            f.write(resp.text)
        print(f"  Downloaded KEGG pathway: {kegg_file.stat().st_size} bytes")
    except Exception as e:
        print(f"  ✗ KEGG download failed: {e}")
        print("  Using cached data if available...")
else:
    print(f"  KEGG file exists: {kegg_file.stat().st_size} bytes")

# ============================================================
# Step 2: 解析KEGG KGML格式
# ============================================================
print("\n[Step 2] Parsing KEGG KGML...")

import xml.etree.ElementTree as ET

kegg_genes = set()
kegg_reactions = []
kegg_relations = []

if kegg_file.exists():
    try:
        tree = ET.parse(kegg_file)
        root = tree.getroot()

        # 解析基因节点
        for entry in root.findall('entry'):
            entry_type = entry.get('type')
            if entry_type == 'gene':
                names = entry.get('name', '').split()
                for name in names:
                    if name.startswith('hsa:'):
                        gene_id = name.replace('hsa:', '')
                        kegg_genes.add(gene_id)

        # 解析反应
        for reaction in root.findall('reaction'):
            rxn_id = reaction.get('name')
            rxn_name = reaction.get('name')
            substrates = [s.get('name') for s in reaction.findall('substrate')]
            products = [p.get('name') for p in reaction.findall('product')]
            kegg_reactions.append({
                'id': rxn_id,
                'name': rxn_name,
                'substrates': substrates,
                'products': products
            })

        # 解析关系（基因-基因互作）
        for relation in root.findall('relation'):
            entry1 = relation.get('entry1')
            entry2 = relation.get('entry2')
            rel_type = relation.get('type')
            kegg_relations.append({
                'entry1': entry1,
                'entry2': entry2,
                'type': rel_type
            })

        print(f"  KEGG genes: {len(kegg_genes)}")
        print(f"  KEGG reactions: {len(kegg_reactions)}")
        print(f"  KEGG relations: {len(kegg_relations)}")

    except Exception as e:
        print(f"  ✗ KEGG parsing failed: {e}")
else:
    print("  ⚠ KEGG file not found")

# ============================================================
# Step 3: 下载WikiPathways脂蛋白相关通路
# ============================================================
print("\n[Step 3] Downloading WikiPathways lipoprotein pathways...")

# WikiPathways API - search for lipoprotein pathways in human
wp_search_url = "https://webservice.wikipathways.org/findPathwaysByText"
wp_pathways = []

search_terms = ["lipoprotein", "cholesterol", "lipid metabolism", "HDL", "LDL"]

for term in search_terms:
    try:
        params = {
            'query': term,
            'species': 'Homo sapiens',
            'format': 'json'
        }
        resp = requests.get(wp_search_url, params=params, timeout=10)
        if resp.status_code == 200:
            data = resp.json()
            if 'result' in data:
                for pathway in data['result']:
                    wp_id = pathway.get('id')
                    wp_name = pathway.get('name')
                    if wp_id and wp_name:
                        wp_pathways.append({
                            'id': wp_id,
                            'name': wp_name,
                            'search_term': term
                        })
        time.sleep(0.5)  # Rate limiting
    except Exception as e:
        print(f"  ⚠ WikiPathways search failed for '{term}': {e}")

# 去重
wp_pathways_unique = {p['id']: p for p in wp_pathways}.values()
print(f"  Found {len(wp_pathways_unique)} unique WikiPathways")

# ============================================================
# Step 4: 导入KEGG通路到Neo4j
# ============================================================
print("\n[Step 4] Importing KEGG pathway to Neo4j...")

driver = get_driver()

# 4a. 创建KEGG通路节点
with driver.session() as session:
    session.run("""
        MERGE (p:KEGGPathway {id: 'hsa04979'})
        SET p.name = 'Cholesterol metabolism',
            p.source = 'KEGG',
            p.organism = 'Homo sapiens',
            p.url = 'https://www.kegg.jp/pathway/hsa04979'
    """)
    print("  ✓ Created KEGG pathway node: hsa04979")

# 4b. 导入KEGG基因（简化版：只记录基因ID）
if kegg_genes:
    print(f"  Importing {len(kegg_genes)} KEGG genes...")
    batch_size = 500
    gene_list = list(kegg_genes)

    for i in range(0, len(gene_list), batch_size):
        batch = gene_list[i:i+batch_size]
        nodes_data = [{'kegg_id': gid} for gid in batch]

        with driver.session() as session:
            session.run("""
                UNWIND $nodes AS node
                MERGE (g:KEGGGene {kegg_id: node.kegg_id})
                SET g.source = 'KEGG'
            """, nodes=nodes_data)

    print(f"  ✓ Created {len(kegg_genes)} KEGG gene nodes")

    # 4c. 关联KEGG基因到通路
    with driver.session() as session:
        session.run("""
            MATCH (g:KEGGGene)
            MATCH (p:KEGGPathway {id: 'hsa04979'})
            MERGE (g)-[:BELONGS_TO_PATHWAY]->(p)
        """)
        print(f"  ✓ Linked KEGG genes to pathway")

# 4d. 关联KEGG基因到现有Molecule和STRINGProtein节点
print("  Linking KEGG genes to existing nodes...")
with driver.session() as session:
    # 尝试通过基因符号关联（需要KEGG基因符号映射）
    # 这里简化处理，只创建占位关系
    result = session.run("""
        MATCH (kg:KEGGGene)
        MATCH (m:Molecule)
        WHERE kg.kegg_id = m.kegg_id OR kg.kegg_id = m.gene_id
        MERGE (kg)-[:MAPS_TO]->(m)
        RETURN count(*) AS linked
    """)
    linked = result.single()['linked']
    print(f"  ✓ Linked {linked} KEGG genes to Molecule nodes")

# ============================================================
# Step 5: 导入WikiPathways到Neo4j
# ============================================================
print("\n[Step 5] Importing WikiPathways to Neo4j...")

if wp_pathways_unique:
    batch_size = 50
    wp_list = list(wp_pathways_unique)

    for i in range(0, len(wp_list), batch_size):
        batch = wp_list[i:i+batch_size]
        nodes_data = [{'id': p['id'], 'name': p['name']} for p in batch]

        with driver.session() as session:
            session.run("""
                UNWIND $nodes AS node
                MERGE (wp:WikiPathway {id: node.id})
                SET wp.name = node.name,
                    wp.source = 'WikiPathways',
                    wp.url = 'https://www.wikipathways.org/pathways/' + node.id
            """, nodes=nodes_data)

    print(f"  ✓ Created {len(wp_pathways_unique)} WikiPathway nodes")

# ============================================================
# Step 6: 验证并统计
# ============================================================
print("\n[Step 6] Verifying pathway imports...")

with driver.session() as session:
    total_nodes = session.run("MATCH (n) RETURN count(n) AS c").single()['c']
    total_edges = session.run("MATCH ()-[r]->() RETURN count(r) AS c").single()['c']

    kegg_genes = session.run("MATCH (n:KEGGGene) RETURN count(n) AS c").single()['c']
    kegg_pathways = session.run("MATCH (n:KEGGPathway) RETURN count(n) AS c").single()['c']
    wp_pathways = session.run("MATCH (n:WikiPathway) RETURN count(n) AS c").single()['c']

    print(f"\n  {'='*50}")
    print(f"  Updated Graph Statistics:")
    print(f"  {'='*50}")
    print(f"  Total nodes:        {total_nodes:,}")
    print(f"  Total edges:        {total_edges:,}")
    print(f"  KEGG genes:         {kegg_genes:,}")
    print(f"  KEGG pathways:      {kegg_pathways:,}")
    print(f"  WikiPathways:       {wp_pathways:,}")
    print(f"  {'='*50}")

# ============================================================
# Step 7: 保存导入报告
# ============================================================
print("\n[Step 7] Saving import report...")

report = f"""# KEGG + WikiPathways Import Report

## Date
{time.strftime('%Y-%m-%d %H:%M:%S')}

## KEGG Import
- Pathway: hsa04979 (Cholesterol metabolism)
- Genes parsed from KGML: {len(kegg_genes) if isinstance(kegg_genes, set) else kegg_genes}
- Reactions: {len(kegg_reactions)}
- Relations: {len(kegg_relations)}

## WikiPathways Import
- Search terms: {', '.join(search_terms)}
- Pathways found: {len(wp_pathways_unique)}

## Neo4j Results
- KEGG gene nodes created: {kegg_genes if isinstance(kegg_genes, int) else len(kegg_genes)}
- KEGG pathway nodes: {kegg_pathways}
- WikiPathway nodes: {wp_pathways}

## Updated Graph
- Total nodes: {total_nodes:,}
- Total edges: {total_edges:,}
"""

with open(OUTPUT_DIR / "pathway_import_report.md", "w") as f:
    f.write(report)

print(f"  Saved: {OUTPUT_DIR / 'pathway_import_report.md'}")

driver.close()

print("\n" + "=" * 70)
print("✓ Phase S1 Day 2 Complete!")
print("=" * 70)
