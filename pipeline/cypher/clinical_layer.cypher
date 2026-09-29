// ============================================================
//  临床层扩展 — 疾病、药物、生物标志物
//  Clinical Layer Extension
//  节点: ~35 | 边: ~60
// ============================================================


// ============================================================
//  SECTION 1: 疾病节点 (Disease) — 15 个
// ============================================================

CREATE (fh:Disease {
  id: "disease:FH",
  name: "家族性高胆固醇血症",
  name_en: "Familial Hypercholesterolemia",
  omim: "143890",
  inheritance: "常染色体显性",
  prevalence: "杂合子 1:250; 纯合子 1:250,000",
  description: "LDL受体通路缺陷导致LDL-C极度升高，早发冠心病",
  clinical_features: "肌腱黄色瘤、角膜弓、早发ASCVD",
  diagnosis: "Dutch Lipid Clinic Network评分; 基因检测",
  icd11: "5C80.0"
});

CREATE (hofh:Disease {
  id: "disease:HoFH",
  name: "纯合子家族性高胆固醇血症",
  name_en: "Homozygous FH",
  inheritance: "常染色体显性（双等位基因突变）",
  prevalence: "1:250,000-1,000,000",
  description: "LDLR双等位基因突变或复合杂合突变，LDL-C > 13 mmol/L",
  clinical_features: "儿童期即出现严重ASCVD、主动脉瓣狭窄、皮肤黄色瘤",
  treatment_note: "他汀/PCSK9i效果有限（依赖LDLR功能）; 需要脂蛋白血浆置换、Lomitapide、Evinacumab",
  icd11: "5C80.0"
});

CREATE (fch:Disease {
  id: "disease:FCH",
  name: "家族性联合高脂血症",
  name_en: "Familial Combined Hyperlipidemia",
  inheritance: "多基因",
  prevalence: "1:100-200（最常见的遗传性血脂异常）",
  description: "VLDL过度分泌导致TG和LDL-C同时升高",
  clinical_features: "早发ASCVD、肥胖、胰岛素抵抗",
  biomarker_pattern: "TG↑, LDL-C↑, ApoB↑, 小密LDL↑",
  icd11: "5C80.1"
});

CREATE (type3:Disease {
  id: "disease:Type3_HLP",
  name: "III型高脂蛋白血症",
  name_en: "Type III Hyperlipoproteinemia (Dysbetalipoproteinemia)",
  omim: "617347",
  inheritance: "常染色体隐性（ApoE2/E2纯合）",
  prevalence: "1:5,000-10,000",
  description: "ApoE2/E2纯合子导致IDL和CM残粒清除障碍",
  clinical_features: "掌纹黄色瘤、结节性黄色瘤、早发ASCVD",
  biomarker_pattern: "TC↑↑, TG↑↑, IDL堆积, ApoE2/E2基因型",
  treatment_note: "贝特类效果好; 低脂饮食",
  icd11: "5C80.2"
});

CREATE (fcs:Disease {
  id: "disease:FCS",
  name: "家族性乳糜微粒血症",
  name_en: "Familial Chylomicronemia Syndrome (Type I HLP)",
  omim: "238600",
  inheritance: "常染色体隐性",
  prevalence: "1:1,000,000",
  description: "LPL通路完全缺陷导致CM无法脂解，TG极度升高（>10 mmol/L）",
  clinical_features: "反复急性胰腺炎、乳糜血、肝脾肿大、脂血症视网膜",
  genetic_causes: "LPL、APOC2、GPIHBP1、LMF1、APOA5 双等位基因突变",
  treatment_note: "极低脂饮食; Volanesorsen（ApoC-III ASO）已获批（欧洲）",
  icd11: "5C80.3"
});

CREATE (hta:Disease {
  id: "disease:HTG",
  name: "高甘油三酯血症",
  name_en: "Hypertriglyceridemia",
  prevalence: "成人 ~30%（TG > 1.7 mmol/L）",
  description: "血浆TG升高，可为原发性（遗传）或继发性（代谢综合征、糖尿病、酒精）",
  classification: "轻度 1.7-5.6; 中度 5.6-11.3; 重度 >11.3 mmol/L",
  clinical_features: "重度时可致急性胰腺炎; 轻中度与ASCVD风险增加相关",
  icd11: "5C80.1"
});

CREATE (ascvd:Disease {
  id: "disease:ASCVD",
  name: "动脉粥样硬化性心血管疾病",
  name_en: "Atherosclerotic Cardiovascular Disease",
  description: "脂蛋白异常驱动的动脉粥样硬化导致的心梗、脑卒中、外周动脉疾病",
  pathogenesis: "LDL浸润内膜→氧化修饰→巨噬细胞摄取→泡沫细胞→斑块→破裂→血栓",
  risk_factors: "LDL-C↑, Lp(a)↑, TG↑, HDL-C↓, 炎症, 高血压, 糖尿病, 吸烟",
  icd11: "BA80"
});

CREATE (masld:Disease {
  id: "disease:MASLD",
  name: "代谢相关脂肪性肝病",
  name_en: "Metabolic dysfunction-Associated Steatotic Liver Disease",
  prevalence: "全球 ~30%",
  description: "肝脏脂肪堆积（>5%肝细胞），与代谢综合征密切相关",
  pathogenesis: "VLDL分泌不足/脂肪酸氧化受损→肝脏TG堆积→炎症→纤维化",
  progression: "MASLD → MASH（代谢相关脂肪性肝炎）→ 肝硬化 → 肝癌",
  icd11: "DB92"
});

CREATE (metabolic_syndrome:Disease {
  id: "disease:MetS",
  name: "代谢综合征",
  name_en: "Metabolic Syndrome",
  prevalence: "成人 ~25%",
  description: "腹型肥胖 + 高TG + 低HDL-C + 高血压 + 高血糖（5项中≥3项）",
  lipid_profile: "TG↑, HDL-C↓, 小密LDL↑（致AS脂三联征）",
  icd11: "5C81"
});

