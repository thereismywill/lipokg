"""
Supplementary Figures S1-S3
S1: Detailed network topology (multi-panel: node type counts, edge type counts, schema comparison)
S2: Degree distribution with power-law fit (detailed)
S3: Community detection visualization (7 Louvain modules)
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
import pandas as pd
import networkx as nx
from scipy import stats as sp_stats
setup_style()
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'data', 'data')
SUPP_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'supplementary')
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
core_vals = [7, 7, 6052, 36559]
ext_vals = [31, 25, 6463, 37165]
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
stats_table = [
    ['Metric', 'Value'],
    ['Total core nodes', '6,052'],
    ['Total core edges', '36,559'],
    ['Node types (core)', '7'],
    ['Relationship types (core)', '7'],
    ['Connected components', '1'],
    ['Average degree', '34.4'],
    ['Diameter', '8'],
    ['Power-law α', '2.31 (95% CI: 2.24–2.38)'],
    ['Louvain modularity Q', '0.41'],
    ['Louvain modules', '7'],
    ['Total nodes (extended)', '6,463'],
    ['Total edges (extended)', '37,165'],
    ['Node types (extended)', '31'],
    ['Relationship types (extended)', '25'],
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
table.set_fontsize(9)
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

fig_s2, axes_s2 = plt.subplots(1, 3, figsize=(18, 5.5))
fig_s2.suptitle('Figure S2: Degree Distribution Analysis', fontsize=18, fontweight='bold', y=1.02)

# Panel A: Histogram
axA = axes_s2[0]
axA.set_title('A  Degree Histogram', fontsize=12, fontweight='bold')
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

# Panel B: CCDF (complementary cumulative distribution)
axB = axes_s2[1]
axB.set_title('B  CCDF (Log-Log)', fontsize=12, fontweight='bold')
sorted_deg = np.sort(degree_values)
ccdf = 1 - np.arange(1, len(sorted_deg)+1) / len(sorted_deg)
axB.loglog(sorted_deg, ccdf, '-', color='#4C72B0', lw=1.5, alpha=0.8)
axB.set_xlabel('Degree (k)', fontsize=10)
axB.set_ylabel('P(K ≥ k)', fontsize=10)
kmin = 5
above = sorted_deg[sorted_deg >= kmin]
alpha_mle = 1 + len(above) * np.sum(np.log(above / (kmin - 0.5)))**(-1)
fit_x = np.logspace(np.log10(kmin), np.log10(max(sorted_deg)), 100)
fit_y = (fit_x / kmin)**(-(alpha_mle - 1))
axB.loglog(fit_x, fit_y, '--', color='#C44E52', lw=2,
           label=f'Power-law (α = {alpha_mle:.2f})')
axB.legend(fontsize=9)
axB.spines['top'].set_visible(False)
axB.spines['right'].set_visible(False)

# Panel C: Top-20 hub proteins
axC = axes_s2[2]
axC.set_title('C  Top-20 Hub Proteins', fontsize=12, fontweight='bold')
ensembl_to_gene = dict(zip(proteins['ensembl_id'], proteins['name']))
top_hubs = sorted(degrees.items(), key=lambda x: x[1], reverse=True)[:20]
hub_genes = [ensembl_to_gene.get(h[0], h[0][:12]) for h in top_hubs]
hub_degrees = [h[1] for h in top_hubs]
bars_c = axC.barh(range(len(hub_genes)), hub_degrees, color='#DD8452', alpha=0.85, edgecolor='white')
axC.set_yticks(range(len(hub_genes)))
axC.set_yticklabels(hub_genes, fontsize=8)
axC.set_xlabel('Degree', fontsize=10)
axC.invert_yaxis()
for i, d in enumerate(hub_degrees):
    axC.text(d + 2, i, str(d), va='center', fontsize=7.5, color='#333')
axC.spines['top'].set_visible(False)
axC.spines['right'].set_visible(False)

plt.tight_layout()
save_fig(fig_s2, os.path.join(out_dir, 'Figure_S2_Degree_Distribution_v5.tiff'))
plt.close(fig_s2)
print("Figure S2 done!")

# ═══════════════════════════════════════════════════════
# FIGURE S3: Community Detection (7 Modules)
# ═══════════════════════════════════════════════════════
print("Generating Figure S3...")
mod_df = pd.read_csv(os.path.join(SUPP_DIR, 'Table_S22_Modularity_Analysis.csv'))

fig_s3, axes_s3 = plt.subplots(2, 4, figsize=(20, 10))
fig_s3.suptitle('Figure S3: Community Detection — 7 Louvain Modules (Q = 0.41)',
                fontsize=18, fontweight='bold', y=0.98)
module_colors = ['#E63946', '#F4A261', '#E9C46A', '#2A9D8F', '#264653', '#7B2D8B', '#8D6E63']

# Panels A-G: One per module
for idx, (_, row) in enumerate(mod_df.iterrows()):
    ax = axes_s3[idx // 4, idx % 4]
    color = module_colors[idx]
    mid = row['module_id']
    name = row['module_name']
    size = row['module_size']
    key_genes = row['key_genes'].split(', ')[:8]
    pval = row['enrichment_p_value']
    ax.set_title(f'{mid}: {name}', fontsize=11, fontweight='bold', color=color, pad=6)

    # Module size bar
    ax.barh([0], [size], color=color, alpha=0.8, height=0.6)
    ax.text(size/2, 0, f'n = {size}', ha='center', va='center',
            fontsize=10, fontweight='bold', color='white')
    ax.set_xlim(0, 350)
    ax.set_yticks([])

    # Key genes
    ax.text(0, -0.8, 'Key genes:', fontsize=8, fontweight='bold', color='#333')
    for i, gene in enumerate(key_genes):
        col = i % 4
        row_i = i // 4
        ax.text(col * 85, -1.2 - row_i * 0.4, gene, fontsize=7, color=color,
                family='monospace')

    # Enrichment
    ax.text(0, -2.3, f'P = {pval}', fontsize=7.5, color='#555', style='italic')

    # Top disease — 阈值从35增加到55，完整显示长疾病名
    disease = row['top_diseases'].split(';')[0].split('(')[0].strip()
    if len(disease) > 55:                          # ← 唯一修改：35→55
        disease = disease[:52] + '…'
    ax.text(0, -2.7, disease, fontsize=7, color='#888')
    ax.set_ylim(-3.2, 0.6)
    ax.axis('off')

# Panel H: Module size summary
axH = axes_s3[1, 3]
axH.set_title('Module Sizes', fontsize=11, fontweight='bold', pad=6)
sizes = mod_df['module_size'].values
names_short = [f"{r['module_id']}\n{r['module_name']}" for _, r in mod_df.iterrows()]
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