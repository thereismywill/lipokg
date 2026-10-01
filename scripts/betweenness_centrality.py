#!/usr/bin/env python3
"""Betweenness centrality of the STRING-derived protein graph (Table 7 / Supplementary Table S31).

Computed exactly (Brandes' algorithm, no k-source approximation) on the undirected, unweighted
graph formed by data/string_proteins.csv and data/string_interactions.csv (combined_score >= 700).

Run from the repository root:
    python3 scripts/betweenness_centrality.py
Writes betweenness_centrality.csv next to the script.
"""
import csv
import os
import statistics
import sys

import networkx as nx

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "figure_scripts"))
from figure_style import resolve_data_dir  # noqa: E402

DATA = resolve_data_dir()
prot = list(csv.DictReader(open(os.path.join(DATA, "string_proteins.csv"), encoding="utf-8-sig")))
inter = list(csv.DictReader(open(os.path.join(DATA, "string_interactions.csv"), encoding="utf-8-sig")))

G = nx.Graph()
G.add_nodes_from(r["string_id"] for r in prot)
G.add_edges_from((r["source"], r["target"]) for r in inter)
G.remove_nodes_from([n for n in list(G.nodes) if G.degree(n) == 0])
name = {r["string_id"]: r["name"] for r in prot}

print(f"graph: {G.number_of_nodes():,} nodes / {G.number_of_edges():,} edges "
      f"/ {nx.number_connected_components(G)} component(s)")

bc = nx.betweenness_centrality(G, normalized=True, seed=42)
ranked = sorted(bc.items(), key=lambda x: -x[1])
vals = list(bc.values())
print(f"betweenness: max {max(vals):.6f}, median {statistics.median(vals):.6f}")

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "betweenness_centrality.csv")
with open(out, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.writer(f)
    w.writerow(["rank", "gene", "string_id", "betweenness", "degree"])
    for i, (sid, v) in enumerate(ranked, 1):
        w.writerow([i, name.get(sid, sid), sid, round(v, 6), G.degree(sid)])
print(f"wrote {out}")

print("\nTop 10:")
for i, (sid, v) in enumerate(ranked[:10], 1):
    print(f"  {i:>2}. {name.get(sid, sid):<10} {v:.4f}  (degree {G.degree(sid)})")
