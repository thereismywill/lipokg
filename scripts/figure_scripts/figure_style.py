"""
Shared style module for LipoKG paper figures.
Target: Scientific Data (Nature Portfolio) publication quality.
"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import matplotlib.patheffects as path_effects
import numpy as np

# ============================================================
# PUBLICATION SETTINGS
# ============================================================
DPI = 300
FONT_FAMILY = 'Arial'
BG_COLOR = '#FFFFFF'

# Font sizes
TITLE_SIZE = 16
SUBTITLE_SIZE = 13
LABEL_SIZE = 11
TICK_SIZE = 9
LEGEND_SIZE = 9
ANNOTATION_SIZE = 8

def setup_style():
    """Apply Scientific Data style globally."""
    plt.rcParams.update({
        'font.family': 'sans-serif',
        'font.sans-serif': [FONT_FAMILY, 'Helvetica', 'DejaVu Sans'],
        'font.size': LABEL_SIZE,
        'axes.titlesize': TITLE_SIZE,
        'axes.labelsize': LABEL_SIZE,
        'xtick.labelsize': TICK_SIZE,
        'ytick.labelsize': TICK_SIZE,
        'legend.fontsize': LEGEND_SIZE,
        'figure.facecolor': BG_COLOR,
        'axes.facecolor': BG_COLOR,
        'axes.edgecolor': '#333333',
        'axes.linewidth': 0.8,
        'xtick.major.width': 0.6,
        'ytick.major.width': 0.6,
        'lines.linewidth': 1.5,
        'savefig.dpi': DPI,
        'savefig.bbox': 'tight',
        'savefig.pad_inches': 0.1,
        'figure.dpi': DPI,
    })

# ============================================================
# NODE TYPE COLORS (consistent across all figures)
# ============================================================
NODE_COLORS = {
    'STRINGProtein':  '#4C72B0',   # steel blue
    'Particle':       '#DD8452',   # orange
    'Molecule':       '#55A868',   # green
    'Disease':        '#C44E52',   # red
    'ClinVarVariant': '#8172B3',   # purple
    'KEGGGene':       '#937860',   # brown
    'Pathway':        '#DA8BC3',   # pink
}

# Short display labels
NODE_LABELS = {
    'STRINGProtein':  'STRING Protein',
    'Particle':       'Particle',
    'Molecule':       'Molecule',
    'Disease':        'Disease',
    'ClinVarVariant': 'ClinVar Variant',
    'KEGGGene':       'KEGG Gene',
    'Pathway':        'Pathway',
}

# ============================================================
# RELATIONSHIP COLORS
# ============================================================
REL_COLORS = {
    'STRING_INTERACTS':    '#4C72B0',
    'COMPONENT_OF':        '#DD8452',
    'MODIFIES':            '#55A868',
    'ASSEMBLED_BY':        '#937860',
    'DISEASE_ASSOCIATION': '#C44E52',
    'VARIANT_OF':          '#8172B3',
    'MEMBER_OF':           '#DA8BC3',
}

# ============================================================
# PARTICLE COLORS (for particle-centric views)
# ============================================================
PARTICLE_COLORS = {
    'Chylomicron': '#E63946',
    'VLDL':        '#F4A261',
    'IDL':         '#E9C46A',
    'LDL':         '#2A9D8F',
    'HDL':         '#264653',
    'Lp(a)':       '#7B2D8B',
    'Remnant':     '#8D6E63',
}

# ============================================================
# CORE DATA VALUES (from V5 / graph_statistics.json)
# ============================================================
NODE_COUNTS = {
    'STRINGProtein':  1852,
    'Particle':       7,
    'Molecule':       57,
    'Disease':        27,
    'ClinVarVariant': 4042,
    'KEGGGene':       52,
    'Pathway':        15,
}

REL_COUNTS = {
    'STRING_INTERACTS':    31878,
    'COMPONENT_OF':        48,
    'MODIFIES':            23,
    'ASSEMBLED_BY':        8,
    'DISEASE_ASSOCIATION': 238,
    'VARIANT_OF':          4042,
    'MEMBER_OF':           242,
}

TOTAL_CORE_NODES = 6052
TOTAL_CORE_EDGES = 36479
TOTAL_NODES = 6463
TOTAL_EDGES = 37165

# Validation benchmarks
VALIDATION = {
    'KEGG hsa04979':          {'pct': 89.5, 'num': 119, 'den': 133},
    'Reactome pathways':      {'pct': 90.9, 'num': 50,  'den': 55},
    'WikiPathways lipid':     {'pct': 87.7, 'num': 71,  'den': 81},
    'GO lipoprotein process': {'pct': 92.3, 'num': 132, 'den': 143},
    'GLGC 2021 GWAS loci':   {'pct': 64.9, 'num': 244, 'den': 376},
    'ClinGen dosage genes':   {'pct': 100,  'num': 25,  'den': 25},
    'Expert 54-gene set':     {'pct': 100,  'num': 54,  'den': 54},
}

# Network topology
TOPOLOGY = {
    'connected_components': 1,
    'average_degree': 34.4,
    'diameter': 8,
    'power_law_alpha': 2.31,
    'power_law_95CI': (2.24, 2.38),
    'louvain_modularity': 0.41,
    'louvain_modules': 7,
}

def save_fig(fig, path):
    """Save figure with publication settings."""
    fig.savefig(path, dpi=DPI, bbox_inches='tight',
                facecolor='white', edgecolor='none', pad_inches=0.1,
                pil_kwargs={'compression': 'tiff_lzw'})
    print(f"Saved: {path}")
