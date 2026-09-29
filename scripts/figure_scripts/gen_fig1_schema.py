"""
Figure 1: LipoKG Schema Diagram
7 core node types, 7 core relationship types (particles as first-class entities)
Publication quality for Scientific Data.
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *

setup_style()

fig, ax = plt.subplots(figsize=(14, 10))
ax.set_xlim(-7, 7)
ax.set_ylim(-5.5, 6)
ax.set_aspect('equal')
ax.axis('off')
ax.set_facecolor('white')

# ── Node positions (hand-tuned for visual balance) ──
positions = {
    'Particle':       (0, 0.5),
    'STRINGProtein':  (0, 3.5),
    'Molecule':       (-4.5, 2.0),
    'Disease':        (4.5, 2.0),
    'ClinVarVariant': (4.5, -2.5),
    'KEGGGene':       (0, -3.0),
    'Pathway':        (-4.5, -2.5),
}

# ── Node shapes & sizes ──
node_box_w = {
    'Particle': 2.4, 'STRINGProtein': 2.6, 'Molecule': 2.0,
    'Disease': 2.0, 'ClinVarVariant': 2.6, 'KEGGGene': 2.0, 'Pathway': 2.0,
}
node_box_h = 1.1

# Draw node boxes
for ntype, (cx, cy) in positions.items():
    color = NODE_COLORS[ntype]
    w = node_box_w[ntype]
    box = FancyBboxPatch(
        (cx - w/2, cy - node_box_h/2), w, node_box_h,
        boxstyle="round,pad=0.08",
        facecolor=color, edgecolor='#222222', linewidth=1.2, alpha=0.92
    )
    ax.add_patch(box)
    # Label
    label = NODE_LABELS[ntype]
    count = NODE_COUNTS[ntype]
    ax.text(cx, cy + 0.12, label, ha='center', va='center',
            fontsize=11, fontweight='bold', color='white',
            path_effects=[path_effects.withStroke(linewidth=2, foreground=color)])
    ax.text(cx, cy - 0.22, f"n = {count:,}", ha='center', va='center',
            fontsize=9, color='white', style='italic',
            path_effects=[path_effects.withStroke(linewidth=2, foreground=color)])

# ── Relationship edges (arrows with labels) ──
relationships = [
    # (from_type, to_type, rel_name, edge_count, curve)
    ('STRINGProtein', 'Particle',       'COMPONENT_OF',        48,    0.0),
    ('Molecule',      'Particle',       'MODIFIES',            23,    0.0),
    ('Particle',      'Molecule',       'ASSEMBLED_BY',         8,    0.3),
    ('STRINGProtein', 'STRINGProtein',  'STRING_INTERACTS', 31878,    0.0),  # self-loop
    ('STRINGProtein', 'Disease',        'DISEASE_ASSOCIATION', 238,   0.0),
    ('ClinVarVariant','KEGGGene',       'VARIANT_OF',        4042,    0.0),
    ('STRINGProtein', 'Pathway',        'MEMBER_OF',          242,    0.0),
]

def draw_edge(ax, p1, p2, label, count, color, curve=0.0, self_loop=False):
    """Draw a labeled arrow between two node positions."""
    x1, y1 = p1
    x2, y2 = p2

    if self_loop:
        # Self-loop: arc above the node — lowered to avoid overlapping title
        arc_pts_x = [x1 - 0.8, x1 - 1.5, x1, x1 + 1.5, x1 + 0.8]
        arc_pts_y = [y1 + 0.55, y1 + 0.9, y1 + 1.1, y1 + 0.9, y1 + 0.55]
        for i in range(len(arc_pts_x)-1):
            ax.annotate('', xy=(arc_pts_x[i+1], arc_pts_y[i+1]),
                        xytext=(arc_pts_x[i], arc_pts_y[i]),
                        arrowprops=dict(arrowstyle='->' if i == len(arc_pts_x)-2 else '-',
                                        color=color, lw=1.8,
                                        connectionstyle='arc3,rad=0.0'))
        # Label — lowered accordingly
        ax.text(x1, y1 + 1.35, label, ha='center', va='bottom',
                fontsize=8, fontweight='bold', color=color)
        ax.text(x1, y1 + 1.05, f"n = {count:,}", ha='center', va='bottom',
                fontsize=7, color=color, style='italic')
        return

    # Compute arrow endpoints (stop at box edge)
    dx = x2 - x1
    dy = y2 - y1
    dist = np.sqrt(dx**2 + dy**2)
    # shorten by ~half box width
    shrink = 0.65 / dist
    sx1 = x1 + dx * shrink
    sy1 = y1 + dy * shrink
    sx2 = x2 - dx * shrink
    sy2 = y2 - dy * shrink

    rad = curve
    ax.annotate('', xy=(sx2, sy2), xytext=(sx1, sy1),
                arrowprops=dict(arrowstyle='->', color=color, lw=1.8,
                                connectionstyle=f'arc3,rad={rad}',
                                shrinkA=2, shrinkB=2))

    # Label at midpoint
    mx = (sx1 + sx2) / 2
    my = (sy1 + sy2) / 2
    # Offset perpendicular to edge for readability
    if abs(dx) > abs(dy):
        offset_y = 0.25
        offset_x = 0
    else:
        offset_y = 0
        offset_x = 0.25

    ax.text(mx + offset_x, my + offset_y, label, ha='center', va='center',
            fontsize=8, fontweight='bold', color=color,
            bbox=dict(boxstyle='round,pad=0.15', fc='white', ec='none', alpha=0.85))
    ax.text(mx + offset_x, my + offset_y - 0.22, f"n = {count:,}", ha='center', va='center',
            fontsize=7, color=color, style='italic',
            bbox=dict(boxstyle='round,pad=0.1', fc='white', ec='none', alpha=0.85))

# Draw all relationships
for from_t, to_t, rel_name, count, curve in relationships:
    p1 = positions[from_t]
    p2 = positions[to_t]
    color = REL_COLORS[rel_name]
    self_loop = (from_t == to_t)
    draw_edge(ax, p1, p2, rel_name, count, color, curve, self_loop)

# ── Title and summary box ──
ax.text(0, 5.6, "LipoKG Core Schema", ha='center', va='center',
        fontsize=18, fontweight='bold', color='#222222')
ax.text(0, 5.2, "7 Node Types  ·  7 Relationship Types  ·  6,052 Nodes  ·  36,479 Edges",
        ha='center', va='center', fontsize=10, color='#555555')

# ── Legend: Particles as first-class entities ──
legend_box = FancyBboxPatch(
    (-6.8, -5.3), 4.2, 1.2,
    boxstyle="round,pad=0.1",
    facecolor='#FFF8E7', edgecolor='#DD8452', linewidth=0.8, alpha=0.9
)
ax.add_patch(legend_box)
ax.text(-4.7, -4.45, "Particles as First-Class Entities", fontsize=9,
        fontweight='bold', color='#DD8452', ha='center')
ax.text(-4.7, -4.8, "Chylomicron · VLDL · IDL · LDL · HDL · Lp(a) · Remnant",
        fontsize=7.5, color='#555555', ha='center')

# Extended schema note
ext_box = FancyBboxPatch(
    (2.8, -5.3), 4.0, 1.2,
    boxstyle="round,pad=0.1",
    facecolor='#F0F4FF', edgecolor='#4C72B0', linewidth=0.8, alpha=0.9
)
ax.add_patch(ext_box)
ax.text(4.8, -4.45, "Extended Schema (Neo4j)", fontsize=9,
        fontweight='bold', color='#4C72B0', ha='center')
ax.text(4.8, -4.8, "31 node types · 25 relationship types",
        fontsize=7.5, color='#555555', ha='center')
ax.text(4.8, -5.05, f"Total: {TOTAL_NODES:,} nodes · {TOTAL_EDGES:,} edges",
        fontsize=7.5, color='#555555', ha='center')

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_1_Schema_Diagram_v5.tiff'))
plt.close(fig)
print("Figure 1 done!")
