# ETL run reports (2026-06-22)

Raw output of the first full loading of the graph, kept for provenance:

| Report | Covers |
|---|---|
| `string/string_v12_import_report.md` | STRING v12.0 import (1,852 proteins, 31,878 interactions) |
| `pathways/pathway_import_report.md` | KEGG + WikiPathways import as of 2026-06-22 |
| `clinvar_drugbank/clinvar_drugbank_report.md` | ClinVar + DrugBank import; full in-database graph totals |

⚠️ **These are historical records, not the current dataset description.** They were produced on
2026-06-22 and quote the counts of that loading: the KEGG layer was then `hsa04979` "Cholesterol
metabolism" with 52 genes, the WikiPathways search returned no pathways, and the full in-database
graph held 8,394 nodes / 38,865 edges (the ClinVar layer alone held 6,050 variant nodes).

The deposited package (v1.2.2) supersedes all of them: the KEGG layer is `hsa05417`
"Lipid and atherosclerosis" (216 genes), WikiPathways is a 4-pathway / 92-gene reference set, and the
curated CSV schema is 6,214 core nodes / 36,568 core edges, or 6,639 / 41,497 including the extended
schema. The manuscript's "graph-size convention" paragraph explains why the two count sets differ.
