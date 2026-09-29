#!/usr/bin/env python3
"""
Phase S1 Day 6-7: Data Export and Zenodo Preparation
导出图谱数据并准备Zenodo上传包
"""

import os
import sys
import csv
import json
import time
from pathlib import Path
from datetime import datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from shared.neo4j_utils import get_driver

# ============================================================
# 配置
# ============================================================
OUTPUT_DIR = Path("output/p4_s1_zenodo_package")
OUTPUT_DIR.mkdir(exist_ok=True, parents=True)

DATA_EXPORT_DIR = OUTPUT_DIR / "data"
DATA_EXPORT_DIR.mkdir(exist_ok=True, parents=True)

DOCS_DIR = OUTPUT_DIR / "docs"
DOCS_DIR.mkdir(exist_ok=True, parents=True)

print("=" * 70)
print("Phase S1 Day 6-7: Data Export and Zenodo Preparation")
print("=" * 70)

driver = get_driver()

# ============================================================
# Step 1: Export all nodes
# ============================================================
print("\n[Step 1] Exporting all nodes...")

# STRING Protein nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:STRINGProtein)
        RETURN n.ensembl_id AS ensembl_id, n.name AS name,
               n.description AS description, n.string_id AS string_id
    """)

    string_nodes_file = DATA_EXPORT_DIR / "string_proteins.csv"
    with open(string_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['ensembl_id', 'name', 'description', 'string_id'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'ensembl_id': record['ensembl_id'],
                'name': record['name'],
                'description': record['description'],
                'string_id': record['string_id']
            })
            count += 1

    print(f"  ✓ Exported {count} STRING protein nodes")

# Molecule nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:Molecule)
        RETURN n.name AS name, n.type AS type, n.source AS source
    """)

    molecule_nodes_file = DATA_EXPORT_DIR / "molecules.csv"
    with open(molecule_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'type', 'source'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'name': record['name'],
                'type': record['type'],
                'source': record['source']
            })
            count += 1

    print(f"  ✓ Exported {count} Molecule nodes")

# Disease nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:Disease)
        RETURN n.name AS name, n.source AS source
    """)

    disease_nodes_file = DATA_EXPORT_DIR / "diseases.csv"
    with open(disease_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'source'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'name': record['name'],
                'source': record['source']
            })
            count += 1

    print(f"  ✓ Exported {count} Disease nodes")

# ClinVar Variant nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:ClinVarVariant)
        RETURN n.variant_id AS variant_id, n.clinical_significance AS clinical_significance,
               n.review_status AS review_status
    """)

    clinvar_nodes_file = DATA_EXPORT_DIR / "clinvar_variants.csv"
    with open(clinvar_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['variant_id', 'clinical_significance', 'review_status'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'variant_id': record['variant_id'],
                'clinical_significance': record['clinical_significance'],
                'review_status': record['review_status']
            })
            count += 1

    print(f"  ✓ Exported {count} ClinVar variant nodes")

