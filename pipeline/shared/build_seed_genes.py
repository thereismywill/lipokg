#!/usr/bin/env python3
"""
LipoKG Seed Gene Set Builder
============================
从多个权威来源构建脂蛋白代谢种子基因集。
来源：KEGG hsa04979, Reactome R-HSA-174824, GO脂蛋白相关terms, 文献手动补充

输出: seed_genes.csv (gene_symbol, uniprot_id, category, source, description)
"""

import csv
import os

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "data", "seed_genes")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ============================================================
# 1. 核心脂蛋白代谢基因（手动 curated，基于 KEGG/Reactome/文献）
# ============================================================

CORE_GENES = {
    # === 载脂蛋白家族 ===
    "APOB":    {"uniprot": "P04114", "cat": "apolipoprotein", "desc": "Apolipoprotein B (ApoB-100/B-48), 脂蛋白颗粒结构蛋白"},
    "APOA1":   {"uniprot": "P02647", "cat": "apolipoprotein", "desc": "Apolipoprotein A-I, HDL主要结构蛋白，激活LCAT"},
    "APOA2":   {"uniprot": "P02652", "cat": "apolipoprotein", "desc": "Apolipoprotein A-II, HDL第二主要蛋白"},
    "APOA4":   {"uniprot": "P06727", "cat": "apolipoprotein", "desc": "Apolipoprotein A-IV, 肠道来源，参与饱食信号"},
    "APOA5":   {"uniprot": "Q8WWU8", "cat": "apolipoprotein", "desc": "Apolipoprotein A-V, 调控甘油三酯代谢"},
    "APOC1":   {"uniprot": "P02654", "cat": "apolipoprotein", "desc": "Apolipoprotein C-I, 抑制LPL和HL"},
    "APOC2":   {"uniprot": "P02655", "cat": "apolipoprotein", "desc": "Apolipoprotein C-II, LPL必需辅因子"},
    "APOC3":   {"uniprot": "P02656", "cat": "apolipoprotein", "desc": "Apolipoprotein C-III, 抑制LPL和肝摄取"},
    "APOE":    {"uniprot": "P02649", "cat": "apolipoprotein", "desc": "Apolipoprotein E, 脂蛋白残粒清除配体"},
    "APOH":    {"uniprot": "P02749", "cat": "apolipoprotein", "desc": "Apolipoprotein H (β2-glycoprotein I), 抗磷脂抗体靶点"},
    "APOM":    {"uniprot": "O95445", "cat": "apolipoprotein", "desc": "Apolipoprotein M, HDL相关鞘脂结合蛋白"},
    "APO_LPA": {"uniprot": "P42731", "cat": "apolipoprotein", "desc": "Apolipoprotein(a), Lp(a)特有成分，kringle结构域"},

    # === 脂蛋白颗粒组装/分泌 ===
    "MTTP":    {"uniprot": "P55157", "cat": "assembly", "desc": "Microsomal triglyceride transfer protein, 脂蛋白组装必需"},
    "SAR1B":   {"uniprot": "Q969E1", "cat": "assembly", "desc": "SAR1B, 乳糜微粒从ER到Golgi转运"},

    # === 脂蛋白脂肪酶及其调控 ===
    "LPL":     {"uniprot": "P06858", "cat": "lipase", "desc": "Lipoprotein lipase, 水解TG的核心酶"},
    "LIPC":    {"uniprot": "P11150", "cat": "lipase", "desc": "Hepatic lipase, 水解HDL中的TG和PL"},
    "LIPE":    {"uniprot": "P28038", "cat": "lipase", "desc": "Hormone-sensitive lipase"},
    "GPIHBP1": {"uniprot": "Q8IV16", "cat": "lipase_regulator", "desc": "GPI-anchored HDL-binding protein 1, LPL毛细血管转运"},
    "LMF1":    {"uniprot": "Q96S42", "cat": "lipase_regulator", "desc": "Lipase maturation factor 1, LPL成熟辅助"},
    "SEL1L":   {"uniprot": "Q8WV00", "cat": "lipase_regulator", "desc": "SEL1L, LPL ER质量控制"},

    # === ANGPTL家族（LPL调控） ===
    "ANGPTL3": {"uniprot": "Q9Y5C1", "cat": "angptl", "desc": "ANGPTL3, 抑制LPL和EL, evinacumab靶点"},
    "ANGPTL4": {"uniprot": "Q9BY76", "cat": "angptl", "desc": "ANGPTL4, 禁食状态下抑制LPL"},
    "ANGPTL8": {"uniprot": "Q86XK6", "cat": "angptl", "desc": "ANGPTL8 (RIFL/C19orf80), 与ANGPTL3协同抑制LPL"},

    # === LDL受体通路 ===
    "LDLR":    {"uniprot": "P01130", "cat": "receptor", "desc": "LDL receptor, 清除LDL的主要受体"},
    "LDLRAP1": {"uniprot": "Q8SWB1", "cat": "receptor", "desc": "LDLR adaptor protein 1, ARH致病基因"},
    "LRP1":    {"uniprot": "Q07954", "cat": "receptor", "desc": "LDL receptor-related protein 1, 清除残粒"},
    "VLDLR":   {"uniprot": "P98155", "cat": "receptor", "desc": "VLDL receptor, 脑和肌肉中表达"},
    "SCARB1":  {"uniprot": "Q8WTV0", "cat": "receptor", "desc": "SR-BI, HDL胆固醇选择性摄取受体"},
    "SORT1":   {"uniprot": "Q99590", "cat": "receptor", "desc": "Sortilin 1, 调控LDLR转运, GWAS热点"},
    "PCSK9":   {"uniprot": "Q8NBP7", "cat": "regulator", "desc": "PCSK9, 促进LDLR降解, 药物靶点"},
    "IDOL":    {"uniprot": "Q96CV9", "cat": "regulator", "desc": "IDOL/MYLIP, E3泛素连接酶降解LDLR"},

    # === 胆固醇转运/酯化 ===
    "ABCA1":   {"uniprot": "O95477", "cat": "transporter", "desc": "ABCA1, 细胞胆固醇外流至ApoA-I, Tangier病基因"},
    "ABCG1":   {"uniprot": "P45844", "cat": "transporter", "desc": "ABCG1, 胆固醇外流至成熟HDL"},
    "ABCG5":   {"uniprot": "Q9H222", "cat": "transporter", "desc": "ABCG5, 植物固醇排泄, 谷固醇血症基因"},
    "ABCG8":   {"uniprot": "Q9H221", "cat": "transporter", "desc": "ABCG8, 与ABCG5形成异二聚体"},
    "NPC1L1":  {"uniprot": "Q9UHC9", "cat": "transporter", "desc": "Niemann-Pick C1-like 1, 肠道胆固醇吸收, ezetimibe靶点"},
    "NPC1":    {"uniprot": "O15118", "cat": "transporter", "desc": "NPC1, 溶酶体胆固醇转运"},
    "NPC2":    {"uniprot": "P61916", "cat": "transporter", "desc": "NPC2, 溶酶体胆固醇结合蛋白"},

    # === 脂蛋白重塑酶 ===
    "LCAT":    {"uniprot": "P04180", "cat": "enzyme", "desc": "Lecithin-cholesterol acyltransferase, HDL成熟必需"},
    "CETP":    {"uniprot": "P11597", "cat": "enzyme", "desc": "Cholesteryl ester transfer protein, CE↔TG交换"},
    "PLTP":    {"uniprot": "P55058", "cat": "enzyme", "desc": "Phospholipid transfer protein, PL转运和HDL重塑"},
    "PLA2G7":  {"uniprot": "Q13093", "cat": "enzyme", "desc": "Lp-PLA2 (PAF-AH), 氧化磷脂水解酶"},

    # === 胆固醇合成/调控 ===
    "HMGCR":   {"uniprot": "P04035", "cat": "synthesis", "desc": "HMG-CoA reductase, 胆固醇合成限速酶, statin靶点"},
    "HMGCS1":  {"uniprot": "Q01581", "cat": "synthesis", "desc": "HMG-CoA synthase, 甲羟戊酸通路"},
    "SQLE":    {"uniprot": "Q14534", "cat": "synthesis", "desc": "Squalene epoxidase, 胆固醇合成"},
    "SREBF2":  {"uniprot": "P36957", "cat": "regulator", "desc": "SREBP-2, 胆固醇合成/摄取主调控因子"},
    "SREBF1":  {"uniprot": "P36956", "cat": "regulator", "desc": "SREBP-1c, 脂肪酸合成调控"},
    "SCAP":    {"uniprot": "Q12770", "cat": "regulator", "desc": "SREBP cleavage-activating protein"},
    "INSIG1":  {"uniprot": "O15503", "cat": "regulator", "desc": "Insulin-induced gene 1, 抑制SREBP转运"},
    "INSIG2":  {"uniprot": "Q9Y5U4", "cat": "regulator", "desc": "Insulin-induced gene 2"},

    # === 核受体/转录因子 ===
    "NR1H3":   {"uniprot": "Q13133", "cat": "nuclear_receptor", "desc": "LXRα, 胆固醇感受器, 调控ABCA1等"},
    "NR1H2":   {"uniprot": "P55055", "cat": "nuclear_receptor", "desc": "LXRβ"},
    "PPARA":   {"uniprot": "Q07869", "cat": "nuclear_receptor", "desc": "PPARα, 脂肪酸氧化主调控因子, fibrate靶点"},
    "PPARG":   {"uniprot": "P37231", "cat": "nuclear_receptor", "desc": "PPARγ, 脂肪细胞分化, 脂代谢"},
    "NR1H4":   {"uniprot": "Q96RI1", "cat": "nuclear_receptor", "desc": "FXR, 胆汁酸受体"},
    "RXRA":    {"uniprot": "P19793", "cat": "nuclear_receptor", "desc": "RXRα, 核受体共激活因子"},

    # === 胆汁酸代谢 ===
    "CYP7A1":  {"uniprot": "P22680", "cat": "bile_acid", "desc": "Cholesterol 7α-hydroxylase, 胆汁酸合成限速酶"},
    "CYP27A1": {"uniprot": "Q02313", "cat": "bile_acid", "desc": "Sterol 27-hydroxylase, 替代胆汁酸通路"},
    "ABCB11":  {"uniprot": "O75362", "cat": "bile_acid", "desc": "BSEP, 胆管胆汁酸转运"},
}