CREATE (tangier:Disease {
  id: "disease:Tangier",
  name: "Tangier病",
  name_en: "Tangier Disease",
  omim: "205400",
  inheritance: "常染色体隐性",
  prevalence: "< 1:1,000,000",
  description: "ABCA1完全缺陷导致HDL无法生成，HDL-C极低（<0.1 mmol/L）",
  clinical_features: "橙黄色扁桃体、肝脾肿大、周围神经病变、早发ASCVD",
  icd11: "5C80.4"
});

CREATE (lcat_def:Disease {
  id: "disease:LCAT_def",
  name: "家族性LCAT缺乏症",
  name_en: "Familial LCAT Deficiency",
  omim: "245900",
  inheritance: "常染色体隐性",
  description: "LCAT缺陷导致FC无法酯化，HDL成熟障碍",
  clinical_features: "角膜混浊、溶血性贫血、肾功能衰竭",
  icd11: "5C80.5"
});

CREATE (abetalipo:Disease {
  id: "disease:Abetalipo",
  name: "无β脂蛋白血症",
  name_en: "Abetalipoproteinemia (Bassen-Kornzweig)",
  omim: "200100",
  inheritance: "常染色体隐性（MTP突变）",
  description: "MTP缺陷导致CM和VLDL无法组装，ApoB脂蛋白完全缺失",
  clinical_features: "脂肪泻、脂溶性维生素缺乏、棘红细胞、共济失调、视网膜色素变性",
  icd11: "5C80.6"
});

CREATE (sitosterolemia:Disease {
  id: "disease:Sitosterolemia",
  name: "植物甾醇血症",
  name_en: "Sitosterolemia",
  omim: "210250",
  inheritance: "常染色体隐性（ABCG5/ABCG8突变）",
  description: "肠道植物甾醇吸收增加+胆汁排泄减少→植物甾醇堆积",
  clinical_features: "肌腱黄色瘤、早发ASCVD、溶血、血小板减少",
  treatment_note: "依折麦布有效（抑制NPC1L1）; 低植物甾醇饮食",
  icd11: "5C80.7"
});

CREATE (lpa_risk:Disease {
  id: "disease:LpA_elevated",
  name: "Lp(a)升高",
  name_en: "Elevated Lipoprotein(a)",
  prevalence: "~20%人群 > 50 mg/dL",
  description: "Lp(a)水平>90%由LPA基因kringle IV-2重复数决定",
  clinical_features: "ASCVD风险↑（独立于LDL-C）; 钙化性主动脉瓣狭窄风险↑",
  treatment_note: "传统降脂药（他汀、PCSK9i）效果有限; Pelacarsen/Olpasiran在III期试验中",
  icd11: "5C80.8"
});

CREATE (pancreatitis:Disease {
  id: "disease:Pancreatitis",
  name: "急性胰腺炎（高TG性）",
  name_en: "Hypertriglyceridemic Pancreatitis",
  description: "TG > 11.3 mmol/L时风险显著增加; >56 mmol/L时极高危",
  pathogenesis: "CM阻塞胰腺毛细血管→局部LPL水解→FFA毒性→胰腺炎",
  treatment_note: "急性期：胰岛素+葡萄糖（激活LPL）、血浆置换; 长期：极低脂饮食+贝特类+Volanesorsen",
  icd11: "DB73"
});


// ============================================================
//  SECTION 2: 药物节点 (Drug) — 12 个
// ============================================================

CREATE (statin:Drug {
  id: "drug:Statin",
  name: "他汀类",
  name_en: "Statins",
  atc: "C10AA",
  examples: "阿托伐他汀、瑞舒伐他汀、辛伐他汀、匹伐他汀",
  mechanism: "竞争性抑制HMGCR → 细胞内胆固醇↓ → SREBP-2激活 → LDLR↑ → LDL-C↓",
  effect: "LDL-C↓30-63%（因药物/剂量而异）; TG↓10-30%; HDL-C↑5-10%",
  indication: "ASCVD一级/二级预防; 家族性高胆固醇血症",
  side_effects: "肌痛（常见）; 横纹肌溶解（罕见）; 转氨酶升高; 新发糖尿病（轻度增加）",
  landmark_trials: "4S, WOSCOPS, HPS, JUPITER, IMPROVE-IT",
  approved: true,
  status: "一线治疗"
});

CREATE (ezetimibe:Drug {
  id: "drug:Ezetimibe",
  name: "依折麦布",
  name_en: "Ezetimibe",
  atc: "C10AX09",
  mechanism: "抑制小肠NPC1L1 → 胆固醇吸收↓ → 肝脏胆固醇↓ → LDLR↑ → LDL-C↓",
  effect: "LDL-C↓18-22%（单药）; 与他汀联用额外↓18-20%",
  indication: "他汀不耐受; 他汀+依折麦布联合治疗",
  landmark_trials: "IMPROVE-IT（心血管获益证实）",
  approved: true,
  status: "二线治疗"
});

CREATE (pcsk9i:Drug {
  id: "drug:PCSK9i",
  name: "PCSK9抑制剂",
  name_en: "PCSK9 Inhibitors",
  atc: "C10AX13/C10AX15",
  examples: "Evolocumab（瑞百安）、Alirocumab（波立达）",
  mechanism: "单克隆抗体结合PCSK9 → 阻止PCSK9-LDLR结合 → LDLR降解减少 → LDL-C↓",
  effect: "LDL-C↓55-65%（在他汀基础上）",
  indication: "FH; ASCVD他汀治疗未达标; 他汀不耐受",
  side_effects: "注射部位反应; 流感样症状",
  landmark_trials: "FOURIER (Evolocumab), ODYSSEY OUTCOMES (Alirocumab)",
  approved: true,
  status: "三线治疗（注射给药，每2-4周一次）"
});

