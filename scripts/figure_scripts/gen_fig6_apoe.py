"""
Figure 6: Particle-Centric Query — APOE in 5 Particles
Shows APOE's multi-particle context with associated diseases, variants, and pathways.
Demonstrates the unique value of particle-level querying.
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *

setup_style()

fig, ax = plt.subplots(figsize=(16, 12))
ax.set_xlim(-8, 8)
ax.set_ylim(-7, 8)
ax.set_aspect('equal')
ax.axis('off')

# ── Title ──
ax.text(0, 7.5, 'Figure 6: Particle-Centric Query — APOE', ha='center', va='center',
        fontsize=18, fontweight='bold', color='#222')
ax.text(0, 7.0, 'Apolipoprotein E across 5 lipoprotein particles: context unavailable from protein-level data alone',
        ha='center', va='center', fontsize=10, color='#555')

# ── Central APOE node ──
apoe_box = FancyBboxPatch((-1.2, -0.5), 2.4, 1.0, boxstyle="round,pad=0.1",
                           facecolor='#DD8452', edgecolor='#222', linewidth=2.0, alpha=0.95,
                           zorder=10)
ax.add_patch(apoe_box)
ax.text(0, 0.15, 'APOE', ha='center', va='center', fontsize=16, fontweight='bold',
        color='white', zorder=11)
ax.text(0, -0.2, 'Apolipoprotein E', ha='center', va='center', fontsize=8,
        color='white', style='italic', zorder=11)

# ── Particle nodes (arranged in arc above APOE) ──
particles = [
    ('Chylomicron', -6.0, 4.5, 'APOE acquired from HDL;\nremnant clearance ligand'),
    ('VLDL',        -3.0, 5.5, 'Acquired from HDL;\nTG transport'),
    ('IDL',          0.0, 6.0, 'Essential for remnant\nclearance via LRP1/LDLR'),
    ('HDL',          3.0, 5.5, 'Source pool for TG-rich\nparticle acquisition'),
    ('Remnant',      6.0, 4.5, 'Critical for\nhepatic clearance'),
]

for name, px, py, note in particles:
    color = PARTICLE_COLORS[name]
    box = FancyBboxPatch((px-1.1, py-0.45), 2.2, 0.9, boxstyle="round,pad=0.08",
                          facecolor=color, edgecolor='#222', linewidth=1.2, alpha=0.9, zorder=8)
    ax.add_patch(box)
    ax.text(px, py+0.1, name, ha='center', va='center', fontsize=9, fontweight='bold',
            color='white', zorder=9)
    ax.text(px, py-0.2, 'exchangeable', ha='center', va='center', fontsize=6.5,
            color='white', style='italic', alpha=0.8, zorder=9)

    # Arrow from APOE to particle
    ax.annotate('', xy=(px, py-0.45), xytext=(0, 0.5),
                arrowprops=dict(arrowstyle='->', color=color, lw=1.5, alpha=0.7,
                                connectionstyle='arc3,rad=0.1'))
    # Note
    ax.text(px, py-0.9, note, ha='center', va='top', fontsize=6.5, color='#555',
            style='italic', bbox=dict(boxstyle='round,pad=0.15', fc='white', ec='none', alpha=0.7))

# ── Disease associations (left side) ──
ax.text(-6.5, 2.5, 'Disease Associations', ha='center', fontsize=11, fontweight='bold', color='#C44E52')
diseases = [
    'Familial Hypercholesterolemia',
    'Type III Hyperlipoproteinemia',
    'Familial Combined Hyperlipidemia',
    'ASCVD',
    'LDL cholesterol levels',
    'HDL cholesterol levels',
    'Triglyceride levels',
]
for i, d in enumerate(diseases):
    y = 1.8 - i * 0.45
    box = FancyBboxPatch((-7.8, y-0.15), 2.6, 0.3, boxstyle="round,pad=0.03",
                          facecolor='#FFEBEE', edgecolor='#C44E52', linewidth=0.5, alpha=0.85)
    ax.add_patch(box)
    ax.text(-6.5, y, d, ha='center', va='center', fontsize=6.5, color='#C44E52')
    # Connect to APOE
    ax.plot([-5.2, -1.2], [y, -0.1], '-', color='#C44E52', lw=0.3, alpha=0.4)

# ── ClinVar variants (right side) ──
ax.text(6.5, 2.5, 'ClinVar Variants', ha='center', fontsize=11, fontweight='bold', color='#8172B3')
ax.text(6.5, 2.0, '134 pathogenic / likely\npathogenic variants', ha='center',
        fontsize=8, color='#8172B3', style='italic')

# Show variant types as small dots
np.random.seed(42)
for i in range(30):
    angle = np.random.uniform(0, 2*np.pi)
    r = np.random.uniform(0.3, 1.2)
    vx = 6.5 + r * np.cos(angle)
    vy = 1.0 + r * np.sin(angle) * 0.7
    ax.plot(vx, vy, 'o', color='#8172B3', markersize=3, alpha=0.5)

ax.text(6.5, -0.3, 'Familial dysbetalipoproteinemia\nAlzheimer disease',
        ha='center', va='center', fontsize=7, color='#555', style='italic')

# ── Pathway memberships (bottom) ──
ax.text(0, -2.5, 'Pathway Memberships (7 pathways)', ha='center', fontsize=11,
        fontweight='bold', color='#DA8BC3')
pathways = [
    'Lipid and atherosclerosis (KEGG)',
    'Plasma lipoprotein assembly (Reactome)',
    'Chylomicron-mediated lipid transport',
    'HDL remodeling',
    'LDL clearance',
    'VLDL assembly',
    'TG-rich lipoprotein clearance',
]

for i, p in enumerate(pathways):
    col = i % 4
    row = i // 4
    px = -4.5 + col * 3.0
    py = -3.2 - row * 0.6
    box = FancyBboxPatch((px-1.3, py-0.2), 2.6, 0.4, boxstyle="round,pad=0.03",
                          facecolor='#FCE4EC', edgecolor='#DA8BC3', linewidth=0.5, alpha=0.85)
    ax.add_patch(box)
    ax.text(px, py, p, ha='center', va='center', fontsize=6.5, color='#880E4F')
    # Connect to APOE
    ax.plot([0, px], [-0.5, py+0.2], '-', color='#DA8BC3', lw=0.3, alpha=0.3)

# ── Key insight box ──
insight_box = FancyBboxPatch((-7.5, -5.8), 15, 1.2, boxstyle="round,pad=0.1",
                              facecolor='#FFF8E1', edgecolor='#F57F17', linewidth=1.5, alpha=0.95)
ax.add_patch(insight_box)
ax.text(0, -4.95, 'Key Insight: Particle-Centric Context', ha='center', fontsize=12,
        fontweight='bold', color='#E65100')
ax.text(0, -5.35,
        'APOE is "exchangeable" — it moves between particles. Its functional role differs dramatically:\n'
        'in HDL it serves as a source pool; in VLDL/IDL/Remnant it mediates receptor clearance.\n'
        'This biological nuance is only queryable through particle-level relationships in LipoKG.',
        ha='center', va='center', fontsize=8.5, color='#333')

# ── Receptors (bottom-right) ──
ax.text(5.5, -1.5, 'Clearance Receptors', ha='center', fontsize=9, fontweight='bold', color='#4C72B0')
for i, (r, note) in enumerate([('LDLR', 'APOE-mediated'), ('LRP1', 'APOE-mediated')]):
    ry = -2.0 - i * 0.6
    box = FancyBboxPatch((4.5, ry-0.2), 2.0, 0.4, boxstyle="round,pad=0.03",
                          facecolor='#E3F2FD', edgecolor='#4C72B0', linewidth=0.6, alpha=0.85)
    ax.add_patch(box)
    ax.text(5.5, ry, f'{r} ({note})', ha='center', va='center', fontsize=7, color='#1565C0')

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_6_APOE_Particle_Query_v5.tiff'))
plt.close(fig)
print("Figure 6 done!")