# ============================================================
# 2. 扩展基因集（外围调控、免疫交叉、PTM相关）
# ============================================================

EXTENDED_GENES = {
    # === 脂蛋白相关炎症/免疫 ===
    "LOX1":    {"uniprot": "P78380", "cat": "immune", "desc": "LOX-1 (OLR1), oxLDL受体, 内皮细胞"},
    "CD36":    {"uniprot": "Q08345", "cat": "immune", "desc": "CD36, oxLDL/fatty acid受体, 巨噬细胞"},
    "MSR1":    {"uniprot": "P14898", "cat": "immune", "desc": "Scavenger receptor A, oxLDL摄取"},
    "NR1H3_LXR": {"uniprot": "Q13133", "cat": "immune", "desc": "LXRα在巨噬细胞中的抗炎作用"},
    "ABCA1_MACRO": {"uniprot": "O95477", "cat": "immune", "desc": "ABCA1在巨噬细胞中的胆固醇外流"},
    "TNF":     {"uniprot": "P01375", "cat": "cytokine", "desc": "TNF-α, 脂蛋白代谢炎症调控"},
    "IL1B":    {"uniprot": "P01584", "cat": "cytokine", "desc": "IL-1β, 炎症小体下游"},
    "IL6":     {"uniprot": "P05231", "cat": "cytokine", "desc": "IL-6, 肝脏急性期反应调控脂蛋白"},
    "NLRP3":   {"uniprot": "Q96P20", "cat": "immune", "desc": "NLRP3炎症小体, oxLDL激活"},

    # === 脂蛋白修饰相关 ===
    "MPO":     {"uniprot": "P05164", "cat": "ptm_enzyme", "desc": "Myeloperoxidase, ApoA-I氧化修饰"},
    "EPX":     {"uniprot": "P42127", "cat": "ptm_enzyme", "desc": "Eosinophil peroxidase"},
    "PON1":    {"uniprot": "P27169", "cat": "ptm_enzyme", "desc": "Paraoxonase 1, HDL相关抗氧化酶"},
    "PLA2G2A": {"uniprot": "P14555", "cat": "ptm_enzyme", "desc": "sPLA2-IIA, LDL修饰酶"},
    "ACACA":   {"uniprot": "Q13085", "cat": "ptm_enzyme", "desc": "ACC1, 脂肪酸合成"},

    # === 脂蛋白清除相关 ===
    "APOBR":   {"uniprot": "P06207", "cat": "clearance", "desc": "ApoB receptor"},
    "STAB1":   {"uniprot": "Q9NY15", "cat": "clearance", "desc": "Stabilin-1, 清除修饰脂蛋白"},
    "STAB2":   {"uniprot": "Q8WWQ8", "cat": "clearance", "desc": "Stabilin-2"},

    # === 信号通路/PTM调控 ===
    "AMPK_PRKAA1": {"uniprot": "Q13131", "cat": "signaling", "desc": "AMPK α1, 能量代谢调控"},
    "PRKAA2":  {"uniprot": "P54646", "cat": "signaling", "desc": "AMPK α2"},
    "MTOR":    {"uniprot": "P42345", "cat": "signaling", "desc": "mTOR, 脂质合成调控"},
    "AKT1":    {"uniprot": "P31749", "cat": "signaling", "desc": "AKT1, 胰岛素信号"},
    "STK11":   {"uniprot": "Q15831", "cat": "signaling", "desc": "STK11/LKB1, AMPK上游激酶"},

    # === 新兴靶点/药物开发 ===
    "ANGPTL3_DRUG": {"uniprot": "Q9Y5C1", "cat": "drug_target", "desc": "ANGPTL3, evinacumab/vupanorsen靶点"},
    "APOC3_DRUG": {"uniprot": "P02656", "cat": "drug_target", "desc": "APOC3, volanesorsen/olezarsen靶点"},
    "LPA_DRUG": {"uniprot": "P42731", "cat": "drug_target", "desc": "LPA, pelacarsen/olpasiran靶点"},

    # === 肠道脂质吸收 ===
    "FABP2":   {"uniprot": "P12104", "cat": "intestinal", "desc": "I-FABP, 肠道脂肪酸结合蛋白"},
    "DGAT1":   {"uniprot": "O75907", "cat": "intestinal", "desc": "DGAT1, TG合成终末酶"},
    "DGAT2":   {"uniprot": "Q9H3M4", "cat": "intestinal", "desc": "DGAT2, TG合成"},
    "ACSL5":   {"uniprot": "Q9NR30", "cat": "intestinal", "desc": "ACSL5, 脂肪酸活化"},
}