CREATE (inclisiran:Drug {
  id: "drug:Inclisiran",
  name: "Inclisiran",
  name_en: "Inclisiran (Leqvio)",
  atc: "C10AX16",
  mechanism: "siRNA沉默肝脏PCSK9 mRNA → PCSK9蛋白合成↓ → LDL-C↓",
  effect: "LDL-C↓50%",
  indication: "ASCVD; FH; 他汀治疗未达标",
  dosing: "皮下注射: 第0、3月各1次，之后每6月1次（全年仅2针）",
  landmark_trials: "ORION-1, ORION-3, ORION-4（进行中）",
  approved: true,
  status: "三线治疗（极低给药频率优势）"
});

CREATE (fibrate:Drug {
  id: "drug:Fibrate",
  name: "贝特类",
  name_en: "Fibrates",
  atc: "C10AB",
  examples: "非诺贝特（力平之）、吉非贝齐、苯扎贝特",
  mechanism: "激活PPARα → LPL↑, ApoC-II↑, ApoC-III↓ → TG水解↑ → VLDL清除↑",
  effect: "TG↓30-50%; HDL-C↑10-20%; LDL-C↓5-20%（TG高时可能升高LDL-C）",
  indication: "高TG血症; III型高脂蛋白血症; 混合型高脂血症",
  side_effects: "肌病（与他汀联用时风险增加，吉非贝齐尤甚）; 胆石症",
  landmark_trials: "HHS, VA-HIT, FIELD, ACCORD-Lipid",
  approved: true,
  status: "高TG血症一线治疗"
});

CREATE (bempedoic:Drug {
  id: "drug:Bempedoic_acid",
  name: "Bempedoic acid",
  name_en: "Bempedoic acid (Nexletol)",
  atc: "C10AX13",
  mechanism: "抑制ATP柠檬酸裂解酶(ACL) → 胆固醇合成↓（HMGCR上游）→ LDLR↑",
  effect: "LDL-C↓15-25%（单药）; 与他汀联用额外↓15-20%",
  indication: "他汀不耐受; ASCVD他汀治疗未达标",
  advantage: "前体药物，需ACSVL1激活（肝脏特异性）→ 不在肌肉中活化 → 无肌痛",
  landmark_trials: "CLEAR Outcomes（2023，心血管获益证实）",
  approved: true,
  status: "二线/三线治疗"
});

CREATE (lomitapide:Drug {
  id: "drug:Lomitapide",
  name: "Lomitapide",
  name_en: "Lomitapide (Juxtapid)",
  mechanism: "抑制MTP → ApoB脂化受阻 → VLDL/CM组装减少 → LDL-C↓",
  effect: "LDL-C↓40-50%",
  indication: "仅限HoFH（REMS限制使用项目）",
  side_effects: "胃肠道症状（常见）; 肝脏脂肪堆积（需监测）; 肝毒性",
  approved: true,
  status: "HoFH专用（限制使用）"
});

CREATE (evinacumab:Drug {
  id: "drug:Evinacumab",
  name: "Evinacumab",
  name_en: "Evinacumab (Evkeeza)",
  mechanism: "单克隆抗体抑制ANGPTL3 → LPL和EL抑制解除 → TG↓, LDL-C↓, HDL-C↓",
  effect: "TG↓68%; LDL-C↓49%（HoFH）; HDL-C↓（因EL也解除抑制）",
  indication: "HoFH（ adjunctive治疗）",
  advantage: "不依赖LDLR功能 → 对LDLR null/null HoFH患者有效",
  landmark_trials: "ELIzabeth (Phase 3, HoFH)",
  approved: true,
  status: "HoFH专用（2021 FDA批准）"
});

CREATE (volanesersen:Drug {
  id: "drug:Volanesersen",
  name: "Volanesorsen",
  name_en: "Volanesersen (Waylivra)",
  mechanism: "ASO靶向ApoC-III mRNA → ApoC-III蛋白↓ → LPL抑制解除 + 残粒清除↑ → TG↓",
  effect: "TG↓77%（FCS患者）",
  indication: "FCS（欧洲获批）; 严重高TG血症",
  side_effects: "注射部位反应; 血小板减少（需监测）",
  landmark_trials: "APPROACH (FCS), COMPASS (FHTG)",
  approved: true,
  status: "FCS专用（仅欧洲获批，FDA拒绝）"
});

CREATE (icosapent:Drug {
  id: "drug:Icosapent_ethyl",
  name: "二十碳五烯酸乙酯",
  name_en: "Icosapent ethyl (Vascepa)",
  atc: "C10AX06",
  mechanism: "高纯度EPA（ω-3脂肪酸）→ 减少肝脏VLDL合成 + 抗炎 + 抗血小板",
  effect: "TG↓20-30%; 心血管事件↓25%（REDUCE-IT）",
  indication: "ASCVD或糖尿病 + TG 1.5-5.6 mmol/L（他汀已优化LDL-C）",
  landmark_trials: "REDUCE-IT（里程碑：首个显示ω-3 CV获益的试验）",
  approved: true,
  status: "ASCVD+高TG辅助治疗"
});

CREATE (niacin:Drug {
  id: "drug:Niacin",
  name: "烟酸",
  name_en: "Niacin (Vitamin B3)",
  atc: "C10BA01",
  mechanism: "抑制脂肪组织激素敏感性脂肪酶 → FFA释放↓ → 肝脏VLDL合成↓ + HDL-C↑",
  effect: "LDL-C↓5-25%; TG↓20-50%; HDL-C↑15-35%（最强升HDL药物）",
  indication: "混合型高脂血症; 低HDL-C（已较少使用）",
  side_effects: "潮红（前列腺素介导）; 高血糖; 高尿酸; 肝毒性",
  landmark_trials: "AIM-HIGH, HPS2-THRIVE（均未显示额外CV获益）",
  approved: true,
  status: "已较少使用（大型试验未证实CV获益）"
});

