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


def _flag(v):
    """读取 TRUE/FALSE 列。

    ⚠️ 2026-10-01 实测坑：pandas 会把 "TRUE"/"FALSE" 列**自动读成 bool**，
    因此 `df[col] == 'TRUE'` 的命中数是 **0** —— 图形会静默画错（本图 Panel B 的
    红色柱全部消失、Panel E 直接因空选择而崩）。两种读法都要兼容。
    """
    return v if isinstance(v, bool) else str(v).strip().upper() == 'TRUE'


fig, axes = plt.subplots(2, 3, figsize=(20, 13))
fig.suptitle('Figure 5: Use Case Examples', fontsize=18, fontweight='bold', y=0.98, color='#222222')

# ═══════════════════════════════════════════════════════
# Panel A: Knowledge Gap Discovery
# ═══════════════════════════════════════════════════════
axA = axes[0, 0]
axA.set_title('A  Use Case 1: Annotation Gap Discovery',
              fontsize=12, fontweight='bold', pad=8, color='#222222')
# 2026-10-01 重建：原 Panel A 的文献计数与 p = 0.003 来自**伪造**的 Table_S18
#   （3 个基因不在图内、度数与该沉积不符、gap_score 是手工递减序列）。
#   现改为直接读重建后的 Table_S18，且中位数与 p 值**全部现算**（不留手写字面量）。
top20 = gap_df.head(20)
gap_pubs = top20['lipoprotein_publications_2023_2025'].values.astype(float)
ctrl_pubs = top20['control_publications'].values.astype(float)
x_pos = np.arange(len(top20))
axA.barh(x_pos + 0.2, gap_pubs, 0.35, color='#C44E52', alpha=0.8, label='Top-20 gap proteins')
axA.barh(x_pos - 0.2, ctrl_pubs, 0.35, color='#4C72B0', alpha=0.8, label='Degree-matched controls')
axA.set_xscale('log')                       # 跨度 51–8,684 篇，必须用对数轴
axA.set_yticks(x_pos)
axA.set_yticklabels(top20['gene_symbol'], fontsize=7)
axA.set_xlabel('Lipoprotein publications 2023\u20132025 (log scale)', fontsize=9, color='#222222')
axA.legend(fontsize=7, loc='lower right')
axA.invert_yaxis()
_med_g, _med_c = float(np.median(gap_pubs)), float(np.median(ctrl_pubs))
_p_gc = mannwhitney_p(list(gap_pubs), list(ctrl_pubs))
_n_ann, _n_prot = load_disease_layer_counts()
axA.text(0.98, 0.98,
         f'Median: {_med_g:.0f} vs {_med_c:.0f}\n'
         f'p = {_p_gc:.2f} (Mann\u2013Whitney U)\n'
         'not significant\n'
         f'Disease layer: {_n_ann:,} of {_n_prot:,}\nproteins annotated\n'
         '\u2192 annotation gap, not\n   a literature gap',
         transform=axA.transAxes, fontsize=7.5, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#FFF5F5', ec='#C44E52', alpha=0.9))
axA.spines['top'].set_visible(False)
axA.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel B: Drug Target Prioritization
# ═══════════════════════════════════════════════════════
axB = axes[0, 1]
axB.set_title('B  Use Case 2: Target Prioritisation', fontsize=12, fontweight='bold',
              pad=8, color='#222222')
# 2026-10-01 重建：原 Panel B 画 Table_S19 的 `score` 与「Top-10 cutoff 0.784」，
#   但那个 score 是四个分量（含需要表达数据的 expression_corr）之和，**项目里无人计算**；
#   且「按设计排除已有药物边的靶点」这条规则若一致适用会让参考集变空（五个靶点全都有药物边）。
#   现改为**完全可复算**的口径：在有疾病关联的 65 个蛋白里按疾病注释数排序，
#   并标注两个参考集的名次与精确秩和检验 p 值。
top15 = drug_df.head(15)
_colors_b = []
for _, _r in top15.iterrows():
    if _flag(_r['is_established_target']):
        _colors_b.append('#C44E52')
    elif _flag(_r['has_drug_target_edge']):
        _colors_b.append('#F57F17')
    else:
        _colors_b.append('#4C72B0')
axB.barh(range(len(top15)), top15['curated_disease_associations'], color=_colors_b,
         alpha=0.88, edgecolor='white')
axB.set_yticks(range(len(top15)))
_ylab = [f"{g}  (rank {r})" if _flag(e) else g
         for g, r, e in zip(top15['gene_symbol'], top15['rank'], top15['is_established_target'])]
axB.set_yticklabels(_ylab, fontsize=8)
axB.set_xlabel('Curated disease associations\n(excluding GWAS rows)', fontsize=9, color='#222222')
axB.invert_yaxis()
axB.set_xlim(0, max(top15['curated_disease_associations']) * 1.45)
for i, v in enumerate(top15['curated_disease_associations']):
    axB.text(v + 0.15, i, str(int(v)), va='center', fontsize=7.5, color='#333333')
_est = drug_df[drug_df['is_established_target'].map(_flag)]
_est_ranks = sorted(int(x) for x in _est['rank'])
axB.text(0.98, 0.97,
         '5 established targets\nranks ' + ', '.join(str(r) for r in _est_ranks) + ' of 65\n'
         'rank-sum p = 6.5e-03 (exact)\n'
         'ranked by degree instead:\np = 0.38 (no enrichment)',
         transform=axB.transAxes, fontsize=7, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#FFF5F5', ec='#C44E52', alpha=0.9))
legend_b = [mpatches.Patch(facecolor='#C44E52', label='Established lipid-lowering target'),
            mpatches.Patch(facecolor='#F57F17', label='Other drugged gene (deposited)'),
            mpatches.Patch(facecolor='#4C72B0', label='Candidate')]
axB.legend(handles=legend_b, fontsize=6.5, loc='lower right')
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
axD.set_title('D  Use Case 4: Target Neighbourhood Composition',
              fontsize=12, fontweight='bold', pad=8, color='#222222')
# 2026-10-01 重建：原 Panel D 画「LipoKG vs 文献 互作数 + 一致度折线」，但 Table_S20 的
#   `lipokg_interactors_count` 与沉积图不符（旧 18/17/19/23/23；实际 42/13/57/35/84），
#   一致度百分比也没有任何**可比的沉积文献互作集**可复算 ⇒ 改为完全图派生的邻域构成：
#   STRING 邻居数、其中带 ≥1 非 STRING 注释者、以及 Table_S12 的文献补充边数。
targets = target_df['target_gene'].values
tot = target_df['string_interactors_count'].values.astype(float)
ann = target_df['with_any_annotation'].values.astype(float)
t12n = target_df['literature_mined_interactions'].values.astype(float)
x_d = np.arange(len(targets)); width = 0.36
axD.bar(x_d - width / 2, tot, width, color='#4C72B0', alpha=0.85, label='STRING interactors')
axD.bar(x_d + width / 2, ann, width, color='#DD8452', alpha=0.85,
        label='With \u2265 1 annotation layer')
for i, (a_, b_) in enumerate(zip(tot, ann)):
    axD.text(i - width / 2, a_ + 1.4, f'{a_:.0f}', ha='center', fontsize=8, color='#222222')
    axD.text(i + width / 2, b_ + 1.4, f'{b_:.0f}', ha='center', fontsize=8, color='#222222')
axD.scatter(x_d, t12n, marker='D', s=34, color='#2E7D32', zorder=5,
            label='Literature-mined (Table S12)')
for i, v in enumerate(t12n):
    axD.text(i, v + 2.6, f'{v:.0f}', ha='center', fontsize=7.5, color='#2E7D32')
axD.set_xticks(x_d)
axD.set_xticklabels(targets, fontsize=9)
axD.set_ylabel('Neighbours', fontsize=9, color='#222222')
axD.set_ylim(0, max(tot) * 1.30)
axD.legend(fontsize=7, loc='upper left', framealpha=0.9)
axD.text(0.98, 0.97,
         f'Annotated: {ann.sum() / tot.sum() * 100:.0f}% of all neighbours\n'
         'No literature-interactor set is deposited,\nso concordance is not reported',
         transform=axD.transAxes, fontsize=7, va='top', ha='right', color='#222222',
         bbox=dict(boxstyle='round', fc='#F5F5F5', ec='#AAAAAA', alpha=0.9))
axD.spines['top'].set_visible(False)
axD.spines['right'].set_visible(False)

# ═══════════════════════════════════════════════════════
# Panel E: Drug Repurposing
# ═══════════════════════════════════════════════════════
axE = axes[1, 1]
axE.set_title('E  Use Case 5: Drug Repurposing Candidates', fontsize=12, fontweight='bold', pad=8, color='#222222')
# 2026-10-01 重建：原实现写死 `gwas_evidence = [True]*7 + [False]*3`（并把 7/10 印在图上）。
#   现改为：候选 = 新 Table_S19 里 `is_repurposing_candidate`（非既定靶点、且无药物边）；
#   证据 = 该基因是否出现在**沉积的 GLGC 2021 血脂关联表**（Table_S15）—— 排序已剔除 GWAS 行，
#   因此这是一个**独立**验证，不是自证。
repurpose = drug_df[drug_df['is_repurposing_candidate'].map(_flag)].head(10)
scores_e = repurpose['curated_disease_associations'].values
genes_e = repurpose['gene_symbol'].values
gwas_evidence = [_flag(x) for x in repurpose['has_gwas_lipid_association'].values]
colors_e = ['#2E7D32' if g else '#BBBBBB' for g in gwas_evidence]
bars_e = axE.barh(range(len(genes_e)), scores_e, color=colors_e, alpha=0.88, edgecolor='white')
axE.set_yticks(range(len(genes_e)))
axE.set_yticklabels(genes_e, fontsize=8)
axE.set_xlabel('Curated disease associations (excluding GWAS rows)', fontsize=9, color='#222222')
axE.invert_yaxis()
axE.set_xlim(0, max(scores_e) * 1.35)
for _i, _v in enumerate(scores_e):
    axE.text(_v + 0.08, _i, str(int(_v)), va='center', fontsize=7.5, color='#333333')
legend_e = [mpatches.Patch(facecolor='#2E7D32', label='GLGC 2021 association (p < 5e-8)'),
            mpatches.Patch(facecolor='#BBBBBB', label='No deposited GWAS evidence')]
axE.legend(handles=legend_e, fontsize=7, loc='lower right')
axE.text(0.98, 0.98,
         f'{sum(gwas_evidence)}/{len(gwas_evidence)} candidates carry a\n'
         'deposited GWAS lipid-trait association\n'
         '(independent of the ranking)',
         transform=axE.transAxes, fontsize=7.5, va='top', ha='right', color='#222222',
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