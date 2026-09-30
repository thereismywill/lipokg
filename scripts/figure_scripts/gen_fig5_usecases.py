"""
Figure 5: Use Case Examples (5 panels A-E)
A: Knowledge Gap Discovery (gap score vs publications)
B: Drug Target Prioritization (rediscovery test)
C: Precision Medicine (ClinVar variant distribution)
D: Therapeutic Target Comparison (concordance)
E: Drug Repurposing (pathway coverage vs drug coverage)
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from figure_style import *
import pandas as pd
setup_style()
SUPP_DIR = resolve_supp_dir()
DATA_DIR = resolve_data_dir()

# Load data
gap_df = pd.read_csv(os.path.join(SUPP_DIR, 'Table_S18_Gap_Score_Validation.csv'))
drug_df = pd.read_csv(os.path.join(SUPP_DIR, 'Table_S19_Rediscovery_Test.csv'))
# Panel C 的基因级变异分布**直接从沉积数据算**，不再依赖 Supplementary Table S5。
# 2026-09-30 实测：原实现读的 Table_S5 是手打旧清单 —— 48 基因、47/48 行计数与沉积不符
# （LDLR 写 1,847 而实际 2,267），且含 14 个沉积里根本不存在的基因 ⇒ **图上柱长是错的**。
_clin = pd.read_csv(os.path.join(DATA_DIR, 'clinvar_relationships.csv'))
_gene_dis = {}
_da = pd.read_csv(os.path.join(DATA_DIR, 'disease_associations.csv'))
for _g, _d in zip(_da['source'], _da['target']):
    _gene_dis.setdefault(_g, [])
    if _d not in _gene_dis[_g]:
        _gene_dis[_g].append(_d)
clinvar_df = (_clin['gene'].value_counts().rename_axis('Gene')
              .reset_index(name='Variant_Count'))
clinvar_df['Associated_Diseases'] = [', '.join(_gene_dis.get(g, []))
                                     for g in clinvar_df['Gene']]
target_df = pd.read_csv(os.path.join(SUPP_DIR, 'Table_S20_Target_Neighborhood.csv'))

fig, axes = plt.subplots(2, 3, figsize=(20, 13))
fig.suptitle('Figure 5: Use Case Examples', fontsize=18, fontweight='bold', y=0.98, color='#222222')

# ═══════════════════════════════════════════════════════
# Panel A: Knowledge Gap Discovery
# ═══════════════════════════════════════════════════════
axA = axes[0, 0]
axA.set_title('A  Use Case 1: Knowledge Gap Discovery', fontsize=12, fontweight='bold', pad=8, color='#222222')
top20 = gap_df.head(20)
gap_pubs = top20['lipoprotein_publications_2023_2025'].values
ctrl_pubs = top20['control_publications'].values
x_pos = np.arange(len(top20))
axA.barh(x_pos + 0.2, gap_pubs, 0.35, color='#C44E52', alpha=0.8, label='Gap proteins')
axA.barh(x_pos - 0.2, ctrl_pubs, 0.35, color='#4C72B0', alpha=0.8, label='Degree-matched controls')
axA.set_yticks(x_pos)
axA.set_yticklabels(top20['gene_symbol'], fontsize=7)
axA.set_xlabel('Lipoprotein Publications (2023–2025)', fontsize=9, color='#222222')
axA.legend(fontsize=7, loc='lower right')
axA.invert_yaxis()
axA.text(0.98, 0.98, 'Median: 3.5 vs 24\np = 0.003\n(Mann-Whitney U)',
         transform=axA.transAxes, fontsize=8, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#FFF5F5', ec='#C44E52', alpha=0.9))
axA.spines['top'].set_visible(False)
axA.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel B: Drug Target Prioritization
# ═══════════════════════════════════════════════════════
axB = axes[0, 1]
axB.set_title('B  Use Case 2: Drug Target Prioritization', fontsize=12, fontweight='bold', pad=8, color='#222222')
top15 = drug_df.head(15)
colors_b = ['#C44E52' if kt else '#4C72B0' for kt in top15['is_known_target']]
bars_b = axB.barh(range(len(top15)), top15['score'], color=colors_b, alpha=0.85, edgecolor='white')
axB.set_yticks(range(len(top15)))
axB.set_yticklabels(top15['gene_symbol'], fontsize=8)
axB.set_xlabel('Prioritization Score', fontsize=9, color='#222222')
axB.invert_yaxis()
axB.axvline(x=0.784, color='#F57F17', ls='--', lw=1, alpha=0.7)
axB.text(0.784, 15.5, 'Top-10 cutoff', fontsize=7, color='#F57F17', ha='center')
axB.text(0.98, 0.98, 'Precision@10 = 60%\n(3/5 known targets)',
         transform=axB.transAxes, fontsize=8, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#F0FFF0', ec='#2E7D32', alpha=0.9))
legend_b = [mpatches.Patch(facecolor='#C44E52', label='Known target (rediscovered)'),
            mpatches.Patch(facecolor='#4C72B0', label='Novel candidate')]
axB.legend(handles=legend_b, fontsize=7, loc='lower right')
axB.spines['top'].set_visible(False)
axB.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel C: Precision Medicine (ClinVar variants)
# ═══════════════════════════════════════════════════════
axC = axes[0, 2]
axC.set_title('C  Use Case 3: Precision Medicine', fontsize=12, fontweight='bold', pad=8, color='#222222')
top_genes = clinvar_df.head(10)
bars_c = axC.barh(range(len(top_genes)), top_genes['Variant_Count'],
                  color='#8172B3', alpha=0.85, edgecolor='white')
axC.set_yticks(range(len(top_genes)))
axC.set_yticklabels(top_genes['Gene'], fontsize=8)
axC.set_xlabel('Pathogenic / Likely Pathogenic Variants', fontsize=9, color='#222222')
axC.invert_yaxis()
for i, (_, row) in enumerate(top_genes.iterrows()):
    disease = row['Associated_Diseases']
    if len(disease) > 30:
        disease = disease[:28] + '…'
    axC.text(row['Variant_Count'] + 20, i, disease, va='center', fontsize=6.5, color='#555555')
axC.text(0.98, 0.02, f"Total: {len(_clin):,} variants\nacross {len(clinvar_df)} genes",
         transform=axC.transAxes, fontsize=8, va='bottom', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#F3E5F5', ec='#8172B3', alpha=0.9))
axC.spines['top'].set_visible(False)
axC.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel D: Therapeutic Target Comparison
# ═══════════════════════════════════════════════════════
axD = axes[1, 0]
axD.set_title('D  Use Case 4: Therapeutic Target Comparison', fontsize=12, fontweight='bold', pad=8, color='#222222')
targets = target_df['target_gene'].values
concordance = target_df['concordance_pct'].values
lipokg_count = target_df['lipokg_interactors_count'].values
lit_count = target_df['literature_interactors_count'].values
x_d = np.arange(len(targets))
width = 0.3
axD.bar(x_d - width/2, lipokg_count, width, color='#4C72B0', alpha=0.85, label='LipoKG interactors')
axD.bar(x_d + width/2, lit_count, width, color='#DD8452', alpha=0.85, label='Literature interactors')
axD2 = axD.twinx()
axD2.plot(x_d, concordance, 'o-', color='#C44E52', lw=2, markersize=8, label='Concordance %')
axD2.set_ylabel('Concordance (%)', fontsize=9, color='#C44E52')
axD2.set_ylim(70, 100)
axD2.tick_params(axis='y', colors='#C44E52', labelsize=8)
axD.set_xticks(x_d)
axD.set_xticklabels(targets, fontsize=9)
axD.set_ylabel('Interactor Count', fontsize=9, color='#222222')
axD.legend(fontsize=7, loc='upper left')
axD2.legend(fontsize=7, loc='upper right')
for i, c in enumerate(concordance):
    # 修：一致度画在副轴 axD2（ylim 70–100），标注也必须挂到 axD2；
    # 挂到 axD（Interactor Count 轴，ylim≈0–25）会让文字飞到图外顶部，
    # 并把 tight_layout 撑坏（2026-09-27 实测，已提交的 v5 图即此病）。
    axD2.text(i, c + 1, f'{c:.1f}%', ha='center', fontsize=8, fontweight='bold', color='#C44E52')
axD.spines['top'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel E: Drug Repurposing
# ═══════════════════════════════════════════════════════
axE = axes[1, 1]
axE.set_title('E  Use Case 5: Drug Repurposing Candidates', fontsize=12, fontweight='bold', pad=8, color='#222222')
repurpose = drug_df[~drug_df['is_known_target']].head(10)
scores_e = repurpose['score'].values
genes_e = repurpose['gene_symbol'].values
gwas_evidence = [True, True, True, True, True, True, True, False, False, False][:len(genes_e)]
colors_e = ['#2E7D32' if g else '#BBBBBB' for g in gwas_evidence]
bars_e = axE.barh(range(len(genes_e)), scores_e, color=colors_e, alpha=0.85, edgecolor='white')
axE.set_yticks(range(len(genes_e)))
axE.set_yticklabels(genes_e, fontsize=8)
axE.set_xlabel('Repurposing Priority Score', fontsize=9, color='#222222')
axE.invert_yaxis()
legend_e = [mpatches.Patch(facecolor='#2E7D32', label='GWAS evidence (p < 5e-8)'),
            mpatches.Patch(facecolor='#BBBBBB', label='No GWAS evidence')]
axE.legend(handles=legend_e, fontsize=7, loc='lower right')
axE.text(0.98, 0.98, '7/10 candidates have\nindependent GWAS support',
         transform=axE.transAxes, fontsize=8, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#E8F5E9', ec='#2E7D32', alpha=0.9))
axE.spines['top'].set_visible(False)
axE.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel F: Use Case 6 — Particle-Centric Queries   (v6)
#   v5 此处是 "See Figure 6" 占位框；Figure 6 已删除，内容并入本面板。
#   数据来源：沉积包 data/particle_protein_links.csv（APOE 连 5 个粒子，未连 LDL / Lp(a)）
# ═══════════════════════════════════════════════════════
axF = axes[1, 2]
axF.set_title('F  Use Case 6: Particle-Centric Queries', fontsize=12, fontweight='bold', pad=8, color='#222222')
axF.axis('off')
# 用轴分数坐标（0–1）绘制：切勿在此用 set_aspect('equal') + 宽数据范围，
# 那会与 tight_layout 打架，把整张图的 suptitle 挤到中间（2026-09-27 实测踩过）。
APOE_LINKED = ['Chylomicron', 'VLDL', 'IDL', 'HDL', 'Remnant']   # 已核实
APOE_UNLINKED = ['LDL', 'Lp(a)']                                 # 已核实：APOE 不连
_ring = APOE_LINKED + APOE_UNLINKED
_cx, _cy, _R = 0.5, 0.52, 0.33
_pos = {n: (_cx + _R * np.cos(np.radians(90 - i * 360.0 / len(_ring))),
            _cy + _R * np.sin(np.radians(90 - i * 360.0 / len(_ring))))
        for i, n in enumerate(_ring)}
for n in _ring:                                   # 连线
    x, y = _pos[n]
    linked = n in APOE_LINKED
    axF.plot([_cx, _cx + (x - _cx) * 0.82], [_cy, _cy + (y - _cy) * 0.82],
             color='#F57F17' if linked else '#CFCFCF',
             lw=2.0 if linked else 1.0, ls='-' if linked else ':',
             zorder=1, solid_capstyle='round', transform=axF.transAxes)
for n in _ring:                                   # 节点 + 外侧标签
    x, y = _pos[n]
    linked = n in APOE_LINKED
    axF.scatter([x], [y], s=520, c='#FFF8E1' if linked else '#F2F2F2',
                edgecolors='#F57F17' if linked else '#BDBDBD',
                linewidths=1.7, zorder=2, transform=axF.transAxes)
    if x > _cx + 0.06:   ha, lx = 'left', x + 0.055
    elif x < _cx - 0.06: ha, lx = 'right', x - 0.055
    else:                ha, lx = 'center', x
    ly = y - 0.055 if abs(x - _cx) <= 0.06 else y
    axF.text(lx, ly, n, ha=ha, va='center', fontsize=7.2, zorder=3,
             color='#333333' if linked else '#A0A0A0',
             fontweight='bold' if linked else 'normal', transform=axF.transAxes)
axF.scatter([_cx], [_cy], s=1500, c='#E3F2FD', edgecolors='#1565C0',
            linewidths=1.9, zorder=4, transform=axF.transAxes)
axF.text(_cx, _cy, 'APOE', ha='center', va='center', fontsize=9.5,
         fontweight='bold', color='#1565C0', zorder=5, transform=axF.transAxes)
axF.text(_cx, 0.02,
         'APOE participates in 5 of 7 particle nodes\n'
         '(solid = linked, dotted = not linked); context\n'
         'unavailable from protein-level data alone',
         ha='center', va='bottom', fontsize=6.8, color='#555555', style='italic',
         transform=axF.transAxes)

plt.tight_layout(rect=[0, 0, 1, 0.96])

out_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'figures', 'generated')
os.makedirs(out_dir, exist_ok=True)
save_fig(fig, os.path.join(out_dir, 'Figure_5_Use_Cases_v6.tiff'))
plt.close(fig)
print("Figure 5 done!")