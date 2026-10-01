#!/usr/bin/env python3
"""Rebuild Table S19 (Use Case 2) — reproducible prioritisation with an independent GWAS check.

What was wrong
--------------
The published table scored 30 proteins with a `score` (0.923 ... ) equal to the exact sum
of four component columns (path_similarity + neighbor_overlap + disease_cooccur +
expression_corr).  `expression_corr` requires expression data the deposit does not contain,
and no script in the project computes any of the four, so neither the score nor the
ranking was reproducible.  Two further defects surfaced on recomputation:

  * the ranks reported for the reference targets (2 / 4 / 7 / 11 / 15) do not match the rule
    the project's own query documents;
  * the caption says LPL and ANGPTL3 were "excluded by design due to existing drug-target
    edges", yet **all five** reference targets carry a drug-target edge in the deposit, so
    that rule applied consistently would empty the reference set.

Design of the replacement
-------------------------
To keep the GWAS check independent of the ranking, the two use disjoint data:

  ranking  = curated disease associations from DisGeNET / OMIM / Orphanet / expert curation
             **excluding the GLGC-derived `GWAS_Catalog` rows**
  validation = membership of the top candidates in the deposited GLGC 2021 lipid-trait
             associations (Supplementary Table S15, p < 5e-8)

  pool  = proteins in the interaction graph with >= 1 such curated annotation (55 proteins)
  order = curated count desc, then STRING degree desc, then symbol
  test  = rank sum of a reference set vs the exact distribution of the rank sum of k ranks
          drawn uniformly without replacement from 1..N (exact DP — no normal approximation,
          which matters because k is 5 and 8)

Output: supplementary/Table_S19_Rediscovery_Test.csv (rebuilt in place)
        Review/use_case2_rebuild.json
"""
import csv, json, pathlib
from collections import Counter
from fractions import Fraction
from math import comb

ROOT = pathlib.Path(__file__).resolve().parent.parent
D = ROOT / "data/zenodo_package_v1.2.0/data"
GWAS_SRC = "GWAS_Catalog"
EST5 = ["PCSK9", "HMGCR", "NPC1L1", "LPL", "ANGPTL3"]

name = {r["string_id"]: r["name"]
        for r in csv.DictReader(open(D / "string_proteins.csv", encoding="utf-8-sig"))}
deg = Counter()
for r in csv.DictReader(open(D / "string_interactions.csv", encoding="utf-8-sig")):
    deg[r["source"]] += 1
    deg[r["target"]] += 1
deg = {name[s]: v for s, v in deg.items()}

da = list(csv.DictReader(open(D / "disease_associations.csv", encoding="utf-8-sig")))
cur = Counter(r["source"] for r in da if r["source_db"] != GWAS_SRC)
allc = Counter(r["source"] for r in da)
gwas_genes = {r["gene"] for r in csv.DictReader(
    open(ROOT / "supplementary/Table_S15_GWAS_Catalog_Associations.csv", encoding="utf-8-sig"))}
drug = sorted({r["target_gene"] for r in csv.DictReader(
    open(D / "extended/drug_targets.csv", encoding="utf-8-sig"))})

pool = [g for g in deg if cur.get(g, 0) > 0]
N = len(pool)
order = sorted(pool, key=lambda g: (-cur[g], -deg[g], g))
rank = {g: i for i, g in enumerate(order, 1)}


def exact_rank_sum_p(ranks, n_pool):
    """P(rank sum <= observed), exact, for k ranks drawn without replacement from 1..n_pool."""
    k = len(ranks)
    obs = sum(ranks)
    dp = [Counter() for _ in range(k + 1)]
    dp[0][0] = 1
    for v in range(1, n_pool + 1):
        for j in range(min(k, v), 0, -1):
            for s, c in list(dp[j - 1].items()):
                if s + v <= obs:
                    dp[j][s + v] += c
    return Fraction(sum(dp[k].values()), comb(n_pool, k))


def test(genes, label):
    inp = [g for g in genes if g in rank]
    rs = [rank[g] for g in inp]
    p = exact_rank_sum_p(rs, N)
    rec = {"label": label, "n_reference": len(genes), "n_in_pool": len(inp),
           "outside_pool": sorted(g for g in genes if g not in rank),
           "ranks": {g: rank[g] for g in inp}, "rank_sum": sum(rs),
           "null_mean_rank_sum": len(rs) * (N + 1) / 2,
           "exact_one_sided_p": float(p)}
    print(f"  {label}（n={len(inp)} 在池内 / {len(genes)} 参考）")
    print("    " + ", ".join(f"{g}={rank[g]}" for g in inp))
    if rec["outside_pool"]:
        print(f"    池外：{', '.join(rec['outside_pool'])}")
    print(f"    秩和 {rec['rank_sum']}（零分布均值 {rec['null_mean_rank_sum']:.0f}）  "
          f"精确单尾 p = {float(p):.4f}")
    return rec


