#!/usr/bin/env python3
"""
Phase S1 Day 4-5: Technical Validation
与KEGG、Reactome、WikiPathways进行覆盖度对比分析
"""

import os
import sys
import csv
import json
import requests
import time
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from shared.neo4j_utils import get_driver

# ============================================================
# 配置
# ============================================================
DATA_DIR = Path(__file__).parent.parent / "data" / "external"
OUTPUT_DIR = Path("output/p4_s1_validation")
DATA_DIR.mkdir(exist_ok=True, parents=True)
OUTPUT_DIR.mkdir(exist_ok=True, parents=True)

print("=" * 70)
print("Phase S1 Day 4-5: Technical Validation")
print("=" * 70)

# ============================================================
# Step 1: 从Neo4j提取当前图谱的基因集合
# ============================================================
print("\n[Step 1] Extracting current gene set from Neo4j...")

driver = get_driver()
with driver.session() as session:
    # 提取所有STRING蛋白节点
    result = session.run("""
        MATCH (n:STRINGProtein)
        RETURN n.name AS gene_symbol, n.ensembl_id AS ensembl_id
    """)
    current_genes = {}
    for record in result:
        gene = record['gene_symbol']
        if gene:
            current_genes[gene] = record['ensembl_id']

    # 提取Molecule节点
    result = session.run("""
        MATCH (n:Molecule)
        RETURN n.name AS gene_symbol
    """)
    for record in result:
        gene = record['gene_symbol']
        if gene and gene not in current_genes:
            current_genes[gene] = None

print(f"  Current graph contains {len(current_genes)} unique genes")

# ============================================================
# Step 2: 下载KEGG hsa04979 (Lipid and atherosclerosis)
# ============================================================
print("\n[Step 2] Downloading KEGG hsa04979 pathway data...")

kegg_url = "https://rest.kegg.jp/get/hsa04979/kgml"
kegg_file = DATA_DIR / "kegg_hsa04979.kgml"

if not kegg_file.exists():
    try:
        resp = requests.get(kegg_url, timeout=30)
        resp.raise_for_status()
        with open(kegg_file, 'w') as f:
            f.write(resp.text)
        print(f"  ✓ Downloaded KEGG pathway: {kegg_file.stat().st_size / 1024:.1f} KB")
    except Exception as e:
        print(f"  ✗ Download failed: {e}")
else:
    print(f"  ✓ File exists: {kegg_file.stat().st_size / 1024:.1f} KB")

# 解析KEGG KGML
kegg_genes = set()
kegg_interactions = []

if kegg_file.exists():
    import xml.etree.ElementTree as ET
    tree = ET.parse(kegg_file)
    root = tree.getroot()

    # 提取基因节点
    for entry in root.findall('.//entry[@type="gene"]'):
        names = entry.get('name', '').split()
        for name in names:
            # KEGG基因ID格式: hsa:1234
            if name.startswith('hsa:'):
                gene_id = name.replace('hsa:', '')
                kegg_genes.add(gene_id)

    # 提取关系（PPrel: protein-protein interaction）
    for relation in root.findall('.//relation[@type="PPrel"]'):
        entry1 = relation.get('entry1')
        entry2 = relation.get('entry2')
        rel_type = relation.get('type')
        kegg_interactions.append({
            'entry1': entry1,
            'entry2': entry2,
            'type': rel_type
        })

print(f"  KEGG hsa04979 contains:")
print(f"    - {len(kegg_genes)} genes")
print(f"    - {len(kegg_interactions)} protein-protein interactions")

# ============================================================
# Step 3: 下载Reactome脂蛋白代谢通路
# ============================================================
print("\n[Step 3] Downloading Reactome lipoprotein metabolism pathways...")

# Reactome主要脂蛋白代谢通路
reactome_pathways = {
    'R-HSA-174824': 'Plasma lipoprotein assembly, remodeling, and conversion',
    'R-HSA-176187': 'HDL assembly',
    'R-HSA-176206': 'HDL remodeling',
    'R-HSA-174577': 'Chylomicron assembly',
    'R-HSA-174668': 'Chylomicron remodeling',
    'R-HSA-174752': 'VLDL assembly',
    'R-HSA-174783': 'VLDL remodeling',
    'R-HSA-174809': 'LDL remodeling',
    'R-HSA-8964043': 'LDL clearance',
    'R-HSA-174823': 'Reverse cholesterol transport',
}

