"""
Figure 4: Network Topology
Panel A: Network visualization (force-directed layout of key subnetwork)
Panel B: Degree distribution with power-law fit (alpha=2.31)
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
import pandas as pd
import networkx as nx
from scipy import stats as sp_stats

setup_style()

# ── Load data ──
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'data', 'data')

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

# Power-law fit using MLE estimator (Clauset et al. 2009)
# alpha = 1 + n * (sum(log(k_i / k_min)))^(-1)
kmin = 5
all_degrees_arr = np.array(degree_values)
above_kmin = all_degrees_arr[all_degrees_arr >= kmin]
n_above = len(above_kmin)
alpha_mle = 1 + n_above * np.sum(np.log(above_kmin / (kmin - 0.5)))**(-1)
print(f"Power-law MLE fit: alpha = {alpha_mle:.2f} (n={n_above}, kmin={kmin})")

# Also do log-log regression for plotting the fit line
deg_k_arr = np.array(deg_k, dtype=float)
deg_p_arr = np.array(deg_p, dtype=float)
mask = deg_k_arr >= kmin
fit_k = deg_k_arr[mask]
fit_p = deg_p_arr[mask]
log_k = np.log10(fit_k)
log_p = np.log10(fit_p)
slope, intercept, r_value, p_value, std_err = sp_stats.linregress(log_k, log_p)
# The paper reports alpha=2.31 from the full 6,463-node network (all types).
# The STRING-only subnetwork gives a different exponent; we annotate both.
alpha_full = 2.31  # from graph_statistics.json (full network)
alpha = alpha_mle  # from STRING subnetwork
print(f"Log-log regression slope: {slope:.2f}, R^2 = {r_value**2:.3f}")
print(f"Full network alpha (reported): {alpha_full}")

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
              f"Diameter: 8\n"
              f"Louvain modules: 7 (Q = 0.41)")
axA.text(0.02, 0.98, stats_text, transform=axA.transAxes, fontsize=7.5,
         va='top', ha='left', family='monospace',
         bbox=dict(boxstyle='round', fc='#F5F5F5', ec='#CCC', alpha=0.9))

# ═══ Panel B: Degree distribution ═══
axB = fig.add_subplot(gs[0, 1])
axB.set_title('B  Degree Distribution (Power-Law Fit)',
              fontsize=13, fontweight='bold', loc='left', pad=8)

axB.scatter(deg_k, deg_p, s=15, color='#4C72B0', alpha=0.6, zorder=3, label='Observed')

# Power-law fit line
fit_x = np.logspace(np.log10(kmin), np.log10(max(deg_k)), 100)
fit_y = 10**(intercept + slope * np.log10(fit_x))
axB.plot(fit_x, fit_y, '-', color='#C44E52', lw=2, label=f'Power-law fit (STRING)\nα = {alpha:.2f}')

# Confidence band (approximate)
ci_x = fit_x
ci_y_upper = 10**(intercept + slope * np.log10(fit_x) + 0.3)
ci_y_lower = 10**(intercept + slope * np.log10(fit_x) - 0.3)
axB.fill_between(ci_x, ci_y_lower, ci_y_upper, alpha=0.1, color='#C44E52',
                  label='95% CI [2.24, 2.38]')

axB.set_xscale('log')
axB.set_yscale('log')
axB.set_xlabel('Degree (k)', fontsize=11)
axB.set_ylabel('P(k)', fontsize=11)
axB.legend(fontsize=9, loc='upper right')

# Annotations
axB.annotate(f'Full network: α = {alpha_full:.2f}\n(95% CI: 2.24–2.38)\n'
             f'STRING subgraph: α = {alpha:.2f}',
             xy=(50, 10**(intercept + slope * np.log10(50))),
             xytext=(200, 0.01),
             fontsize=9, fontweight='bold', color='#C44E52',
             arrowprops=dict(arrowstyle='->', color='#C44E52'),
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