CREATE (olezarsen:Drug {
  id: "drug:Olezarsen",
  name: "Olezarsen",
  name_en: "Olezarsen (ApoC-III ASO next-gen)",
  mechanism: "新一代ASO靶向ApoC-III mRNA（GalNAc偶联，肝脏靶向）",
  effect: "TG↓50-70%; ApoC-III↓75%",
  indication: "FCS; 严重高TG血症（III期试验中）",
  advantage: "比Volanesersen更强效、更安全（血小板减少风险↓）",
  landmark_trials: "Bridge (FCS, Phase 3, 2024)",
  approved: false,
  status: "Phase 3（2024-2025预期获批）"
});


// ============================================================
//  SECTION 3: 生物标志物节点 (Biomarker) — 8 个
// ============================================================

CREATE (ldlc_bm:Biomarker {
  id: "biomarker:LDL_C",
  name: "LDL-C",
  name_cn: "低密度脂蛋白胆固醇",
  unit: "mmol/L (mg/dL)",
  normal_range: "< 3.0 (理想 < 2.6; 极高危 < 1.4)",
  measurement: "Friedewald公式计算 或 直接测定",
  clinical_significance: "ASCVD首要危险因素; 降LDL-C治疗的首要靶点",
  formula: "Friedewald: LDL-C = TC - HDL-C - TG/2.2"
});

CREATE (hdlc_bm:Biomarker {
  id: "biomarker:HDL_C",
  name: "HDL-C",
  name_cn: "高密度脂蛋白胆固醇",
  unit: "mmol/L (mg/dL)",
  normal_range: "> 1.0 (男); > 1.3 (女)",
  clinical_significance: "低HDL-C是ASCVD独立危险因素; 但药物升HDL-C未证实CV获益",
  note: "HDL功能（胆固醇外流能力）比HDL-C浓度更重要"
});

CREATE (tg_bm:Biomarker {
  id: "biomarker:TG",
  name: "TG",
  name_cn: "甘油三酯",
  unit: "mmol/L (mg/dL)",
  normal_range: "< 1.7",
  clinical_significance: "重度升高(>5.6)→胰腺炎风险; 轻中度与ASCVD相关; 残粒胆固醇的标志",
  note: "非空腹TG可能更有临床意义"
});

CREATE (tc_bm:Biomarker {
  id: "biomarker:TC",
  name: "TC",
  name_cn: "总胆固醇",
  unit: "mmol/L (mg/dL)",
  normal_range: "< 5.2",
  clinical_significance: "传统血脂四项之一; 不如LDL-C精确"
});

CREATE (apob_bm:Biomarker {
  id: "biomarker:ApoB",
  name: "ApoB",
  name_cn: "载脂蛋白B",
  unit: "mg/dL",
  normal_range: "< 90 (极高危 < 65)",
  clinical_significance: "反映所有致AS颗粒总数（LDL+VLDL+IDL+Lp(a)）; 比LDL-C更准确预测ASCVD风险",
  advantage: "每个致AS颗粒含1分子ApoB → 直接反映颗粒数量"
});

CREATE (apoa1_bm:Biomarker {
  id: "biomarker:ApoA1",
  name: "ApoA-I",
  name_cn: "载脂蛋白A-I",
  unit: "mg/dL",
  normal_range: "> 120 (男); > 140 (女)",
  clinical_significance: "HDL主要载脂蛋白; 反映HDL颗粒数量和功能"
});

CREATE (lpa_bm:Biomarker {
  id: "biomarker:Lpa",
  name: "Lp(a)",
  name_cn: "脂蛋白(a)",
  unit: "mg/dL 或 nmol/L",
  normal_range: "< 50 mg/dL (< 125 nmol/L)",
  clinical_significance: "独立ASCVD危险因素; 钙化性主动脉瓣狭窄危险因素",
  genetic_determinism: ">90%由LPA基因kringle IV-2重复数决定",
  note: "每个成人应至少检测一次（ESC 2019指南）"
});

CREATE (non_hdlc_bm:Biomarker {
  id: "biomarker:non_HDL_C",
  name: "non-HDL-C",
  name_cn: "非HDL胆固醇",
  unit: "mmol/L (mg/dL)",
  normal_range: "< 3.8 (极高危 < 2.2)",
  clinical_significance: "TC - HDL-C; 反映所有致AS脂蛋白中的胆固醇总量",
  advantage: "不需要空腹; TG高时比LDL-C更可靠; 次要治疗靶点",
  formula: "non-HDL-C = TC - HDL-C"
});


// ============================================================
//  SECTION 4: 疾病-基因/分子 关系 (CAUSED_BY) — 15 条
// ============================================================

MATCH (fh:Disease {id:"disease:FH"}), (ldlr:Molecule {id:"mol:LDLR"})
CREATE (fh)-[:CAUSED_BY {gene:"LDLR", mutation_pct:">90%", note:"LDLR功能丧失/减少"}]->(ldlr);

MATCH (fh:Disease {id:"disease:FH"}), (apob:Molecule {id:"mol:ApoB100"})
CREATE (fh)-[:CAUSED_BY {gene:"APOB", mutation_pct:"5-10%", note:"ApoB-100受体结合域突变（FH-B）"}]->(apob);