reactome_genes = set()
reactome_interactions = []

for pathway_id, pathway_name in reactome_pathways.items():
    url = f"https://reactome.org/ContentService/data/participants/{pathway_id}"
    try:
        resp = requests.get(url, timeout=10)
        if resp.status_code == 200:
            data = resp.json()
            # 提取参与者（基因/蛋白）
            for participant in data:
                if participant.get('type') == 'Protein':
                    gene_symbol = participant.get('name', '').split()[0] if participant.get('name') else None
                    if gene_symbol:
                        reactome_genes.add(gene_symbol)
        time.sleep(0.5)  # Rate limiting
    except Exception as e:
        print(f"  ⚠ Failed to fetch {pathway_id}: {e}")

print(f"  Reactome lipoprotein pathways contain:")
print(f"    - {len(reactome_genes)} unique genes")

# ============================================================
# Step 4: 下载WikiPathways脂代谢通路
# ============================================================
print("\n[Step 4] Downloading WikiPathways lipid metabolism pathways...")

# WikiPathways主要脂代谢通路
wikipathways_ids = [
    'WP5242',  # Lipid metabolism
    'WP4842',  # Lipid droplet metabolism
    'WP5243',  # Lipoprotein metabolism
    'WP5244',  # Cholesterol metabolism
]

wikipathways_genes = set()

for wp_id in wikipathways_ids:
    url = f"https://webservice.wikipathways.org/getPathway?pwId={wp_id}&format=json"
    try:
        resp = requests.get(url, timeout=10)
        if resp.status_code == 200:
            data = resp.json()
            pathway = data.get('pathway', {})
            data_nodes = pathway.get('dataNode', [])
            for node in data_nodes:
                gene_symbol = node.get('textContent')
                if gene_symbol and node.get('type') == 'GeneProduct':
                    wikipathways_genes.add(gene_symbol)
        time.sleep(0.5)
    except Exception as e:
        print(f"  ⚠ Failed to fetch {wp_id}: {e}")

print(f"  WikiPathways lipid pathways contain:")
print(f"    - {len(wikipathways_genes)} unique genes")

# ============================================================
# Step 5: 计算覆盖度统计
# ============================================================
print("\n[Step 5] Computing coverage statistics...")

# 将KEGG基因ID转换为基因符号（需要映射）
# 简化处理：假设KEGG基因ID与基因符号有对应关系
kegg_gene_symbols = set()
for gene_id in kegg_genes:
    # 这里需要KEGG ID到基因符号的映射
    # 简化：使用KEGG API获取基因信息
    url = f"https://rest.kegg.jp/get/hsa:{gene_id}"
    try:
        resp = requests.get(url, timeout=5)
        if resp.status_code == 200:
            lines = resp.text.split('\n')
            for line in lines:
                if line.startswith('SYMBOL'):
                    symbol = line.split(':')[1].strip().split(',')[0].strip()
                    kegg_gene_symbols.add(symbol)
                    break
        time.sleep(0.2)
    except:
        pass

print(f"  Mapped {len(kegg_gene_symbols)} KEGG gene IDs to symbols")

# 计算覆盖度
coverage = {}

# KEGG覆盖度
kegg_in_graph = kegg_gene_symbols & set(current_genes.keys())
coverage['KEGG'] = {
    'total': len(kegg_gene_symbols),
    'covered': len(kegg_in_graph),
    'percentage': (len(kegg_in_graph) / len(kegg_gene_symbols) * 100) if kegg_gene_symbols else 0,
    'missing': kegg_gene_symbols - set(current_genes.keys())
}

# Reactome覆盖度
reactome_in_graph = reactome_genes & set(current_genes.keys())
coverage['Reactome'] = {
    'total': len(reactome_genes),
    'covered': len(reactome_in_graph),
    'percentage': (len(reactome_in_graph) / len(reactome_genes) * 100) if reactome_genes else 0,
    'missing': reactome_genes - set(current_genes.keys())
}

