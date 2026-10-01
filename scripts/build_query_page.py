#!/usr/bin/env python3
"""生成 LipoKG 只读查询页（单文件、离线、零依赖）。

数据源（全部取自已沉积的补充表，避免手工转录）：
  supplementary/Table_S24_Gene_Level_Coverage.csv  基因 × 四层注释 + STRING 度
  supplementary/Table_S8_Alias_Mapping.csv         别名 → 标准符号
  supplementary/Table_S17_Particle_Protein_Mappings.csv  粒子 × 蛋白

产物：web/lipokg_query.html
界面遵循 `workbench-ui-style`（老于工作台视觉 token）。
"""
from __future__ import annotations

import csv
import json
import pathlib

# 仓库根 = 本脚本所在目录的上一级；**不要**写死绝对路径（克隆后必然跑不起来）
B = pathlib.Path(__file__).resolve().parent.parent
OUT_DIR = B / "web"
OUT = OUT_DIR / "lipokg_query.html"


def load(name):
    with (B / "supplementary" / name).open(encoding="utf-8-sig") as fh:
        return list(csv.DictReader(fh))


def i(x):
    try:
        return int(x)
    except Exception:
        return 0


def main() -> int:
    genes = load("Table_S24_Gene_Level_Coverage.csv")
    aliases = load("Table_S8_Alias_Mapping.csv")
    parts = load("Table_S17_Particle_Protein_Mappings.csv")

    # 基因：[symbol, 是否在蛋白图, 粒子, 通路, 疾病/GWAS, 变异, 非STRING层数, STRING度, 层级]
    g_rows = [[r["gene"], i(r["in_string_graph"]), i(r["particle"]), i(r["pathway"]),
               i(r["disease_GWAS"]), i(r["clinvar_variant"]), i(r["n_non_string_layers"]),
               i(r["string_degree"]), r["tier"]] for r in genes]
    a_rows = [[r["reported_name"], r["standard_name"]] for r in aliases if r.get("reported_name") and r.get("standard_name")]
    p_rows = [[r["protein"], r["particle"], r.get("relationship_type", ""), r.get("subtype", ""),
               r.get("biological_role", ""), r.get("tissue_context", ""), r.get("evidence_source", "")]
              for r in parts]

    tiers = sorted({r[8] for r in g_rows})
    print(f"基因 {len(g_rows)}  别名 {len(a_rows)}  粒子关系 {len(p_rows)}")
    print(f"层级取值: {tiers}")

    data = {"genes": g_rows, "alias": a_rows, "particles": p_rows}
    payload = json.dumps(data, ensure_ascii=True, separators=(",", ":"))

    html = HTML_TEMPLATE.replace("/*__DATA__*/", payload)
    if not OUT_DIR.exists():
        OUT_DIR.mkdir(parents=True)
    OUT.write_text(html, encoding="utf-8")
    print(f"写出 {OUT.relative_to(B)}  ({OUT.stat().st_size/1024:.1f} KB)")
    return 0


