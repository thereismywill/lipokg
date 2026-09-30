"""
Figure 3: Coverage and Validation Analysis
7 benchmarks with 95% Wilson score confidence intervals
Horizontal bar chart + summary statistics
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
from scipy import stats
setup_style()
fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(21, 7),
                                   gridspec_kw={'width_ratios': [2.3, 0.85, 1.15]})

# ═══════════════════════════════════════════════════════
# PANEL A: Validation benchmarks (horizontal bar chart)
# ═══════════════════════════════════════════════════════
benchmarks = [
    ('Expert 54-gene set',      54,  54,  '#2E7D32'),
    ('ClinGen dosage genes',    25,  25,  '#2E7D32'),
    ('GO lipoprotein process', 132, 143,  '#1565C0'),
    ('Reactome pathways',       61,  71,  '#1565C0'),
    ('KEGG hsa05417',          157, 216,  '#1565C0'),
    ('WikiPathways lipid',      73,  92,  '#1565C0'),
    ('GLGC 2021 GWAS loci',   244, 376,  '#E65100'),
]

def wilson_ci(num, den, z=1.96):
    """Wilson score confidence interval."""
    p = num / den
    denom = 1 + z**2/den
    center = (p + z**2/(2*den)) / denom
    spread = z * np.sqrt(p*(1-p)/den + z**2/(4*den**2)) / denom
    return max(0, center - spread), min(1, center + spread)

names = [b[0] for b in benchmarks]
pcts = [b[1]/b[2]*100 for b in benchmarks]
cis = [wilson_ci(b[1], b[2]) for b in benchmarks]
ci_low = [(pcts[i] - cis[i][0]*100) for i in range(len(pcts))]
ci_high = [(cis[i][1]*100 - pcts[i]) for i in range(len(pcts))]
colors = [b[3] for b in benchmarks]
y_pos = np.arange(len(names))

bars = ax1.barh(y_pos, pcts, xerr=[ci_low, ci_high],
                color=colors, alpha=0.85, edgecolor='white', linewidth=0.5,
                capsize=4, error_kw={'linewidth': 1.2, 'capthick': 1.2})

# Labels and annotations
ax1.set_yticks(y_pos)
ax1.set_yticklabels(names, fontsize=10)
ax1.set_xlabel('Coverage (%)', fontsize=12)
ax1.set_xlim(0, 115)

# Add count annotations — placed to the right of the upper error bar cap
for i, (num, den, pct) in enumerate(zip([b[1] for b in benchmarks],
                                        [b[2] for b in benchmarks], pcts)):
    ci_lo, ci_hi = cis[i]
    text_x = pct + ci_high[i] + 1.0       # ← 始终在误差棒上须右侧，避免重叠
    ax1.text(text_x, i,
             f"{pct:.1f}%  ({num}/{den})  95% CI [{ci_lo*100:.1f}, {ci_hi*100:.1f}]",
             va='center', fontsize=8, color='#333')

# Threshold lines
ax1.axvline(x=90, color='#2E7D32', ls='--', lw=0.8, alpha=0.5)
ax1.text(90.5, 6.4, '90% threshold', fontsize=7, color='#2E7D32', va='bottom')
ax1.axvline(x=80, color='#F57F17', ls='--', lw=0.8, alpha=0.5)
ax1.text(80.5, 6.4, '80%', fontsize=7, color='#F57F17', va='bottom')

# Category labels
ax1.text(-0.5, 0.5, 'Gene Sets\n(100%)', ha='right', va='center',
         fontsize=8, fontweight='bold', color='#2E7D32',
         transform=ax1.get_yaxis_transform())
ax1.text(-0.5, 3.5, 'Pathway\nCompleteness', ha='right', va='center',
         fontsize=8, fontweight='bold', color='#1565C0',
         transform=ax1.get_yaxis_transform())
ax1.text(-0.5, 6.0, 'GWAS\nCoverage', ha='right', va='center',
         fontsize=8, fontweight='bold', color='#E65100',
         transform=ax1.get_yaxis_transform())

ax1.set_title('A  Benchmark Coverage with 95% CI', fontsize=14, fontweight='bold',
              loc='left', pad=10)
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# PANEL B: Summary donut chart
# ═══════════════════════════════════════════════════════
# Group by coverage tier —— **从 VALIDATION 实算**，不再写死
#   2026-10-01 实测：此处原写死 high=4/med=2/low=1，连改前的 7 个基准都对不上
#   （≥90% 只有 GO/ClinGen/Expert = 3 个）。写死的分档会随基准值变动而静默失效。
_pcts = [v['pct'] for v in VALIDATION.values()]
high = sum(1 for _p in _pcts if _p >= 90)
med = sum(1 for _p in _pcts if 80 <= _p < 90)
low = sum(1 for _p in _pcts if _p < 80)
assert high + med + low == len(_pcts), '分档之和须等于基准数'
sizes = [high, med, low]
labels_donut = [f'High (≥90%)\nn={high}', f'Medium (80-90%)\nn={med}',
                f'Below 80%\nn={low}']
donut_colors = ['#2E7D32', '#F57F17', '#C62828']
wedges, texts = ax2.pie(sizes, labels=labels_donut, colors=donut_colors,
                        startangle=90, pctdistance=0.75,
                        wedgeprops=dict(width=0.35, edgecolor='white', linewidth=2))
for t in texts:
    t.set_fontsize(9)

# Center text
ax2.text(0, 0, f'{len(_pcts)}\nBenchmarks', ha='center', va='center',
         fontsize=14, fontweight='bold', color='#333')
ax2.text(0, -0.25, f'Overall: {sum(_pcts) / len(_pcts):.1f}%', ha='center', va='center',
         fontsize=10, color='#555')
ax2.set_title('B  Coverage Tier Summary', fontsize=14, fontweight='bold',
              loc='left', pad=10)

# ═══════════════════════════════════════════════════════
# PANEL C: Gene-level annotation depth (added in v6)
#   每个蛋白节点「除 STRING 边之外还带几层注释」
#   数据源：Review/gene_level_coverage.csv（由沉积数据实算）
# ═══════════════════════════════════════════════════════
#   2026-10-01 改为**读 Table_S24 实算**（原先写死 {4:22,3:14,2:24,1:57,0:1735}，
#   移除伪造的 WikiPathways 层后这里必须跟着变，写死就会与表/正文脱节）。
import csv as _csv
_S24 = os.path.join(resolve_supp_dir(), 'Table_S24_Gene_Level_Coverage.csv')
_S1 = os.path.join(resolve_supp_dir(), 'Table_S1_Seed_Genes.csv')
with open(_S24, encoding='utf-8-sig') as _f24:
    _rows24 = list(_csv.DictReader(_f24))
_in_graph = [r for r in _rows24 if r['in_string_graph'] == '1']
n_prot = len(_in_graph)                          # 交互图中的蛋白数（分母）
depth_counts = {k: sum(1 for r in _in_graph if int(r['n_non_string_layers']) == k)
                for k in range(5)}               # 非 STRING 层数 -> 基因数
assert sum(depth_counts.values()) == n_prot, "注释深度分布之和须等于交互图蛋白数"
with open(_S1, encoding='utf-8-sig') as _f1:
    _seed = {r['symbol'] for r in _csv.DictReader(_f1)}
_core = [r for r in _rows24 if r['gene'] in _seed]
_core_ge1 = sum(1 for r in _core if int(r['n_non_string_layers']) >= 1)
_core_eq4 = sum(1 for r in _core if int(r['n_non_string_layers']) == 4)
_ge1 = sum(v for k, v in depth_counts.items() if k >= 1)

depth_labels = ['4 layers', '3 layers', '2 layers', '1 layer', 'STRING only']
depth_vals = [depth_counts[k] for k in (4, 3, 2, 1, 0)]
depth_cols = ['#2E7D32', '#2E7D32', '#43A047', '#90A4AE', '#CFD8DC']
dy = np.arange(len(depth_labels))

ax3.barh(dy, depth_vals, color=depth_cols, alpha=0.9,
         edgecolor='white', linewidth=0.5)
ax3.set_xscale('log')                 # 1,735 与 14 同图必须用对数轴
ax3.set_xlim(8, 4000)
ax3.set_yticks(dy)
ax3.set_yticklabels(depth_labels, fontsize=10)
ax3.set_xlabel('Proteins in interaction graph (log scale)', fontsize=11)

for i, v in enumerate(depth_vals):
    ax3.text(v * 1.15, i, f"{v:,}  ({v / n_prot * 100:.1f}%)",
             va='center', fontsize=8.5, color='#333')

ax3.text(0.98, 0.06,
         f"{_ge1:,} of {n_prot:,} ({_ge1 / n_prot * 100:.1f}%) carry ≥1 non-STRING layer\n"
         f"{len(_core)}-gene curated core: {_core_ge1 / len(_core) * 100:.1f}% ≥1 layer, "
         f"{_core_eq4 / len(_core) * 100:.1f}% all four",
         transform=ax3.transAxes, ha='right', va='bottom', fontsize=8.5,
         color='#555', bbox=dict(boxstyle='round,pad=0.4',
                                 fc='#F5F5F5', ec='#BDBDBD', lw=0.6))
ax3.set_title('C  Gene-Level Annotation Depth', fontsize=14, fontweight='bold',
              loc='left', pad=10)
ax3.spines['top'].set_visible(False)
ax3.spines['right'].set_visible(False)

fig.suptitle('Figure 3: Coverage and Validation Analysis', fontsize=16,
             fontweight='bold', y=1.02)
plt.tight_layout()

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_3_Coverage_Analysis_v6.tiff'))
plt.close(fig)
print("Figure 3 done!")