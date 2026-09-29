#!/usr/bin/env python3
"""
reactome_import.py — 从 Reactome 拉取脂蛋白代谢通路数据，生成 Cypher 导入语句

目标通路：
  R-HSA-174824  Plasma lipoprotein assembly, remodeling, and clearance
  R-HSA-191273  Cholesterol biosynthesis
  R-HSA-1655829 Regulation of cholesterol biosynthesis by SREBP

流程：
  1. 递归遍历通路层级，收集所有反应
  2. 对每个反应提取 inputs/outputs/catalysts/regulators
  3. 通过 UniProt ID 映射到现有图谱节点
  4. 生成 Cypher 语句（CREATE 新反应节点 + MERGE 关系）
"""

import json
import os
import re
import sys
import time
import urllib.request
import urllib.error
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple

# ============================================================
# 配置
# ============================================================

BASE_URL = "https://reactome.org/ContentService"
CACHE_DIR = Path(__file__).parent / "cache"
OUTPUT_FILE = Path(__file__).parent / "reactome_layer.cypher"

# 目标通路（脂蛋白代谢相关）
TARGET_PATHWAYS = [
    "R-HSA-174824",   # Plasma lipoprotein assembly, remodeling, and clearance
    "R-HSA-191273",   # Cholesterol biosynthesis
    "R-HSA-1655829",  # Regulation of cholesterol biosynthesis by SREBP
    "R-HSA-194068",   # Bile acid and bile salt metabolism
]

# 延迟（秒）避免过快请求
API_DELAY = 0.3

# ============================================================
# UniProt ID → 现有图谱节点 ID 映射表
# ============================================================

UNIPROT_TO_GRAPH: Dict[str, str] = {
    # 载脂蛋白
    "P02647": "mol:ApoA1",     # APOA1
    "P02652": "mol:ApoA2",     # APOA2
    "P04114": "mol:ApoB100",   # APOB (ApoB-100)
    "P02654": "mol:ApoC1",     # APOC1
    "P02655": "mol:ApoC2",     # APOC2
    "P02656": "mol:ApoC3",     # APOC3
    "P02649": "mol:ApoE",      # APOE
    "P08519": "mol:ApoA_",     # LPA / Apo(a)

    # 酶
    "P06858": "mol:LPL",       # LPL
    "P11150": "mol:HL",        # LIPC
    "P04180": "mol:LCAT",      # LCAT
    "Q9Y5X9": "mol:EL",        # LIPG
    "P35510": "mol:ACAT",      # SOAT1
    "P04035": "mol:HMGCR",     # HMGCR

    # 受体/转运蛋白
    "P01130": "mol:LDLR",      # LDLR
    "Q07954": "mol:LRP1",      # LRP1
    "Q8WTV0": "mol:SR_BI",     # SCARB1
    "P98155": "mol:VLDLR",     # VLDLR
    "O95477": "mol:ABCA1",     # ABCA1
    "O95975": "mol:ABCG1",     # ABCG1 (Q9H210 is more common)
    "Q9UHC9": "mol:NPC1L1",    # NPC1L1
    "P55157": "mol:MTP",       # MTTP (Q86V39 is L subunit)
    "Q8IV16": "mol:GPIHBP1",   # GPIHBP1

    # 调控因子
    "Q8NBP7": "mol:PCSK9",     # PCSK9
    "Q9Y5C1": "mol:ANGPTL3",   # ANGPTL3
    "Q9BY76": "mol:ANGPTL4",   # ANGPTL4
    "Q9H9S8": "mol:ANGPTL8",   # ANGPTL8 (C19orf80)
    "P36956": "mol:SREBP2",    # SREBF2
    "Q13133": "mol:LXR",       # NR1H3 (LXRα)
    "Q03181": "mol:PPARa",     # PPARA
    "P11597": "mol:CETP",      # CETP
    "P55058": "mol:PLTP",      # PLTP
}

