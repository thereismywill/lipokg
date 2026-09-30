# LipoKG Quick Start Guide

快速开始使用LipoKG知识图谱的简明指南。

## 3分钟快速开始

### 1. 下载数据

```bash
# 从Zenodo下载
wget https://zenodo.org/records/[DOI]/files/lipokg-v1.0.0.zip
unzip lipokg-v1.0.0.zip
cd lipokg-v1.0.0
```

### 2. 导入Neo4j

```bash
# 停止Neo4j
neo4j stop

# 导入数据
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
  --overwrite-destination neo4j

# 启动Neo4j
neo4j start
```

### 3. 运行第一个查询

打开浏览器访问 http://localhost:7474，运行：

```cypher
// 查看图谱规模
MATCH (n)
RETURN labels(n)[0] AS type, count(n) AS count
ORDER BY count DESC;
```

## 常用查询速查

### 查找蛋白互作

```cypher
// 查找与APOE互作的蛋白
MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description
LIMIT 20;
```

### 查找疾病关联

```cypher
// 查找与家族性高胆固醇血症相关的基因
MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease {name: 'Familial Hypercholesterolemia'})
RETURN g.name
ORDER BY g.name;
```

### 查找致病性变异

```cypher
// 查找LDLR的致病性变异
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:KEGGGene {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance
LIMIT 20;
```

### 查找通路基因

```cypher
// 查找KEGG脂蛋白代谢通路中的基因
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Cholesterol metabolism'})
RETURN g.name
ORDER BY g.name;
```

### 发现知识裂缝

```cypher
// 查找高度连接但疾病关联少的基因
MATCH (g:STRINGProtein)
OPTIONAL MATCH (g)-[:STRING_INTERACTS]-(interactor)
OPTIONAL MATCH (g)-[:DISEASE_ASSOCIATION]->(d:Disease)
WITH g, count(DISTINCT interactor) AS interactions, count(DISTINCT d) AS diseases
WHERE interactions > 30 AND diseases < 3
RETURN g.name, interactions, diseases
ORDER BY interactions DESC
LIMIT 20;
```

## Python快速集成

```python
from neo4j import GraphDatabase
import networkx as nx

# 连接Neo4j
driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))

# 提取子图
with driver.session() as session:
    result = session.run("""
    MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(q)
    RETURN p.name AS source, q.name AS target
    LIMIT 100
    """)
    
    G = nx.Graph()
    for record in result:
        G.add_edge(record['source'], record['target'])

# 分析
print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
```

## 关键统计

- **核心节点总数**: 6,050（扩展schema: 6,475）
- **核心边总数**: 36,404（扩展schema: 37,177）
- **核心节点类型**: 7 (STRINGProtein, Particle, Molecule, Disease, ClinVarVariant, KEGGGene, Pathway)
- **核心边类型**: 7 (STRING_INTERACTS, COMPONENT_OF, MODIFIES, ASSEMBLED_BY, VARIANT_OF, MEMBER_OF, DISEASE_ASSOCIATION)
- **蛋白数**: 1,852 (STRING v12.0)
- **脂蛋白颗粒**: 7 (Chylomicron, VLDL, IDL, LDL, HDL, Lp(a), Remnant)
- **变异数**: 4,042 (ClinVar, pathogenic/likely pathogenic)
- **疾病/性状数**: 27
- **通路数**: 13 (1 KEGG, 12 Reactome)

## 覆盖度验证

**ETL完整性:**
- **KEGG hsa04979**: 88.5% (46/52 genes)
- **Reactome lipoprotein**: 85.9% (61/71 genes)
- **WikiPathways lipid**: 79.3% (73/92 genes)
- **总体通路完整度**: 78.9% (127/161 unique genes)

**独立验证:**
- **GO:0042157 (脂蛋白代谢过程)**: 92.3% (132/143 genes)
- **GLGC 2021 GWAS位点**: 64.9% (244/376 loci)
- **ClinGen剂量敏感基因**: 100% (25/25)
- **已发表综述基因列表**: 95.9% (93/97 genes)
- **专家 curated 54基因集**: 100% (54/54)

## 下一步

1. **阅读完整文档**: [README.md](README.md)
2. **查看模式文档**: [docs/SCHEMA.md](docs/SCHEMA.md)
3. **学习详细教程**: [docs/USAGE_TUTORIAL.md](docs/USAGE_TUTORIAL.md)
4. **运行更多查询**: [docs/CYPHER_EXAMPLES.cypher](docs/CYPHER_EXAMPLES.cypher)

## 获取帮助

- **问题**: 查看 [USAGE_TUTORIAL.md](docs/USAGE_TUTORIAL.md#故障排除)
- **GitHub**: [repository URL]
- **Email**: [corresponding author email]

## 引用

```bibtex
@dataset{lipoKG2024,
  title={LipoKG: Lipoprotein Metabolism Knowledge Graph},
  year={2024},
  publisher={Zenodo},
  doi={[DOI]}
}
```

## 许可证

CC BY 4.0 - 可自由分享和改编，需注明出处。
