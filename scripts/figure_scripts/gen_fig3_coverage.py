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
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7),
                                gridspec_kw={'width_ratios': [2.5, 1]})

# ═══════════════════════════════════════════════════════
# PANEL A: Validation benchmarks (horizontal bar chart)
# ═══════════════════════════════════════════════════════
benchmarks = [
    ('Expert 54-gene set',      54,  54,  '#2E7D32'),
    ('ClinGen dosage genes',    25,  25,  '#2E7D32'),
    ('GO lipoprotein process', 132, 143,  '#1565C0'),
    ('Reactome pathways',       50,  55,  '#1565C0'),
    ('KEGG hsa04979',          119, 133,  '#1565C0'),
    ('WikiPathways lipid',      71,  81,  '#1565C0'),
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
# Group by coverage tier
high = 4    # >= 90%
med = 2     # 80-90%
low = 1     # < 80%
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
ax2.text(0, 0, f'7\nBenchmarks', ha='center', va='center',
         fontsize=14, fontweight='bold', color='#333')
ax2.text(0, -0.25, f'Overall: 89.3%', ha='center', va='center',
         fontsize=10, color='#555')
ax2.set_title('B  Coverage Tier Summary', fontsize=14, fontweight='bold',
              loc='left', pad=10)

fig.suptitle('Figure 3: Coverage and Validation Analysis', fontsize=16,
             fontweight='bold', y=1.02)
plt.tight_layout()

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_3_Coverage_Analysis_v5.tiff'))
plt.close(fig)
print("Figure 3 done!")