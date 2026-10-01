#!/usr/bin/env python3
"""Definitive power-law vs alternative-distribution fit for the LipoKG STRING
degree distribution (Clauset-Shalizi-Newman 2009), with xmin sensitivity.
Writes powerlaw_fit.json into figures/generated/
"""
import csv, json
from collections import Counter
import numpy as np, powerlaw

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "figure_scripts"))
from figure_style import resolve_data_dir, resolve_out_dir  # noqa: E402

DATA = resolve_data_dir()      # 数据目录（两种仓库布局都能解析）
OUT = resolve_out_dir()        # 输出目录（figures/generated/，并确保存在）
sp = list(csv.DictReader(open(os.path.join(DATA, "string_proteins.csv"), encoding="utf-8-sig")))
si = list(csv.DictReader(open(os.path.join(DATA, "string_interactions.csv"), encoding="utf-8-sig")))
deg = Counter({r["string_id"]: 0 for r in sp})
for r in si:
    deg[r["source"]] += 1; deg[r["target"]] += 1
x = np.array([v for v in deg.values() if v > 0], dtype=int)

f = powerlaw.Fit(x, discrete=True, verbose=False)
sig = f.power_law.sigma
out = {
    "n_nonzero_degree": int(len(x)),
    "xmin": float(f.xmin), "n_above_xmin": int((x >= f.xmin).sum()),
    "alpha": float(f.alpha), "alpha_sigma": float(sig),
    "alpha_ci95": [float(f.alpha - 1.96*sig), float(f.alpha + 1.96*sig)],
    "ks_D": float(f.power_law.D),
}
D_obs = f.power_law.D
n = out["n_above_xmin"]
cnt = 0; N = 2500
for _ in range(N):
    s = f.power_law.generate_random(n, estimate_discrete=True)
    if powerlaw.Fit(s, discrete=True, xmin=f.xmin, verbose=False).power_law.D >= D_obs:
        cnt += 1
out["bootstrap_p"] = cnt / N
out["bootstrap_N"] = N
R, p = f.distribution_compare("power_law", "exponential")
out["R_vs_exponential"] = float(R); out["p_vs_exponential"] = float(p)
R2, p2 = f.distribution_compare("power_law", "lognormal")
out["R_vs_lognormal"] = float(R2); out["p_vs_lognormal"] = float(p2)
R3, p3 = f.distribution_compare("power_law", "truncated_power_law")
out["R_vs_truncated_power_law"] = float(R3); out["p_vs_truncated_power_law"] = float(p3)
out["lognormal_mu"] = float(f.lognormal.mu)
out["lognormal_sigma"] = float(f.lognormal.sigma)

sweep = []
for xmin in [5, 10, 15, 20, 23, 34, 50]:
    ff = powerlaw.Fit(x[x >= xmin], discrete=True, xmin=xmin, verbose=False)
    d = ff.power_law.D; c = 0; M = 500
    for _ in range(M):
        s = ff.power_law.generate_random(int((x >= xmin).sum()), estimate_discrete=True)
        if powerlaw.Fit(s, discrete=True, xmin=xmin, verbose=False).power_law.D >= d:
            c += 1
    rr, _ = ff.distribution_compare("power_law", "lognormal")
    sweep.append({"xmin": xmin, "n": int((x >= xmin).sum()), "alpha": round(ff.power_law.alpha, 3),
                  "bootstrap_p": c/M, "R_vs_lognormal": round(rr, 2)})
out["xmin_sweep"] = sweep
json.dump(out, open(os.path.join(OUT, "powerlaw_fit.json"), "w"), indent=1, ensure_ascii=False)
for k, v in out.items():
    if k != "xmin_sweep": print(f"  {k}: {v}")
print("  sweep:", json.dumps(sweep, ensure_ascii=False))
