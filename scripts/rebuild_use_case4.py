#!/usr/bin/env python3
"""Rebuild Table S20 (Use Case 4) from the deposited graph.

What was wrong
--------------
The published table carried `lipokg_interactors_count` 18 / 17 / 19 / 23 / 23 for
LPA / ANGPTL3 / APOC3 / PCSK9 / LPL.  The deposited degrees are 42 / 13 / 57 / 35 / 84 —
none of the five matches, and for ANGPTL3 the claimed 17 exceeds the real degree of 13.
The concordant-interactor symbol lists are not from this graph either: of the 17 symbols
listed as LPA-concordant, only 8 (APOB, APOE, APOA1, LPL, PCSK9, F2, FN1, LCAT) are
actually neighbours of LPA here; LRP1, LDLR, HGF, PLG, SERPINE1, VTN, ITGB3, CD36 and
SCARB1 are not.  The literature-side counts and the "discrepancy_reason" strings have no
deposited source at all.

What this rebuild does
----------------------
Keeps the table's subject — the interaction neighbourhood of the five targets — and
replaces every cell with something computed from the deposit:

  string_interactors_count      degree in data/string_interactions.csv
  in_curated_core               neighbours in the 82-gene seed set (Table S1)
  in_<layer>_layer              neighbours present in each annotation layer
  with_any_annotation           neighbours in at least one non-STRING layer
  literature_mined_interactions pairs in Table S12 that involve the target
  annotated_interactors         the actual symbol list backing with_any_annotation

The literature-concordance percentage is dropped: there is no deposited literature
interaction set to compare against, so the number cannot be reproduced.

Output: supplementary/Table_S20_Target_Neighborhood.csv (rebuilt in place)
        Review/use_case4_rebuild.json
"""
import csv, json, pathlib
from collections import defaultdict

ROOT = pathlib.Path(__file__).resolve().parent.parent
D = ROOT / "data/zenodo_package_v1.2.0/data"
TARGETS = [("LPA", "P08519"), ("ANGPTL3", "Q9Y5C1"), ("APOC3", "P02654"),
           ("PCSK9", "Q8NBP7"), ("LPL", "P06858")]


def rd(p, d=D):
    return list(csv.DictReader(open(d / p, encoding="utf-8-sig")))


prot = rd("string_proteins.csv")
inter = rd("string_interactions.csv")
name = {r["string_id"]: r["name"] for r in prot}
adj = defaultdict(set)
for r in inter:
    a, b = name.get(r["source"], r["source"]), name.get(r["target"], r["target"])
    adj[a].add(b)
    adj[b].add(a)

seed = {r["symbol"] for r in rd("Table_S1_Seed_Genes.csv", ROOT / "supplementary")}
layers = {
    "pathway": {r["gene"] for r in rd("pathway_memberships.csv")},
    "disease": {r["source"] for r in rd("disease_associations.csv")},
    "particle": {(r.get("protein") or r.get("target") or "")
                 for r in rd("particle_protein_links.csv")} |
                {(r.get("protein") or r.get("target") or "")
                 for r in rd("assembly_links.csv")},
    "clinvar": {r["gene"] for r in rd("clinvar_relationships.csv")},
}
layers["particle"].discard("")
t12 = rd("Table_S12_Literature_Mined_Interactions.csv", ROOT / "supplementary")

rows = []
for gene, up in TARGETS:
    nb = adj.get(gene, set())
    ann = nb & set().union(*layers.values())
    t12n = [f"{r['protein_a']}-{r['protein_b']}" for r in t12
            if gene in (r["protein_a"], r["protein_b"])]
    rows.append({
        "target_gene": gene,
        "target_uniprot": up,
        "string_interactors_count": len(nb),
        "in_curated_core": len(nb & seed),
        "in_pathway_layer": len(nb & layers["pathway"]),
        "in_disease_layer": len(nb & layers["disease"]),
        "in_particle_layer": len(nb & layers["particle"]),
        "in_clinvar_layer": len(nb & layers["clinvar"]),
        "with_any_annotation": len(ann),
        "literature_mined_interactions": len(t12n),
        "annotated_interactors": ", ".join(sorted(ann)),
        "literature_mined_edges": "; ".join(t12n),
    })

out = ROOT / "supplementary/Table_S20_Target_Neighborhood.csv"
with open(out, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

meta = {
    "source": "data/string_interactions.csv (degree) + the five annotation layers "
              "in data/*.csv + Supplementary Table S12",
    "layer_sizes": {k: len(v) for k, v in layers.items()} | {"curated_core": len(seed)},
    "withdrawn": "literature_interactors_count / concordant_interactors / concordance_pct / "
                 "lipokg_only / literature_only / discrepancy_reason — no deposited literature "
                 "interaction set exists, so these cannot be reproduced",
    "rows": rows,
}
(ROOT / "Review/use_case4_rebuild.json").write_text(
    json.dumps(meta, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

print(f"  层大小：core {len(seed)} | "
      + " | ".join(f"{k} {len(v)}" for k, v in layers.items()))
print(f"\n  {'target':<9} {'deg':>4} {'core':>5} {'path':>5} {'dis':>4} {'part':>5} {'cv':>4} "
      f"{'≥1注释':>7} {'T12':>4}")
for r in rows:
    print(f"  {r['target_gene']:<9} {r['string_interactors_count']:>4} {r['in_curated_core']:>5} "
          f"{r['in_pathway_layer']:>5} {r['in_disease_layer']:>4} {r['in_particle_layer']:>5} "
          f"{r['in_clinvar_layer']:>4} {r['with_any_annotation']:>7} "
          f"{r['literature_mined_interactions']:>4}")
print(f"\n  旧表声称的 lipokg_interactors_count：18 / 17 / 19 / 23 / 23（实际 {' / '.join(str(r['string_interactors_count']) for r in rows)}）")
print("  ✅ Table_S20 已重建；Review/use_case4_rebuild.json")
