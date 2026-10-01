# LipoKG Integration Pipeline

Scripts that build the LipoKG knowledge graph (v1.2.1). The graph was constructed in
Python using the Neo4j Python driver and Cypher `CREATE` statements (not `LOAD CSV`).

## Run order

```bash
# 1. Seed gene set
python pipeline/shared/build_seed_genes.py

# 2. Data import (Day 1–7)
python pipeline/p4_s1_string_import.py
python pipeline/p4_s1_pathway_import.py
python pipeline/p4_s1_clinvar_drugbank.py
python pipeline/p4_s1_technical_validation.py        # or _robust variant
python pipeline/p4_s1_zenodo_export.py               # exports the Zenodo CSV package

# One-shot:
bash pipeline/run_all.sh
```

## Contents

| Path | Purpose |
|---|---|
| `pipeline/p4_s1_*.py` | Six ETL steps: STRING import, pathway import, ClinVar/DrugBank, technical validation, Zenodo export |
| `pipeline/shared/` | `build_seed_genes.py` (82-gene seed set), `neo4j_utils.py` (Neo4j driver) |
| `pipeline/cypher/*.cypher` | Cypher layer scripts (Reactome layer, clinical layer, inflammation axis, etc.) |
| `pipeline/run_all.sh` | Top-level runner |

## Connection

Neo4j connection is configured in `pipeline/shared/neo4j_utils.py` (bolt://localhost:7687).

## Note

The ETL run reports of 2026-06-22 are archived under `data/raw/` (`string/string_v12_import_report.md`, `pathways/pathway_import_report.md`,
`clinvar_drugbank/clinvar_drugbank_report.md`). They record the per-step counts of that first
loading — 1,852 proteins and 31,878 interactions, but also 8,394 nodes / 38,865 edges for the
full in-database graph, in which the ClinVar layer held 6,050 variant nodes and the KEGG layer the
then-current 52 genes. Those counts are **superseded** by the deposited package (v1.2.1), which
exports a curated subset: 6,214 core nodes / 36,568 core edges after the KEGG, Reactome and
WikiPathways re-retrievals. See the graph-size convention in the accompanying manuscript.