# 基因名 → 图谱节点 ID（备选映射，用于非 UniProt 实体）
GENE_TO_GRAPH: Dict[str, str] = {
    "APOA1": "mol:ApoA1", "APOA2": "mol:ApoA2", "APOB": "mol:ApoB100",
    "APOC1": "mol:ApoC1", "APOC2": "mol:ApoC2", "APOC3": "mol:ApoC3",
    "APOE": "mol:ApoE", "LPA": "mol:ApoA_",
    "LPL": "mol:LPL", "LIPC": "mol:HL", "LCAT": "mol:LCAT",
    "LIPG": "mol:EL", "SOAT1": "mol:ACAT", "SOAT2": "mol:ACAT",
    "HMGCR": "mol:HMGCR",
    "LDLR": "mol:LDLR", "LRP1": "mol:LRP1", "SCARB1": "mol:SR_BI",
    "VLDLR": "mol:VLDLR", "ABCA1": "mol:ABCA1", "ABCG1": "mol:ABCG1",
    "NPC1L1": "mol:NPC1L1", "MTTP": "mol:MTP", "GPIHBP1": "mol:GPIHBP1",
    "PCSK9": "mol:PCSK9", "ANGPTL3": "mol:ANGPTL3", "ANGPTL4": "mol:ANGPTL4",
    "ANGPTL8": "mol:ANGPTL8", "C19orf80": "mol:ANGPTL8",
    "SREBF2": "mol:SREBP2", "NR1H3": "mol:LXR", "NR1H2": "mol:LXR",
    "PPARA": "mol:PPARa", "CETP": "mol:CETP", "PLTP": "mol:PLTP",
}

# Reactome 通路 stId → 图谱通路 ID 映射
PATHWAY_TO_GRAPH: Dict[str, str] = {
    # 直接映射到现有通路
    "R-HSA-174824": "pathway:endogenous",  # 总体对应
    "R-HSA-8963898": "pathway:endogenous",  # assembly
    "R-HSA-8963888": "pathway:exogenous",   # CM assembly
    "R-HSA-8866423": "pathway:endogenous",  # VLDL assembly
    "R-HSA-8963896": "pathway:rct",         # HDL assembly
    "R-HSA-8963899": "pathway:endogenous",  # remodeling
    "R-HSA-8964041": "pathway:endogenous",  # LDL remodeling
    "R-HSA-8964043": "pathway:endogenous",  # clearance
    "R-HSA-8964026": "pathway:exogenous",   # CM clearance
    "R-HSA-191273": "pathway:cholesterol_homeostasis",
    "R-HSA-1655829": "pathway:cholesterol_homeostasis",
    "R-HSA-194068": "pathway:cholesterol_homeostasis",
}


# ============================================================
# API 请求
# ============================================================

