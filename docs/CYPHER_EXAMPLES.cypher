// ============================================================================
// LipoKG Cypher Query Examples
// 可直接在Neo4j Browser或Cypher Shell中运行的查询示例
// ============================================================================

// ============================================================================
// 1. 基础统计查询
// ============================================================================

// 1.1 图谱总体统计
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC;

// 1.2 关系统计
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY count DESC;

// 1.3 图谱规模
MATCH (n)
OPTIONAL MATCH (n)-[r]->()
RETURN count(DISTINCT n) AS total_nodes,
       count(DISTINCT r) AS total_relationships;

// ============================================================================
// 2. 蛋白查询
// ============================================================================

// 2.1 查找特定蛋白
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p.name, p.description, p.ensembl_id;

// 2.2 查找蛋白的所有互作
MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description
ORDER BY interactor.name
LIMIT 50;

// 2.3 查找高置信度互作 (score > 900)
MATCH (p:STRINGProtein {name: 'APOE'})-[r:STRING_INTERACTS]-(interactor)
WHERE r.score > 900
RETURN interactor.name, r.score
ORDER BY r.score DESC;

// 2.4 查找度最高的蛋白 (hub genes)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
WHERE degree > 50
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 20;

// 2.5 查找两个蛋白之间的最短路径
MATCH path = shortestPath(
  (p1:STRINGProtein {name: 'APOB'})-[:STRING_INTERACTS*..5]-(p2:STRINGProtein {name: 'LDLR'})
)
RETURN path;

// ============================================================================
// 3. 疾病关联查询
// ============================================================================

// 3.1 查找特定疾病的关联基因
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name, g.type
ORDER BY g.name;

// 3.2 统计每个疾病的关联基因数
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN d.name, count(DISTINCT g) AS gene_count
ORDER BY gene_count DESC
LIMIT 20;

// 3.3 查找与多个疾病相关的基因
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, collect(d.name) AS diseases
WHERE size(diseases) > 3
RETURN g.name, diseases
ORDER BY size(diseases) DESC
LIMIT 20;

// 3.4 查找疾病共现模式
MATCH (g)-[:DISEASE_ASSOCIATION]->(d1:Disease),
      (g)-[:DISEASE_ASSOCIATION]->(d2:Disease)
WHERE d1.name < d2.name
WITH d1.name AS disease1, d2.name AS disease2, count(DISTINCT g) AS shared_genes
WHERE shared_genes > 5
RETURN disease1, disease2, shared_genes
ORDER BY shared_genes DESC
LIMIT 20;

// ============================================================================
// 4. ClinVar变异查询
// ============================================================================

// 4.1 查找特定基因的致病性变异
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance, v.review_status
LIMIT 50;

// 4.2 统计每个基因的致病性变异数
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
RETURN g.name, count(v) AS pathogenic_variants
ORDER BY pathogenic_variants DESC
LIMIT 20;

// 4.3 查找变异-基因-疾病路径
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g.name, d.name
LIMIT 30;

// 4.4 查找有多个致病性变异的基因
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
WITH g, count(v) AS variants
WHERE variants > 10
RETURN g.name, variants
ORDER BY variants DESC;

// ============================================================================
// 5. 通路查询
// ============================================================================

// 5.1 查找KEGG脂蛋白代谢通路中的所有基因
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Lipid and atherosclerosis'})
RETURN g.name, g.kegg_id
ORDER BY g.name;

// 5.2 查找同时参与多个通路的基因
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
WITH g, collect(p.name) AS pathways
WHERE size(pathways) > 1
RETURN g.name, pathways
ORDER BY size(pathways) DESC;

// 5.3 查找Reactome脂蛋白通路中的基因
MATCH (g)-[:MEMBER_OF]->(p:Pathway)
WHERE p.source = 'Reactome' AND p.name CONTAINS 'lipoprotein'
RETURN g.name, p.name
ORDER BY p.name, g.name;

// 5.4 通路重叠分析
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p1:Pathway),
      (g)-[:MEMBER_OF]->(p2:Pathway)
