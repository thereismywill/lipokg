# LipoKG Usage Tutorial

This tutorial shows how to query LipoKG, a knowledge graph of lipoprotein metabolism, with Cypher
and Python.

## Contents

1. [Environment](#environment)
2. [Loading the data into Neo4j](#loading-the-data-into-neo4j)
3. [Basic queries](#basic-queries)
4. [Advanced analyses](#advanced-analyses)
5. [Annotation-gap discovery](#annotation-gap-discovery)
6. [Python integration](#python-integration)
7. [Visualisation](#visualisation)
8. [Best practice](#best-practice)
9. [Troubleshooting](#troubleshooting)

## Environment

### Requirements

- Neo4j Community or Enterprise **2026.05.0** (or a later 2026.x release)
- Python 3.9+
- RAM: ≥ 8 GB (16 GB recommended)
- Disk: ≥ 5 GB

### Installing the dependencies

```bash
# Neo4j (macOS)
brew install neo4j

# Start Neo4j
neo4j start

# Python libraries
pip install neo4j pandas networkx matplotlib seaborn
```

### Downloading the data

```bash
# Version 1.2.2 — 30 files, 2.38 MB uncompressed / 0.35 MB as the archive
wget "https://zenodo.org/records/23080346/files/lipokg_data_v1.2.2.zip?download=1"
unzip lipokg_data_v1.2.2.zip
cd lipokg_data_v1.2.2
```

The version DOI `10.5281/zenodo.23080346` always resolves to v1.2.2 and the concept DOI
`10.5281/zenodo.21318099` always resolves to the latest version.

## Loading the data into Neo4j

### Option 1 — neo4j-admin (recommended)

```bash
neo4j stop

neo4j-admin database import full \
  --nodes=data/string_proteins.csv \
  --nodes=data/molecules.csv \
  --nodes=data/diseases.csv \
  --nodes=data/clinvar_variants.csv \
  --nodes=data/kegg_genes.csv \
  --nodes=data/pathways.csv \
  --relationships=data/string_interactions.csv \
  --relationships=data/disease_associations.csv \
  --relationships=data/clinvar_relationships.csv \
  --relationships=data/pathway_memberships.csv \
  --overwrite-destination \
  neo4j

neo4j start
```

### Option 2 — Cypher LOAD CSV

```cypher
// STRING proteins
LOAD CSV WITH HEADERS FROM 'file:///string_proteins.csv' AS row
CREATE (p:STRINGProtein {
  ensembl_id: row.ensembl_id,
  name: row.name,
  description: row.description,
  string_id: row.string_id
});

CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);

// STRING interactions — the scores belong to the relationship, not to the node
LOAD CSV WITH HEADERS FROM 'file:///string_interactions.csv' AS row
MATCH (p1:STRINGProtein {string_id: row.source})
MATCH (p2:STRINGProtein {string_id: row.target})
CREATE (p1)-[:STRING_INTERACTS {
  score: toFloat(row.score),
  combined_score: toFloat(row.combined_score)
}]->(p2);

// Repeat for the remaining files, following the column names in docs/SCHEMA.md.
```

## Basic queries

### 1. Graph overview

```cypher
// Nodes per type
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC;

// Relationships per type
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY count DESC;

// A single protein
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p.name, p.description, p.ensembl_id;

// Its interaction partners
MATCH (p:STRINGProtein {name: 'APOE'})-[r:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description, r.combined_score
ORDER BY r.combined_score DESC
LIMIT 20;
```

### 2. Disease associations

```cypher
// Genes associated with familial hypercholesterolaemia
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name, g.type
ORDER BY g.name;

// All pathogenic variants of LDLR
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance, v.review_status
LIMIT 20;

// Associated genes per disease
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN d.name, count(DISTINCT g) AS gene_count
ORDER BY gene_count DESC
LIMIT 10;
```

### 3. Pathway queries

```cypher
// Genes in the KEGG lipid-and-atherosclerosis pathway (hsa05417, 216 genes)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {pathway_id: 'hsa05417'})
RETURN g.name, g.kegg_id
ORDER BY g.name;

// Genes in more than one pathway
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
WITH g, collect(p.name) AS pathways
WHERE size(pathways) > 1
RETURN g.name, pathways
ORDER BY size(pathways) DESC;

// Genes in Reactome lipoprotein pathways
MATCH (g)-[:MEMBER_OF]->(p:Pathway)
WHERE p.source = 'Reactome' AND p.name CONTAINS 'lipoprotein'
RETURN g.name, p.name
ORDER BY p.name, g.name;
```

> Use `pathway_id` rather than `name` when filtering the KEGG layer: v1.2.1 re-retrieved the layer as
> `hsa05417` "Lipid and atherosclerosis", replacing `hsa04979` "Cholesterol metabolism". Querying the
> old name returns an empty result.

## Advanced analyses

### 4. Interaction network analysis

```cypher
// Hub proteins
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
WHERE degree > 50
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 20;

// Shortest path between two proteins
MATCH path = shortestPath(
  (p1:STRINGProtein {name: 'APOB'})-[:STRING_INTERACTS*]-(p2:STRINGProtein {name: 'LDLR'})
)
RETURN path;

// Protein complexes (3-cliques)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS]-(p2:STRINGProtein),
      (p2)-[:STRING_INTERACTS]-(p3:STRINGProtein),
      (p3)-[:STRING_INTERACTS]-(p1)
WHERE p1.name < p2.name AND p2.name < p3.name
RETURN p1.name, p2.name, p3.name
LIMIT 20;
```

### 5. Multi-hop queries

```cypher
// Genes linked to a disease through an interaction partner
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE NOT (g1)-[:DISEASE_ASSOCIATION]->(d)
RETURN g1.name AS indirect_gene, g2.name AS mediator, d.name AS disease
LIMIT 20;

// Variant-gene-disease paths
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g.name, d.name
LIMIT 20;

// Gene-pathway-disease associations
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway),
      (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name, p.name, d.name
ORDER BY p.name, d.name
LIMIT 30;
```

## Annotation-gap discovery

### 6. Highly connected proteins with few curated disease associations

```cypher
// Proteins with many interactions but few disease associations
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases,
       (interactions * 1.0 / (diseases + 1)) AS gap_score
ORDER BY gap_score DESC
LIMIT 20;

// Proteins in several pathways but with few disease associations
MATCH (g:KEGGGene)
OPTIONAL MATCH (g)-[:MEMBER_OF]->(p:Pathway)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT p) AS pathways, count(DISTINCT d) AS diseases
WHERE pathways > 2 AND diseases < 2
RETURN g.name, pathways, diseases
ORDER BY pathways DESC, diseases ASC
LIMIT 20;

// Proteins with pathogenic variants but few disease associations
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT v) AS variants, count(DISTINCT d) AS diseases
WHERE variants > 5 AND diseases < 3
RETURN g.name, variants, diseases
ORDER BY variants DESC
LIMIT 20;
```

> ⚠️ **These queries rank annotation gaps, not literature gaps.** Only 65 of the 1,852 proteins in
> the interaction graph carry any disease association, so `diseases` is almost always 0 and the
> `gap_score` is dominated by interaction degree. The top-scoring proteins are the graph's generic
> hubs (AKT1, TNF, IL6, …), which are not under-studied in the literature. Use these queries to find
> curation priorities; read Use Case 1 and the Limitations section of the manuscript before drawing
> biological conclusions from the ranking.

### 7. Drug repurposing (extended schema)

`Drug` nodes and `TARGETS` relationships are declared by the extended schema rather than the core
CSVs. Load `data/extended/drug_targets.csv` first (29 `Drug` → `STRINGProtein` edges).

```cypher
// Disease-associated proteins that no recorded drug targets
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
OPTIONAL MATCH (m:Drug)-[:TARGETS]->(g)
WITH g, d, collect(DISTINCT m.name) AS drugs
WHERE size(drugs) = 0
RETURN g.name, d.name
ORDER BY d.name, g.name
LIMIT 50;

// Interaction neighbourhood of known drug targets
MATCH (m:Drug)-[:TARGETS]->(target:STRINGProtein)
MATCH (target)-[r:STRING_INTERACTS]-(interactor:STRINGProtein)
WHERE r.score > 800
RETURN m.name AS drug, target.name, interactor.name
ORDER BY m.name, target.name
LIMIT 50;
```

## Python integration

### 8. Network analysis with Python

```python
from neo4j import GraphDatabase
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

# Connect to Neo4j
driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))


def extract_subgraph(gene_name, depth=2):
    """Return the `depth`-hop interaction neighbourhood of a gene as a NetworkX graph."""
    with driver.session() as session:
        result = session.run(
            """
            MATCH path = (start:STRINGProtein {name: $gene})-[:STRING_INTERACTS*1..%d]-(end)
            RETURN path
            """ % depth,
            gene=gene_name,
        )
        G = nx.Graph()
        for record in result:
            for rel in record["path"].relationships:
                source = rel.start_node["name"]
                target = rel.end_node["name"]
                score = rel["score"] if "score" in rel else 0
                G.add_edge(source, target, weight=score)
        return G


# APOE, two hops out
G = extract_subgraph("APOE", depth=2)

print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")

degree_centrality = nx.degree_centrality(G)
betweenness = nx.betweenness_centrality(G)

plt.figure(figsize=(12, 10))
pos = nx.spring_layout(G, k=2, iterations=50)
nx.draw(G, pos, with_labels=True, node_size=500,
        node_color="lightblue", font_size=8)
plt.title("APOE interaction network")
plt.tight_layout()
plt.savefig("apoe_network.png", dpi=300)
```

### 9. Exporting the results

```python
# Degree distribution
degrees = [G.degree(node) for node in G.nodes()]
plt.figure(figsize=(10, 6))
plt.hist(degrees, bins=20, color="skyblue", edgecolor="black")
plt.xlabel("Degree")
plt.ylabel("Frequency")
plt.title("Degree distribution")
plt.savefig("degree_distribution.png", dpi=300)

# Centrality table
df = pd.DataFrame({
    "Gene": list(degree_centrality.keys()),
    "Degree_Centrality": list(degree_centrality.values()),
    "Betweenness": [betweenness[g] for g in degree_centrality.keys()],
})
df = df.sort_values("Degree_Centrality", ascending=False)
df.to_csv("centrality_analysis.csv", index=False)
```

## Visualisation

### 10. Generating data for a visualisation

```cypher
// Network data for D3.js or a similar tool
MATCH (p:STRINGProtein)-[r:STRING_INTERACTS]->(q:STRINGProtein)
WHERE r.combined_score > 900
WITH p, q, r
LIMIT 100
RETURN
  {id: p.name, label: p.name, group: 'protein'} AS source,
  {id: q.name, label: q.name, group: 'protein'} AS target,
  {type: 'interaction', score: r.combined_score} AS relationship;

// Bipartite disease-gene data
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, d
LIMIT 50
RETURN
  {id: g.name, label: g.name, group: 'gene'} AS source,
  {id: d.name, label: d.name, group: 'disease'} AS target,
  {type: 'association'} AS relationship;
```

### 11. Generating a statistics report

```cypher
CALL {
  MATCH (n)
  RETURN 'Nodes' AS category, labels(n)[0] AS type, count(n) AS count
  UNION
  MATCH ()-[r]->()
  RETURN 'Relationships' AS category, type(r) AS type, count(r) AS count
  UNION
  MATCH (p:STRINGProtein)-[r:STRING_INTERACTS]-(q)
  WHERE r.combined_score > 900
  RETURN 'Interactions' AS category, 'High confidence (>900)' AS type, count(*) AS count
  UNION
  MATCH (v:ClinVarVariant)
  WHERE v.clinical_significance = 'Pathogenic'
  RETURN 'Variants' AS category, 'Pathogenic' AS type, count(v) AS count
}
RETURN category, type, count
ORDER BY category, count DESC;
```

## Best practice

### Performance

1. **Create indexes**

```cypher
CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);
CREATE INDEX FOR (d:Disease) ON (d.name);
CREATE INDEX FOR (v:ClinVarVariant) ON (v.variant_id);
```

2. **Use parameters**

```cypher
// Preferred
MATCH (p:STRINGProtein {name: $gene_name})
RETURN p;

// Avoid
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p;
```

3. **Cap the result size**

```cypher
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(q)
RETURN p.name, q.name
LIMIT 1000;
```

### Data-quality checks

```cypher
// Isolated nodes
MATCH (n)
WHERE NOT (n)--()
RETURN labels(n)[0] AS type, count(n) AS isolated_count;

// Duplicate relationships
MATCH (a)-[r1]->(b), (a)-[r2]->(b)
WHERE elementId(r1) < elementId(r2)
RETURN type(r1) AS type, count(*) AS duplicates;

// Incomplete nodes
MATCH (p:STRINGProtein)
WHERE p.name IS NULL OR p.ensembl_id IS NULL
RETURN count(p) AS incomplete_nodes;
```

## Troubleshooting

**Q: The import is slow.**
A: Use `neo4j-admin` rather than `LOAD CSV`, and give the import enough heap.

**Q: Queries time out.**
A: Add a `LIMIT`, create the indexes above, and simplify the pattern.

**Q: Out of memory.**
A: Raise the Neo4j heap, for example `dbms.memory.heap.max_size=4G`.

**Q: A node cannot be found.**
A: Check the label and property names, and inspect the data with
`MATCH (n) RETURN labels(n), keys(n) LIMIT 10`.

## References

- [Neo4j documentation](https://neo4j.com/docs/)
- [Cypher manual](https://neo4j.com/docs/cypher-manual/)
- [NetworkX documentation](https://networkx.org/documentation/stable/)
- [LipoKG schema documentation](SCHEMA.md)

## Citation

```bibtex
@dataset{lipokg2026,
  author    = {Zhang, Ke and Zhao, Junyi and Yu, Yang},
  title     = {LipoKG: A Knowledge Graph Dataset for Lipoprotein Metabolism Research},
  year      = {2026},
  version   = {1.2.2},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.23080346},
  url       = {https://doi.org/10.5281/zenodo.23080346}
}
```

## Licence

The dataset is released under a **layered licence**; the licence applicable to each file — and, for
the disease layer, to each source within it — is set out in [`data/LICENSE.md`](../data/LICENSE.md).
Code in this repository is MIT licensed.
