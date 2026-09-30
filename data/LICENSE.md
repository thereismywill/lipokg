# LipoKG v1.2.0 — Layered Licensing

LipoKG is an **integrated knowledge graph** that aggregates data from multiple public
resources whose terms of use differ. Following guidance from the GigaScience editorial
office, the dataset is released under a **layered licence**: components that can be
released under CC0 are released under CC0, while layers derived from sources with more
restrictive terms retain their respective licences. **The licence applicable to each file
(and, for the disease layer, each source within the file) is indicated below.**

> The whole-package CC BY 4.0 label that appears in repository metadata is a convenient
> default and **does not override** the per-layer terms below. Where a layer inherits a
> non-permissive term (CC BY-NC-SA, academic-use-only, or proprietary), that term governs
> the corresponding rows.

---

## 1. Per-file licence map

| File | Content | Source(s) | Licence |
|---|---|---|---|
| `particles.csv` | Lipoprotein particle definitions | Curated by the authors | **CC0** |
| `particle_protein_links.csv` | Particle–protein composition | Curated by the authors | **CC0** |
| `assembly_links.csv` | Particle assembly relations | Curated by the authors | **CC0** |
| `enzyme_particle_links.csv` | Enzyme–particle modification | Curated by the authors | **CC0** |
| `string_proteins.csv` | Protein nodes | STRING v12.0 | **CC BY 4.0** |
| `string_interactions.csv` | Protein–protein interactions | STRING v12.0 | **CC BY 4.0** |
| `clinvar_variants.csv` | Variant nodes | ClinVar | Public domain (CC0-equivalent) |
| `clinvar_relationships.csv` | Variant–gene edges | ClinVar | Public domain (CC0-equivalent) |
| `kegg_genes.csv` | KEGG genes (hsa04979) | KEGG | **Academic use only** (see §3) |
| `pathways.csv` | Pathway nodes | KEGG (1) / Reactome (10) / WikiPathways (4) | KEGG: academic use; Reactome & WikiPathways: CC BY 4.0 |
| `pathway_memberships.csv` | Gene–pathway edges | KEGG / Reactome / WikiPathways | per source (see above) |
| `molecules.csv` | Molecule nodes | UniProt (56) / LIPID MAPS (1) | UniProt: CC BY 4.0; LIPID MAPS: CC BY 4.0 |
| `diseases.csv` | Disease/trait nodes | OMIM / DisGeNET / Orphanet / GWAS | **mixed — see §2** |
| `disease_associations.csv` | Gene–disease/trait edges | DisGeNET / OMIM / GWAS (GLGC 2021) / Orphanet / expert curation | **mixed — see §2** |
| `data/extended/drug_targets.csv` | Drug–target relations | DrugBank / ClinicalTrials / literature | **mixed — see §4** |
| `data/extended/drug_diseases.csv` | Drug–disease relations | FDA / EMA | Public domain (regulatory labels) |
| `data/extended/enzyme_substrates.csv` | Enzyme–substrate relations | UniProt / literature | UniProt: CC BY 4.0; literature: cite original |
| `data/extended/affects_gene.csv` | Variant–gene effects | ClinVar-derived | Public domain |
| `data/extended/particle_all_links.csv` | Merged particle–protein | Curated by the authors | **CC0** |
| `data/extended/isoform_links.csv` | Protein isoform relations | Curated by the authors | **CC0** |

---

## 2. Disease layer (`diseases.csv`, `disease_associations.csv`) — per-source terms

Both files carry a `source` / `source_db` column. The licence governing each row follows
that column:

| `source_db` / `source` | Licence | Count (associations / nodes) |
|---|---|---|
| `GWAS_Catalog` | **CC0** (GLGC 2021 summary statistics, Graham et al. 2021) | 111 / 4 |
| `Orphanet` | **CC BY 4.0** | 50 / 7 |
| `Expert_curation` | **CC0** (curated by the authors) | 22 / — |
| `DisGeNET` | **CC BY-NC-SA 4.0** | 35 / 6 |
| `OMIM` | **Proprietary** (custom terms restrict redistribution) | 20 / 10 |

**Non-commercial / share-alike / redistribution restrictions** apply to the
DisGeNET- and OMIM-derived rows only. These rows **cannot** be re-released under CC0.

---

## 3. How to access data that cannot be redistributed

The following sources are **not redistributable in this package** under CC0/CC BY. Users
should obtain the original records directly from the source, then re-run the integration:

| Source | How to obtain |
|---|---|
| **OMIM** | https://www.omim.org (proprietary; an account/licence may be required) |
| **DisGeNET** | https://www.disgenet.org (CC BY-NC-SA 4.0; free registration for academic use) |
| **KEGG** | https://www.kegg.jp (academic use only; requires a KEGG licence for redistribution) |

---

## 4. Drug–target layer (`data/extended/drug_targets.csv`)

Rows are drawn from DrugBank (5.1.12), ClinicalTrials.gov, and manually curated
literature. DrugBank terms permit use for academic research but **restrict redistribution
of bulk datasets**; ClinicalTrials.gov records are public domain; literature-derived rows
should cite their source. When in doubt, obtain DrugBank records from https://go.drugbank.com.

---

## 5. Reproducing the integration

The full build pipeline is available in the `pipeline/` directory of the GitHub
repository (https://github.com/thereismywill/lipokg): `p4_s1_string_import.py`,
`p4_s1_pathway_import.py`, `p4_s1_clinvar_drugbank.py`,
`p4_s1_technical_validation*.py`, `p4_s1_zenodo_export.py`, plus the Cypher layer scripts
under `pipeline/cypher/`. Using these scripts, users can regenerate the integration from
the original sources (subject to each source's own access terms), which is the intended
route for obtaining the non-redistributable layers.
