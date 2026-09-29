# LipoKG Integration Pipeline

Scripts that build the LipoKG knowledge graph (v1.2.0). The graph was constructed in
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

The ETL run reports (STRING / pathway / ClinVar-DrugBank import results) are archived in the
project repository under `data/raw/<source>/<source>_report.md` and record the authoritative
per-step counts (e.g. 1,852 proteins, 31,878 interactions, 8,394 nodes / 38,865 edges in the
full in-database graph). The deposited CSV package (v1.2.0) exports a curated subset of this graph.
