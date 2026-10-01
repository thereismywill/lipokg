// ============================================================================
// LipoKG Cypher Query Examples
// Queries you can run as-is in Neo4j Browser or Cypher Shell
// ============================================================================

// ============================================================================
// 1. Basic statistics
// ============================================================================

// 1.1 Graph totals
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC;

// 1.2 Relationship counts
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY count DESC;

// 1.3 Graph size
MATCH (n)
OPTIONAL MATCH (n)-[r]->()
RETURN count(DISTINCT n) AS total_nodes,
       count(DISTINCT r) AS total_relationships;

// ============================================================================
// 2. Protein queries
// ============================================================================

// 2.1 Look up a protein
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p.name, p.description, p.ensembl_id;

// 2.2 All interactions of a protein
MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description
ORDER BY interactor.name
LIMIT 50;

// 2.3 High-confidence interactions (combined_score > 900)
MATCH (p:STRINGProtein {name: 'APOE'})-[r:STRING_INTERACTS]-(interactor)
WHERE r.score > 900
RETURN interactor.name, r.score
ORDER BY r.score DESC;

// 2.4 Highest-degree proteins (hubs)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
WHERE degree > 50
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 20;

// 2.5 Shortest path between two proteins
MATCH path = shortestPath(
  (p1:STRINGProtein {name: 'APOB'})-[:STRING_INTERACTS*..5]-(p2:STRINGProtein {name: 'LDLR'})
)
RETURN path;

// ============================================================================
// 3. Disease association queries
// ============================================================================

// 3.1 Genes associated with a given disease
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name, g.type
ORDER BY g.name;

// 3.2 Associations per disease
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN d.name, count(DISTINCT g) AS gene_count
ORDER BY gene_count DESC
LIMIT 20;

// 3.3 Genes associated with several diseases
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, collect(d.name) AS diseases
WHERE size(diseases) > 3
RETURN g.name, diseases
ORDER BY size(diseases) DESC
LIMIT 20;

// 3.4 Disease co-occurrence patterns
MATCH (g)-[:DISEASE_ASSOCIATION]->(d1:Disease),
      (g)-[:DISEASE_ASSOCIATION]->(d2:Disease)
WHERE d1.name < d2.name
WITH d1.name AS disease1, d2.name AS disease2, count(DISTINCT g) AS shared_genes
WHERE shared_genes > 5
RETURN disease1, disease2, shared_genes
ORDER BY shared_genes DESC
LIMIT 20;

// ============================================================================
// 4. ClinVar variant queries
// ============================================================================

// 4.1 Pathogenic variants of a given gene
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance, v.review_status
LIMIT 50;

// 4.2 Pathogenic variants per gene
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
RETURN g.name, count(v) AS pathogenic_variants
ORDER BY pathogenic_variants DESC
LIMIT 20;

// 4.3 Variant-gene-disease paths
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g.name, d.name
LIMIT 30;

// 4.4 Genes with several pathogenic variants
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
WITH g, count(v) AS variants
WHERE variants > 10
RETURN g.name, variants
ORDER BY variants DESC;

// ============================================================================
// 5. Pathway queries
// ============================================================================

// 5.1 Genes in the KEGG lipid-and-atherosclerosis pathway (hsa05417)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {pathway_id: 'hsa05417'})
RETURN g.name, g.kegg_id
ORDER BY g.name;

// 5.2 Genes in more than one pathway
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
WITH g, collect(p.name) AS pathways
WHERE size(pathways) > 1
RETURN g.name, pathways
ORDER BY size(pathways) DESC;

// 5.3 Genes in Reactome lipoprotein pathways
MATCH (g)-[:MEMBER_OF]->(p:Pathway)
WHERE p.source = 'Reactome' AND p.name CONTAINS 'lipoprotein'
RETURN g.name, p.name
ORDER BY p.name, g.name;

// 5.4 Pathway overlap
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p1:Pathway),
      (g)-[:MEMBER_OF]->(p2:Pathway)
WHERE p1.name < p2.name
WITH p1.name AS pathway1, p2.name AS pathway2, count(DISTINCT g) AS shared_genes
WHERE shared_genes > 5
RETURN pathway1, pathway2, shared_genes
ORDER BY shared_genes DESC;

// ============================================================================
// 6. Multi-hop queries
// ============================================================================

// 6.1 Genes linked to a disease through an interaction partner
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE NOT (g1)-[:DISEASE_ASSOCIATION]->(d)
RETURN g1.name AS indirect_gene, g2.name AS mediator, d.name AS disease
LIMIT 30;

