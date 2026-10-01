#!/usr/bin/env python3
"""Recompute LipoKG STRING-graph modularity (Louvain) and GO:BP enrichment.

Substrate: string_proteins.csv (nodes) + string_interactions.csv (edges) from the data
directory resolved by figure_style.resolve_data_dir().
Procedure: Louvain (networkx louvain_communities), 100 random seeds; the run whose
module count equals the modal count (9 across 100 seeds) and whose modularity is
closest to the median of those runs is used as the representative partition.
Output: modularity_recompute.json (into figures/generated/)
"""
import csv, json, statistics, urllib.request
from collections import Counter
import networkx as nx
from networkx.algorithms.community import louvain_communities, modularity

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "figure_scripts"))
from figure_style import resolve_data_dir, resolve_out_dir  # noqa: E402

DATA = resolve_data_dir()      # 数据目录（两种仓库布局都能解析）
OUT = resolve_out_dir()        # 输出目录（figures/generated/，并确保存在）
sp = list(csv.DictReader(open(os.path.join(DATA, "string_proteins.csv"), encoding="utf-8-sig")))
si = list(csv.DictReader(open(os.path.join(DATA, "string_interactions.csv"), encoding="utf-8-sig")))
G = nx.Graph()
name = {}
for r in sp:
    G.add_node(r["string_id"]); name[r["string_id"]] = r["name"]
for r in si:
    G.add_edge(r["source"], r["target"])

runs = {}
for seed in range(100):
    c = louvain_communities(G, seed=seed)
    runs[seed] = (c, modularity(G, c))

counts = Counter(len(v[0]) for v in runs.values())
modal = max(counts, key=lambda k: counts[k])
cands = {s: v for s, v in runs.items() if len(v[0]) == modal}
med = statistics.median(v[1] for v in cands.values())
seed = min(cands, key=lambda s: abs(cands[s][1] - med))
c, q = cands[seed]
print(f"modal modules={modal} (dist {dict(sorted(counts.items()))})")
print(f"representative seed={seed}  Q={q:.4f}  (median Q of modal runs={med:.4f})")

deg = dict(G.degree())
mods = sorted(c, key=len, reverse=True)
out = []
for i, comm in enumerate(mods, 1):
    genes = sorted(name[n] for n in comm)
    hubs = sorted(comm, key=lambda n: -deg[n])[:20]
    out.append({"module": f"M{i}", "size": len(comm),
                "top_genes": [name[n] for n in hubs], "genes": genes})

def gprofiler(genes):
    body = json.dumps({"organism": "hsapiens", "query": genes, "sources": ["GO:BP"],
                       "user_threshold": 0.05, "no_evidences": True}).encode()
    req = urllib.request.Request("https://biit.cs.ut.ee/gprofiler/api/gost/profile/",
                                 data=body, headers={"Content-Type": "application/json",
                                                     "User-Agent": "LipoKG-audit/1.0"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read().decode())

for m in out:
    try:
        res = gprofiler(m["genes"]).get("result", [])
        res = sorted(res, key=lambda x: x.get("p_value", 1))[:7]
        m["enriched_go_terms"] = [f'{x.get("native","?")}~{x.get("name","?")}' for x in res]
        m["enrichment_p_value"] = res[0]["p_value"] if res else None
    except Exception as e:
        m["enriched_go_terms"] = []; m["enrichment_p_value"] = None; m["err"] = str(e)[:80]
    print(f'  {m["module"]}: size={m["size"]} top={m["top_genes"][:5]} p={m["enrichment_p_value"]}')

json.dump({"seed": seed, "modal_modules": modal, "modularity": round(q, 4),
           "modularity_range": [round(min(v[1] for v in runs.values()), 4),
                                round(max(v[1] for v in runs.values()), 4)],
           "seed_distribution": dict(sorted(counts.items())), "modules": out},
          open(os.path.join(OUT, "modularity_recompute.json"), "w"), ensure_ascii=False, indent=1)
print(f"saved {os.path.join(OUT, 'modularity_recompute.json')}")