HTML_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>LipoKG — Dataset Query</title>
<style>
:root{--bg:#f7f8fa;--card:#fff;--ink:#1f2933;--muted:#6b7280;--line:#e5e7eb;
--accent:#E17055;--accent-d:#2D3436;--ok:#16a34a;--warn:#d97706;--no:#dc2626;
--particle:#0d9488;--pathway:#2563eb;--disease:#7c3aed;--variant:#E17055}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
font-family:-apple-system,"PingFang SC","Microsoft YaHei",sans-serif;font-size:14px;line-height:1.55}
a{color:var(--accent);text-decoration:none}
.nav{background:var(--accent-d);color:#fff;display:flex;align-items:center;gap:14px;padding:10px 22px}
.nav b{font-size:15px;font-weight:600;letter-spacing:.2px}
.nav .chip{background:rgba(255,255,255,.14);border-radius:20px;padding:3px 11px;font-size:12px}
.nav .sp{margin-left:auto;font-size:12px;opacity:.85}
header{background:linear-gradient(135deg,#E17055,#f0936b);color:#fff;padding:22px 24px 20px;
border-radius:0 0 16px 16px}
header h1{margin:0 0 6px;font-size:21px;font-weight:600}
header p{margin:0;font-size:13px;opacity:.94;max-width:940px}
.layout{display:grid;grid-template-columns:340px 1fr;gap:16px;padding:16px 22px 40px;align-items:start}
@media(max-width:1080px){.layout{grid-template-columns:1fr}}
.card{background:var(--card);border:1px solid var(--line);border-radius:14px;
box-shadow:0 2px 10px rgba(0,0,0,.04);padding:15px 16px;margin-bottom:14px}
.sec-h{font-size:13px;font-weight:700;color:var(--accent-d);border-left:5px solid var(--accent);
padding-left:9px;margin:0 0 11px;display:flex;align-items:center}
.sec-h .hint{margin-left:auto;font-weight:400;font-size:12px;color:var(--muted)}
input[type=text]{width:100%;padding:10px 12px;border:1px solid var(--line);border-radius:9px;
font-size:15px;font-family:inherit;outline:none}
input[type=text]:focus{border-color:var(--accent)}
select{width:100%;padding:9px 11px;border:1px solid var(--line);border-radius:9px;
font-size:14px;font-family:inherit;background:#fff}
.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(148px,1fr));gap:11px}
.kpi{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:12px 14px}
.kpi .v{font-size:20px;font-weight:700;color:var(--accent-d);line-height:1.2}
.kpi .l{font-size:12px;color:var(--muted);margin-top:3px}
.dot{display:inline-block;width:8px;height:8px;border-radius:50%;margin-right:5px;vertical-align:middle}
.badge{display:inline-block;padding:3px 9px;border-radius:20px;font-size:12px;margin:2px 4px 2px 0;
border:1px solid var(--line);background:#fbfbfc;color:var(--muted)}
.badge.on{color:#fff;border-color:transparent}
.badge.particle.on{background:var(--particle)}
.badge.pathway.on{background:var(--pathway)}
.badge.disease.on{background:var(--disease)}
.badge.variant.on{background:var(--variant)}
.badge.off{opacity:.5}
.detail .row{display:flex;gap:10px;padding:6px 0;border-bottom:1px dashed var(--line);font-size:13px}
.detail .row:last-child{border-bottom:0}
.detail .k{color:var(--muted);min-width:132px}
.list{max-height:262px;overflow:auto;border:1px solid var(--line);border-radius:9px}
.list div{padding:7px 11px;border-bottom:1px solid var(--line);cursor:pointer;font-size:13px;
display:flex;gap:9px;align-items:center}
.list div:last-child{border-bottom:0}
.list div:hover{background:#fdf1ec}
.list div.sel{background:#fdf1ec;font-weight:600}
.list .m{margin-left:auto;font-size:11px;color:var(--muted)}
table{width:100%;border-collapse:collapse;font-size:13px}
th{background:var(--accent-d);color:#fff;text-align:left;padding:8px 10px;font-weight:500;
position:sticky;top:0;cursor:pointer;white-space:nowrap}
td{padding:6px 10px;border-bottom:1px solid var(--line);white-space:nowrap}
tr:hover td{background:#fdf1ec}
.wrap{max-height:520px;overflow:auto;border:1px solid var(--line);border-radius:9px}
.note{background:#fffaf6;border:1px solid #f3d6c8;border-radius:11px;padding:11px 13px;
font-size:13px;color:#7a4a33}
.note b{color:#8a3f1c}
.mono{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px}
footer{padding:0 22px 34px;color:var(--muted);font-size:12px}
.stbar{display:flex;align-items:center;gap:7px;font-size:12.5px;color:var(--muted);margin-top:9px}
.stbar .d{width:8px;height:8px;border-radius:50%;background:var(--ok)}
.tabs{display:flex;gap:6px;margin-bottom:11px}
.tabs button{flex:1;padding:7px 9px;border:1px solid var(--line);background:#fff;border-radius:9px;
font-family:inherit;font-size:13px;cursor:pointer;color:var(--muted)}
.tabs button.on{background:var(--accent-d);border-color:var(--accent-d);color:#fff;font-weight:600}
</style>
</head>
<body>
<div class="nav">
  <b>LipoKG</b><span class="chip">read-only dataset query</span>
  <span class="sp">Lipoprotein Metabolism Knowledge Graph · v1.2.0</span>
</div>
<header>
  <h1>Query the LipoKG gene-annotation layers</h1>
  <p>Look up any gene symbol (or a legacy alias) to see which of the four core annotation layers it
  belongs to &mdash; lipoprotein particle membership, pathway membership, disease/GWAS association and
  ClinVar variant annotation &mdash; together with its STRING interaction degree.</p>
</header>

<div class="layout">
  <aside>
    <div class="card">
      <div class="sec-h">Search<span class="hint">symbol or alias</span></div>
      <input type="text" id="q" placeholder="e.g. APOE, PCSK9, LDL receptor" autocomplete="off">
      <div class="list" id="hits" style="margin-top:10px"></div>
      <div class="stbar"><span class="d"></span><span id="st">type to search 1,910 annotated genes</span></div>
    </div>
    <div class="card">
      <div class="sec-h">Particle browser<span class="hint">7 particles</span></div>
      <select id="psel"></select>
      <div class="list" id="plist" style="margin-top:10px"></div>
    </div>
  </aside>

  <main>
    <div class="kpis" id="kpis"></div>
    <div class="card" style="margin-top:14px">
      <div class="sec-h">Selected gene<span class="hint" id="selname">&mdash;</span></div>
      <div class="detail" id="detail"><div class="note">Search for a gene on the left, or click any row in the table below.</div></div>
    </div>
    <div class="card">
      <div class="sec-h">How to read this<span class="hint">please read before using</span></div>
      <div class="note">
        Annotation depth is <b>concentrated in the curated lipoprotein core</b>. Of the 1,852 proteins in the
        STRING-derived interaction graph, only <b>117 (6.3%)</b> carry at least one non-STRING annotation layer and
        <b>1,735 (93.7%)</b> are represented by interaction edges alone. Proteins reachable only through 1-hop
        interaction expansion should therefore be read as <b>interaction context</b>, not as multi-layer annotations.
        Layer membership here reflects the deposited dataset snapshot (January 2024) and does not imply clinical validity.
      </div>
    </div>
    <div class="card">
      <div class="sec-h">All annotated genes<span class="hint" id="cnt"></span></div>
      <div class="tabs">
        <button class="on" data-f="all">All</button>
        <button data-f="multi">2+ layers</button>
        <button data-f="one">Exactly 1 layer</button>
        <button data-f="string">STRING only</button>
        <button data-f="graph">Not in protein graph</button>
      </div>
      <input type="text" id="tf" placeholder="filter by symbol..." autocomplete="off" style="margin-bottom:9px">
      <div class="wrap"><table>
        <thead><tr>
          <th data-k="0">Gene</th><th data-k="1">Particle</th><th data-k="2">Pathway</th>
          <th data-k="3">Disease/GWAS</th><th data-k="4">ClinVar</th><th data-k="7">STRING degree</th>
          <th data-k="6">Non-STRING layers</th>
        </tr></thead>
        <tbody id="tbody"></tbody>
      </table></div>
    </div>
  </main>
</div>

<footer>
  Dataset: <span class="mono">Zenodo 10.5281/zenodo.21318099</span> (LipoKG v1.2.1; layered licence — see <span class="mono">data/LICENSE.md</span>) &nbsp;·&nbsp;
  Code: <span class="mono">github.com/thereismywill/lipokg</span><br>
  This page is generated from the deposited supplementary tables (S8, S17, S24) and runs entirely in your browser;
  no data leaves your device. Layer membership is derived from STRING v12.0, ClinVar (2026-06), KEGG hsa05417,
  Reactome, WikiPathways, DisGeNET v7.0, OMIM, GLGC 2021 and Orphanet; individual source terms apply
  to the corresponding records.
</footer>

<script>
var DATA = /*__DATA__*/;
</script>
<script>
(function(){
  var G = DATA.genes, A = DATA.alias, P = DATA.particles;
  var bySym = {}, aliasMap = {};
  G.forEach(function(r){ bySym[r[0]] = r; });
  A.forEach(function(a){ aliasMap[a[0].toLowerCase()] = a[1]; });

  var LAYERS = [[2,"particle","Particle"],[3,"pathway","Pathway"],[4,"disease","Disease/GWAS"],[5,"variant","ClinVar"]];

  function tierLabel(t){
    if(t.indexOf("T2")===0) return ["multi","#0f766e","2+ layers"];
    if(t.indexOf("T3")===0) return ["one","#2563eb","1 layer"];
    if(t.indexOf("T4")===0) return ["string","#9ca3af","STRING only"];
    return ["t0","#b45309","not in graph"];
  }
  function esc(s){ return String(s).replace(/[&<>"]/g,function(c){
    return {"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]; }); }

  document.getElementById("kpis").innerHTML = [
    ["1,910","genes with layer annotations"],
    ["6,463","nodes (extended schema)"],
    ["37,165","relationships (extended)"],
    ["7","lipoprotein particles"],
    ["1,852","STRING proteins"]
  ].map(function(k){ return '<div class="kpi"><div class="v">'+k[0]+'</div><div class="l">'+k[1]+'</div></div>'; }).join("");

  var pnames = [];
  P.forEach(function(r){ if(pnames.indexOf(r[1])<0) pnames.push(r[1]); });
  pnames.sort();
  var psel = document.getElementById("psel");
  psel.innerHTML = '<option value="">&mdash; choose a particle &mdash;</option>' +
    pnames.map(function(p){ return '<option value="'+esc(p)+'">'+esc(p)+'</option>'; }).join("");

  function drawHits(list){
    var h = document.getElementById("hits");
    if(!list.length){ h.innerHTML = '<div style="color:#6b7280;cursor:default">no match</div>'; return; }
    h.innerHTML = list.slice(0,60).map(function(r){
      var tl = tierLabel(r[8]);
      return '<div data-g="'+esc(r[0])+'">'+esc(r[0])+
        '<span class="m"><span class="dot" style="background:'+tl[1]+'"></span>'+r[6]+' layer(s)</span></div>';
    }).join("");
    Array.prototype.forEach.call(h.querySelectorAll("div[data-g]"), function(d){
      d.onclick = function(){ select(d.getAttribute("data-g")); };
    });
  }

  function search(v){
    v = (v||"").trim();
    if(!v){ drawHits([]); document.getElementById("st").textContent = "type to search 1,910 annotated genes"; return; }
    var up = v.toUpperCase();
    var resolved = bySym[up] ? up : (aliasMap[v.toLowerCase()] || null);
    var list;
    if(resolved && bySym[resolved]) list = [bySym[resolved]].concat(
      G.filter(function(r){ return r[0]!==resolved && r[0].indexOf(up)===0; }));
    else list = G.filter(function(r){ return r[0].indexOf(up)===0; })
                 .concat(G.filter(function(r){ return r[0].indexOf(up)>0 && r[0].indexOf(up)!==0; }));
    drawHits(list);
    document.getElementById("st").textContent = list.length + " match(es)" +
      (resolved ? " · alias resolved to " + resolved : "");
    if(resolved && bySym[resolved]) select(resolved, true);
  }

  function select(sym, keepList){
    var r = bySym[sym]; if(!r) return;
    Array.prototype.forEach.call(document.querySelectorAll("#hits div[data-g]"), function(d){
      d.className = (d.getAttribute("data-g")===sym) ? "sel" : ""; });
    document.getElementById("selname").textContent = sym;
    var tl = tierLabel(r[8]);
    var badges = LAYERS.map(function(L){
      var on = r[L[0]] === 1;
      return '<span class="badge '+L[1]+' '+(on?"on":"off")+'">'+L[2]+(on?"":" · none")+'</span>';
    }).join("");
    var mine = P.filter(function(p){ return p[0]===sym; });
    var rows = [
      ["Symbol", '<b>'+esc(sym)+'</b>'],
      ["Annotation depth", '<span class="dot" style="background:'+tl[1]+'"></span>'+tl[2]+
        ' &nbsp;<span style="color:#6b7280">('+r[6]+' non-STRING layer'+(r[6]===1?"":"s")+')</span>'],
      ["Layers", badges],
      ["In STRING graph", r[1] ? "yes" : "no"],
      ["STRING degree", r[7] ? r[7] : "&mdash;"],
      ["Particle membership", mine.length ? mine.map(function(p){
          return '<span class="badge particle on">'+esc(p[1])+'</span>'; }).join("")
        : '<span style="color:#6b7280">none in this dataset</span>']
    ];
    document.getElementById("detail").innerHTML = rows.map(function(x){
      return '<div class="row"><div class="k">'+x[0]+'</div><div>'+x[1]+'</div></div>'; }).join("") +
      (mine.length ? '<div class="row"><div class="k">Role notes</div><div>' + mine.map(function(p){
          return esc(p[4]||"") + (p[5] ? ' <span style="color:#6b7280">('+esc(p[5])+')</span>' : ""); }).join("<br>") + '</div></div>' : "");
  }

  psel.onchange = function(){
    var p = psel.value, h = document.getElementById("plist");
    if(!p){ h.innerHTML = ""; return; }
    var rows = P.filter(function(r){ return r[1]===p; });
    h.innerHTML = rows.map(function(r){
      return '<div data-g="'+esc(r[0])+'"><b>'+esc(r[0])+'</b>'+
        (r[3] ? '<span class="m">'+esc(r[3])+'</span>' : "")+'</div>';
    }).join("") || '<div style="color:#6b7280;cursor:default">none</div>';
    Array.prototype.forEach.call(h.querySelectorAll("div[data-g]"), function(d){
      d.onclick = function(){ select(d.getAttribute("data-g")); };
    });
  };

  var filter = "all", tq = "", sortK = 6, sortDir = -1;
  function passes(r){
    if(filter==="multi"  && r[6] < 2) return false;
    if(filter==="one"    && r[6] !== 1) return false;
    if(filter==="string" && r[8].indexOf("T4")!==0) return false;
    if(filter==="graph"  && r[8].indexOf("T0")!==0) return false;
    if(tq && r[0].indexOf(tq) < 0) return false;
    return true;
  }
  function drawTable(){
    var rows = G.filter(passes).sort(function(a,b){
      var d = (a[sortK] > b[sortK]) ? 1 : (a[sortK] < b[sortK] ? -1 : 0);
      return sortDir * d || (a[0] > b[0] ? 1 : -1);
    });
    document.getElementById("cnt").textContent = rows.length + " gene(s) shown";
    document.getElementById("tbody").innerHTML = rows.map(function(r){
      var tl = tierLabel(r[8]);
      return "<tr data-g=\""+esc(r[0])+"\"><td><b>"+esc(r[0])+"</b></td>" +
        LAYERS.map(function(L){ return '<td style="text-align:center">'+(r[L[0]]===1?'<span class="dot" style="background:var(--'+L[1]+')"></span>':'<span style="color:#d1d5db">&middot;</span>')+"</td>"; }).join("") +
        '<td style="text-align:right">'+(r[7]||"")+"</td>" +
        '<td><span class="dot" style="background:'+tl[1]+'"></span>'+r[6]+"</td></tr>";
    }).join("");
    Array.prototype.forEach.call(document.querySelectorAll("#tbody tr"), function(tr){
      tr.onclick = function(){ select(tr.getAttribute("data-g")); window.scrollTo({top:0,behavior:"smooth"}); };
    });
  }

  Array.prototype.forEach.call(document.querySelectorAll(".tabs button"), function(b){
    b.onclick = function(){
      Array.prototype.forEach.call(document.querySelectorAll(".tabs button"), function(x){ x.className=""; });
      b.className = "on"; filter = b.getAttribute("data-f"); drawTable();
    };
  });
  Array.prototype.forEach.call(document.querySelectorAll("th[data-k]"), function(th){
    th.onclick = function(){
      var k = parseInt(th.getAttribute("data-k"),10);
      if(sortK===k){ sortDir = -sortDir; } else { sortK = k; sortDir = -1; }
      drawTable();
    };
  });

  var qEl = document.getElementById("q"); var timer = null;
  qEl.oninput = function(){ clearTimeout(timer); timer = setTimeout(function(){ search(qEl.value); }, 120); };
  document.getElementById("tf").oninput = function(e){ tq = e.target.value.toUpperCase(); drawTable(); };

  drawHits([]); drawTable();
  select("APOE");
})();
</script>
</body>
</html>
"""

if __name__ == "__main__":
    raise SystemExit(main())
