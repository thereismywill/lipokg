#!/usr/bin/env python3
"""
LipoKG Shared Neo4j Connection Module
=====================================
提供统一的Neo4j连接和常用查询函数。
"""

from neo4j import GraphDatabase
import os
import json
import csv
from datetime import datetime

# ============================================================
# 连接配置
# ============================================================
NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASS = os.environ.get("NEO4J_PASS", "lipid2026")

_driver = None

def get_driver():
    """获取Neo4j驱动实例（单例模式）"""
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASS))
    return _driver

def run_cypher(query, params=None):
    """执行Cypher查询并返回结果列表"""
    driver = get_driver()
    with driver.session() as session:
        result = session.run(query, params or {})
        return [dict(record) for record in result]

def close_driver():
    """关闭驱动"""
    global _driver
    if _driver:
        _driver.close()
        _driver = None

# ============================================================
# 常用查询
# ============================================================

def get_all_nodes():
    """获取所有节点"""
    return run_cypher("""
        MATCH (n)
        RETURN labels(n) AS labels, n.id AS id,
               n.name AS name, properties(n) AS props
    """)

def get_all_edges():
    """获取所有边"""
    return run_cypher("""
        MATCH (a)-[r]->(b)
        RETURN labels(a) AS src_labels, a.id AS src_id, a.name AS src_name,
               type(r) AS rel_type, properties(r) AS rel_props,
               labels(b) AS tgt_labels, b.id AS tgt_id, b.name AS tgt_name
    """)

def get_node_counts():
    """获取各类节点数量"""
    return run_cypher("""
        MATCH (n)
        RETURN labels(n) AS labels, COUNT(n) AS count
        ORDER BY count DESC
    """)

def get_edge_counts():
    """获取各类边数量"""
    return run_cypher("""
        MATCH ()-[r]->()
        RETURN type(r) AS rel_type, COUNT(r) AS count
        ORDER BY count DESC
    """)

def get_node_stats():
    """获取节点统计信息"""
    return run_cypher("""
        MATCH (n)
        RETURN labels(n) AS labels,
               COUNT(n) AS count,
               min(n.name) AS example
    """)

# ============================================================
# 导出函数
# ============================================================

def export_to_csv(data, filepath):
    """将查询结果导出为CSV"""
    if not data:
        print(f"  ⚠ No data to export for {filepath}")
        return
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    keys = data[0].keys()
    with open(filepath, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=keys)
        writer.writeheader()
        for row in data:
            # 转换非字符串值
            clean_row = {}
            for k, v in row.items():
                if isinstance(v, (list, dict)):
                    clean_row[k] = json.dumps(v, ensure_ascii=False)
                else:
                    clean_row[k] = v
            writer.writerow(clean_row)
    print(f"  ✅ Exported {len(data)} rows to {filepath}")

def export_graph_for_cytoscape(filepath):
    """导出节点和边为Cytoscape兼容的JSON格式"""
    os.makedirs(os.path.dirname(filepath), exist_ok=True)

    nodes_data = run_cypher("""
        MATCH (n)
        RETURN n.id AS id, n.name AS name, labels(n) AS labels,
               properties(n) AS props
    """)

    edges_data = run_cypher("""
        MATCH (a)-[r]->(b)
        RETURN a.id AS source, b.id AS target,
               type(r) AS relationship, properties(r) AS props
    """)

    # 构建Cytoscape JSON
    cytoscape_data = {
        "elements": {
            "nodes": [],
            "edges": []
        }
    }

    for n in nodes_data:
        node = {
            "data": {
                "id": str(n["id"]),
                "name": str(n.get("name", n["id"])),
                "label": n["labels"][0] if n["labels"] else "Unknown",
                **{k: v for k, v in (n.get("props") or {}).items()
                   if not isinstance(v, (list, dict))}
            }
        }
        cytoscape_data["elements"]["nodes"].append(node)

    for i, e in enumerate(edges_data):
        edge = {
            "data": {
                "id": f"e{i}",
                "source": str(e["source"]),
                "target": str(e["target"]),
                "relationship": e["relationship"],
            }
        }
        cytoscape_data["elements"]["edges"].append(edge)

    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(cytoscape_data, f, indent=2, ensure_ascii=False)

    print(f"  ✅ Exported {len(nodes_data)} nodes, {len(edges_data)} edges")
    print(f"     → {filepath}")

# ============================================================
# 路径配置
# ============================================================

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
DATA_DIR = os.path.join(PROJECT_ROOT, "data")
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "output")

def get_data_path(*parts):
    return os.path.join(DATA_DIR, *parts)

def get_output_path(*parts):
    return os.path.join(OUTPUT_DIR, *parts)

if __name__ == "__main__":
    print("=== LipoKG Neo4j Status ===\n")
    try:
        nodes = get_node_counts()
        print("Node counts:")
        for n in nodes:
            print(f"  {n['labels']}: {n['count']}")

        edges = get_edge_counts()
        print(f"\nEdge counts:")
        for e in edges:
            print(f"  {e['rel_type']}: {e['count']}")

        total_nodes = sum(n['count'] for n in nodes)
        total_edges = sum(e['count'] for e in edges)
        print(f"\nTotal: {total_nodes} nodes, {total_edges} edges")
    except Exception as e:
        print(f"❌ Connection error: {e}")
    finally:
        close_driver()