# ============================================================
# 3. 合并去重
# ============================================================

all_genes = {}

for symbol, info in CORE_GENES.items():
    # 去掉后缀（如 _DRUG, _MACRO）
    clean_symbol = symbol.split("_")[0] if "_" in symbol else symbol
    if clean_symbol not in all_genes:
        all_genes[clean_symbol] = {
            "symbol": clean_symbol,
            "uniprot_id": info["uniprot"],
            "category": info["cat"],
            "source": "KEGG+Reactome+GO+literature",
            "description": info["desc"],
            "is_core": True,
        }
    else:
        # 如果已存在，添加额外source标注
        all_genes[clean_symbol]["source"] += "+extended"

for symbol, info in EXTENDED_GENES.items():
    clean_symbol = symbol.split("_")[0] if "_" in symbol else symbol
    if clean_symbol not in all_genes:
        all_genes[clean_symbol] = {
            "symbol": clean_symbol,
            "uniprot_id": info["uniprot"],
            "category": info["cat"],
            "source": "literature_extended",
            "description": info["desc"],
            "is_core": False,
        }

# ============================================================
# 4. 输出
# ============================================================

output_path = os.path.join(OUTPUT_DIR, "seed_genes.csv")
with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=[
        "symbol", "uniprot_id", "category", "source", "description", "is_core"
    ])
    writer.writeheader()
    for gene in sorted(all_genes.values(), key=lambda g: (g["category"], g["symbol"])):
        writer.writerow(gene)

