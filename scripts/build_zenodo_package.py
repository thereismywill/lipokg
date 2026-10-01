#!/usr/bin/env python3
"""构建 Zenodo 沉积包（zip）并重算 Supplementary Table S25。

WHY THIS EXISTS（2026-10-01）
    在这个脚本之前，zip 是手工/临时打出来的，Table_S25（逐文件字节与行数清单）是**手工维护**的。
    两者都会随后续改动作废：
      * 沉积的 zip 停留在 2026-09-29，而数据在 09-30～10-01 又改过多轮 ⇒ 稿件说「30 files」、
        实际沉积只有 29 个、KEGG 层还是 52 基因的旧口径（见 Review/投稿前核查报告_20261001.md A-1）；
      * 包内 `README.md` / `metadata.json` 等描述性文件同样滞后。
    ⇒ 把「打包」与「清单重算」放进同一个脚本，二者便不可能再各走各的。

    版本号只从 `metadata.json` 读取（**不要**在文件名里另写一份）：本脚本产出的 zip 名为
    `lipokg_data_v<version>.zip`，因此改版本号只需改 metadata.json 一处。

用法
    python3 scripts/build_zenodo_package.py
    python3 scripts/build_zenodo_package.py --check-manuscript manuscripts/V9-LipoKG_Manuscript.md
    python3 scripts/build_zenodo_package.py --package data/zenodo_package_v1.2.0 --no-zip

不变量（脚本会自己断言）
    * zip 内不得含 `.bak*` / `.DS_Store` —— 实测包目录里有 40 个 `.bak` 备份，手工压缩会把它们
      一并带上（30 → 70 文件），稿件的「30 files」当场作废；
    * Table_S25 的行数 = 实际文件数；
    * 清单里每个文件的字节与行数都要与磁盘一致。
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import pathlib
import re
import sys
import zipfile

EXCLUDE_SUFFIX = ".bak"
EXCLUDE_NAMES = {".DS_Store"}


def is_deposited(p: pathlib.Path, package: pathlib.Path) -> bool:
    rel = p.relative_to(package)
    if p.name in EXCLUDE_NAMES or EXCLUDE_SUFFIX in p.name:
        return False
    if p.suffix == ".zip":                      # 归档自身与历史归档
        return False
    if any(part.startswith(".") for part in rel.parts):
        return False
    return True


def human(n: int) -> str:
    if n >= 1024 * 1024:
        return f"{n / 1024 / 1024:.2f} MB"
    return f"{n / 1024:.1f} KB"


def line_stats(p: pathlib.Path) -> tuple[int, str]:
    """返回 (行数, 数据行数)。CSV 的 data_rows = 行数 − 1（表头）；其他类型留空，
    除非旧清单里已经有一个**人工赋予**的语义值（如 graph_statistics.json 的 11）——那种值
    推不出来，保留比清掉好。"""
    try:
        text = p.read_text(encoding="utf-8-sig")
    except (UnicodeDecodeError, OSError):
        return 0, ""
    lines = text.count("\n") + (0 if text.endswith("\n") or not text else 1)
    if p.suffix.lower() == ".csv":
        return lines, str(max(lines - 1, 0))
    return lines, ""


def load_prev_table(path: pathlib.Path) -> dict[str, str]:
    if not path.exists():
        return {}
    with open(path, encoding="utf-8-sig", newline="") as f:
        return {r["file"]: (r.get("data_rows") or "") for r in csv.DictReader(f)}


def build_table(package: pathlib.Path, files: list[pathlib.Path], table_path: pathlib.Path) -> list[list[str]]:
    prev = load_prev_table(table_path)
    rows = [["file", "bytes", "size_human", "lines", "data_rows"]]
    for p in sorted(files, key=lambda x: str(x.relative_to(package))):
        rel = str(p.relative_to(package))
        lines, data_rows = line_stats(p)
        # 非 CSV 的人工语义值优先保留
        if not data_rows and rel in prev and prev[rel]:
            data_rows = prev[rel]
        rows.append([rel, str(p.stat().st_size), human(p.stat().st_size), str(lines), data_rows])
    return rows


def write_table(rows: list[list[str]], path: pathlib.Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    # utf-8-sig 与项目内其余补充表一致；newline="" 保证 \n 不被转成 \r\n
    with open(path, "w", encoding="utf-8-sig", newline="") as f:
        csv.writer(f, lineterminator="\n").writerows(rows)


def make_zip(package: pathlib.Path, files: list[pathlib.Path], out: pathlib.Path) -> None:
    if out.exists():
        os.replace(out, out.with_name(out.name + f".bak_prev"))
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for p in sorted(files, key=lambda x: str(x.relative_to(package))):
            z.write(p, arcname=str(p.relative_to(package)))


def check_manuscript(ms: pathlib.Path, n_files: int, raw: int, comp: int) -> list[str]:
    """把稿件的声明与实测对一遍。只做陈述性比较，不做自动改写。"""
    t = ms.read_text(encoding="utf-8")
    out = []
    m = re.search(r"comprises (\d+) files", t)
    if m:
        declared = int(m.group(1))
        out.append(f"{'✅' if declared == n_files else '❌'} 稿件声明 {declared} 个文件；实测 {n_files}")
    m = re.search(r"([\d.]+) MB uncompressed", t)
    if m:
        declared = float(m.group(1))
        actual = raw / 1024 / 1024
        out.append(f"{'✅' if abs(declared - actual) < 0.02 else '⚠️'} 稿件声明 {declared} MB 未压缩；实测 {actual:.2f} MB")
    m = re.search(r"([\d.]+) MB as a single compressed archive", t)
    if m:
        declared = float(m.group(1))
        actual = comp / 1024 / 1024
        out.append(f"{'✅' if abs(declared - actual) < 0.02 else '⚠️'} 稿件声明 {declared} MB 压缩；实测 {actual:.2f} MB")
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--package", default="data/zenodo_package_v1.2.0", help="沉积包目录")
    ap.add_argument("--table", default="supplementary/Table_S25_Deposited_File_Inventory.csv")
    ap.add_argument("--check-manuscript", default=None)
    ap.add_argument("--no-zip", action="store_true")
    a = ap.parse_args()

    package = pathlib.Path(a.package)
    if not package.is_dir():
        print(f"❌ 找不到包目录 {package}")
        return 1

    meta = json.loads((package / "metadata.json").read_text(encoding="utf-8"))
    version = meta.get("version") or (meta.get("metadata") or {}).get("version")
    assert version, "❌ metadata.json 里读不到 version"
    print(f"  包目录   : {package}")
    print(f"  版本号   : {version}（来自 metadata.json）")

    all_files = [p for p in package.rglob("*") if p.is_file()]
    files = [p for p in all_files if is_deposited(p, package)]
    skipped = len(all_files) - len(files)
    print(f"  文件     : {len(files)} 个入包；跳过 {skipped} 个（.bak / .DS_Store / *.zip）")

    raw = sum(p.stat().st_size for p in files)
    print(f"  未压缩   : {raw:,} B = {human(raw)}")

    # Table_S25
    table_path = pathlib.Path(a.table)
    rows = build_table(package, files, table_path)
    assert len(rows) - 1 == len(files), "❌ 清单行数 ≠ 文件数"
    write_table(rows, table_path)
    print(f"  ✅ 重算 {table_path}（{len(rows) - 1} 行数据）")

    # zip
    comp = 0
    if not a.no_zip:
        out = package / f"lipokg_data_v{version}.zip"   # 保留历史命名里的 v
        make_zip(package, files, out)
        comp = out.stat().st_size
        with zipfile.ZipFile(out) as z:
            inner = {i.filename for i in z.infolist() if not i.is_dir()}
        assert inner == {str(p.relative_to(package)) for p in files}, "❌ zip 内清单与预期不符"
        assert not any(".bak" in n or n.endswith(".DS_Store") for n in inner), "❌ zip 里混进了备份文件"
        print(f"  ✅ 产出 {out}（{comp:,} B = {human(comp)}）；包内 {len(inner)} 个文件，无备份混入")

    if a.check_manuscript:
        print(f"\n  与稿件声明对照（{a.check_manuscript}）：")
        for line in check_manuscript(pathlib.Path(a.check_manuscript), len(files), raw, comp):
            print(f"    {line}")

    print(f"\n  下一步：把 {package.name}/lipokg_data_v{version}.zip 上传到 Zenodo 的新版本")
    return 0


if __name__ == "__main__":
    sys.exit(main())