def api_get(endpoint: str, use_cache: bool = True) -> Optional[dict]:
    """GET 请求 Reactome API，带本地缓存"""
    cache_key = endpoint.replace("/", "_").replace("?", "_")
    cache_path = CACHE_DIR / f"{cache_key}.json"

    if use_cache and cache_path.exists():
        with open(cache_path, "r") as f:
            return json.load(f)

    url = f"{BASE_URL}/{endpoint}"
    try:
        req = urllib.request.Request(url, headers={"Accept": "application/json"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            # 缓存
            CACHE_DIR.mkdir(parents=True, exist_ok=True)
            with open(cache_path, "w") as f:
                json.dump(data, f, indent=2)
            time.sleep(API_DELAY)
            return data
    except urllib.error.HTTPError as e:
        print(f"  ⚠ HTTP {e.code}: {endpoint}", file=sys.stderr)
        return None
    except Exception as e:
        print(f"  ⚠ Error: {endpoint}: {e}", file=sys.stderr)
        return None


# ============================================================
# 通路遍历
# ============================================================

def collect_reactions(pathway_stid: str, depth: int = 0) -> List[dict]:
    """递归收集通路下所有反应"""
    indent = "  " * depth
    print(f"{indent}📂 遍历通路: {pathway_stid}", file=sys.stderr)

    data = api_get(f"data/query/{pathway_stid}")
    if not data:
        return []

    pathway_name = data.get("displayName", "?")
    schema_class = data.get("schemaClass", "")
    print(f"{indent}   {pathway_name} ({schema_class})", file=sys.stderr)

    reactions = []
    children = data.get("hasEvent", [])

    for child in children:
        child_stid = child.get("stId", "")
        child_class = child.get("schemaClass", "")
        child_name = child.get("displayName", "?")

        if child_class in ("Pathway", "TopLevelPathway"):
            # 递归子通路
            reactions.extend(collect_reactions(child_stid, depth + 1))
        elif child_class in ("Reaction", "BlackBoxEvent"):
            # 收集反应
            print(f"{indent}   ⚛ 反应: {child_name}", file=sys.stderr)
            rxn_data = api_get(f"data/query/{child_stid}")
            if rxn_data:
                rxn_data["_parent_pathway"] = pathway_stid
                reactions.append(rxn_data)

    return reactions


# ============================================================
# 实体解析
# ============================================================

def resolve_entity_to_graph_id(entity) -> Optional[str]:
    """
    尝试将 Reactome 实体映射到现有图谱节点 ID
    返回: 图谱节点 ID 或 None
    """
    # 处理整数引用（dbId）而非完整对象的情况
    if isinstance(entity, int):
        return None

    schema_class = entity.get("schemaClass", "")

    # 1. 蛋白质/基因产物 — 通过 UniProt ID
    if schema_class == "EntityWithAccessionedSequence":
        # 尝试从 referenceEntity 获取 UniProt ID
        ref_entity = entity.get("referenceEntity", {})
        if ref_entity:
            accession = ref_entity.get("accession", "")
            database = ref_entity.get("databaseName", "")
            if database == "UniProt" and accession in UNIPROT_TO_GRAPH:
                return UNIPROT_TO_GRAPH[accession]

        # 尝试从 name 获取基因名
        name = entity.get("displayName", "")
        # 去掉 [compartment] 部分
        gene_name = re.sub(r"\s*\[.*\]", "", name).strip()
        # 处理复合物中的多个蛋白：取第一个
        gene_name = gene_name.split(":")[0].strip()
        if gene_name in GENE_TO_GRAPH:
            return GENE_TO_GRAPH[gene_name]

    # 2. 复合物 — 提取组分蛋白
    elif schema_class == "Complex":
        components = entity.get("hasComponent", [])
        for comp in components:
            mapped = resolve_entity_to_graph_id(comp)
            if mapped:
                return mapped
        # 尝试从名称推断
        name = entity.get("displayName", "")
        name_clean = re.sub(r"\s*\[.*\]", "", name).strip()
        for gene, gid in GENE_TO_GRAPH.items():
            if gene.lower() in name_clean.lower():
                return gid

    # 3. 小分子 — ChEBI
    elif schema_class == "SimpleEntity":
        name = entity.get("displayName", "")
        name_clean = re.sub(r"\s*\[.*\]", "", name).strip().lower()
        # 映射脂质分子
        lipid_map = {
            "triglyceride": "lipid:TG", "triacylglycerol": "lipid:TG",
            "cholesteryl ester": "lipid:CE", "cholesterol ester": "lipid:CE",
            "cholesterol": "lipid:FC", "free cholesterol": "lipid:FC",
            "phospholipid": "lipid:PL", "phosphatidylcholine": "lipid:PL",
            "fatty acid": "lipid:FFA", "free fatty acid": "lipid:FFA",
        }
        for key, lipid_id in lipid_map.items():
            if key in name_clean:
                return lipid_id

    return None


def resolve_catalyst(catalyst_activity: dict) -> Optional[str]:
    """从催化剂活性对象中提取催化分子"""
    # 优先取 activeUnit（具体活性亚基）
    active_units = catalyst_activity.get("activeUnit", [])
    for unit in active_units:
        mapped = resolve_entity_to_graph_id(unit)
        if mapped:
            return mapped

    # 否则取整个 physicalEntity
    phys_entity = catalyst_activity.get("physicalEntity", {})
    if phys_entity:
        mapped = resolve_entity_to_graph_id(phys_entity)
        if mapped:
            return mapped

    return None


def resolve_regulator(regulation: dict) -> Tuple[Optional[str], str]:
    """
    从调控对象中提取调控分子和方向
    返回: (graph_id, direction)  direction = "activates" | "inhibits"
    """
    schema_class = regulation.get("schemaClass", "")
    direction = "activates" if "Positive" in schema_class else "inhibits"

    regulator = regulation.get("regulator", {})
    if regulator:
        mapped = resolve_entity_to_graph_id(regulator)
        return mapped, direction

    return None, direction


# ============================================================
# Cypher 生成
# ============================================================

def escape_cypher_string(s: str) -> str:
    """转义 Cypher 字符串中的特殊字符"""
    return s.replace("\\", "\\\\").replace("'", "\\'").replace('"', '\\"').replace("\n", " ")


def generate_cypher(reactions: List[dict]) -> str:
    """从反应列表生成 Cypher 导入语句"""
    lines = [
        "// ============================================================",
        "//  Reactome 脂蛋白代谢通路 — 自动导入",
        f"//  生成时间: {time.strftime('%Y-%m-%d %H:%M')}",
        f"//  反应数: {len(reactions)}",
        "// ============================================================",
        "",
        "",
    ]

    # 统计
    created_reactions: Set[str] = set()
    created_edges: Set[str] = set()  # 避免重复边
    new_reaction_nodes = []
    new_edges = []
    new_participant_nodes = []  # Reactome 中有但图谱中没有的分子
    unmapped_entities: Set[str] = set()

    for rxn in reactions:
        rxn_stid = rxn.get("stId", "")
        rxn_name = rxn.get("displayName", "")
        rxn_class = rxn.get("schemaClass", "")
        parent_pw = rxn.get("_parent_pathway", "")

        if rxn_stid in created_reactions:
            continue
        created_reactions.add(rxn_stid)

        # 文献引用
        lit_refs = rxn.get("literatureReference", [])
        pmids = [str(ref.get("pubMedIdentifier", "")) for ref in lit_refs if ref.get("pubMedIdentifier")]

        # GO 注释
        go_terms = rxn.get("goBiologicalProcess", {})

        # 亚细胞定位
        compartments = rxn.get("compartment", [])
        compartment_names = [c.get("displayName", "") for c in compartments]

        # ---------- 创建 Reaction 节点 ----------
        rxn_id = f"rxn:reactome:{rxn_stid}"
        props = {
            "id": rxn_id,
            "name": rxn_name,
            "reactome_id": rxn_stid,
            "source": "Reactome",
        }
        if pmids:
            props["pmids"] = ", ".join(pmids[:5])
        if compartment_names:
            props["compartment"] = ", ".join(compartment_names)
        if go_terms:
            props["go_term"] = go_terms.get("displayName", "")
        if lit_refs:
            props["evidence"] = f"Reactome (reviewed, {len(lit_refs)} refs)"

        props_str = ", ".join(f'{k}: "{escape_cypher_string(str(v))}"' for k, v in props.items())
        new_reaction_nodes.append(f'CREATE (:{rxn_class} {{{props_str}}});')

        # ---------- 连接到父通路 ----------
        parent_graph_id = PATHWAY_TO_GRAPH.get(parent_pw)
        if parent_graph_id:
            edge_key = f"{rxn_id}-BELONGS->{parent_graph_id}"
            if edge_key not in created_edges:
                created_edges.add(edge_key)
                new_edges.append(
                    f'MATCH (r {{id:"{rxn_id}"}}), (pw {{id:"{parent_graph_id}"}})\n'
                    f'MERGE (r)-[:BELONGS_TO_PATHWAY {{source:"Reactome"}}]->(pw);'
                )

        # ---------- 解析 inputs ----------
        inputs = rxn.get("input", [])
        input_ids = set()
        for inp in inputs:
            mapped = resolve_entity_to_graph_id(inp)
            if mapped:
                input_ids.add(mapped)
            else:
                name = inp.get("displayName", "?") if isinstance(inp, dict) else f"dbId:{inp}"
                unmapped_entities.add(f"INPUT: {name}")

        # ---------- 解析 outputs ----------
        outputs = rxn.get("output", [])
        output_ids = set()
        for out in outputs:
            mapped = resolve_entity_to_graph_id(out)
            if mapped:
                output_ids.add(mapped)
            else:
                name = out.get("displayName", "?") if isinstance(out, dict) else f"dbId:{out}"
                unmapped_entities.add(f"OUTPUT: {name}")

        # ---------- 解析 catalysts ----------
        catalysts = rxn.get("catalystActivity", [])
        catalyst_ids = set()
        for cat in catalysts:
            # 处理整数引用
            if isinstance(cat, int):
                cat_full = api_get(f"data/query/{cat}")
                if cat_full:
                    cat = cat_full
                else:
                    continue

            # 如果 catalystActivity 只有摘要，需要深入获取
            if isinstance(cat, dict) and "physicalEntity" not in cat and "activeUnit" not in cat:
                cat_dbid = cat.get("dbId")
                if cat_dbid:
                    cat_full = api_get(f"data/query/{cat_dbid}")
                    if cat_full:
                        cat = cat_full

            mapped = resolve_catalyst(cat)
            if mapped:
                catalyst_ids.add(mapped)
            else:
                name = cat.get("displayName", "?") if isinstance(cat, dict) else f"dbId:{cat}"
                unmapped_entities.add(f"CATALYST: {name}")

        # ---------- 解析 regulators ----------
        regulations = rxn.get("regulatedBy", [])
        regulator_pairs: List[Tuple[str, str]] = []  # (graph_id, direction)
        for reg in regulations:
            # 处理整数引用
            if isinstance(reg, int):
                reg_full = api_get(f"data/query/{reg}")
                if reg_full:
                    reg = reg_full
                else:
                    continue

            # 获取完整调控对象
            if isinstance(reg, dict) and "regulator" not in reg:
                reg_dbid = reg.get("dbId")
                if reg_dbid:
                    reg_full = api_get(f"data/query/{reg_dbid}")
                    if reg_full:
                        reg = reg_full

            mapped, direction = resolve_regulator(reg)
            if mapped:
                regulator_pairs.append((mapped, direction))
            else:
                name = reg.get("displayName", "?") if isinstance(reg, dict) else f"dbId:{reg}"
                unmapped_entities.add(f"REGULATOR: {name}")

        # ---------- 生成边 ----------

        # 底物 → 反应 (SUBSTRATE_OF)
        for inp_id in input_ids:
            edge_key = f"{inp_id}-SUBSTRATE->{rxn_id}"
            if edge_key not in created_edges:
                created_edges.add(edge_key)
                new_edges.append(
                    f'MATCH (n {{id:"{inp_id}"}}), (r {{id:"{rxn_id}"}})\n'
                    f'MERGE (n)-[:SUBSTRATE_OF {{source:"Reactome"}}]->(r);'
                )

        # 反应 → 产物 (PRODUCES)
        for out_id in output_ids:
            edge_key = f"{rxn_id}-PRODUCES->{out_id}"
            if edge_key not in created_edges:
                created_edges.add(edge_key)
                new_edges.append(
                    f'MATCH (r {{id:"{rxn_id}"}}), (n {{id:"{out_id}"}})\n'
                    f'MERGE (r)-[:PRODUCES {{source:"Reactome"}}]->(n);'
                )

        # 催化剂 → 反应 (CATALYZES)
        for cat_id in catalyst_ids:
            edge_key = f"{cat_id}-CATALYZES->{rxn_id}"
            if edge_key not in created_edges:
                created_edges.add(edge_key)
                new_edges.append(
                    f'MATCH (n {{id:"{cat_id}"}}), (r {{id:"{rxn_id}"}})\n'
                    f'MERGE (n)-[:CATALYZES {{source:"Reactome", reactome_id:"{rxn_stid}"}}]->(r);'
                )

        # 调控因子 → 反应
        for reg_id, direction in regulator_pairs:
            rel_type = "ACTIVATES" if direction == "activates" else "INHIBITS"
            edge_key = f"{reg_id}-{rel_type}->{rxn_id}"
            if edge_key not in created_edges:
                created_edges.add(edge_key)
                new_edges.append(
                    f'MATCH (n {{id:"{reg_id}"}}), (r {{id:"{rxn_id}"}})\n'
                    f'MERGE (n)-[:{rel_type} {{source:"Reactome", reactome_id:"{rxn_stid}"}}]->(r);'
                )

        # 反应 → 反应（前后顺序关系）
        preceding = rxn.get("precedingEvent", [])
        for prev in preceding:
            prev_stid = prev.get("stId", "")
            if prev_stid:
                prev_rxn_id = f"rxn:reactome:{prev_stid}"
                edge_key = f"{prev_rxn_id}-PRECEDES->{rxn_id}"
                if edge_key not in created_edges:
                    created_edges.add(edge_key)
                    new_edges.append(
                        f'MATCH (r1 {{id:"{prev_rxn_id}"}}), (r2 {{id:"{rxn_id}"}})\n'
                        f'MERGE (r1)-[:PRECEDES {{source:"Reactome"}}]->(r2);'
                    )

    # ---------- 组装输出 ----------
    lines.append(f"// ====== 新增 Reaction 节点: {len(new_reaction_nodes)} ======\n")
    lines.extend(new_reaction_nodes)
    lines.append("")

    lines.append(f"// ====== 新增关系: {len(new_edges)} ======\n")
    lines.extend(new_edges)
    lines.append("")

    # 验证查询
    lines.extend([
        "// ============================================================",
        "//  验证查询",
        "// ============================================================",
        "",
        "// Reactome 导入的反应数",
        "MATCH (n) WHERE n.source = 'Reactome' RETURN labels(n)[0] AS type, count(n) AS count;",
        "",
        "// Reactome 导入的边数",
        "MATCH ()-[r]->() WHERE r.source = 'Reactome' RETURN type(r) AS edge_type, count(r) AS count;",
        "",
        "// 全局统计",
        "MATCH (n) WITH count(n) AS nodes MATCH ()-[r]->() WITH nodes, count(r) AS edges",
        "RETURN nodes, edges, round(edges * 1.0 / nodes, 2) AS avg_degree;",
    ])

    # 打印未映射实体报告
    if unmapped_entities:
        lines.insert(0, f"// ⚠ {len(unmapped_entities)} 个未映射实体（已跳过）")
        print(f"\n⚠ {len(unmapped_entities)} 个 Reactome 实体未映射到现有图谱：", file=sys.stderr)
        for ue in sorted(unmapped_entities)[:20]:
            print(f"   {ue}", file=sys.stderr)
        if len(unmapped_entities) > 20:
            print(f"   ... 还有 {len(unmapped_entities) - 20} 个", file=sys.stderr)

    return "\n".join(lines)


# ============================================================
# 主流程
# ============================================================

def main():
    print("=" * 60, file=sys.stderr)
    print("  Reactome 脂蛋白代谢通路导入", file=sys.stderr)
    print("=" * 60, file=sys.stderr)

    # 1. 收集所有反应
    all_reactions = []
    for pathway_stid in TARGET_PATHWAYS:
        print(f"\n🔬 处理通路: {pathway_stid}", file=sys.stderr)
        reactions = collect_reactions(pathway_stid)
        print(f"   → 收集到 {len(reactions)} 个反应", file=sys.stderr)
        all_reactions.extend(reactions)

    # 去重
    seen_stids: Set[str] = set()
    unique_reactions = []
    for rxn in all_reactions:
        stid = rxn.get("stId", "")
        if stid not in seen_stids:
            seen_stids.add(stid)
            unique_reactions.append(rxn)

    print(f"\n📊 总计: {len(unique_reactions)} 个唯一反应（去重后）", file=sys.stderr)

    # 2. 生成 Cypher
    print("\n🔧 生成 Cypher 语句...", file=sys.stderr)
    cypher = generate_cypher(unique_reactions)

    # 3. 写入文件
    OUTPUT_FILE.write_text(cypher, encoding="utf-8")
    print(f"\n✅ 已写入: {OUTPUT_FILE}", file=sys.stderr)
    print(f"   文件大小: {OUTPUT_FILE.stat().st_size / 1024:.1f} KB", file=sys.stderr)
    print("", file=sys.stderr)


if __name__ == "__main__":
    main()
