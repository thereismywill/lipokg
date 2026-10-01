# Figure inputs

These seven supplementary tables are the only supplementary files the figure scripts in
`scripts/figure_scripts/` read, and they are included here so that every script runs
directly after a fresh clone.

| File | Used by | Content |
|---|---|---|
| `Table_S1_Seed_Genes.csv` | `gen_fig3_coverage.py` | The 82 curated seed genes (HGNC symbols) |
| `Table_S2_Coverage_Analysis.csv` | `figure_style.py` (via `load_coverage_table()`), `gen_fig3_coverage.py` panel A | Per-database pathway coverage (KEGG / Reactome / WikiPathways) |
| `Table_S18_Gap_Score_Validation.csv` | `gen_fig5_usecases.py` (panel A) | Use Case 1 annotation-gap discovery |
| `Table_S19_Rediscovery_Test.csv` | `gen_fig5_usecases.py` (panel B, E) | Use Case 2/5 target prioritisation and repurposing candidates |
| `Table_S20_Target_Neighborhood.csv` | `gen_fig5_usecases.py` (panel D) | Use Case 4 target-neighbourhood composition |
| `Table_S22_Modularity_Analysis.csv` | `gen_supp_figures.py` (Figure S3) | Louvain modules (9 modules, Q = 0.51) with gene lists |
| `Table_S24_Gene_Level_Coverage.csv` | `gen_fig3_coverage.py` (panel C) | Per-gene annotation depth across the four non-STRING layers |

All other graph-scale numbers are read from `data/graph_statistics.json`, and the KEGG pathway
identifier from `data/pathways.csv`; no counts are hard-coded in the scripts, so re-running them
after any data change stays consistent by construction.

The **complete** supplementary table set (S1–S31) is deposited with the manuscript. Panel C of
Figure 5 is computed directly from `data/clinvar_relationships.csv` and
`data/disease_associations.csv`, so it needs no supplementary input.