// 6.2 Gene-pathway-disease associations
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway),
      (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name, p.name, d.name
ORDER BY p.name, d.name
LIMIT 50;

// 6.3 Variant-gene-interaction-disease paths
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g1.name, g2.name, d.name
LIMIT 30;

// 6.4 All paths between two genes (length <= 3)
MATCH path = (p1:STRINGProtein {name: 'APOE'})-[*1..3]-(p2:STRINGProtein {name: 'LDLR'})
RETURN path
LIMIT 10;

// ============================================================================
// 7. Annotation-gap discovery
// ============================================================================

// 7.1 Highly connected proteins with few curated disease associations
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases,
       (interactions * 1.0 / (diseases + 1)) AS gap_score
ORDER BY gap_score DESC
LIMIT 20;

// 7.2 Proteins in several pathways but with few disease associations
MATCH (g:KEGGGene)
OPTIONAL MATCH (g)-[:MEMBER_OF]->(p:Pathway)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT p) AS pathways, count(DISTINCT d) AS diseases
WHERE pathways > 2 AND diseases < 2
RETURN g.name, pathways, diseases
ORDER BY pathways DESC, diseases ASC
LIMIT 20;

// 7.3 Proteins with pathogenic variants but few disease associations
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT v) AS variants, count(DISTINCT d) AS diseases
WHERE variants > 5 AND diseases < 3
RETURN g.name, variants, diseases
ORDER BY variants DESC
LIMIT 20;

// 7.4 High-confidence interactions without a known functional link
MATCH (p1:STRINGProtein)-[r:STRING_INTERACTS]-(p2:STRINGProtein)
WHERE r.score > 900
OPTIONAL MATCH (p1)-[:DISEASE_ASSOCIATION]->(d:Disease)
OPTIONAL MATCH (p2)-[:DISEASE_ASSOCIATION]->(d)
WITH p1, p2, r, count(DISTINCT d) AS shared_diseases
WHERE shared_diseases = 0
RETURN p1.name, p2.name, r.score
ORDER BY r.score DESC
LIMIT 30;

// ============================================================================
// 8. Drug repurposing (Drug and TARGETS are declared by the extended schema)
// ============================================================================

// 8.1 Disease-associated proteins that no recorded drug targets
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
OPTIONAL MATCH (m:Drug)-[:TARGETS]->(g)
WITH g, d, collect(DISTINCT m.name) AS drugs
WHERE size(drugs) = 0
RETURN g.name, d.name
ORDER BY d.name, g.name
LIMIT 50;

// 8.2 Interaction neighbourhood of known drug targets
MATCH (m:Drug)-[:TARGETS]->(target:STRINGProtein)
MATCH (target)-[r:STRING_INTERACTS]-(interactor:STRINGProtein)
WHERE r.score > 800
RETURN m.name AS drug, target.name, interactor.name
ORDER BY m.name, target.name
LIMIT 50;

// 8.3 Candidate combination targets
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)
MATCH (g1)-[:DISEASE_ASSOCIATION]->(d:Disease)
MATCH (g2)-[:DISEASE_ASSOCIATION]->(d)
OPTIONAL MATCH (m1:Drug)-[:TARGETS]->(g1)
OPTIONAL MATCH (m2:Drug)-[:TARGETS]->(g2)
WHERE m1 IS NULL AND m2 IS NULL
RETURN g1.name, g2.name, d.name
ORDER BY d.name
LIMIT 30;

// ============================================================================
// 9. Subgraph extraction
// ============================================================================

// 9.1 2-hop subgraph around a gene
MATCH path = (start:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS*1..2]-(end)
RETURN path
LIMIT 100;

// 9.2 Disease-associated subgraph
MATCH path = (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor:STRINGProtein)
RETURN path
LIMIT 50;

// 9.3 Pathway subgraph
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {pathway_id: 'hsa05417'})
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor:KEGGGene)-[:MEMBER_OF]->(p)
RETURN g.name, interactor.name, p.name
ORDER BY g.name
LIMIT 100;

// 9.4 Variant-gene-disease subgraph
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic' AND g.name IN ['LDLR', 'APOB', 'PCSK9']
RETURN v.variant_id, g.name, d.name
LIMIT 50;

// ============================================================================
// 10. Export queries
// ============================================================================