# WikiPathways覆盖度
wikipathways_in_graph = wikipathways_genes & set(current_genes.keys())
coverage['WikiPathways'] = {
    'total': len(wikipathways_genes),
    'covered': len(wikipathways_in_graph),
    'percentage': (len(wikipathways_in_graph) / len(wikipathways_genes) * 100) if wikipathways_genes else 0,
    'missing': wikipathways_genes - set(current_genes.keys())
}

# 打印覆盖度统计
print("\n" + "=" * 70)
print("Coverage Statistics")
print("=" * 70)

for db_name, stats in coverage.items():
    print(f"\n{db_name}:")
    print(f"  Total genes: {stats['total']}")
    print(f"  Covered: {stats['covered']} ({stats['percentage']:.1f}%)")
    print(f"  Missing: {len(stats['missing'])}")
    if stats['missing']:
        missing_list = sorted(list(stats['missing']))[:10]
        print(f"  Sample missing genes: {', '.join(missing_list)}")

# ============================================================
# Step 6: 生成覆盖度对比报告
# ============================================================
print("\n[Step 6] Generating coverage comparison report...")

report = f"""# Technical Validation Report

## Date
{time.strftime('%Y-%m-%d %H:%M:%S')}

## Current Graph Statistics
- Total unique genes: {len(current_genes)}
- STRING proteins: {sum(1 for v in current_genes.values() if v is not None)}

## Coverage Comparison

### KEGG hsa04979 (Lipid and atherosclerosis)
- Total genes in pathway: {coverage['KEGG']['total']}
- Covered in our graph: {coverage['KEGG']['covered']} ({coverage['KEGG']['percentage']:.1f}%)
- Missing genes: {len(coverage['KEGG']['missing'])}

### Reactome Lipoprotein Metabolism Pathways
- Total unique genes: {coverage['Reactome']['total']}
- Covered in our graph: {coverage['Reactome']['covered']} ({coverage['Reactome']['percentage']:.1f}%)
- Missing genes: {len(coverage['Reactome']['missing'])}

### WikiPathways Lipid Metabolism Pathways
- Total unique genes: {coverage['WikiPathways']['total']}
- Covered in our graph: {coverage['WikiPathways']['covered']} ({coverage['WikiPathways']['percentage']:.1f}%)
- Missing genes: {len(coverage['WikiPathways']['missing'])}

## Summary
- Combined unique genes across all databases: {len(kegg_gene_symbols | reactome_genes | wikipathways_genes)}
- Overall coverage: {len((kegg_gene_symbols | reactome_genes | wikipathways_genes) & set(current_genes.keys()))} / {len(kegg_gene_symbols | reactome_genes | wikipathways_genes)} ({len((kegg_gene_symbols | reactome_genes | wikipathways_genes) & set(current_genes.keys())) / len(kegg_gene_symbols | reactome_genes | wikipathways_genes) * 100:.1f}%)

## Missing Genes (Top 20)
"""

# 收集所有缺失基因
all_missing = coverage['KEGG']['missing'] | coverage['Reactome']['missing'] | coverage['WikiPathways']['missing']
missing_list = sorted(list(all_missing))[:20]
report += '\n'.join([f"- {gene}" for gene in missing_list])

# 保存报告
report_file = OUTPUT_DIR / "coverage_validation_report.md"
with open(report_file, 'w') as f:
    f.write(report)

print(f"  ✓ Report saved: {report_file}")

# ============================================================
# Step 7: 生成覆盖度数据文件
# ============================================================
print("\n[Step 7] Generating coverage data files...")

# 保存详细覆盖度数据
coverage_data = {
    'current_genes': list(current_genes.keys()),
    'kegg_genes': list(kegg_gene_symbols),
    'reactome_genes': list(reactome_genes),
    'wikipathways_genes': list(wikipathways_genes),
    'coverage': {k: {**v, 'missing': list(v['missing'])} for k, v in coverage.items()}
}

coverage_file = OUTPUT_DIR / "coverage_data.json"
with open(coverage_file, 'w') as f:
    json.dump(coverage_data, f, indent=2)

print(f"  ✓ Coverage data saved: {coverage_file}")

driver.close()

print("\n" + "=" * 70)
print("✓ Phase S1 Day 4-5 Complete!")
print("=" * 70)
