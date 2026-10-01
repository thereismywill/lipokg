"""
Supplementary Figures S1-S3
S1: Detailed network topology (multi-panel: node type counts, edge type counts, schema comparison)
S2: Degree distribution and distribution-model comparison
S3: Community detection visualization (7 Louvain modules)
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
import degree_models as dm
import pandas as pd
import networkx as nx
from scipy import stats as sp_stats
setup_style()
DATA_DIR = resolve_data_dir()
SUPP_DIR = resolve_supp_dir()
out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)

# ═══════════════════════════════════════════════════════
# FIGURE S1: Detailed Network Topology
# ═══════════════════════════════════════════════════════
print("Generating Figure S1...")
fig_s1, axes_s1 = plt.subplots(2, 2, figsize=(16, 14))
fig_s1.suptitle('Figure S1: Detailed Network Topology', fontsize=18, fontweight='bold', y=0.98)

# Panel A: Node type distribution (pie chart) — labels moved outside to avoid overlap
axA = axes_s1[0, 0]
axA.set_title('A  Node Type Distribution (Core)', fontsize=12, fontweight='bold')
labels = [f"{NODE_LABELS[k]}\n({v:,})" for k, v in NODE_COUNTS.items()]
sizes = list(NODE_COUNTS.values())
colors_pie = [NODE_COLORS[k] for k in NODE_COUNTS.keys()]
wedges, texts, autotexts = axA.pie(sizes, labels=labels, colors=colors_pie,
                                   autopct='%1.1f%%', startangle=90,
                                   labeldistance=1.25,      # ← 标签外推，避免扇区间重叠
                                   rotatelabels=True,        # ← 自动旋转标签
                                   pctdistance=0.6)          # ← 百分比文字留在内部
for t in texts:
    t.set_fontsize(7.5)
for t in autotexts:
    t.set_fontsize(7.5)
    t.set_color('white')
    t.set_fontweight('bold')

# Panel B: Edge type distribution (bar chart)
axB = axes_s1[0, 1]
axB.set_title('B  Relationship Type Distribution', fontsize=12, fontweight='bold')
rel_names = list(REL_COUNTS.keys())
rel_values = list(REL_COUNTS.values())
rel_colors = [REL_COLORS[k] for k in rel_names]
bars = axB.barh(range(len(rel_names)), rel_values, color=rel_colors, alpha=0.85)
axB.set_yticks(range(len(rel_names)))
axB.set_yticklabels(rel_names, fontsize=8)
axB.set_xlabel('Edge Count', fontsize=10)
axB.set_xscale('log')
for i, v in enumerate(rel_values):
    axB.text(v * 1.1, i, f'{v:,}', va='center', fontsize=7.5, color='#333')
axB.spines['top'].set_visible(False)
axB.spines['right'].set_visible(False)

# Panel C: Core vs Extended schema comparison
axC = axes_s1[1, 0]
axC.set_title('C  Core vs Extended Schema', fontsize=12, fontweight='bold')
categories = ['Node Types', 'Relationship Types', 'Nodes', 'Edges']
# 2026-10-01：原为 `core_vals = [7, 7, 6052, 36479]` / `ext_vals = [31, 25, 6463, 37165]`
#   —— **裸数字列表**，无标签无单位，此前所有判据都落空（只有肉眼看得出来）。
#   现从 graph_statistics.json 实算；废值已进 `--retired` 黑名单防回归。
core_vals = [len(NODE_COUNTS), len(REL_COUNTS), TOTAL_CORE_NODES, TOTAL_CORE_EDGES]
ext_vals = [EXT_NODE_TYPES, EXT_REL_TYPES, TOTAL_NODES, TOTAL_EDGES]
x = np.arange(len(categories))
w = 0.35
axC.bar(x - w/2, core_vals, w, color='#4C72B0', alpha=0.85, label='Core (CSV)')
axC.bar(x + w/2, ext_vals, w, color='#DD8452', alpha=0.85, label='Extended (Neo4j)')
axC.set_xticks(x)
axC.set_xticklabels(categories, fontsize=9)
axC.set_yscale('log')
axC.set_ylabel('Count (log scale)', fontsize=10)
axC.legend(fontsize=9)
for i, (c, e) in enumerate(zip(core_vals, ext_vals)):
    axC.text(i - w/2, c * 1.2, f'{c:,}', ha='center', fontsize=7.5, color='#4C72B0')
    axC.text(i + w/2, e * 1.2, f'{e:,}', ha='center', fontsize=7.5, color='#DD8452')
axC.spines['top'].set_visible(False)
axC.spines['right'].set_visible(False)

# Panel D: Network summary statistics
axD = axes_s1[1, 1]
axD.set_title('D  Network Summary Statistics', fontsize=12, fontweight='bold')
axD.axis('off')
# 2026-10-01：整表改为**从 graph_statistics.json 实算**。原表 4 个格子是手写字面量且全部过期
#   （core 6,054/36,483；全图 6,475/37,177 —— 后者还是已被整体替换掉的 Neo4j count(*) 口径）。
#   判据已覆盖该写法（check_figure_constants.py 的「图内汇总表 标签计数」）。
_T = TOPOLOGY
_PREF = _T['degree_distribution_preferred'].split(';')[0]
stats_table = [
    ['Metric', 'Value'],
    ['Core nodes', f'{TOTAL_CORE_NODES:,}'],
    ['Core edges', f'{TOTAL_CORE_EDGES:,}'],
    ['Node types (core)', str(len(NODE_COUNTS))],
    ['Relationship types (core)', str(len(REL_COUNTS))],
    ['Connected components', str(_T['connected_components'])],
    ['Average degree', f"{_T['average_degree']:.1f}"],
    ['Diameter', str(_T['diameter'])],
    ['Degree distribution', 'heavy-tailed; power law rejected'],
    [f"Power-law \u03b1 (xmin = {int(_T['power_law_xmin'])})",
     f"{_T['power_law_alpha']:.2f} (95% CI: {_T['power_law_95CI'][0]:.2f}\u2013{_T['power_law_95CI'][1]:.2f})"],
    ['Preferred model', _PREF.replace('likelihood ratio ', '')],
    ['Louvain modularity Q', f"{_T['louvain_modularity']:.2f}"],
    ['Louvain modules', str(_T['louvain_modules'])],
    ['Whole-graph nodes (core + extended)', f'{TOTAL_NODES:,}'],
    ['Whole-graph edges (core + extended)', f'{TOTAL_EDGES:,}'],
    ['Node types (extended)', str(EXT_NODE_TYPES)],
    ['Relationship types (extended)', str(EXT_REL_TYPES)],
]

cell_colors = []
for i in range(len(stats_table)):
    if i == 0:
        cell_colors.append(['#4C72B0', '#4C72B0'])
    else:
        cell_colors.append(['#F5F5F5', '#FFFFFF'] if i % 2 == 0 else ['#FFFFFF', '#FFFFFF'])
table = axD.table(cellText=stats_table, cellLoc='center', loc='center',
                  cellColours=cell_colors)
table.auto_set_font_size(False)
table.set_fontsize(8)
table.scale(1, 1.6)
for j in range(2):
    table[0, j].set_text_props(fontweight='bold', color='white')
    table[0, j].set_facecolor('#4C72B0')

plt.tight_layout(rect=[0, 0, 1, 0.96])
save_fig(fig_s1, os.path.join(out_dir, 'Figure_S1_Detailed_Topology_v5.tiff'))
plt.close(fig_s1)
print("Figure S1 done!")

# ═══════════════════════════════════════════════════════
# FIGURE S2: Degree Distribution (Detailed)
# ═══════════════════════════════════════════════════════
print("Generating Figure S2...")
proteins = pd.read_csv(os.path.join(DATA_DIR, 'string_proteins.csv'))
interactions = pd.read_csv(os.path.join(DATA_DIR, 'string_interactions.csv'))
G = nx.Graph()
G.add_edges_from(zip(interactions['source'], interactions['target']))
degrees = dict(G.degree())
degree_values = np.array(list(degrees.values()))

fig_s2, axes_s2 = plt.subplots(2, 2, figsize=(15, 11))
fig_s2.suptitle('Figure S2: Degree Distribution and Model Comparison',
                fontsize=18, fontweight='bold', y=0.98)

# Panel A: Histogram
axA = axes_s2[0, 0]
axA.set_title('A  Degree histogram', fontsize=12, fontweight='bold')
axA.hist(degree_values, bins=80, color='#4C72B0', alpha=0.7, edgecolor='white', linewidth=0.3)
axA.set_xlabel('Degree (k)', fontsize=10)
axA.set_ylabel('Count', fontsize=10)
axA.axvline(np.mean(degree_values), color='#C44E52', ls='--', lw=1.5,
            label=f'Mean = {np.mean(degree_values):.1f}')
axA.axvline(np.median(degree_values), color='#DD8452', ls='--', lw=1.5,
            label=f'Median = {np.median(degree_values):.1f}')
axA.legend(fontsize=8)
axA.spines['top'].set_visible(False)
axA.spines['right'].set_visible(False)

# Panel B: CCDF with competing model fits
axB = axes_s2[0, 1]
axB.set_title('B  CCDF with competing model fits (log-log)', fontsize=12, fontweight='bold')
k_emp, ccdf_emp = dm.empirical_ccdf(degree_values)
kk = np.logspace(0, np.log10(max(k_emp)), 400)
lam = dm.exponential_lambda(degree_values)
axB.scatter(k_emp, ccdf_emp, s=3, color='#4C72B0', alpha=0.35, label='Observed')
axB.plot(kk, dm.exponential_ccdf(kk, lam), '--', color='#55A868', lw=1.6, label='Exponential')
axB.plot(kk, dm.lognormal_ccdf(kk), '-', color='#DD8452', lw=2.2,
         label=f'Lognormal (\u03bc = {dm.FIT["lognormal_mu"]:.2f}, \u03c3 = {dm.FIT["lognormal_sigma"]:.2f})')
axB.plot(kk, dm.pl_ccdf(kk), '-', color='#C44E52', lw=2.2,
         label=f'Power law (\u03b1 = {dm.FIT["alpha"]:.2f}, xmin = {int(dm.FIT["xmin"])})')
axB.set_xscale('log')
axB.set_yscale('log')
axB.set_xlim(0.9, max(k_emp) * 1.4)
axB.set_ylim(4e-4, 1.6)
axB.set_xlabel('Degree (k)', fontsize=10)
axB.set_ylabel('P(K \u2265 k)', fontsize=10)
axB.legend(fontsize=8, loc='lower left')
axB.spines['top'].set_visible(False)
axB.spines['right'].set_visible(False)

# Panel C: distribution-model comparison (likelihood ratio vs the power law)
axC = axes_s2[1, 0]
axC.set_title('C  Distribution-model comparison', fontsize=12, fontweight='bold')
labels_c = ['vs exponential', 'vs lognormal', 'vs truncated\npower law']
vals_c = [dm.FIT['R_vs_exponential'], dm.FIT['R_vs_lognormal'], dm.FIT['R_vs_truncated_power_law']]
pv_c = [dm.FIT['p_vs_exponential'], dm.FIT['p_vs_lognormal'], dm.FIT['p_vs_truncated_power_law']]
colors_c = ['#55A868' if v < 0 else '#C44E52' for v in vals_c]
axC.barh(range(len(vals_c)), vals_c, color=colors_c, alpha=0.85, edgecolor='white')
axC.set_yticks(range(len(vals_c)))
axC.set_yticklabels(labels_c, fontsize=9)
axC.axvline(0, color='#333', lw=0.8)
axC.set_xlabel('log-likelihood ratio R (power law vs alternative)', fontsize=10)
axC.invert_yaxis()
axC.set_xlim(min(vals_c) * 1.15, 62)
for i, (v, pv) in enumerate(zip(vals_c, pv_c)):
    axC.text(2.5, i, f'R = {v:.1f}, p = {pv:.1e}', va='center', ha='left', fontsize=8)
axC.tick_params(axis='y', labelsize=8)
axC.text(0.98, 0.06, f'R < 0: alternative favoured\nPower-law bootstrap KS p = {dm.FIT["bootstrap_p"]:.0e}',
         transform=axC.transAxes, fontsize=8, va='bottom', ha='right',
         bbox=dict(boxstyle='round', fc='#F5F5F5', ec='#CCC'))
axC.spines['top'].set_visible(False)
axC.spines['right'].set_visible(False)

# Panel D: Top-20 hub proteins
axD = axes_s2[1, 1]
axD.set_title('D  Top-20 hub proteins', fontsize=12, fontweight='bold')
ensembl_to_gene = dict(zip(proteins['ensembl_id'], proteins['name']))
top_hubs = sorted(degrees.items(), key=lambda x: x[1], reverse=True)[:20]
hub_genes = [ensembl_to_gene.get(h[0], h[0][:12]) for h in top_hubs]
hub_degrees = [h[1] for h in top_hubs]
axD.barh(range(len(hub_genes)), hub_degrees, color='#DD8452', alpha=0.85, edgecolor='white')
axD.set_yticks(range(len(hub_genes)))
axD.set_yticklabels(hub_genes, fontsize=8)
axD.set_xlabel('Degree', fontsize=10)
axD.invert_yaxis()
for i, d in enumerate(hub_degrees):
    axD.text(d + 4, i, str(d), va='center', fontsize=7.5, color='#333')
axD.spines['top'].set_visible(False)
axD.spines['right'].set_visible(False)

plt.tight_layout()
save_fig(fig_s2, os.path.join(out_dir, 'Figure_S2_Degree_Distribution_v5.tiff'))
plt.close(fig_s2)
print("Figure S2 done!")

# ═══════════════════════════════════════════════════════
# FIGURE S3: Community Detection (9 Modules)
# ═══════════════════════════════════════════════════════
print("Generating Figure S3...")
mod_df = pd.read_csv(os.path.join(SUPP_DIR, 'Table_S22_Modularity_Analysis.csv'))

fig_s3, axes_s3 = plt.subplots(3, 4, figsize=(22, 16))
fig_s3.suptitle('Figure S3: Community Detection — 9 Louvain Modules (Q = 0.51)',
                fontsize=18, fontweight='bold', y=0.98)
module_colors = ['#E63946', '#F4A261', '#E9C46A', '#2A9D8F', '#264653', '#7B2D8B', '#8D6E63',
                 '#4C72B0', '#55A868']

# Panels A-I: One per module
for idx, (_, row) in enumerate(mod_df.iterrows()):
    ax = axes_s3[idx // 4, idx % 4]
    color = module_colors[idx]
    mid = row['module_id']
    name = row['module_name']
    size = row['module_size']
    key_genes = row['top_genes'].split('; ')[:8]
    pval = row['enrichment_p_value']
    ax.set_title(f'{mid}: {name}', fontsize=11, fontweight='bold', color=color, pad=6)

    # Module size bar
    ax.barh([0], [size], color=color, alpha=0.8, height=0.6)
    ax.text(size/2, 0, f'n = {size}', ha='center', va='center',
            fontsize=10, fontweight='bold', color='white')
    ax.set_xlim(0, 450)
    ax.set_yticks([])

    # Key genes
    ax.text(0, -0.8, 'Key genes:', fontsize=8, fontweight='bold', color='#333')
    for i, gene in enumerate(key_genes):
        col = i % 4
        row_i = i // 4
        ax.text(col * 85, -1.2 - row_i * 0.4, gene, fontsize=7, color=color,
                family='monospace')

    # Enrichment
    ax.text(0, -2.3, f'P = {float(pval):.2g}', fontsize=7.5, color='#555', style='italic')

    # Top disease — 阈值从35增加到55，完整显示长疾病名
    disease = row['enriched_go_terms'].split(';')[0].split('~')[-1].strip()
    if len(disease) > 55:                          # ← 唯一修改：35→55
        disease = disease[:52] + '…'
    ax.text(0, -2.7, disease, fontsize=7, color='#888')
    ax.set_ylim(-3.2, 0.6)
    ax.axis('off')

# Panel J: Module size summary
axes_s3[2, 1].axis('off'); axes_s3[2, 2].axis('off')
axH = axes_s3[2, 3]
axH.set_title('Module Sizes', fontsize=11, fontweight='bold', pad=6)
sizes = mod_df['module_size'].values
names_short = [f"{r['module_id']}: {str(r['module_name'])[:24]}" for _, r in mod_df.iterrows()]
bars_h = axH.barh(range(len(sizes)), sizes, color=module_colors, alpha=0.85, edgecolor='white')
axH.set_yticks(range(len(sizes)))
axH.set_yticklabels(names_short, fontsize=7)
axH.set_xlabel('Module Size (# proteins)', fontsize=9)
axH.invert_yaxis()
axH.spines['top'].set_visible(False)
axH.spines['right'].set_visible(False)

plt.tight_layout(rect=[0, 0, 1, 0.96])
save_fig(fig_s3, os.path.join(out_dir, 'Figure_S3_Community_Detection_v5.tiff'))
plt.close(fig_s3)
print("Figure S3 done!")
print("\n=== All supplementary figures generated! ===")