WHERE p1.name < p2.name
WITH p1.name AS pathway1, p2.name AS pathway2, count(DISTINCT g) AS shared_genes
WHERE shared_genes > 5
RETURN pathway1, pathway2, shared_genes
ORDER BY shared_genes DESC;

// ============================================================================
// 6. 多跳关系查询
// ============================================================================

// 6.1 查找通过蛋白互作与疾病关联的基因
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE NOT (g1)-[:DISEASE_ASSOCIATION]->(d)
RETURN g1.name AS indirect_gene, g2.name AS mediator, d.name AS disease
LIMIT 30;

// 6.2 查找基因-通路-疾病关联
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway),
      (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name, p.name, d.name
ORDER BY p.name, d.name
LIMIT 50;

// 6.3 查找变异-基因-互作-疾病路径
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g1.name, g2.name, d.name
LIMIT 30;

// 6.4 查找两个基因之间的所有路径 (长度<=3)
MATCH path = (p1:STRINGProtein {name: 'APOE'})-[*1..3]-(p2:STRINGProtein {name: 'LDLR'})
RETURN path
LIMIT 10;

// ============================================================================
// 7. 知识裂缝发现
// ============================================================================

// 7.1 高度连接但疾病关联少的基因
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases,
       (interactions * 1.0 / (diseases + 1)) AS gap_score
ORDER BY gap_score DESC
LIMIT 20;

// 7.2 多通路但少疾病关联的基因
MATCH (g:KEGGGene)
OPTIONAL MATCH (g)-[:MEMBER_OF]->(p:Pathway)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT p) AS pathways, count(DISTINCT d) AS diseases
WHERE pathways > 2 AND diseases < 2
RETURN g.name, pathways, diseases
ORDER BY pathways DESC, diseases ASC
LIMIT 20;

// 7.3 有致病性变异但疾病关联少的基因
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT v) AS variants, count(DISTINCT d) AS diseases
WHERE variants > 5 AND diseases < 3
RETURN g.name, variants, diseases
ORDER BY variants DESC
LIMIT 20;

// 7.4 高置信度互作但未知的功能关联
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
// 8. 药物重定位分析
// ============================================================================

// 8.1 查找与疾病相关但未用于治疗该疾病的蛋白
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
OPTIONAL MATCH (m:Molecule {type: 'drug'})-[:TARGETS]->(g)
WITH g, d, collect(DISTINCT m.name) AS drugs
WHERE size(drugs) = 0
RETURN g.name, d.name
ORDER BY d.name, g.name
LIMIT 50;

// 8.2 查找已知药物靶点的蛋白互作网络
MATCH (m:Molecule {type: 'drug'})-[:TARGETS]->(target:STRINGProtein)
MATCH (target)-[:STRING_INTERACTS]-(interactor:STRINGProtein)
WHERE interactor.score > 800
RETURN m.name AS drug, target.name, interactor.name
ORDER BY m.name, target.name
LIMIT 50;

// 8.3 查找潜在的药物组合靶点
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)
MATCH (g1)-[:DISEASE_ASSOCIATION]->(d:Disease)
MATCH (g2)-[:DISEASE_ASSOCIATION]->(d)
OPTIONAL MATCH (m1:Molecule {type: 'drug'})-[:TARGETS]->(g1)
OPTIONAL MATCH (m2:Molecule {type: 'drug'})-[:TARGETS]->(g2)
WHERE m1 IS NULL AND m2 IS NULL
RETURN g1.name, g2.name, d.name
ORDER BY d.name
LIMIT 30;

// ============================================================================
// 9. 子图提取
// ============================================================================

// 9.1 提取特定基因的子图 (2-hop)
MATCH path = (start:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS*1..2]-(end)
RETURN path
LIMIT 100;

// 9.2 提取疾病相关子图
MATCH path = (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor:STRINGProtein)
RETURN path
LIMIT 50;

// 9.3 提取通路子图
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Lipid and atherosclerosis'})
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor:KEGGGene)-[:MEMBER_OF]->(p)
RETURN g.name, interactor.name, p.name
ORDER BY g.name
LIMIT 100;

// 9.4 提取变异-基因-疾病子图
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic' AND g.name IN ['LDLR', 'APOB', 'PCSK9']
RETURN v.variant_id, g.name, d.name
LIMIT 50;

