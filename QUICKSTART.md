# LipoKG Quick Start Guide

A short guide to loading and querying LipoKG, a knowledge graph of lipoprotein metabolism.

## 1. Download the data

```bash
# Version 1.2.1 (30 files, 2.37 MB uncompressed / 0.35 MB as the archive)
wget "https://zenodo.org/records/23074632/files/lipokg_data_v1.2.1.zip?download=1"
unzip lipokg_data_v1.2.1.zip
cd lipokg_data_v1.2.1
```

The version DOI `10.5281/zenodo.23074632` always resolves to v1.2.1. The concept DOI
`10.5281/zenodo.21318099` always resolves to the latest version. A per-file inventory with byte
sizes and row counts is given in Supplementary Table S25 of the accompanying manuscript.

## 2. Import into Neo4j

Requires Neo4j Community or Enterprise **2026.05.0** (or a later 2026.x release).

### Option A — `neo4j-admin` (recommended for the full core schema)

```bash
neo4j stop

neo4j-admin database import full \
  --nodes=data/string_proteins.csv \
  --nodes=data/particles.csv \
  --nodes=data/molecules.csv \
  --nodes=data/diseases.csv \
  --nodes=data/clinvar_variants.csv \
  --nodes=data/kegg_genes.csv \
  --nodes=data/pathways.csv \
  --relationships=data/string_interactions.csv \
  --relationships=data/particle_protein_links.csv \
  --relationships=data/enzyme_particle_links.csv \
  --relationships=data/assembly_links.csv \
  --relationships=data/disease_associations.csv \
  --relationships=data/clinvar_relationships.csv \
  --relationships=data/pathway_memberships.csv \
  --overwrite-destination \
  neo4j

neo4j start
```

This loads the core CSV schema (6,214 nodes / 36,568 relationships across 7 node and 7 relationship
types). The six extended-schema exports under `data/extended/` and the additional node types they
declare (Drug, Reaction, Isoform, …) are **not** part of the core CSV import; see
`docs/lipokg_schema.yaml` for their BioLinkML definitions.

### Option B — Cypher `LOAD CSV`

```cypher
// Proteins
LOAD CSV WITH HEADERS FROM 'file:///string_proteins.csv' AS row
CREATE (:STRINGProtein {
  ensembl_id: row.ensembl_id,
  name: row.name,
  description: row.description,
  string_id: row.string_id
});

CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);

// Interactions — `score` and `combined_score` are properties of the relationship,
// not of the protein node.
LOAD CSV WITH HEADERS FROM 'file:///string_interactions.csv' AS row
MATCH (p1:STRINGProtein {string_id: row.source})
MATCH (p2:STRINGProtein {string_id: row.target})
CREATE (p1)-[:STRING_INTERACTS {
  score: toFloat(row.score),
  combined_score: toFloat(row.combined_score)
}]->(p2);
```

Repeat for the remaining CSV files; `docs/CYPHER_EXAMPLES.cypher` covers the full set.

## 3. First query

Open <http://localhost:7474> and run:

```cypher
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC;
```

## Common queries

### Protein interactions

```cypher
// Everything that interacts with APOE
MATCH (p:STRINGProtein {name: 'APOE'})-[r:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description, r.combined_score
ORDER BY r.combined_score DESC
LIMIT 20;
```

### Disease associations

```cypher
// Genes associated with familial hypercholesterolaemia
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name, g.type
ORDER BY g.name;
```

### Pathogenic variants

```cypher
// Pathogenic ClinVar variants mapped to LDLR
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance, v.review_status
LIMIT 20;
```

### Pathway genes

```cypher
// Genes in the KEGG lipid-and-atherosclerosis pathway (hsa05417, 216 genes)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {pathway_id: 'hsa05417'})
RETURN g.name, g.kegg_id
ORDER BY g.name;
```

Querying by `pathway_id` is more stable than by `name`: the KEGG layer was re-retrieved as
`hsa05417` "Lipid and atherosclerosis" in v1.2.1, replacing `hsa04979` "Cholesterol metabolism".

### Drug targets (extended schema)

`Drug` nodes and `TARGETS` relationships are declared by the extended schema rather than by the core
CSVs. Load them from `data/extended/drug_targets.csv` (29 `Drug` → `STRINGProtein` edges):

```cypher
MATCH (m:Drug)-[:TARGETS]->(p:STRINGProtein)
RETURN m.name, p.name
ORDER BY m.name;
```

### Annotation gaps — read this before interpreting the result

```cypher
// Highly connected proteins that carry few curated disease associations
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases,
       (interactions * 1.0 / (diseases + 1)) AS gap_score
ORDER BY gap_score DESC
LIMIT 20;
```

