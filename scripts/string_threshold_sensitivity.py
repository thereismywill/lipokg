#!/usr/bin/env python3
"""Real STRING combined-score threshold sensitivity for network topology metrics.
The deposited export spans combined_score 700-999, so thresholds 700/800/900 are testable.
Output: string_threshold_sensitivity.json (into figures/generated/)
"""
import csv, json, statistics
from collections import Counter
import numpy as np, networkx as nx, powerlaw
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

out = []
for thr in [700, 800, 900]:
    edges = [(r["source"], r["target"]) for r in si if int(r["combined_score"]) >= thr]
    G = nx.Graph(); G.add_nodes_from(r["string_id"] for r in sp); G.add_edges_from(edges)
    G.remove_nodes_from([n for n in list(G.nodes) if G.degree(n) == 0])
    deg = np.array([d for _, d in G.degree()], dtype=int)
    comps = list(nx.connected_components(G))
    lcc = G.subgraph(max(comps, key=len))
    cnt, qs = Counter(), []
    for seed in range(20):
        c = louvain_communities(G, seed=seed)
        cnt[len(c)] += 1; qs.append(modularity(G, c))
    modules = max(cnt, key=lambda k: cnt[k])
    rec = {"threshold": int(thr), "edges": int(len(edges)), "nodes_nonzero_degree": int(G.number_of_nodes()),
           "average_degree": round(statistics.mean(deg), 1),
           "components": int(len(comps)), "diameter_LCC": int(nx.diameter(lcc)),
           "louvain_modules_mode": int(modules), "louvain_Q_median": round(float(statistics.median(qs)), 3)}
    try:
        f = powerlaw.Fit(deg, discrete=True, verbose=False)
        R, p = f.distribution_compare("power_law", "lognormal")
        Dobs = f.power_law.D
        c2 = 0; N = 500
        for _ in range(N):
            s = f.power_law.generate_random(int((deg >= f.xmin).sum()), estimate_discrete=True)
            if powerlaw.Fit(s, discrete=True, xmin=f.xmin, verbose=False).power_law.D >= Dobs:
                c2 += 1
        rec.update({"xmin": float(f.xmin), "alpha": round(float(f.alpha), 3),
                    "bootstrap_p": float(c2/N), "R_vs_lognormal": round(float(R), 2)})
    except Exception as e:
        rec["fit_error"] = str(e)[:60]
    out.append(rec)
    print(json.dumps(rec, ensure_ascii=False, default=lambda o: o.item() if hasattr(o, "item") else float(o)), flush=True)

json.dump(out, open(os.path.join(OUT, "string_threshold_sensitivity.json"), "w"), indent=1, ensure_ascii=False,
          default=lambda o: o.item() if hasattr(o, "item") else float(o))
print(f"saved {os.path.join(OUT, 'string_threshold_sensitivity.json')}")
