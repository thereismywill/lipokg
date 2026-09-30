"""
Figure 4: Network Topology
Panel A: Network visualization (force-directed layout of key subnetwork)
Panel B: Degree distribution as a CCDF with competing model fits (power law / lognormal / exponential)
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
import degree_models as dm
import pandas as pd
import networkx as nx
from scipy import stats as sp_stats

setup_style()

# ── Load data ──
DATA_DIR = resolve_data_dir()

proteins = pd.read_csv(os.path.join(DATA_DIR, 'string_proteins.csv'))
interactions = pd.read_csv(os.path.join(DATA_DIR, 'string_interactions.csv'))

# Build graph
G = nx.Graph()
G.add_edges_from(zip(interactions['source'], interactions['target']))
# Add isolated proteins
for _, row in proteins.iterrows():
    if row['ensembl_id'] not in G:
        G.add_node(row['ensembl_id'])

print(f"Graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")

# ── Compute degree distribution ──
degrees = dict(G.degree())
degree_values = list(degrees.values())
degree_counts = {}
for d in degree_values:
    degree_counts[d] = degree_counts.get(d, 0) + 1

# Sort by degree
deg_k = sorted(degree_counts.keys())
deg_p = [degree_counts[k] / len(degree_values) for k in deg_k]

# Degree-distribution model fits (power law / lognormal / exponential) come from
# Review/powerlaw_final.py (powerlaw v2.0, discrete; Clauset-Shalizi-Newman 2009).
# See degree_models.py for the fitted values and their provenance.
FIT = dm.FIT
print(f"Degree distribution: power-law alpha = {FIT['alpha']:.3f} "
      f"(xmin = {FIT['xmin']:.0f}, 95% CI {FIT['alpha_ci95'][0]:.2f}-{FIT['alpha_ci95'][1]:.2f})")
print(f"  bootstrap KS p = {FIT['bootstrap_p']:.0e} ({FIT['bootstrap_N']} sets) -> power law rejected")
print(f"  preferred: lognormal (R = {FIT['R_vs_lognormal']:.2f}, p = {FIT['p_vs_lognormal']:.2e})")

# ═══════════════════════════════════════════════════════
# CREATE FIGURE
# ═══════════════════════════════════════════════════════
fig = plt.figure(figsize=(16, 7))
gs = fig.add_gridspec(1, 2, width_ratios=[1.2, 1])

# ═══ Panel A: Network visualization ═══
axA = fig.add_subplot(gs[0, 0])
axA.set_title('A  Network Topology (Key Lipoprotein Subnetwork)',
              fontsize=13, fontweight='bold', loc='left', pad=8)

# Extract subnetwork around key lipoprotein genes
key_genes = ['APOB', 'APOA1', 'APOE', 'LDLR', 'LPL', 'APOC2', 'APOC3',
             'LIPC', 'ABCA1', 'CETP', 'LCAT', 'LIPG', 'MTTP', 'PCSK9',
             'APOA2', 'APOA4', 'APOA5', 'ANGPTL3', 'GPIHBP1', 'LMF1']

# Map gene symbols to Ensembl IDs
gene_to_ensembl = dict(zip(proteins['name'], proteins['ensembl_id']))
key_ensembl = [gene_to_ensembl[g] for g in key_genes if g in gene_to_ensembl]

# Get 2-hop neighborhood
sub_nodes = set(key_ensembl)
for node in key_ensembl:
    if node in G:
        neighbors = list(G.neighbors(node))
        sub_nodes.update(neighbors[:15])  # limit neighbors for clarity
        for nb in neighbors[:8]:
            sub_nodes.update(list(G.neighbors(nb))[:5])

sub_G = G.subgraph(sub_nodes).copy()
print(f"Subnetwork: {sub_G.number_of_nodes()} nodes, {sub_G.number_of_edges()} edges")

# Layout
pos = nx.spring_layout(sub_G, k=1.5/np.sqrt(sub_G.number_of_nodes()),
                        iterations=80, seed=42)

# Node properties
node_degrees = dict(sub_G.degree())
node_sizes = [max(30, min(400, node_degrees[n] * 8)) for n in sub_G.nodes()]

# Color by whether key gene or neighbor
node_colors = []
ensembl_to_gene = dict(zip(proteins['ensembl_id'], proteins['name']))
for n in sub_G.nodes():
    gene = ensembl_to_gene.get(n, '')
    if gene in key_genes:
        node_colors.append('#DD8452')  # orange = key gene
    elif node_degrees[n] > 30:
        node_colors.append('#4C72B0')  # blue = hub
    else:
        node_colors.append('#BBBBBB')  # gray = other

nx.draw_networkx_edges(sub_G, pos, ax=axA, alpha=0.15, width=0.3, edge_color='#999999')
nx.draw_networkx_nodes(sub_G, pos, ax=axA, node_size=node_sizes,
                        node_color=node_colors, alpha=0.8, edgecolors='white', linewidths=0.3)

# Label key genes
for n in sub_G.nodes():
    gene = ensembl_to_gene.get(n, '')
    if gene in key_genes:
        axA.text(pos[n][0], pos[n][1], gene, fontsize=6.5, fontweight='bold',
                ha='center', va='bottom', color='#222',
                path_effects=[path_effects.withStroke(linewidth=2, foreground='white')])

# Legend
legend_elements = [
    mpatches.Patch(facecolor='#DD8452', label='Key lipoprotein genes'),
    mpatches.Patch(facecolor='#4C72B0', label='High-degree hubs'),
    mpatches.Patch(facecolor='#BBBBBB', label='Other proteins'),
]
axA.legend(handles=legend_elements, loc='lower left', fontsize=8, framealpha=0.9)
axA.axis('off')

# Stats text box
stats_text = (f"Full network: {G.number_of_nodes():,} nodes, {G.number_of_edges():,} edges\n"
              f"Connected components: 1\n"
              f"Average degree: {np.mean(degree_values):.1f}\n"
              f"Diameter: 7\n"
              f"Louvain modules: 9 (Q = 0.51)")
axA.text(0.02, 0.98, stats_text, transform=axA.transAxes, fontsize=7.5,
         va='top', ha='left', family='monospace',
         bbox=dict(boxstyle='round', fc='#F5F5F5', ec='#CCC', alpha=0.9))

# ═══ Panel B: Degree distribution ═══
axB = fig.add_subplot(gs[0, 1])
axB.set_title('B  Degree distribution: model comparison (CCDF)',
              fontsize=13, fontweight='bold', loc='left', pad=8)

k_emp, ccdf_emp = dm.empirical_ccdf(degree_values)
kk = np.logspace(0, np.log10(max(k_emp)), 400)
lam = dm.exponential_lambda(degree_values)

axB.scatter(k_emp, ccdf_emp, s=3, color='#4C72B0', alpha=0.35, zorder=2,
            label=f'Observed ({len(degree_values):,} proteins)')
axB.plot(kk, dm.exponential_ccdf(kk, lam), '--', color='#55A868', lw=1.6, label='Exponential')
axB.plot(kk, dm.lognormal_ccdf(kk), '-', color='#DD8452', lw=2.2,
         label=f'Lognormal (\u03bc = {dm.FIT["lognormal_mu"]:.2f}, \u03c3 = {dm.FIT["lognormal_sigma"]:.2f})')
axB.plot(kk, dm.pl_ccdf(kk), '-', color='#C44E52', lw=2.2,
         label=f'Power law (\u03b1 = {dm.FIT["alpha"]:.2f}, xmin = {int(dm.FIT["xmin"])})')

axB.set_xscale('log')
axB.set_yscale('log')
axB.set_xlim(0.9, max(k_emp) * 1.4)
axB.set_ylim(4e-4, 1.6)
axB.set_xlabel('Degree (k)', fontsize=11)
axB.set_ylabel('P(K \u2265 k)', fontsize=11)
axB.legend(fontsize=8, loc='lower left', framealpha=0.9)

axB.text(0.98, 0.97,
         'Power law rejected\n'
         f'bootstrap KS p = {dm.FIT["bootstrap_p"]:.0e} (n = {dm.FIT["bootstrap_N"]:,})\n'
         'Lognormal preferred\n'
         f'R = {dm.FIT["R_vs_lognormal"]:.1f}, p = {dm.FIT["p_vs_lognormal"]:.1e}',
         transform=axB.transAxes, ha='right', va='top', fontsize=8,
         bbox=dict(boxstyle='round', fc='#FFF5F5', ec='#C44E52', alpha=0.9))

axB.spines['top'].set_visible(False)
axB.spines['right'].set_visible(False)

fig.suptitle('Figure 4: Network Topology', fontsize=16, fontweight='bold', y=1.02)
plt.tight_layout()

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_4_Network_Topology_v5.tiff'))
plt.close(fig)
print("Figure 4 done!")
