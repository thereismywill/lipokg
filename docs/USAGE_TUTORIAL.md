# LipoKG Usage Tutorial

本教程展示如何使用LipoKG知识图谱进行脂蛋白代谢研究。

## 目录

1. [环境准备](#环境准备)
2. [数据导入Neo4j](#数据导入neo4j)
3. [基础查询](#基础查询)
4. [高级分析](#高级分析)
5. [知识裂缝发现](#知识裂缝发现)
6. [Python集成](#python集成)
7. [可视化](#可视化)

## 环境准备

### 系统要求
- Neo4j 5.x (Community或Enterprise版本)
- Python 3.9+
- 内存: ≥8GB (推荐16GB)
- 磁盘空间: ≥5GB

### 安装依赖

```bash
# 安装Neo4j (macOS)
brew install neo4j

# 启动Neo4j
neo4j start

# 安装Python依赖
pip install neo4j pandas networkx matplotlib seaborn
```

### 下载数据

从Zenodo下载LipoKG数据包:
```bash
# 下载并解压
wget https://zenodo.org/records/[DOI]/files/lipokg-v1.0.0.zip
unzip lipokg-v1.0.0.zip
cd lipokg-v1.0.0
```

## 数据导入Neo4j

### 方法1: 使用neo4j-admin (推荐)

```bash
# 停止Neo4j
neo4j stop

# 导入节点
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

# 启动Neo4j
neo4j start
```

### 方法2: 使用Cypher LOAD CSV

```cypher
// 导入STRING蛋白
LOAD CSV WITH HEADERS FROM 'file:///string_proteins.csv' AS row
CREATE (p:STRINGProtein {
  ensembl_id: row.ensembl_id,
  name: row.name,
  description: row.description,
  string_id: row.string_id
});

// 创建索引
CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);

// 导入STRING互作
LOAD CSV WITH HEADERS FROM 'file:///string_interactions.csv' AS row
MATCH (p1:STRINGProtein {ensembl_id: row.source})
MATCH (p2:STRINGProtein {ensembl_id: row.target})
CREATE (p1)-[:STRING_INTERACTS {
  score: toFloat(row.score),
  combined_score: toFloat(row.combined_score)
}]->(p2);

// 重复类似步骤导入其他数据...
```

## 基础查询

### 1. 图谱概览

```cypher
// 统计节点类型
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC;

// 统计关系类型
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY count DESC;

// 查看APOE蛋白信息
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p.name, p.description, p.ensembl_id;

// 查看与APOE互作的蛋白
MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description
LIMIT 20;
```

### 2. 疾病关联查询

```cypher
// 查找与家族性高胆固醇血症相关的基因
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name, g.type
ORDER BY g.name;

// 查找LDLR的所有致病性变异
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance, v.review_status
LIMIT 20;

// 统计每个疾病的关联基因数
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN d.name, count(DISTINCT g) AS gene_count
ORDER BY gene_count DESC
LIMIT 10;
```

### 3. 通路查询

```cypher
// 查找KEGG脂蛋白代谢通路中的所有基因
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Lipid and atherosclerosis'})
RETURN g.name, g.kegg_id
ORDER BY g.name;

// 查找同时参与多个通路的基因
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway)
WITH g, collect(p.name) AS pathways
WHERE size(pathways) > 1
RETURN g.name, pathways
ORDER BY size(pathways) DESC;

// 查找Reactome脂蛋白通路中的基因
MATCH (g)-[:MEMBER_OF]->(p:Pathway)
WHERE p.source = 'Reactome' AND p.name CONTAINS 'lipoprotein'
RETURN g.name, p.name
ORDER BY p.name, g.name;
```

## 高级分析

### 4. 蛋白互作网络分析

```cypher
// 查找高度连接的蛋白 (hub genes)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(interactor)
WITH p, count(DISTINCT interactor) AS degree
WHERE degree > 50
RETURN p.name, degree
ORDER BY degree DESC
LIMIT 20;

// 查找两个蛋白之间的最短路径
MATCH path = shortestPath(
  (p1:STRINGProtein {name: 'APOB'})-[:STRING_INTERACTS*]-(p2:STRINGProtein {name: 'LDLR'})
)
RETURN path;

// 查找蛋白复合物 (cliques)
MATCH (p1:STRINGProtein)-[:STRING_INTERACTS]-(p2:STRINGProtein),
      (p2)-[:STRING_INTERACTS]-(p3:STRINGProtein),
      (p3)-[:STRING_INTERACTS]-(p1)
WHERE p1.name < p2.name AND p2.name < p3.name
RETURN p1.name, p2.name, p3.name
LIMIT 20;
```

### 5. 多跳关系查询

```cypher
// 查找通过蛋白互作与疾病关联的基因
MATCH (g1:STRINGProtein)-[:STRING_INTERACTS]-(g2:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE NOT (g1)-[:DISEASE_ASSOCIATION]->(d)
RETURN g1.name AS indirect_gene, g2.name AS mediator, d.name AS disease
LIMIT 20;

// 查找变异-基因-疾病路径
MATCH path = (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, g.name, d.name
LIMIT 20;

// 查找基因-通路-疾病关联
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway),
      (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
RETURN g.name, p.name, d.name
ORDER BY p.name, d.name
LIMIT 30;
```

## 知识裂缝发现

### 6. 识别研究不足的高重要性基因

```cypher
// 查找高度连接但疾病关联少的基因 (潜在知识裂缝)
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases, 
       (interactions * 1.0 / (diseases + 1)) AS gap_score
ORDER BY gap_score DESC
LIMIT 20;

// 查找在多个通路中但疾病关联少的基因
MATCH (g:KEGGGene)
OPTIONAL MATCH (g)-[:MEMBER_OF]->(p:Pathway)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT p) AS pathways, count(DISTINCT d) AS diseases
WHERE pathways > 2 AND diseases < 2
RETURN g.name, pathways, diseases
ORDER BY pathways DESC, diseases ASC
LIMIT 20;

// 查找有致病性变异但疾病关联少的基因
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene)
WHERE v.clinical_significance = 'Pathogenic'
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT v) AS variants, count(DISTINCT d) AS diseases
WHERE variants > 5 AND diseases < 3
RETURN g.name, variants, diseases
ORDER BY variants DESC
LIMIT 20;
```

### 7. 药物重定位分析

```cypher
// 查找与疾病相关但未用于治疗该疾病的蛋白
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
OPTIONAL MATCH (m:Molecule {type: 'drug'})-[:TARGETS]->(g)
WITH g, d, collect(DISTINCT m.name) AS drugs
WHERE size(drugs) = 0
RETURN g.name, d.name
ORDER BY d.name, g.name
LIMIT 30;

// 查找已知药物靶点的蛋白互作网络
MATCH (m:Molecule {type: 'drug'})-[:TARGETS]->(target:STRINGProtein)
MATCH (target)-[:STRING_INTERACTS]-(interactor:STRINGProtein)
WHERE interactor.score > 800
RETURN m.name AS drug, target.name, interactor.name
ORDER BY m.name, target.name
LIMIT 30;
```

## Python集成

### 8. 使用Python进行网络分析

```python
from neo4j import GraphDatabase
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

# 连接Neo4j
driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))

# 提取子图
def extract_subgraph(gene_name, depth=2):
    with driver.session() as session:
        query = """
        MATCH path = (start:STRINGProtein {name: $gene})-[:STRING_INTERACTS*1..%d]-(end)
        RETURN path
        """ % depth
        
        result = session.run(query, gene=gene_name)
        
        G = nx.Graph()
        for record in result:
            path = record['path']
            for rel in path.relationships:
                source = rel.start_node['name']
                target = rel.end_node['name']
                score = rel['score'] if 'score' in rel else 0
                G.add_edge(source, target, weight=score)
        
        return G

# 提取APOE子图
G = extract_subgraph('APOE', depth=2)

# 网络分析
print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")

# 计算中心性
degree_centrality = nx.degree_centrality(G)
betweenness = nx.betweenness_centrality(G)

# 可视化
plt.figure(figsize=(12, 10))
pos = nx.spring_layout(G, k=2, iterations=50)
nx.draw(G, pos, with_labels=True, node_size=500, 
        node_color='lightblue', font_size=8)
plt.title('APOE Interaction Network')
plt.tight_layout()
plt.savefig('apoe_network.png', dpi=300)
```

### 9. 导出分析结果

```python
# 导出度分布
degrees = [G.degree(node) for node in G.nodes()]
plt.figure(figsize=(10, 6))
plt.hist(degrees, bins=20, color='skyblue', edgecolor='black')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.title('Degree Distribution')
plt.savefig('degree_distribution.png', dpi=300)

# 导出中心性Top基因
df = pd.DataFrame({
    'Gene': list(degree_centrality.keys()),
    'Degree_Centrality': list(degree_centrality.values()),
    'Betweenness': [betweenness[g] for g in degree_centrality.keys()]
})
df = df.sort_values('Degree_Centrality', ascending=False)
df.to_csv('centrality_analysis.csv', index=False)
```

## 可视化

### 10. 使用Cypher生成可视化数据

```cypher
// 生成网络可视化数据 (用于D3.js或其他可视化工具)
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]->(q:STRINGProtein)
WHERE p.score > 900  // 高置信度互作
WITH p, q
LIMIT 100
RETURN 
  {id: p.name, label: p.name, group: 'protein'} AS source,
  {id: q.name, label: q.name, group: 'protein'} AS target,
  {type: 'interaction', score: p.score} AS relationship;

// 生成疾病-基因二部图数据
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, d
LIMIT 50
RETURN 
  {id: g.name, label: g.name, group: 'gene'} AS source,
  {id: d.name, label: d.name, group: 'disease'} AS target,
  {type: 'association'} AS relationship;
```

### 11. 生成统计报告

```cypher
// 生成完整的图谱统计报告
CALL {
  MATCH (n) 
  RETURN 'Nodes' AS category, labels(n)[0] AS type, count(n) AS count
  UNION
  MATCH ()-[r]->() 
  RETURN 'Relationships' AS category, type(r) AS type, count(r) AS count
  UNION
  MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(q)
  RETURN 'Interactions' AS category, 'High confidence (>900)' AS type, 
         count(*) AS count
  WHERE p.score > 900
  UNION
  MATCH (v:ClinVarVariant)
  WHERE v.clinical_significance = 'Pathogenic'
  RETURN 'Variants' AS category, 'Pathogenic' AS type, count(v) AS count
}
RETURN category, type, count
ORDER BY category, count DESC;
```

## 最佳实践

### 性能优化

1. **创建索引**:
```cypher
CREATE INDEX FOR (p:STRINGProtein) ON (p.name);
CREATE INDEX FOR (p:STRINGProtein) ON (p.ensembl_id);
CREATE INDEX FOR (d:Disease) ON (d.name);
CREATE INDEX FOR (v:ClinVarVariant) ON (v.variant_id);
```

2. **使用参数化查询**:
```cypher
// 好的做法
MATCH (p:STRINGProtein {name: $gene_name})
RETURN p

// 避免
MATCH (p:STRINGProtein {name: 'APOE'})
RETURN p
```

3. **限制返回结果**:
```cypher
MATCH (p:STRINGProtein)-[:STRING_INTERACTS]-(q)
RETURN p.name, q.name
LIMIT 1000  // 始终使用LIMIT
```

### 数据质量检查

```cypher
// 检查孤立节点
MATCH (n)
WHERE NOT (n)--()
RETURN labels(n)[0] AS type, count(n) AS isolated_count;

// 检查重复边
MATCH (a)-[r1]->(b), (a)-[r2]->(b)
WHERE id(r1) < id(r2)
RETURN type(r1) AS type, count(*) AS duplicates;

// 检查不一致的标识符
MATCH (p:STRINGProtein)
WHERE p.name IS NULL OR p.ensembl_id IS NULL
RETURN count(p) AS incomplete_nodes;
```

## 故障排除

### 常见问题

**Q: 导入速度慢?**
A: 使用neo4j-admin而非LOAD CSV，确保有足够的内存分配

**Q: 查询超时?**
A: 添加LIMIT，创建索引，优化查询模式

**Q: 内存不足?**
A: 增加Neo4j堆内存: `dbms.memory.heap.max_size=4G`

**Q: 找不到节点?**
A: 检查节点标签和属性名称是否正确，使用`MATCH (n) RETURN n LIMIT 10`查看实际数据

## 参考资源

- [Neo4j官方文档](https://neo4j.com/docs/)
- [Cypher查询语言参考](https://neo4j.com/docs/cypher-manual/)
- [NetworkX文档](https://networkx.org/documentation/stable/)
- [LipoKG Schema文档](SCHEMA.md)

## 引用

使用LipoKG数据集请引用:

```bibtex
@dataset{lipoKG2024,
  author = {[Author Names]},
  title = {LipoKG: Lipoprotein Metabolism Knowledge Graph},
  year = {2024},
  publisher = {Zenodo},
  doi = {[DOI]},
  url = {[URL]}
}
```

## 许可证

本教程和数据集使用CC BY 4.0许可证发布。
