#!/usr/bin/env python3
"""Use Case 1 v3 — final, reproducible rebuild of Table S18 and Figure 5 panel A.

Findings that drive the redesign
--------------------------------
The published Table S18 is not reproducible:
  * 3 of its 20 genes (GALNT2, TM6SF2, GCKR) are not in the deposited graph;
  * its interaction_degree column disagrees with the deposited STRING edges;
  * its gap_score column is a smooth arithmetic run (0.847 ... 0.592) that matches
    no formula, including the project's own `degree/(diseases+1)`.
Recomputing with the documented formula shows *why* the original could not work:
only 65-78 of the 1,852 deposited proteins carry any disease association, so
`degree/(diseases+1)` is a degree ranking with a small perturbation.  The top 20
are generic hubs (AKT1, TNF, IL6, ...), and the literature comparison is not
significant (p = 0.61), so the panel does not support "fewer publications".

This script therefore rebuilds the table from the deposited graph alone.  Every
column is either read from a deposited CSV or is a PubMed count from a fixed,
recorded query.  Controls are degree-matched proteins drawn from the whole graph
excluding the top 20 themselves (a protein is never its own control), which is a
reproducible rule and avoids the core/non-core confound.

Outputs
  supplementary/Table_S18_Gap_Score_Validation.csv   (rebuilt in place)
  Review/use_case1_rebuild_v3.json                   (all statistics + provenance)
  Review/pubmed_cache.json                           (query cache)
"""
import csv, json, pathlib, statistics, time, urllib.parse, urllib.request
from collections import Counter
from math import erf, sqrt

ROOT = pathlib.Path(__file__).resolve().parent.parent
D = ROOT / "data/zenodo_package_v1.2.0/data"
CACHE = ROOT / "Review/pubmed_cache.json"
TOP_N = 20
TAG = ("lipoprotein OR cholesterol OR lipid OR triglyceride OR HDL OR LDL OR "
       "dyslipidaemia OR atherosclerosis")
Y0, Y1 = 2023, 2025

# ---------------------------------------------------------------- graph metrics
prot = list(csv.DictReader(open(D / "string_proteins.csv", encoding="utf-8-sig")))
inter = list(csv.DictReader(open(D / "string_interactions.csv", encoding="utf-8-sig")))
name = {r["string_id"]: r["name"] for r in prot}
deg_sid = Counter()
for r in inter:
    deg_sid[r["source"]] += 1
    deg_sid[r["target"]] += 1
deg = {name[s]: v for s, v in deg_sid.items()}

da = list(csv.DictReader(open(D / "disease_associations.csv", encoding="utf-8-sig")))
n_dis = Counter(r["source"] for r in da)
seed = {r["symbol"] for r in csv.DictReader(
    open(ROOT / "supplementary/Table_S1_Seed_Genes.csv", encoding="utf-8-sig"))}

# documented filter: degree > 30 AND diseases < 3
cand = [{"gene": g, "degree": d, "diseases": n_dis.get(g, 0)}
        for g, d in deg.items() if d > 30 and n_dis.get(g, 0) < 3]
for c in cand:
    c["gap_score"] = round(c["degree"] / (c["diseases"] + 1), 2)
cand.sort(key=lambda c: (-c["gap_score"], c["gene"]))
top = cand[:TOP_N]
top_genes = {c["gene"] for c in top}

# controls: degree-nearest from the whole graph, never a top-20 member, no reuse
used, controls = set(), []
for t in top:
    pool = [g for g in deg if g not in top_genes and g not in used]
    pick = min(pool, key=lambda g: (abs(deg[g] - t["degree"]), g))
    used.add(pick)
    controls.append({"gene": pick, "degree": deg[pick], "diseases": n_dis.get(pick, 0)})
for t, c in zip(top, controls):
    t["control"] = c["gene"]
    t["control_degree"] = c["degree"]

# ------------------------------------------------------------------- PubMed
cache = json.loads(CACHE.read_text(encoding="utf-8")) if CACHE.exists() else {}


def key(g):
    return f"{g}|{Y0}-{Y1}"