// ============================================================================
// 10. 数据导出查询
// ============================================================================

// 10.1 导出蛋白互作网络 (用于NetworkX分析)
MATCH (p1:STRINGProtein)-[r:STRING_INTERACTS]->(p2:STRINGProtein)
WHERE r.score > 700
RETURN p1.name AS source, p2.name AS target, r.score AS weight
LIMIT 10000;

// 10.2 导出疾病-基因关联 (用于富集分析)
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name AS gene, d.name AS disease
LIMIT 5000;

// 10.3 导出变异数据 (用于统计分析)
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
RETURN v.variant_id, v.clinical_significance, g.name AS gene
LIMIT 10000;

// 10.4 导出通路成员数据 (用于通路分析)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
RETURN g.name AS gene, p.name AS pathway, p.source
LIMIT 5000;

// 10.5 导出中心性数据 (用于网络分析)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 1000;

// ============================================================================
// 11. 数据质量检查
// ============================================================================

// 11.1 检查孤立节点
MATCH (n)
WHERE NOT (n)--()
RETURN labels(n)[0] AS type, count(n) AS isolated_count;

// 11.2 检查重复边
MATCH (a)-[r1]->(b), (a)-[r2]->(b)
WHERE id(r1) < id(r2) AND type(r1) = type(r2)
RETURN type(r1) AS type, count(*) AS duplicates;

// 11.3 检查不完整节点
MATCH (p:STRINGProtein)
WHERE p.name IS NULL OR p.ensembl_id IS NULL
RETURN count(p) AS incomplete_nodes;

// 11.4 检查不一致的关系
MATCH (a)-[r:STRING_INTERACTS]->(b)
WHERE a.name = b.name
RETURN count(r) AS self_loops;

// 11.5 检查数据完整性
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g)
WHERE NOT g:KEGGGene AND NOT g:STRINGProtein
RETURN count(v) AS orphan_variants;

// ============================================================================
// 12. 高级分析
// ============================================================================

// 12.1 查找蛋白复合物 (3-cliques)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS]-(p2:STRINGProtein),
      (p2)-[:STRING_INTERACTS]-(p3:STRINGProtein),
      (p3)-[:STRING_INTERACTS]-(p1)
WHERE p1.name < p2.name AND p2.name < p3.name
RETURN p1.name, p2.name, p3.name
LIMIT 50;

// 12.2 查找桥梁基因 (连接不同通路的基因)
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p1:Pathway),
      (g)-[:MEMBER_OF]->(p2:Pathway)
WHERE p1.name < p2.name
WITH g, collect(DISTINCT p1.name) AS pathways
WHERE size(pathways) > 2
RETURN g.name, pathways
ORDER BY size(pathways) DESC
LIMIT 20;

// 12.3 查找疾病模块 (高度连接的疾病相关基因)
MATCH (g1:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease),
      (g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d),
      (g1)-[:STRING_INTERACTS]-(g2)
WHERE g1.name < g2.name
WITH d, collect(DISTINCT g1.name) AS module_genes
WHERE size(module_genes) > 5
RETURN d.name, module_genes
ORDER BY size(module_genes) DESC
LIMIT 20;

// 12.4 计算介数中心性近似 (通过路径计数)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS*2..3]-(p2:STRINGProtein)
WHERE p1.name < p2.name
WITH p1, count(*) AS path_count
RETURN p1.name, path_count AS betweenness_approx
ORDER BY betweenness_approx DESC
LIMIT 20;

// 12.5 查找功能模块 (通过互作密度)
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
// 使用说明
// ============================================================================
//
// 1. 这些查询可以在Neo4j Browser或Cypher Shell中直接运行
// 2. 大多数查询都有LIMIT限制,可以根据需要调整
// 3. 对于大型查询,建议先运行EXPLAIN查看执行计划
// 4. 如果查询速度慢,确保已创建相关索引
// 5. 某些查询可能需要较长时间,建议在后台运行
//
// 创建索引示例:
// CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
// CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);
// CREATE INDEX FOR (d:Disease) ON (d.name);
// CREATE INDEX FOR (v:ClinVarVariant) ON (v.variant_id);
//
// ============================================================================