# KEGG Gene nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:KEGGGene)
        RETURN n.name AS name, n.kegg_id AS kegg_id
    """)

    kegg_nodes_file = DATA_EXPORT_DIR / "kegg_genes.csv"
    with open(kegg_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'kegg_id'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'name': record['name'],
                'kegg_id': record['kegg_id']
            })
            count += 1

    print(f"  ✓ Exported {count} KEGG gene nodes")

# Pathway nodes
with driver.session() as session:
    result = session.run("""
        MATCH (n:Pathway)
        RETURN n.name AS name, n.source AS source, n.pathway_id AS pathway_id
    """)

    pathway_nodes_file = DATA_EXPORT_DIR / "pathways.csv"
    with open(pathway_nodes_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'source', 'pathway_id'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'name': record['name'],
                'source': record['source'],
                'pathway_id': record['pathway_id']
            })
            count += 1

    print(f"  ✓ Exported {count} Pathway nodes")

# ============================================================
# Step 2: Export all relationships
# ============================================================
print("\n[Step 2] Exporting all relationships...")

# STRING interactions
with driver.session() as session:
    result = session.run("""
        MATCH (a:STRINGProtein)-[r:STRING_INTERACTS]->(b:STRINGProtein)
        RETURN a.ensembl_id AS source, b.ensembl_id AS target,
               r.score AS score, r.combined_score AS combined_score
    """)

    string_edges_file = DATA_EXPORT_DIR / "string_interactions.csv"
    with open(string_edges_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['source', 'target', 'score', 'combined_score'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'source': record['source'],
                'target': record['target'],
                'score': record['score'],
                'combined_score': record['combined_score']
            })
            count += 1

    print(f"  ✓ Exported {count} STRING interactions")

# Disease associations
with driver.session() as session:
    result = session.run("""
        MATCH (a)-[r:DISEASE_ASSOCIATION]->(b:Disease)
        RETURN a.name AS source, b.name AS target, r.source AS source_db
    """)

    disease_edges_file = DATA_EXPORT_DIR / "disease_associations.csv"
    with open(disease_edges_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['source', 'target', 'source_db'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'source': record['source'],
                'target': record['target'],
                'source_db': record['source_db']
            })
            count += 1

    print(f"  ✓ Exported {count} disease associations")

# ClinVar relationships
with driver.session() as session:
    result = session.run("""
        MATCH (v:ClinVarVariant)-[r:VARIANT_OF]->(g)
        RETURN v.variant_id AS variant, g.name AS gene, r.clinical_significance AS significance
    """)

    clinvar_edges_file = DATA_EXPORT_DIR / "clinvar_relationships.csv"
    with open(clinvar_edges_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['variant', 'gene', 'significance'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'variant': record['variant'],
                'gene': record['gene'],
                'significance': record['significance']
            })
            count += 1

    print(f"  ✓ Exported {count} ClinVar relationships")

# Pathway memberships
with driver.session() as session:
    result = session.run("""
        MATCH (g)-[r:MEMBER_OF]->(p:Pathway)
        RETURN g.name AS gene, p.name AS pathway, p.source AS source
    """)

    pathway_edges_file = DATA_EXPORT_DIR / "pathway_memberships.csv"
    with open(pathway_edges_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['gene', 'pathway', 'source'])
        writer.writeheader()
        count = 0
        for record in result:
            writer.writerow({
                'gene': record['gene'],
                'pathway': record['pathway'],
                'source': record['source']
            })
            count += 1

    print(f"  ✓ Exported {count} pathway memberships")

# ============================================================
# Step 3: Export graph statistics
# ============================================================
print("\n[Step 3] Exporting graph statistics...")

stats = {}
with driver.session() as session:
    # Node counts by label
    result = session.run("""
        MATCH (n)
        WITH labels(n) AS labels
        UNWIND labels AS label
        RETURN label, COUNT(*) AS count
        ORDER BY count DESC
    """)

    node_stats = {}
    for record in result:
        node_stats[record['label']] = record['count']

    stats['nodes'] = node_stats

    # Edge counts by type
    result = session.run("""
        MATCH ()-[r]->()
        RETURN type(r) AS type, COUNT(*) AS count
        ORDER BY count DESC
    """)

    edge_stats = {}
    for record in result:
        edge_stats[record['type']] = record['count']

    stats['edges'] = edge_stats

    # Total counts
    stats['total_nodes'] = sum(node_stats.values())
    stats['total_edges'] = sum(edge_stats.values())

stats_file = DATA_EXPORT_DIR / "graph_statistics.json"
with open(stats_file, 'w') as f:
    json.dump(stats, f, indent=2)

print(f"  ✓ Exported graph statistics")
print(f"    - Total nodes: {stats['total_nodes']}")
print(f"    - Total edges: {stats['total_edges']}")

# ============================================================
# Step 4: Create Schema Documentation
# ============================================================
print("\n[Step 4] Creating schema documentation...")

schema_doc = """# LipoKG Schema Documentation

## Overview
LipoKG is a comprehensive knowledge graph for lipoprotein metabolism research, integrating data from multiple high-quality sources.

## Node Types

### STRINGProtein
Proteins from STRING database (v12.0)

**Properties:**
- `ensembl_id` (string): Ensembl protein identifier
- `name` (string): Gene symbol
- `description` (string): Protein description
- `string_id` (string): STRING database identifier

### Molecule
Small molecules, drugs, and other molecular entities

**Properties:**
- `name` (string): Molecule name or identifier
- `type` (string): Molecule type (e.g., "drug", "metabolite")
- `source` (string): Data source (e.g., "DrugBank", "HMDB")

### Disease
Disease entities

**Properties:**
- `name` (string): Disease name
- `source` (string): Data source (e.g., "MONDO", "OMIM")

### ClinVarVariant
Genetic variants from ClinVar database

