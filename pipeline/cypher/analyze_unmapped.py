#!/usr/bin/env python3
"""分析 Reactome 缓存中未映射的分子"""
import json
import re
from pathlib import Path
from collections import Counter

CACHE_DIR = Path(__file__).parent / "cache"

# 现有的 UniProt 映射
EXISTING_UNIPROTS = {
    "P02647", "P02652", "P04114", "P02654", "P02655", "P02656", "P02649", "P08519",
    "P06858", "P11150", "P04180", "Q9Y5X9", "P35510", "P04035",
    "P01130", "Q07954", "Q8WTV0", "P98155", "O95477", "O95975",
    "Q9UHC9", "P55157", "Q8IV16",
    "Q8NBP7", "Q9Y5C1", "Q9BY76", "Q9H9S8", "P36956", "Q13133",
    "Q03181", "P11597", "P55058",
}

def extract_proteins_from_cache():
    """从缓存文件中提取所有蛋白质参与者"""
    proteins = {}  # uniprot_id -> {name, count, gene}

    for cache_file in CACHE_DIR.glob("*.json"):
        try:
            with open(cache_file) as f:
                data = json.load(f)
        except:
            continue

        if not isinstance(data, dict):
            continue

        # 检查是否是反应对象
        schema_class = data.get("schemaClass", "")
        if schema_class not in ("Reaction", "BlackBoxEvent"):
            continue

        # 提取 inputs, outputs, catalysts, regulators 中的蛋白质
        for field in ["input", "output", "catalystActivity", "regulatedBy"]:
            items = data.get(field, [])
            if not isinstance(items, list):
                items = [items]

            for item in items:
                if not isinstance(item, dict):
                    continue
                extract_protein_from_entity(item, proteins)

    return proteins

def extract_protein_from_entity(entity, proteins, depth=0):
    """递归提取蛋白质信息"""
    if not isinstance(entity, dict) or depth > 3:
        return

    schema_class = entity.get("schemaClass", "")

    # 蛋白质/基因产物
    if schema_class == "EntityWithAccessionedSequence":
        ref = entity.get("referenceEntity", {})
        if isinstance(ref, dict):
            accession = ref.get("accession", "")
            db = ref.get("databaseName", "")
            if db == "UniProt" and accession:
                name = entity.get("displayName", "")
                name = re.sub(r"\s*\[.*\]", "", name).strip()
                gene = ref.get("geneName", [{}])
                gene_name = gene[0].get("displayName", "") if isinstance(gene, list) and gene else ""

                if accession not in proteins:
                    proteins[accession] = {"name": name, "count": 0, "gene": gene_name}
                proteins[accession]["count"] += 1

    # 复合物 — 递归提取组分
    elif schema_class == "Complex":
        for comp in entity.get("hasComponent", []):
            extract_protein_from_entity(comp, proteins, depth + 1)

    # CatalystActivity
    if "physicalEntity" in entity:
        extract_protein_from_entity(entity["physicalEntity"], proteins, depth + 1)
    if "activeUnit" in entity:
        for unit in (entity["activeUnit"] if isinstance(entity["activeUnit"], list) else [entity["activeUnit"]]):
            extract_protein_from_entity(unit, proteins, depth + 1)

    # Regulation
    if "regulator" in entity:
        extract_protein_from_entity(entity["regulator"], proteins, depth + 1)

def main():
    proteins = extract_proteins_from_cache()

    # 分类
    mapped = {k: v for k, v in proteins.items() if k in EXISTING_UNIPROTS}
    unmapped = {k: v for k, v in proteins.items() if k not in EXISTING_UNIPROTS}

    # 按出现频率排序
    unmapped_sorted = sorted(unmapped.items(), key=lambda x: x[1]["count"], reverse=True)

    print(f"总蛋白质: {len(proteins)}")
    print(f"已映射: {len(mapped)}")
    print(f"未映射: {len(unmapped)}")
    print()
    print("=" * 80)
    print("未映射蛋白质（按出现频率排序，前50个）：")
    print("=" * 80)
    print(f"{'UniProt ID':<12} {'基因名':<12} {'出现次数':<8} {'名称'}")
    print("-" * 80)
    for uniprot_id, info in unmapped_sorted[:50]:
        print(f"{uniprot_id:<12} {info['gene']:<12} {info['count']:<8} {info['name'][:50]}")

if __name__ == "__main__":
    main()