def pm_count(gene):
    if key(gene) in cache:
        return cache[key(gene)]
    q = f'({gene}[tiab]) AND ({TAG}[tiab]) AND {Y0}:{Y1}[dp]'
    url = ("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed"
           f"&retmode=json&retmax=0&term={urllib.parse.quote(q)}")
    for a in range(4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            v = json.loads(urllib.request.urlopen(req, timeout=60).read().decode())
            cache[key(gene)] = int(v["esearchresult"]["count"])
            return cache[key(gene)]
        except Exception:
            time.sleep(2 + a * 3)
    return None


need = [c["gene"] for c in top] + [c["gene"] for c in controls]
todo = [g for g in need if key(g) not in cache]
print(f"  PubMed：需要 {len(need)}，缓存 {len(need)-len(todo)}，新查 {len(todo)} …", flush=True)
for i, g in enumerate(todo, 1):
    pm_count(g)
    if i % 10 == 0:
        CACHE.write_text(json.dumps(cache, ensure_ascii=False, indent=1), encoding="utf-8")
        print(f"    {i}/{len(todo)}", flush=True)
    time.sleep(0.4)
CACHE.write_text(json.dumps(cache, ensure_ascii=False, indent=1), encoding="utf-8")


def med(xs):
    xs = sorted(x for x in xs if x is not None)
    n = len(xs)
    return None if not n else (float(xs[n // 2]) if n % 2 else
                               (xs[n // 2 - 1] + xs[n // 2]) / 2)


def iqr(xs):
    xs = sorted(x for x in xs if x is not None)
    if len(xs) < 4:
        return (None, None)
    q = statistics.quantiles(xs, n=4, method="inclusive")
    return (q[0], q[2])


def mannwhitney(a, b):
    a = [x for x in a if x is not None]
    b = [x for x in b if x is not None]
    allv = sorted(a + b)
    n1, n2 = len(a), len(b)
    ranks, i = {}, 0
    while i < len(allv):
        j = i
        while j + 1 < len(allv) and allv[j + 1] == allv[i]:
            j += 1
        ranks[allv[i]] = (i + j + 2) / 2
        i = j + 1
    R1 = sum(ranks[x] for x in a)
    U1 = R1 - n1 * (n1 + 1) / 2
    U = min(U1, n1 * n2 - U1)
    cnt = Counter(allv)
    tie = sum(t ** 3 - t for t in cnt.values())
    N = n1 + n2
    sd = ((n1 * n2 / 12) * ((N + 1) - tie / (N * (N - 1)))) ** 0.5
    z = (U - n1 * n2 / 2) / sd if sd else 0.0
    return U, 2 * (1 - 0.5 * (1 + erf(abs(z) / sqrt(2))))


gp = [cache.get(key(c["gene"])) for c in top]
cp = [cache.get(key(c["gene"])) for c in controls]
U, p = mannwhitney(gp, cp)

# --------------------------------------------------------- write the new table
rows = []
for i, (t, c, gv, cv) in enumerate(zip(top, controls, gp, cp), 1):
    rows.append({
        "rank": i,
        "gene_symbol": t["gene"],
        "degree": t["degree"],
        "disease_associations": t["diseases"],
        "gap_score": t["gap_score"],
        "lipoprotein_publications_2023_2025": gv,
        "is_in_curated_core": "TRUE" if t["gene"] in seed else "FALSE",
        "matched_control": c["gene"],
        "control_degree": c["degree"],
        "control_publications": cv,
    })
p18 = ROOT / "supplementary/Table_S18_Gap_Score_Validation.csv"
with open(p18, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

out = {
    "definition": "gap_score = STRING degree / (n_disease_associations + 1)",
    "filter": "degree > 30 AND n_disease_associations < 3",
    "source": "data/string_interactions.csv + data/disease_associations.csv",
    "n_proteins_in_graph": len(deg),
    "n_proteins_with_any_disease_association": len([g for g in deg if n_dis.get(g, 0) > 0]),
    "n_eligible": len(cand),
    "control_rule": "degree-nearest protein from the whole graph, excluding the top 20 and any reuse",
    "pubmed_query_template": f'(<GENE>[tiab]) AND ({TAG}[tiab]) AND {Y0}:{Y1}[dp]',
    "pubmed_retrieved": "2026-10-01",
    "gap_pub_median": med(gp), "gap_pub_iqr": iqr(gp), "gap_pub_n": len([x for x in gp if x is not None]),
    "control_pub_median": med(cp), "control_pub_iqr": iqr(cp), "control_pub_n": len([x for x in cp if x is not None]),
    "mannwhitney_U": U, "mannwhitney_p": p,
    "top20": rows,
}
(ROOT / "Review/use_case1_rebuild_v3.json").write_text(
    json.dumps(out, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

print(f"\n  公式 {out['definition']}   过滤 {out['filter']}")
print(f"  图内 {out['n_proteins_in_graph']}；有任一疾病关联 {out['n_proteins_with_any_disease_association']}；"
      f"合格 {out['n_eligible']}")
print(f"\n  {'#':>3} {'gene':<9} {'deg':>4} {'dis':>3} {'gap':>7} {'pubs':>6} | {'control':<9} {'deg':>4} {'pubs':>6}")
for r in rows:
    print(f"  {r['rank']:>3} {r['gene_symbol']:<9} {r['degree']:>4} {r['disease_associations']:>3} "
          f"{r['gap_score']:>7} {str(r['lipoprotein_publications_2023_2025']):>6} | "
          f"{r['matched_control']:<9} {r['control_degree']:>4} {str(r['control_publications']):>6}")
print(f"\n  gap 中位 {out['gap_pub_median']} IQR {out['gap_pub_iqr']}")
print(f"  对照中位 {out['control_pub_median']} IQR {out['control_pub_iqr']}")
print(f"  U={U:.1f}  p={p:.4f}")
print("  ✅ Table_S18 已重建；Review/use_case1_rebuild_v3.json")