**Properties:**
- `variant_id` (string): ClinVar variant identifier
- `clinical_significance` (string): Clinical significance (e.g., "Pathogenic", "Benign")
- `review_status` (string): Review status in ClinVar

### KEGGGene
Genes from KEGG database

**Properties:**
- `name` (string): Gene symbol
- `kegg_id` (string): KEGG gene identifier

### Pathway
Biological pathways

**Properties:**
- `name` (string): Pathway name
- `source` (string): Data source (e.g., "KEGG", "Reactome", "WikiPathways")
- `pathway_id` (string): Pathway identifier

## Relationship Types

### STRING_INTERACTS
Protein-protein interactions from STRING database

**Properties:**
- `score` (float): Interaction confidence score (0-1000)
- `combined_score` (float): Combined interaction score

### DISEASE_ASSOCIATION
Associations between genes/proteins and diseases

**Properties:**
- `source` (string): Data source (e.g., "DisGeNET", "OMIM")

### VARIANT_OF
Links ClinVar variants to their associated genes

**Properties:**
- `clinical_significance` (string): Clinical significance of the variant

### MEMBER_OF
Links genes to pathways they participate in

**Properties:**
- None

## Data Sources

### STRING v12.0
- **Coverage:** {string_count} proteins
- **Interactions:** {string_edges} protein-protein interactions
- **Confidence threshold:** 700 (high confidence)
- **URL:** https://string-db.org

### ClinVar
- **Coverage:** {clinvar_count} pathogenic variants
- **Genes:** Variants in lipoprotein metabolism genes
- **URL:** https://www.ncbi.nlm.nih.gov/clinvar/

### KEGG
- **Pathway:** hsa04979 (Lipid and atherosclerosis)
- **Coverage:** {kegg_count} genes
- **URL:** https://www.kegg.jp

### Reactome
- **Pathways:** 10 lipoprotein metabolism pathways
- **Coverage:** {reactome_count} genes
- **URL:** https://reactome.org

### WikiPathways
- **Pathways:** 4 lipid metabolism pathways
- **Coverage:** {wikipathways_count} genes
- **URL:** https://www.wikipathways.org

## Statistics

- **Total nodes:** {total_nodes}
- **Total edges:** {total_edges}
- **Node types:** {node_types}
- **Edge types:** {edge_types}

## Coverage Validation

- **KEGG hsa04979:** 89.5% coverage (119/133 genes)
- **Reactome lipoprotein pathways:** 81.8% coverage (45/55 genes)
- **WikiPathways lipid pathways:** 87.7% coverage (71/81 genes)
- **Overall coverage:** 82.2% (162/197 unique genes)

## Version Information

- **Version:** 1.0.0
- **Release date:** {release_date}
- **Data collection date:** {collection_date}
""".format(
    string_count=stats['nodes'].get('STRINGProtein', 0),
    string_edges=stats['edges'].get('STRING_INTERACTS', 0),
    clinvar_count=stats['nodes'].get('ClinVarVariant', 0),
    kegg_count=stats['nodes'].get('KEGGGene', 0),
    reactome_count=45,  # From validation
    wikipathways_count=71,  # From validation
    total_nodes=stats['total_nodes'],
    total_edges=stats['total_edges'],
    node_types=len(stats['nodes']),
    edge_types=len(stats['edges']),
    release_date=datetime.now().strftime('%Y-%m-%d'),
    collection_date=datetime.now().strftime('%Y-%m-%d')
)

schema_file = DOCS_DIR / "SCHEMA.md"
with open(schema_file, 'w') as f:
    f.write(schema_doc)

print(f"  ✓ Created schema documentation")

driver.close()

print("\n" + "=" * 70)
print("✓ Phase S1 Day 6-7 Complete!")
print("=" * 70)
print(f"\nZenodo package prepared at: {OUTPUT_DIR}")
print(f"\nFiles created:")
print(f"  - data/string_proteins.csv")
print(f"  - data/molecules.csv")
print(f"  - data/diseases.csv")
print(f"  - data/clinvar_variants.csv")
print(f"  - data/kegg_genes.csv")
print(f"  - data/pathways.csv")
print(f"  - data/string_interactions.csv")
print(f"  - data/disease_associations.csv")
print(f"  - data/clinvar_relationships.csv")
print(f"  - data/pathway_memberships.csv")
print(f"  - data/graph_statistics.json")
print(f"  - docs/SCHEMA.md")