// 10.1 Protein interaction network (for NetworkX)
MATCH (p1:STRINGProtein)-[r:STRING_INTERACTS]->(p2:STRINGProtein)
WHERE r.score > 700
RETURN p1.name AS source, p2.name AS target, r.score AS weight
LIMIT 10000;

// 10.2 Disease-gene associations (for enrichment analysis)
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name AS gene, d.name AS disease
LIMIT 5000;

// 10.3 Variant data (for statistical analysis)
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
RETURN v.variant_id, v.clinical_significance, g.name AS gene
LIMIT 10000;

// 10.4 Pathway membership (for pathway analysis)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
RETURN g.name AS gene, p.name AS pathway, p.source
LIMIT 5000;

// 10.5 Centrality data (for network analysis)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 1000;

// ============================================================================
// 11. Data-quality checks
// ============================================================================

// 11.1 Isolated nodes
MATCH (n)
WHERE NOT (n)--()
RETURN labels(n)[0] AS type, count(n) AS isolated_count;

// 11.2 Duplicate relationships
MATCH (a)-[r1]->(b), (a)-[r2]->(b)
WHERE id(r1) < id(r2) AND type(r1) = type(r2)
RETURN type(r1) AS type, count(*) AS duplicates;

// 11.3 Incomplete nodes
MATCH (p:STRINGProtein)
WHERE p.name IS NULL OR p.ensembl_id IS NULL
RETURN count(p) AS incomplete_nodes;

// 11.4 Inconsistent relationships
MATCH (a)-[r:STRING_INTERACTS]->(b)
WHERE a.name = b.name
RETURN count(r) AS self_loops;

// 11.5 Completeness
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g)
WHERE NOT g:KEGGGene AND NOT g:STRINGProtein
RETURN count(v) AS orphan_variants;

// ============================================================================
// 12. Advanced analyses
// ============================================================================

// 12.1 Protein complexes (3-cliques)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS]-(p2:STRINGProtein),
      (p2)-[:STRING_INTERACTS]-(p3:STRINGProtein),
      (p3)-[:STRING_INTERACTS]-(p1)
WHERE p1.name < p2.name AND p2.name < p3.name
RETURN p1.name, p2.name, p3.name
LIMIT 50;

// 12.2 Bridge genes (linking different pathways)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p1:Pathway),
      (g)-[:MEMBER_OF]->(p2:Pathway)
WHERE p1.name < p2.name
WITH g, collect(DISTINCT p1.name) AS pathways
WHERE size(pathways) > 2
RETURN g.name, pathways
ORDER BY size(pathways) DESC
LIMIT 20;

// 12.3 Disease modules (densely connected disease-associated proteins)
MATCH (g1:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease),
      (g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d),
      (g1)-[:STRING_INTERACTS]-(g2)
WHERE g1.name < g2.name
WITH d, collect(DISTINCT g1.name) AS module_genes
WHERE size(module_genes) > 5
RETURN d.name, module_genes
ORDER BY size(module_genes) DESC
LIMIT 20;

// 12.4 Approximate betweenness centrality (via path counts)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS*2..3]-(p2:STRINGProtein)
WHERE p1.name < p2.name
WITH p1, count(*) AS path_count
RETURN p1.name, path_count AS betweenness_approx
ORDER BY betweenness_approx DESC
LIMIT 20;

// 12.5 Functional modules (by interaction density)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(neighbor:STRINGProtein)
WITH p, collect(DISTINCT neighbor.name) AS neighbors
WHERE size(neighbors) > 10
UNWIND neighbors AS n1
UNWIND neighbors AS n2
WHERE n1 < n2
MATCH (p1:STRINGProtein {name: n1})-[:STRING_INTERACTS]-(p2:STRINGProtein {name: n2})
WITH p, count(*) AS internal_edges, size(neighbors) AS module_size
WHERE internal_edges > module_size * 2
RETURN p.name AS seed, module_size, internal_edges
ORDER BY internal_edges DESC
LIMIT 20;

// ============================================================================
// Usage notes
// ============================================================================
//
// 1. These queries run as-is in Neo4j Browser or Cypher Shell.
// 2. Most queries are capped with LIMIT; adjust the caps as needed.
// 3. For large queries, run EXPLAIN first to inspect the plan.
// 4. If a query is slow, make sure the indexes below exist.
// 5. Some queries are long-running; consider a background session.
//
// Suggested indexes:
// CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
// CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);
// CREATE INDEX FOR (d:Disease) ON (d.name);
// CREATE INDEX FOR (v:ClinVarVariant) ON (v.variant_id);
//
// ============================================================================