⚠️ **This ranks annotation gaps, not literature gaps.** Only 65 of the 1,852 proteins in the
interaction graph carry any disease association, so the denominator is almost always 1 and the score
is dominated by degree. The 20 highest-scoring proteins are the graph's generic hubs
(AKT1, TNF, IL6, …), which are not under-studied in the literature. This is the query behind Use
Case 1 of the manuscript, reported there as **annotation-gap discovery**; see its Limitations
section before drawing conclusions from it.

## Python integration

```python
from neo4j import GraphDatabase
import networkx as nx

driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))

with driver.session() as session:
    result = session.run("""
    MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(q)
    RETURN p.name AS source, q.name AS target
    LIMIT 100
    """)
    G = nx.Graph()
    for record in result:
        G.add_edge(record["source"], record["target"])

print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
```

## Key statistics

- **Core nodes:** 6,214 — **whole graph:** 6,639 (core plus the 425 nodes declared by the extended schema)
- **Core relationships:** 36,568 — **whole graph:** 41,497 (core plus 4,929 extended)
- **Core node types:** 7 (STRINGProtein, Particle, Molecule, Disease, ClinVarVariant, KEGGGene, Pathway)
- **Core relationship types:** 7 (STRING_INTERACTS, COMPONENT_OF, MODIFIES, ASSEMBLED_BY, VARIANT_OF, MEMBER_OF, DISEASE_ASSOCIATION)
- **Proteins:** 1,852 (STRING v12.0, combined score ≥ 700) — **interactions:** 31,878
- **Lipoprotein particles:** 7 (chylomicron, VLDL, IDL, LDL, HDL, Lp(a), remnant)
- **Molecules:** 57 — **diseases/traits:** 27 — **pathways:** 13 (1 KEGG, 12 Reactome)
- **ClinVar variants:** 4,042 (pathogenic / likely pathogenic) — **KEGG genes:** 216

Every figure above is recomputed at figure-build time from `data/graph_statistics.json` and the
deposited CSVs.

## Coverage

**Completeness against the three construction pathway databases**

- KEGG hsa05417: 72.7% (157/216 genes)
- Reactome lipoprotein pathways: 85.9% (61/71 genes)
- WikiPathways lipid pathways: 79.3% (73/92 genes) — reference set only, not imported
- Overall: 74.9% (259/346 unique genes)

**Independent benchmarks**

- GO:0042157 "lipoprotein metabolic process": 92.3% (132/143 genes)
- GLGC 2021 genome-wide significant lipid loci: 64.9% (244/376 loci)
- ClinGen lipid-related dosage-sensitive genes: 100% (25/25)
- Expert-curated 54-gene clinical reference set: 100% (54/54)

**Gene-level annotation depth** (denominator = 1,852 proteins in the interaction graph)

- At least one non-STRING layer: 252 (13.6%)
- Two or more layers: 48 (2.6%)
- STRING connectivity only: 1,600 (86.4%)

Multi-layer annotation is concentrated in the curated core; proteins reached only through 1-hop
interaction expansion should be read as interaction context rather than as annotated genes.

## Next steps

1. **Full documentation:** [README.md](README.md)
2. **Schema reference:** [docs/SCHEMA.md](docs/SCHEMA.md)
3. **Detailed tutorial:** [docs/USAGE_TUTORIAL.md](docs/USAGE_TUTORIAL.md)
4. **More queries:** [docs/CYPHER_EXAMPLES.cypher](docs/CYPHER_EXAMPLES.cypher)
5. **Browser query interface** (no Neo4j required): `web/lipokg_query.html`

## Getting help

- **Questions and bug reports:** open an issue at <https://github.com/thereismywill/lipokg>
- **Email:** yyu@sdfmu.edu.cn

## Citation

```bibtex
@dataset{lipokg2026,
  author    = {Zhang, Ke and Zhao, Junyi and Yu, Yang},
  title     = {LipoKG: A Knowledge Graph Dataset for Lipoprotein Metabolism Research},
  year      = {2026},
  version   = {1.2.1},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.23074632},
  url       = {https://doi.org/10.5281/zenodo.23074632}
}
```

For the latest version at any time, use the concept DOI `10.5281/zenodo.21318099`.

## Licence

The dataset is released under a **layered licence**: components whose upstream sources permit it are
released under CC0, while layers derived from sources with more restrictive terms (CC BY-NC-SA,
academic-use-only or proprietary) retain those terms. The licence applicable to each file — and, for
the disease layer, to each source within it — is set out in [`data/LICENSE.md`](data/LICENSE.md);
the upstream licence of every source is also listed in Table 2 of the manuscript. The
repository-level CC BY 4.0 label is a convenient default and does not override the per-layer terms.
Code in this repository is MIT licensed ([`LICENSE`](LICENSE)).