print(f"  策展疾病层（剔除 GWAS_Catalog）：{sum(cur.values())} 条 → 池 {N} 个图内蛋白")
print(f"  GWAS 验证集（Table_S15）：{len(gwas_genes)} 个基因")
print(f"  沉积药物表：{len(drug)} 个基因\n")
r_est = test(EST5, "5 个既定降脂靶点")
print()
drug_in = [g for g in drug if g in deg]
r_drug = test(drug_in, "沉积药物表里的在图基因")

# 独立验证：非既定靶点、无药物边的前 10 个候选
cand = [g for g in order if g not in EST5 and g not in drug][:10]
cand_gwas = {g: (g in gwas_genes) for g in cand}
n_hit = sum(cand_gwas.values())
print(f"\n  独立 GWAS 验证：前 10 个候选（非既定靶点、无药物边）中 "
      f"{n_hit}/{len(cand)} 个带 GLGC 2021 血脂关联")
for i, g in enumerate(cand, 1):
    print(f"    {i:>2}. {g:<9} 策展疾病 {cur[g]:>2} 度 {deg[g]:>4}  GWAS {'✓' if cand_gwas[g] else '✗'}")

# 敏感性：若把 GWAS 行也算进排序
order_all = sorted([g for g in deg if allc.get(g, 0) > 0], key=lambda g: (-allc[g], -deg[g], g))
rk_all = {g: i for i, g in enumerate(order_all, 1)}
Na = len(order_all)
sens = {}
for lbl, genes in (("5 个既定靶点", EST5), ("沉积药物基因", drug_in)):
    rs = [rk_all[g] for g in genes if g in rk_all]
    sens[lbl] = {"rank_sum": sum(rs), "exact_one_sided_p": float(exact_rank_sum_p(rs, Na)),
                 "ranks": {g: rk_all[g] for g in genes if g in rk_all}}
print(f"\n  [敏感性] 排序若含 GWAS 行（池 {Na}）："
      + "；".join(f"{k} p = {v['exact_one_sided_p']:.4f}" for k, v in sens.items()))

rows = []
for g in order:
    rows.append({
        "rank": rank[g],
        "gene_symbol": g,
        "curated_disease_associations": cur[g],
        "all_disease_associations": allc.get(g, 0),
        "degree": deg[g],
        "has_gwas_lipid_association": "TRUE" if g in gwas_genes else "FALSE",
        "is_established_target": "TRUE" if g in EST5 else "FALSE",
        "has_drug_target_edge": "TRUE" if g in drug else "FALSE",
        "is_repurposing_candidate": "TRUE" if (g in cand) else "FALSE",
    })
out = ROOT / "supplementary/Table_S19_Rediscovery_Test.csv"
with open(out, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

meta = {
    "ranking_rule": "curated disease associations desc, then STRING degree desc, then symbol",
    "ranking_scope": "curated disease associations from DisGeNET/OMIM/Orphanet/expert curation, "
                     "i.e. data/disease_associations.csv excluding source_db == 'GWAS_Catalog'",
    "pool_size": N,
    "gwas_validation": "membership of Supplementary Table S15 (GLGC 2021 lipid-trait "
                       "associations, p < 5e-8); independent of the ranking by construction",
    "test": "exact one-sided rank-sum test vs k ranks drawn uniformly without replacement",
    "reference_5_established": r_est,
    "reference_deposited_drug_genes": r_drug,
    "validation_top10_candidates": {"candidates": cand, "in_gwas": cand_gwas,
                                    "n_hit": n_hit, "n_total": len(cand)},
    "sensitivity_including_gwas_rows": sens,
    "withdrawn": "the previous `score` (= path_similarity + neighbor_overlap + disease_cooccur + "
                 "expression_corr; nothing in the project computes those, and expression_corr "
                 "needs data the deposit lacks), the reported ranks 2/4/7/11/15, and the rule "
                 "'excluded by design due to existing drug-target edges' — all five reference "
                 "targets carry drug-target edges, so that rule would empty the reference set",
    "table": rows,
}
(ROOT / "Review/use_case2_rebuild.json").write_text(
    json.dumps(meta, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"\n  ✅ Table_S19 已重建（{len(rows)} 行）；Review/use_case2_rebuild.json")
