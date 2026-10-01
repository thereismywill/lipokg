#!/usr/bin/env python3
"""Sensitivity of the power-law verdict to the xmin (lower-bound) choice."""
import csv, time
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
base = powerlaw.Fit(x, discrete=True, verbose=False)
print(f"powerlaw 自动选 xmin={base.xmin}  n(xmin)={int((x>=base.xmin).sum())}", flush=True)
print(f"{'xmin':>5} {'n':>5} {'alpha':>7} {'KS D':>7} {'boot_p':>7} "
      f"{'R_exp':>8} {'p_exp':>8} {'R_logn':>8} {'p_logn':>9}", flush=True)

for xmin in [5, 10, 15, 20, 23, 34, 50]:
    sub = x[x >= xmin]
    f = powerlaw.Fit(sub, discrete=True, xmin=xmin, verbose=False)
    a, Dobs = f.power_law.alpha, f.power_law.D
    t0 = time.time()
    cnt = 0; N = 500
    for _ in range(N):
        s = f.power_law.generate_random(len(sub), estimate_discrete=True)
        if powerlaw.Fit(s, discrete=True, xmin=xmin, verbose=False).power_law.D >= Dobs:
            cnt += 1
    p = cnt / N
    R1, p1 = f.distribution_compare("power_law", "exponential")
    R2, p2 = f.distribution_compare("power_law", "lognormal")
    print(f"{xmin:>5} {len(sub):>5} {a:>7.3f} {Dobs:>7.4f} {p:>7.3f} "
          f"{R1:>8.2f} {p1:>8.3f} {R2:>8.2f} {p2:>9.3g}   (boot {time.time()-t0:.1f}s)", flush=True)
