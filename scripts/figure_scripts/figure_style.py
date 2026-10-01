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
# CORE DATA VALUES —— **从沉积数据实算**（2026-10-01 改造）
#
#   这里原本是手写常量，每次改数据都得记得手改；实测已因此漏改 8 处，
#   把旧数字（MEMBER_OF 242、6,054 Nodes、31 node types …）印进了
#   Figure 1 与 Figure 2 的图面，而稿件和数据都是对的 —— 错的只有图。
#   现在一律读 `data/graph_statistics.json`，任何口径变更都不再需要动这个文件。
#
#   键顺序沿用 NODE_COLORS / REL_COLORS，保证图例与配色一一对应。
# ============================================================
import json as _json
import csv as _csv


def load_graph_statistics():
    with open(os.path.join(resolve_data_dir(), 'graph_statistics.json'), encoding='utf-8') as f:
        return _json.load(f)


GS = load_graph_statistics()
_CORE = GS['core_schema']
_EXT = GS['extended_schema']

NODE_COUNTS = {k: _CORE['node_types'][k] for k in NODE_COLORS}
REL_COUNTS = {k: _CORE['relationship_types'][k] for k in REL_COLORS}

TOTAL_CORE_NODES = _CORE['total_core_nodes']
TOTAL_CORE_EDGES = _CORE['total_core_edges']

# 全图规模 = 全部核心类型 + 全部扩展类型之和。
#   ⚠️ 旧值是 Neo4j `MATCH (n) RETURN count(n)` / `count(r)` 的实测数，与「扩展类型之和」
#      对不上（实测差 −4,320 条边），且改 core 时不会自动跟 ⇒ 已改为可复算的口径。
TOTAL_NODES = TOTAL_CORE_NODES + sum(_EXT['node_types_additional'].values())
TOTAL_EDGES = TOTAL_CORE_EDGES + sum(_EXT['relationship_types_additional'].values())
EXT_NODE_TYPES = GS['node_type_count']
EXT_REL_TYPES = GS['edge_type_count']


def load_kegg_pathway():
    """返回 (pathway_id, name) —— 取 pathways.csv 里唯一的 KEGG 行。"""
    with open(os.path.join(resolve_data_dir(), 'pathways.csv'), encoding='utf-8-sig') as f:
        for r in _csv.DictReader(f):
            if (r.get('source') or '').strip() == 'KEGG':
                return r.get('pathway_id', ''), r.get('name', '')
    return '', ''


KEGG_PATHWAY_ID, KEGG_PATHWAY_NAME = load_kegg_pathway()


def load_clinvar_gene_count():
    """ClinVar 变异所覆盖的基因数（从沉积的 clinvar_relationships.csv 实算）。"""
    with open(os.path.join(resolve_data_dir(), 'clinvar_relationships.csv'),
              encoding='utf-8-sig') as f:
        return len({r['gene'] for r in _csv.DictReader(f)})


CLINVAR_GENES = load_clinvar_gene_count()


def load_coverage_table():
    """读 Table_S2_Coverage_Analysis.csv，返回 {Database: {字段: 值}}。"""
    p = os.path.join(resolve_supp_dir(), 'Table_S2_Coverage_Analysis.csv')
    with open(p, encoding='utf-8-sig') as f:
        return {r['Database']: r for r in _csv.DictReader(f)}

# Validation benchmarks
VALIDATION = {
    'KEGG hsa05417':          {'pct': 72.7, 'num': 157, 'den': 216},
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