# 统计
core_count = sum(1 for g in all_genes.values() if g["is_core"])
ext_count = sum(1 for g in all_genes.values() if not g["is_core"])
cats = {}
for g in all_genes.values():
    cats[g["category"]] = cats.get(g["category"], 0) + 1

print(f"✅ Seed gene set saved to: {output_path}")
print(f"   Total genes: {len(all_genes)}")
print(f"   Core genes:  {core_count}")
print(f"   Extended:    {ext_count}")
print(f"\n   Categories:")
for cat, count in sorted(cats.items(), key=lambda x: -x[1]):
    print(f"     {cat}: {count}")

# 同时输出纯基因符号列表（方便后续工具使用）
symbols_path = os.path.join(OUTPUT_DIR, "gene_symbols.txt")
with open(symbols_path, "w") as f:
    for gene in sorted(all_genes.values(), key=lambda g: g["symbol"]):
        f.write(gene["symbol"] + "\n")
print(f"\n   Gene symbols list: {symbols_path}")

# 输出核心基因符号列表
core_symbols_path = os.path.join(OUTPUT_DIR, "core_gene_symbols.txt")
with open(core_symbols_path, "w") as f:
    for gene in sorted(all_genes.values(), key=lambda g: g["symbol"]):
        if gene["is_core"]:
            f.write(gene["symbol"] + "\n")
print(f"   Core gene symbols: {core_symbols_path}")