MATCH (fh:Disease {id:"disease:FH"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (fh)-[:CAUSED_BY {gene:"PCSK9", mutation_pct:"<1%", note:"功能获得(GoF)突变→LDLR降解增加（ADH3）"}]->(pcsk9);

MATCH (hofh:Disease {id:"disease:HoFH"}), (ldlr:Molecule {id:"mol:LDLR"})
CREATE (hofh)-[:CAUSED_BY {note:"LDLR双等位基因突变（null/null或defective/defective）"}]->(ldlr);

MATCH (type3:Disease {id:"disease:Type3_HLP"}), (apoe:Molecule {id:"mol:ApoE"})
CREATE (type3)-[:CAUSED_BY {gene:"APOE", genotype:"E2/E2纯合", penetrance:"<10%（需第二打击）"}]->(apoe);

MATCH (fcs:Disease {id:"disease:FCS"}), (lpl:Molecule {id:"mol:LPL"})
CREATE (fcs)-[:CAUSED_BY {gene:"LPL", note:"LPL双等位基因LoF突变（最常见原因）"}]->(lpl);

MATCH (fcs:Disease {id:"disease:FCS"}), (apoc2:Molecule {id:"mol:ApoC2"})
CREATE (fcs)-[:CAUSED_BY {gene:"APOC2", note:"ApoC-II缺乏→LPL无法激活"}]->(apoc2);

MATCH (fcs:Disease {id:"disease:FCS"}), (gpihbp1:Molecule {id:"mol:GPIHBP1"})
CREATE (fcs)-[:CAUSED_BY {gene:"GPIHBP1", note:"LPL无法锚定到毛细血管内皮"}]->(gpihbp1);

MATCH (tangier:Disease {id:"disease:Tangier"}), (abca1:Molecule {id:"mol:ABCA1"})
CREATE (tangier)-[:CAUSED_BY {gene:"ABCA1", note:"ABCA1完全缺陷→HDL无法生成"}]->(abca1);

MATCH (lcat_def:Disease {id:"disease:LCAT_def"}), (lcat:Molecule {id:"mol:LCAT"})
CREATE (lcat_def)-[:CAUSED_BY {gene:"LCAT", note:"LCAT缺陷→FC无法酯化→HDL成熟障碍"}]->(lcat);

MATCH (abetalipo:Disease {id:"disease:Abetalipo"}), (mtp:Molecule {id:"mol:MTP"})
CREATE (abetalipo)-[:CAUSED_BY {gene:"MTTP", note:"MTP缺陷→ApoB脂化失败→CM/VLDL无法组装"}]->(mtp);

MATCH (sitosterolemia:Disease {id:"disease:Sitosterolemia"}), (npc1l1:Molecule {id:"mol:NPC1L1"})
CREATE (sitosterolemia)-[:CAUSED_BY {gene:"ABCG5/ABCG8", note:"植物甾醇排泄障碍（非NPC1L1，但NPC1L1是治疗靶点）"}]->(npc1l1);

MATCH (lpa_risk:Disease {id:"disease:LpA_elevated"}), (apoa_:Molecule {id:"mol:ApoA_"})
CREATE (lpa_risk)-[:CAUSED_BY {gene:"LPA", note:"Kringle IV-2重复数少→Lp(a)水平高"}]->(apoa_);

MATCH (masld:Disease {id:"disease:MASLD"}), (vldl:Particle {id:"particle:VLDL"})
CREATE (masld)-[:CAUSED_BY {note:"VLDL分泌不足→肝脏TG堆积; 或脂肪酸氧化受损"}]->(vldl);

MATCH (fch:Disease {id:"disease:FCH"}), (vldl:Particle {id:"particle:VLDL"})
CREATE (fch)-[:CAUSED_BY {note:"肝脏VLDL过度分泌; 多基因（APOB, LPL, USF1等）"}]->(vldl);


// ============================================================
//  SECTION 5: 药物-靶点关系 (TARGETS) — 14 条
// ============================================================

MATCH (statin:Drug {id:"drug:Statin"}), (hmgcr:Molecule {id:"mol:HMGCR"})
CREATE (statin)-[:TARGETS {mechanism:"竞争性抑制"}]->(hmgcr);

MATCH (ezetimibe:Drug {id:"drug:Ezetimibe"}), (npc1l1:Molecule {id:"mol:NPC1L1"})
CREATE (ezetimibe)-[:TARGETS {mechanism:"抑制胆固醇吸收"}]->(npc1l1);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (pcsk9i)-[:TARGETS {mechanism:"单克隆抗体中和"}]->(pcsk9);

MATCH (inclisiran:Drug {id:"drug:Inclisiran"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (inclisiran)-[:TARGETS {mechanism:"siRNA沉默mRNA"}]->(pcsk9);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (ppara:Molecule {id:"mol:PPARa"})
CREATE (fibrate)-[:TARGETS {mechanism:"PPARα激动剂"}]->(ppara);

MATCH (bempedoic:Drug {id:"drug:Bempedoic_acid"}), (hmgcr:Molecule {id:"mol:HMGCR"})
CREATE (bempedoic)-[:TARGETS {mechanism:"抑制ACL（HMGCR上游）"}]->(hmgcr);

MATCH (lomitapide:Drug {id:"drug:Lomitapide"}), (mtp:Molecule {id:"mol:MTP"})
CREATE (lomitapide)-[:TARGETS {mechanism:"MTP抑制剂"}]->(mtp);

MATCH (evinacumab:Drug {id:"drug:Evinacumab"}), (angptl3:Molecule {id:"mol:ANGPTL3"})
CREATE (evinacumab)-[:TARGETS {mechanism:"单克隆抗体中和"}]->(angptl3);

MATCH (volanesersen:Drug {id:"drug:Volanesersen"}), (apoc3:Molecule {id:"mol:ApoC3"})
CREATE (volanesersen)-[:TARGETS {mechanism:"ASO沉默ApoC-III mRNA"}]->(apoc3);

MATCH (olezarsen:Drug {id:"drug:Olezarsen"}), (apoc3:Molecule {id:"mol:ApoC3"})
CREATE (olezarsen)-[:TARGETS {mechanism:"GalNAc-ASO沉默ApoC-III mRNA（下一代）"}]->(apoc3);

MATCH (icosapent:Drug {id:"drug:Icosapent_ethyl"}), (vldl:Particle {id:"particle:VLDL"})
CREATE (icosapent)-[:TARGETS {mechanism:"减少VLDL合成 + 抗炎"}]->(vldl);

MATCH (niacin:Drug {id:"drug:Niacin"}), (lpl:Molecule {id:"mol:LPL"})
CREATE (niacin)-[:TARGETS {mechanism:"间接激活LPL（通过减少FFA）"}]->(lpl);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (ldlr:Molecule {id:"mol:LDLR"})
CREATE (pcsk9i)-[:INDIRECTLY_INCREASES {note:"阻断PCSK9降解LDLR→LDLR数量↑"}]->(ldlr);

MATCH (statin:Drug {id:"drug:Statin"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (statin)-[:INDIRECTLY_INCREASES {note:"SREBP-2激活→同时上调PCSK9（反弹效应，限制LDL-C降幅）"}]->(pcsk9);


// ============================================================
//  SECTION 6: 药物-疾病关系 (TREATS) — 20 条
// ============================================================

MATCH (statin:Drug {id:"drug:Statin"}), (fh:Disease {id:"disease:FH"})
CREATE (statin)-[:TREATS {line:"一线", efficacy:"LDL-C↓30-63%"}]->(fh);

MATCH (statin:Drug {id:"drug:Statin"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (statin)-[:TREATS {line:"一级/二级预防基石", evidence:"多个大型RCT"}]->(ascvd);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (fh:Disease {id:"disease:FH"})
CREATE (pcsk9i)-[:TREATS {line:"二线/三线", note:"他汀未达标时加用"}]->(fh);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (hofh:Disease {id:"disease:HoFH"})
CREATE (pcsk9i)-[:TREATS {efficacy:"LDL-C↓取决于残余LDLR功能; null/null效果差"}]->(hofh);

MATCH (inclisiran:Drug {id:"drug:Inclisiran"}), (fh:Disease {id:"disease:FH"})
CREATE (inclisiran)-[:TREATS {line:"替代PCSK9单抗", advantage:"每年仅2针"}]->(fh);

MATCH (ezetimibe:Drug {id:"drug:Ezetimibe"}), (fh:Disease {id:"disease:FH"})
CREATE (ezetimibe)-[:TREATS {line:"二线（他汀联用）", evidence:"IMPROVE-IT"}]->(fh);

MATCH (ezetimibe:Drug {id:"drug:Ezetimibe"}), (sitosterolemia:Disease {id:"disease:Sitosterolemia"})
CREATE (ezetimibe)-[:TREATS {line:"一线", note:"抑制NPC1L1→植物甾醇吸收↓"}]->(sitosterolemia);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (hta:Disease {id:"disease:HTG"})
CREATE (fibrate)-[:TREATS {line:"高TG一线", efficacy:"TG↓30-50%"}]->(hta);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (type3:Disease {id:"disease:Type3_HLP"})
CREATE (fibrate)-[:TREATS {line:"一线", note:"III型对贝特类反应极好"}]->(type3);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (pancreatitis:Disease {id:"disease:Pancreatitis"})
CREATE (fibrate)-[:TREATS {note:"长期预防（急性期禁用）"}]->(pancreatitis);

MATCH (lomitapide:Drug {id:"drug:Lomitapide"}), (hofh:Disease {id:"disease:HoFH"})
CREATE (lomitapide)-[:TREATS {line:"限制使用", note:"REMS项目; 肝毒性监测"}]->(hofh);

MATCH (evinacumab:Drug {id:"drug:Evinacumab"}), (hofh:Disease {id:"disease:HoFH"})
CREATE (evinacumab)-[:TREATS {line:"专用", advantage:"不依赖LDLR; 对null/null HoFH有效"}]->(hofh);

MATCH (volanesersen:Drug {id:"drug:Volanesersen"}), (fcs:Disease {id:"disease:FCS"})
CREATE (volanesersen)-[:TREATS {line:"专用", region:"仅欧洲", efficacy:"TG↓77%"}]->(fcs);

MATCH (olezarsen:Drug {id:"drug:Olezarsen"}), (fcs:Disease {id:"disease:FCS"})
CREATE (olezarsen)-[:TREATS {status:"Phase 3", note:"下一代ApoC-III ASO"}]->(fcs);

MATCH (icosapent:Drug {id:"drug:Icosapent_ethyl"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (icosapent)-[:TREATS {indication:"ASCVD+高TG（他汀已优化LDL-C）", evidence:"REDUCE-IT CV↓25%"}]->(ascvd);

MATCH (bempedoic:Drug {id:"drug:Bempedoic_acid"}), (fh:Disease {id:"disease:FH"})
CREATE (bempedoic)-[:TREATS {line:"他汀不耐受替代", evidence:"CLEAR Outcomes 2023"}]->(fh);

MATCH (niacin:Drug {id:"drug:Niacin"}), (hta:Disease {id:"disease:HTG"})
CREATE (niacin)-[:TREATS {line:"已较少使用", note:"AIM-HIGH/HPS2-THRIVE未证实额外获益"}]->(hta);

MATCH (statin:Drug {id:"drug:Statin"}), (masld:Disease {id:"disease:MASLD"})
CREATE (statin)-[:TREATS {note:"MASLD患者ASCVD风险高; 他汀安全可用"}]->(masld);

MATCH (statin:Drug {id:"drug:Statin"}), (metabolic_syndrome:Disease {id:"disease:MetS"})
CREATE (statin)-[:TREATS {note:"代谢综合征ASCVD风险高; 需综合管理"}]->(metabolic_syndrome);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (lpa_risk:Disease {id:"disease:LpA_elevated"})
CREATE (pcsk9i)-[:TREATS {efficacy:"Lp(a)↓20-30%（附带效应）", note:"主要目的仍是降LDL-C"}]->(lpa_risk);


// ============================================================
//  SECTION 7: 生物标志物-疾病关系 (BIOMARKER_OF) — 15 条
// ============================================================

MATCH (ldlc:Biomarker {id:"biomarker:LDL_C"}), (fh:Disease {id:"disease:FH"})
CREATE (ldlc)-[:BIOMARKER_OF {pattern:"HeFH: LDL-C 4.9-10 mmol/L; HoFH: >13 mmol/L", role:"首要诊断指标"}]->(fh);

MATCH (ldlc:Biomarker {id:"biomarker:LDL_C"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (ldlc)-[:BIOMARKER_OF {role:"首要危险因素和治疗靶点", target:"极高危 <1.4 mmol/L"}]->(ascvd);

MATCH (tg:Biomarker {id:"biomarker:TG"}), (hta:Disease {id:"disease:HTG"})
CREATE (tg)-[:BIOMARKER_OF {pattern:">1.7 mmol/L", role:"诊断指标"}]->(hta);

MATCH (tg:Biomarker {id:"biomarker:TG"}), (fcs:Disease {id:"disease:FCS"})
CREATE (tg)-[:BIOMARKER_OF {pattern:">10 mmol/L（常 >20）", role:"FCS标志性指标"}]->(fcs);

MATCH (tg:Biomarker {id:"biomarker:TG"}), (pancreatitis:Disease {id:"disease:Pancreatitis"})
CREATE (tg)-[:BIOMARKER_OF {threshold:">11.3 mmol/L风险显著增加; >56极高危", role:"胰腺炎危险因素"}]->(pancreatitis);

MATCH (tg:Biomarker {id:"biomarker:TG"}), (type3:Disease {id:"disease:Type3_HLP"})
CREATE (tg)-[:BIOMARKER_OF {pattern:"TC↑↑ + TG↑↑（平行升高）", role:"III型特征"}]->(type3);

MATCH (hdlc:Biomarker {id:"biomarker:HDL_C"}), (tangier:Disease {id:"disease:Tangier"})
CREATE (hdlc)-[:BIOMARKER_OF {pattern:"HDL-C <0.1 mmol/L（几乎检测不到）", role:"诊断标志"}]->(tangier);

MATCH (hdlc:Biomarker {id:"biomarker:HDL_C"}), (metabolic_syndrome:Disease {id:"disease:MetS"})
CREATE (hdlc)-[:BIOMARKER_OF {threshold:"男<1.0, 女<1.3 mmol/L", role:"代谢综合征诊断标准之一"}]->(metabolic_syndrome);

MATCH (apob:Biomarker {id:"biomarker:ApoB"}), (fch:Disease {id:"disease:FCH"})
CREATE (apob)-[:BIOMARKER_OF {pattern:"ApoB升高（即使LDL-C正常）", role:"FCH关键标志物; 反映致AS颗粒总数"}]->(fch);

MATCH (apob:Biomarker {id:"biomarker:ApoB"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (apob)-[:BIOMARKER_OF {role:"比LDL-C更准确的ASCVD风险预测", target:"极高危 <65 mg/dL"}]->(ascvd);

MATCH (lpa:Biomarker {id:"biomarker:Lpa"}), (lpa_risk:Disease {id:"disease:LpA_elevated"})
CREATE (lpa)-[:BIOMARKER_OF {threshold:">50 mg/dL", role:"诊断指标; 独立ASCVD风险"}]->(lpa_risk);

MATCH (lpa:Biomarker {id:"biomarker:Lpa"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (lpa)-[:BIOMARKER_OF {role:"残余风险因子（LDL-C达标后仍有风险）"}]->(ascvd);

MATCH (nonhdlc:Biomarker {id:"biomarker:non_HDL_C"}), (fch:Disease {id:"disease:FCH"})
CREATE (nonhdlc)-[:BIOMARKER_OF {role:"比LDL-C更全面; 反映所有致AS脂蛋白", target:"极高危 <2.2 mmol/L"}]->(fch);

MATCH (tc:Biomarker {id:"biomarker:TC"}), (fh:Disease {id:"disease:FH"})
CREATE (tc)-[:BIOMARKER_OF {pattern:"HeFH: TC 7-12 mmol/L; HoFH: >15 mmol/L"}]->(fh);

MATCH (apoa1:Biomarker {id:"biomarker:ApoA1"}), (tangier:Disease {id:"disease:Tangier"})
CREATE (apoa1)-[:BIOMARKER_OF {pattern:"ApoA-I极低或缺失", role:"诊断标志"}]->(tangier);


// ============================================================
//  SECTION 8: 药物-标志物影响关系 (AFFECTS_LEVEL) — 15 条
// ============================================================

MATCH (statin:Drug {id:"drug:Statin"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (statin)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"30-63%", dose_response:"剂量每翻倍额外↓6%"}]->(ldlc);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (pcsk9i)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"55-65%"}]->(ldlc);

MATCH (inclisiran:Drug {id:"drug:Inclisiran"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (inclisiran)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"~50%"}]->(ldlc);

MATCH (ezetimibe:Drug {id:"drug:Ezetimibe"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (ezetimibe)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"18-22%"}]->(ldlc);

MATCH (bempedoic:Drug {id:"drug:Bempedoic_acid"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (bempedoic)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"15-25%"}]->(ldlc);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (tg:Biomarker {id:"biomarker:TG"})
CREATE (fibrate)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"30-50%"}]->(tg);

MATCH (fibrate:Drug {id:"drug:Fibrate"}), (hdlc:Biomarker {id:"biomarker:HDL_C"})
CREATE (fibrate)-[:AFFECTS_LEVEL {direction:"increase", magnitude:"10-20%"}]->(hdlc);

MATCH (volanesersen:Drug {id:"drug:Volanesersen"}), (tg:Biomarker {id:"biomarker:TG"})
CREATE (volanesersen)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"~77%"}]->(tg);

MATCH (evinacumab:Drug {id:"drug:Evinacumab"}), (tg:Biomarker {id:"biomarker:TG"})
CREATE (evinacumab)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"~68%"}]->(tg);

MATCH (evinacumab:Drug {id:"drug:Evinacumab"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (evinacumab)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"~49%（HoFH）"}]->(ldlc);

MATCH (icosapent:Drug {id:"drug:Icosapent_ethyl"}), (tg:Biomarker {id:"biomarker:TG"})
CREATE (icosapent)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"20-30%"}]->(tg);

MATCH (niacin:Drug {id:"drug:Niacin"}), (hdlc:Biomarker {id:"biomarker:HDL_C"})
CREATE (niacin)-[:AFFECTS_LEVEL {direction:"increase", magnitude:"15-35%（最强升HDL药物）"}]->(hdlc);

MATCH (niacin:Drug {id:"drug:Niacin"}), (tg:Biomarker {id:"biomarker:TG"})
CREATE (niacin)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"20-50%"}]->(tg);

MATCH (pcsk9i:Drug {id:"drug:PCSK9i"}), (lpa:Biomarker {id:"biomarker:Lpa"})
CREATE (pcsk9i)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"20-30%（附带效应）"}]->(lpa);

MATCH (lomitapide:Drug {id:"drug:Lomitapide"}), (ldlc:Biomarker {id:"biomarker:LDL_C"})
CREATE (lomitapide)-[:AFFECTS_LEVEL {direction:"decrease", magnitude:"40-50%（HoFH）"}]->(ldlc);


// ============================================================
//  SECTION 9: 疾病进展关系 (PROGRESSES_TO / RISK_FOR) — 8 条
// ============================================================

MATCH (fh:Disease {id:"disease:FH"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (fh)-[:RISK_FOR {note:"累积LDL-C暴露→早发ASCVD（HeFH 30-50岁; HoFH儿童期）"}]->(ascvd);

MATCH (hofh:Disease {id:"disease:HoFH"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (hofh)-[:RISK_FOR {note:"极高危; 儿童/青少年即可发生ASCVD"}]->(ascvd);

MATCH (hta:Disease {id:"disease:HTG"}), (pancreatitis:Disease {id:"disease:Pancreatitis"})
CREATE (hta)-[:PROGRESSES_TO {condition:"TG > 11.3 mmol/L"}]->(pancreatitis);

MATCH (fcs:Disease {id:"disease:FCS"}), (pancreatitis:Disease {id:"disease:Pancreatitis"})
CREATE (fcs)-[:RISK_FOR {note:"反复发作; FCS患者终身高风险"}]->(pancreatitis);

MATCH (metabolic_syndrome:Disease {id:"disease:MetS"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (metabolic_syndrome)-[:RISK_FOR {note:"致AS脂三联征 + 胰岛素抵抗 + 炎症"}]->(ascvd);

MATCH (metabolic_syndrome:Disease {id:"disease:MetS"}), (masld:Disease {id:"disease:MASLD"})
CREATE (metabolic_syndrome)-[:RISK_FOR {note:"代谢综合征是MASLD主要驱动因素"}]->(masld);

MATCH (masld:Disease {id:"disease:MASLD"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (masld)-[:RISK_FOR {note:"MASLD患者ASCVD是首要死因（而非肝病）"}]->(ascvd);

MATCH (type3:Disease {id:"disease:Type3_HLP"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (type3)-[:RISK_FOR {note:"IDL和CM残粒致AS性强"}]->(ascvd);


// ============================================================
//  SECTION 10: 验证查询
// ============================================================

// --- 临床层统计 ---
MATCH (n)
WHERE n:Disease OR n:Drug OR n:Biomarker
RETURN labels(n)[0] AS 类型, count(n) AS 数量;

// --- 完整图谱统计（核心 + 临床） ---
MATCH (n) RETURN labels(n)[0] AS 类型, count(n) AS 数量 ORDER BY 数量 DESC;

MATCH ()-[r]->() RETURN type(r) AS 关系类型, count(r) AS 数量 ORDER BY 数量 DESC;

// --- 疾病-基因-药物路径（FH示例） ---
MATCH p = (d:Disease {id:"disease:FH"})-[:CAUSED_BY]->(gene:Molecule)<-[:TARGETS]-(drug:Drug)
RETURN d.name AS 疾病, gene.name AS 致病基因, drug.name AS 靶向药物;

// --- HoFH的完整治疗网络 ---
MATCH (d:Disease {id:"disease:HoFH"})-[r]-(n)
RETURN d.name, type(r) AS 关系, n.name, labels(n)[0] AS 类型;

// --- 药物-标志物影响全景 ---
MATCH (drug:Drug)-[r:AFFECTS_LEVEL]->(bm:Biomarker)
RETURN drug.name AS 药物, bm.name AS 标志物, r.direction AS 方向, r.magnitude AS 幅度
ORDER BY drug.name;

// --- 全局统计 ---
MATCH (n) WITH count(n) AS nodes
MATCH ()-[r]->() WITH nodes, count(r) AS edges
RETURN nodes, edges, round(edges * 1.0 / nodes, 2) AS avg_degree;
