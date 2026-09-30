"""
Shared style module for LipoKG paper figures.
Target: Scientific Data (Nature Portfolio) publication quality.
"""
import os
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
# ============================================================
# 目录布局自适应（2026-09-30）
#   同一份脚本要在两种布局下都能跑：
#     ① 代码仓库布局   <root>/data/*.csv
#     ② 稿件工程布局   <root>/data/data/*.csv  (+ data/zenodo_package*/data/*.csv)
#   实测事故：仓库布局下 gen_fig4 / gen_supp_figures / gen_fig5 因写死
#   `../../data/data/...` 直接 FileNotFoundError —— 审稿人克隆仓库后**跑不出图**，
#   而 GigaScience 的选文标准正是 reproducibility。
# ============================================================
_HERE = os.path.dirname(os.path.abspath(__file__))
_ROOT = os.path.dirname(os.path.dirname(_HERE))

def _first_existing(paths):
    for p in paths:
        if os.path.exists(p):
            return p
    return None

def resolve_data_dir(probe='string_proteins.csv'):
    """返回含 probe 文件的数据目录（两种布局都能找到）。"""
    cands = [os.path.join(_ROOT, 'data'),
             os.path.join(_ROOT, 'data', 'data'),
             os.path.join(_ROOT, 'data', 'zenodo_package_v1.2.0', 'data'),
             os.path.join(_ROOT, 'data', 'zenodo_package', 'data')]
    hit = _first_existing([os.path.join(c, probe) for c in cands])
    if hit is None:
        raise FileNotFoundError(
            f'找不到数据文件 {probe}；已查找：' + ', '.join(cands))
    return os.path.dirname(hit)

def resolve_supp_dir():
    """补充表目录；两种布局下都在 <root>/supplementary。"""
    for c in (os.path.join(_ROOT, 'supplementary'),
              os.path.join(_ROOT, 'data', 'supplementary')):
        if os.path.isdir(c):
            return c
    raise FileNotFoundError(
        '找不到 supplementary/ 目录（图脚本需要其中的 Table_S18/S19/S20/S22 等输入表）')

def resolve_out_dir():
    d = os.path.join(_ROOT, 'figures', 'generated')
    os.makedirs(d, exist_ok=True)
    return d

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
    'Pathway':        13,
}

REL_COUNTS = {
    'STRING_INTERACTS':    31878,
    'COMPONENT_OF':        48,
    'MODIFIES':            23,
    'ASSEMBLED_BY':        8,
    'DISEASE_ASSOCIATION': 238,
    'VARIANT_OF':          4042,
    'MEMBER_OF':           167,
}

TOTAL_CORE_NODES = 6050
TOTAL_CORE_EDGES = 36404
TOTAL_NODES = 6475
TOTAL_EDGES = 37177

# Validation benchmarks
VALIDATION = {
    'KEGG hsa04979':          {'pct': 88.5, 'num': 46,  'den': 52},
    'Reactome pathways':      {'pct': 85.9, 'num': 61,  'den': 71},
    'WikiPathways lipid':     {'pct': 79.3, 'num': 73,  'den': 92},
    'GO lipoprotein process': {'pct': 92.3, 'num': 132, 'den': 143},
    'GLGC 2021 GWAS loci':   {'pct': 64.9, 'num': 244, 'den': 376},
    'ClinGen dosage genes':   {'pct': 100,  'num': 25,  'den': 25},
    'Expert 54-gene set':     {'pct': 100,  'num': 54,  'den': 54},
}

# Network topology
TOPOLOGY = {
    'connected_components': 1,
    'average_degree': 34.4,
    'diameter': 7,
    'power_law_alpha': 2.65,
    'power_law_95CI': (2.52, 2.78),
    'power_law_xmin': 34,
    'louvain_modularity': 0.51,
    'louvain_modules': 9,
}

def save_fig(fig, path):
    """Save figure with publication settings."""
    fig.savefig(path, dpi=DPI, bbox_inches='tight',
                facecolor='white', edgecolor='none', pad_inches=0.1,
                pil_kwargs={'compression': 'tiff_lzw'})
    print(f"Saved: {path}")
