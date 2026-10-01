"""
Figure 2: Data Integration and Seed Gene Selection
Panel A: PRISMA-style seed gene selection   ← v6 起为 A（正文先引它）
Panel B: Multi-source data integration flowchart
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
setup_style()
# v6: 轴对象与位置对调 —— 左=PRISMA(axB), 右=整合流程(axA)；字母随内容走
fig, (axB, axA) = plt.subplots(1, 2, figsize=(18, 8))
for ax in (axA, axB):
    ax.set_xlim(-6, 6)
    ax.set_ylim(-6, 7.5)            # ← 增加顶部空间，避免A/B与图题重叠
    ax.set_aspect('equal')
    ax.axis('off')

# ─── Helper functions ───
def draw_box(ax, x, y, w, h, text, fc='#E8F0FE', ec='#4C72B0', fontsize=9, bold=True, subtext=None):
    box = FancyBboxPatch((x-w/2, y-h/2), w, h, boxstyle="round,pad=0.08",
                         facecolor=fc, edgecolor=ec, linewidth=1.0, alpha=0.95)
    ax.add_patch(box)
    if subtext:
        ax.text(x, y+0.12, text, ha='center', va='center', fontsize=fontsize,
                fontweight='bold' if bold else 'normal', color='#222')
        ax.text(x, y-0.18, subtext, ha='center', va='center', fontsize=fontsize-1.5,
                color='#666', style='italic')
    else:
        ax.text(x, y, text, ha='center', va='center', fontsize=fontsize,
                fontweight='bold' if bold else 'normal', color='#222')

def draw_arrow(ax, x1, y1, x2, y2, color='#888', lw=1.2):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', color=color, lw=lw))

# ═══════════════════════════════════════════════════════
# PANEL A: Data Integration Pipeline
# ═══════════════════════════════════════════════════════
axA.text(0, 7.0, 'B', fontsize=18, fontweight='bold', ha='left', va='top', color='#222')   # ← v6: 内容仍在 axA，但位置在右、字母改为 B

# --- Layer 1: Data Sources ---
axA.text(0, 6.0, 'Data Sources', ha='center', fontsize=12, fontweight='bold', color='#4C72B0')
sources = [
    ('STRING\nv12.0', -4.5), (f'KEGG\n{KEGG_PATHWAY_ID}', -2.7), ('Reactome\n2026-06', -0.9),
    ('UniProt\n2026-06', 0.9), ('ClinVar\n2026-06', 2.7), ('OMIM /\nDrugBank', 4.5)
]
for name, x in sources:
    draw_box(axA, x, 5.0, 1.6, 0.75, name, fc='#FFF3E0', ec='#E65100', fontsize=7.5)
# Arrows down to processing
for name, x in sources:
    draw_arrow(axA, x, 4.6, x, 3.7, color='#E65100', lw=0.8)

# --- Layer 2: Processing ---
axA.text(0, 4.0, 'Processing Pipeline', ha='center', fontsize=12, fontweight='bold', color='#2E7D32')
procs = [
    ('ETL\nExtract-Transform-Load', -3.5, '#C8E6C9'),
    ('Entity Resolution\nHGNC / UniProt mapping', 0, '#C8E6C9'),
    ('Cross-referencing\nEnsembl ↔ KEGG ↔ ClinVar', 3.5, '#C8E6C9'),
]
for text, x, fc in procs:
    draw_box(axA, x, 3.0, 3.2, 0.9, text, fc=fc, ec='#2E7D32', fontsize=8)   # ← w=2.8→3.2
# Converge arrows
for text, x, fc in procs:
    draw_arrow(axA, x, 2.5, 0, 1.7, color='#2E7D32', lw=1.0)

# --- Layer 3: Particle Layer (NEW in V5) ---
draw_box(axA, 0, 1.2, 4.0, 0.8,
         'Particle-Centric Integration (V5)',
         fc='#FFF8E1', ec='#F57F17', fontsize=9,
         subtext='7 lipoprotein particles as first-class entities')
draw_arrow(axA, 0, 0.8, 0, 0.1, color='#F57F17', lw=1.5)

# --- Layer 4: Disease Layer ---
draw_box(axA, 0, -0.4, 4.0, 0.8,
         'Multi-Source Disease Layer',
         fc='#FFEBEE', ec='#C62828', fontsize=9,
         subtext='OMIM + ClinVar + GWAS + DrugBank (27 diseases)')
draw_arrow(axA, 0, -0.8, 0, -1.5, color='#C62828', lw=1.5)

# --- Layer 5: Final KG ---
draw_box(axA, 0, -2.2, 5.0, 1.2,
         'LipoKG Knowledge Graph',
         fc='#E3F2FD', ec='#1565C0', fontsize=11, bold=True,
         subtext=f'{TOTAL_CORE_NODES:,} core nodes · {TOTAL_CORE_EDGES:,} core edges · 7+7 schema')
draw_arrow(axA, 0, -2.8, -2.5, -3.7, color='#1565C0', lw=1.2)
draw_arrow(axA, 0, -2.8, 2.5, -3.7, color='#1565C0', lw=1.2)

# --- Layer 6: Outputs ---
draw_box(axA, -2.5, -4.3, 3.5, 0.9,
         'Core CSV Package\n(Zenodo)', fc='#E8EAF6', ec='#283593', fontsize=8)
draw_box(axA, 2.5, -4.3, 3.5, 0.9,
         f'Extended Neo4j Dump\n({EXT_NODE_TYPES} node / {EXT_REL_TYPES} rel types)', fc='#E8EAF6', ec='#283593', fontsize=8)

# ═══════════════════════════════════════════════════════
# PANEL B: PRISMA-style Seed Gene Selection
# ═══════════════════════════════════════════════════════
axB.text(0, 7.0, 'A', fontsize=18, fontweight='bold', ha='left', va='top', color='#222')   # ← v6: 内容仍在 axB，但位置在左、字母改为 A
axB.text(0, 6.0, 'Seed Gene Selection (PRISMA-style)', ha='center',
         fontsize=12, fontweight='bold', color='#4C72B0')

# PRISMA flow — boxes widened from 4.5→5.2, first text split into 3 lines
# ⚠️ 2026-10-01 重建：原漏斗（487 → 312 → 197 → 130 …）与正文 L73 / 图注**是两套数字**，
#    而正文那套的终点 82 与沉积的 Table_S1（82 行种子）自洽 ⇒ 以正文/沉积为准重建。
#    七级：文献 156 → 通路库 134 → ClinVar 98 → 交集 67 → 专家 +15 → 种子 82 → 1-hop 扩张 1,852。
prisma = [
    (0, 5.0, 5.2, 0.7,
     'Literature review\n(lipoprotein / lipid metabolism)',
     '#E3F2FD', '#1565C0', 'n = 156 candidate genes'),
    (0, 3.6, 5.2, 0.7,
     'Present in a pathway database\n(KEGG / Reactome / WikiPathways)',
     '#FFF3E0', '#E65100', 'n = 134'),
    (0, 2.2, 5.2, 0.7,
     'ClinVar variant evidence\n(pathogenic / likely pathogenic)',
     '#E8F5E9', '#2E7D32', 'n = 98'),
    (0, 0.8, 5.2, 0.7,
     'Intersection of the three criteria',
     '#FFF3E0', '#E65100', 'n = 67'),
    (0, -0.6, 5.2, 0.7,
     'Expert additions\n(clinical reviews, ESC/EAS guidelines)',
     '#E8F5E9', '#2E7D32', '+ 15 genes'),
    (0, -2.0, 5.2, 0.8,
     'Final curated seed set\n82 genes',
     '#E3F2FD', '#1565C0', 'Supplementary Table S1'),
    (0, -3.4, 5.2, 1.0,
     '1-hop STRING expansion\n(combined score \u2265 700)',
     '#F3E5F5', '#6A1B9A',
     f'{NODE_COUNTS["STRINGProtein"]:,} proteins \u00b7 {REL_COUNTS["STRING_INTERACTS"]:,} interactions'),
]
for i, (x, y, w, h, text, fc, ec, sub) in enumerate(prisma):
    draw_box(axB, x, y, w, h, text, fc=fc, ec=ec, fontsize=8.5, subtext=sub)
    if i < len(prisma) - 1:
        next_y = prisma[i+1][1]
        draw_arrow(axB, x, y - h/2, x, next_y + prisma[i+1][3]/2, color='#888', lw=1.2)

# Side exclusion boxes —— 三级筛除的下降量（156→134→98→67）
_side = [
    (3.05, 3.45, 'Excluded: n = 22\n(no pathway membership)', 3.6),
    (1.65, 2.05, 'Excluded: n = 36\n(no ClinVar evidence)', 2.2),
    (0.25, 0.65, 'Excluded: n = 31\n(failed intersection)', 0.8),
]
for _cy, _arrow_y, _label, _from_y in _side:
    axB.add_patch(FancyBboxPatch((3.4, _cy), 2.6, 0.5, boxstyle="round,pad=0.05",
                                 facecolor='#FFCDD2', edgecolor='#C62828', linewidth=0.6, alpha=0.8))
    axB.text(4.7, _cy + 0.25, _label, ha='center', va='center',
             fontsize=7, color='#C62828')
    draw_arrow(axB, 2.6, _from_y, 3.4, _cy + 0.25, color='#C62828', lw=0.8)

# Figure title
fig.suptitle('Figure 2: Data Integration and Seed Gene Selection', fontsize=16, fontweight='bold', y=0.98)
plt.tight_layout(rect=[0, 0, 1, 0.96])

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_2_Integration_Pipeline_v6.tiff'))
plt.close(fig)
print("Figure 2 done!")