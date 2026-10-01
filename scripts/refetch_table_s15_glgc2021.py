#!/usr/bin/env python3
"""Re-check Supplementary Table S15 against the GLGC 2021 trans-ancestry summary statistics.

Why this script exists
----------------------
The GLGC gene-trait association layer published in Supplementary Table S15 was *re-derived*
from the GLGC 2021 trans-ancestry meta-analysis (Graham et al., *Nature* 600, 675-679, 2021;
PMID 34887591) after an earlier curation of the same layer was found to contain systematically
rewritten p-values and rsIDs that do not exist in GLGC. This script is the record of that work:
it re-fetches every locus in the deposited table straight from the GLGC summary statistics and
reports, row by row, whether the deposited beta / standard error / p-value / sample size agree.

It is a *verification* script, not a data-generation script: it never writes a new data table,
only a machine-readable report. Run it whenever the table is revised.

What it needs
-------------
* network access (the GLGC summary statistics are 2.6 GB per trait file, queried remotely -
  nothing large is downloaded, only the ~2 MB `.tbi` index per trait, cached on first run)
* `pysam` (remote tabix)

Usage
-----
    python3 scripts/refetch_table_s15_glgc2021.py
    python3 scripts/refetch_table_s15_glgc2021.py --table path/to/Table_S15.csv
    python3 scripts/refetch_table_s15_glgc2021.py --limit 5       # quick smoke test

Output
------
    glgc_table_s15_recheck.json   (into figures/generated/, alongside the other build artefacts)
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import sys
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "figure_scripts"))
from figure_style import resolve_out_dir  # noqa: E402

BASE = "https://csg.sph.umich.edu/willer/public/glgc-lipids2021/results/trans_ancestry"

# trait label used in Table S15 -> (remote summary-statistics file, cached index name)
FILES = {
    "LDL cholesterol": ("with_BF_meta-analysis_AFR_EAS_EUR_HIS_SAS_LDL_INV_ALL_with_N_1.gz", "LDL.tbi"),
    "HDL cholesterol": ("with_BF_meta-analysis_AFR_EAS_EUR_HIS_SAS_HDL_INV_ALL_with_N_1.gz", "HDL.tbi"),
    "Total Cholesterol": ("with_BF_meta-analysis_AFR_EAS_EUR_HIS_SAS_TC_INV_ALL_with_N_1.gz", "TC.tbi"),
    "Triglycerides": ("with_BF_meta-analysis_AFR_EAS_EUR_HIS_SAS_logTG_INV_ALL_with_N_1.gz", "logTG.tbi"),
}

# Column layout of the GLGC trans-ancestry files (tab separated):
#   0 SNP  1 CHR  2 POS_b37  3 REF  4 ALT  ... 5 N  13 METAL_Effect  14 METAL_StdErr  15 METAL_Pvalue
COL_N, COL_BETA, COL_SE, COL_P = 5, 13, 14, 15


def cache_dir() -> str:
    d = os.path.join(HERE, "..", ".cache", "glgc2021")
    os.makedirs(d, exist_ok=True)
    return os.path.abspath(d)


def ensure_index(fname: str, local_name: str) -> str:
    """Download the remote tabix index once; remote tabix needs a *local* index file."""
    path = os.path.join(cache_dir(), local_name)
    if not os.path.exists(path) or os.path.getsize(path) == 0:
        url = f"{BASE}/{fname}.tbi"
        print(f"  downloading index {local_name} ...", flush=True)
        urllib.request.urlretrieve(url, path)
    return path


def default_table() -> str:
    root = os.path.abspath(os.path.join(HERE, ".."))
    for rel in ("supplementary/Table_S15_GWAS_Catalog_Associations.csv",
                "data/supplementary/Table_S15_GWAS_Catalog_Associations.csv"):
        p = os.path.join(root, rel)
        if os.path.exists(p):
            return p
    raise FileNotFoundError(
        "Table_S15_GWAS_Catalog_Associations.csv not found under supplementary/; "
        "pass it explicitly with --table")


def num(v: str, digits: int = 6):
    """Round for comparison; returns None when the value is not numeric."""
    try:
        return round(float(v), digits)
    except (TypeError, ValueError):
        return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--table", default=None, help="supplementary Table S15 CSV")
    ap.add_argument("--limit", type=int, default=0, help="only the first N rows (smoke test)")
    a = ap.parse_args()

    import pysam  # imported late so --help works without it

    table = a.table or default_table()
    rows = list(csv.DictReader(open(table, encoding="utf-8-sig")))
    if a.limit:
        rows = rows[:a.limit]
    traits = sorted({r["trait"] for r in rows if r["trait"] in FILES})
    print(f"  table : {table}  ({len(rows)} rows)")
    print(f"  traits: {', '.join(traits)}", flush=True)

    tbx = {}
    for t in traits:
        fname, local = FILES[t]
        tbx[t] = pysam.TabixFile(f"{BASE}/{fname}", index=ensure_index(fname, local))

    checked, agree, disagree, missing = [], 0, 0, 0
    for r in rows:
        trait = r["trait"]
        if trait not in tbx:
            continue
        chrom, pos, rs = r["chromosome"], int(r["position"]), r["snp"]
        hit = None
        for rec in tbx[trait].fetch(chrom, pos - 1, pos + 1):
            f = rec.split("\t")
            if f[0] == rs:
                hit = f
                break
        if hit is None:
            missing += 1
            checked.append({"gene": r["gene"], "trait": trait, "snp": rs, "position": pos,
                            "status": "not_found_in_glgc"})
            continue
        got = {"beta": num(hit[COL_BETA]), "se": num(hit[COL_SE]),
               "p_value": num(hit[COL_P], 10), "sample_size": int(hit[COL_N])}
        want = {"beta": num(r["beta"]), "se": num(r["se"]),
                "p_value": num(r["p_value"], 10), "sample_size": int(r["sample_size"])}
        ok = {k: (got[k] == want[k]) for k in want}
        rec_ok = all(ok.values())
        agree += rec_ok
        disagree += (not rec_ok)
        checked.append({"gene": r["gene"], "trait": trait, "snp": rs, "position": pos,
                        "deposited": want, "glgc": got, "fields_agree": ok,
                        "status": "agree" if rec_ok else "MISMATCH"})

    out = {"table": table, "source": f"{BASE} (GLGC 2021, Graham et al., PMID 34887591)",
           "rows_checked": len(checked), "agree": agree, "disagree": disagree,
           "not_found_in_glgc": missing, "rows": checked}
    dst = os.path.join(resolve_out_dir(), "glgc_table_s15_recheck.json")
    json.dump(out, open(dst, "w"), indent=1, ensure_ascii=False)
    print(f"\n  rows checked   : {len(checked)}")
    print(f"  fully agreeing : {agree}")
    print(f"  mismatching    : {disagree}")
    print(f"  not found      : {missing}")
    print(f"  report         : {dst}")
    for c in checked:
        if c["status"] != "agree":
            print(f"    {c['status']:<18} {c['gene']:<9} {c['trait']:<18} {c['snp']}")
    return 0 if disagree == 0 and missing == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
