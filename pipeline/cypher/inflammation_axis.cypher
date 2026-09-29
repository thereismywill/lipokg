// ============================================================
//  炎症轴 + 负反馈环路扩展
//  Inflammation Axis + Feedback Loops
//  新增: ~25 节点 + ~40 关系
//  评审来源: Libby P0, G&B P0
// ============================================================


// ============================================================
//  SECTION 1: 炎症传感器/受体 (Inflammation Sensors)
// ============================================================

CREATE (tlr4:Molecule:InflammationSensor {
  id: "mol:TLR4",
  name: "TLR4",
  name_cn: "Toll样受体4",
  gene: "TLR4",
  uniprot: "O00206",
  function: "模式识别受体，识别oxLDL和LPS，激活NF-κB信号通路",
  tissue_specificity: "巨噬细胞、内皮细胞、树突状细胞",
  clinical: "TLR4激活促进动脉粥样硬化炎症；oxLDL是内源性配体",
  evidence: "Libby P, J Clin Invest 2002"
});

CREATE (nlrp3:Molecule:InflammationSensor {
  id: "mol:NLRP3",
  name: "NLRP3",
  name_cn: "NLRP3炎症小体",
  gene: "NLRP3",
  uniprot: "Q96P20",
  function: "细胞内炎症小体复合体，感应胆固醇结晶等危险信号，激活caspase-1→IL-1β成熟",
  tissue_specificity: "巨噬细胞",
  clinical: "胆固醇结晶激活NLRP3是AS炎症的核心机制",
  evidence: "Duewell P et al, Nature 2010"
});

CREATE (cd36:Molecule:ScavengerReceptor {
  id: "mol:CD36",
  name: "CD36",
  name_cn: "CD36清道夫受体",
  gene: "CD36",
  uniprot: "Q08857",
  function: "清道夫受体B家族，无限制摄取oxLDL→泡沫细胞形成；同时作为TLR4/6的共受体",
  tissue_specificity: "巨噬细胞、脂肪细胞、血小板",
  clinical: "CD36促进泡沫细胞形成；也是脂肪酸转运蛋白",
  evidence: "Endemann G et al, JBC 1993"
});

CREATE (sra:Molecule:ScavengerReceptor {
  id: "mol:SR_A",
  name: "SR-A",
  name_cn: "A类清道夫受体",
  gene: "MSR1",
  uniprot: "P21757",
  function: "清道夫受体A家族，无限制摄取oxLDL→泡沫细胞",
  tissue_specificity: "巨噬细胞",
  clinical: "SR-A与CD36共同介导泡沫细胞形成",
  evidence: "Kodama T et al, Nature 1990"
});


// ============================================================
//  SECTION 2: 转录因子/信号分子
// ============================================================

CREATE (nfkb:Molecule:TranscriptionFactor {
  id: "mol:NF_kB",
  name: "NF-κB",
  name_cn: "核因子κB",
  gene: "NFKB1/RELA",
  function: "主转录因子，调控>500个炎症基因表达（IL-1β, IL-6, TNF-α, MMP-9, VCAM-1等）",
  tissue_specificity: "几乎所有细胞（巨噬细胞中活性最高）",
  clinical: "NF-κB是动脉粥样硬化炎症的核心调控者",
  evidence: "Libby P, Circulation 2001"
});

CREATE (ifng:Molecule:Cytokine {
  id: "mol:IFN_g",
  name: "IFN-γ",
  name_cn: "干扰素γ",
  gene: "IFNG",
  function: "Th1细胞因子，抑制SMC增殖和胶原合成→促进斑块不稳定；激活巨噬细胞",
  tissue_specificity: "T细胞、NK细胞",
  clinical: "IFN-γ使斑块从稳定型转为易损型",
  evidence: "Libby P, J Clin Invest 1995"
});

CREATE (tgfb:Molecule:Cytokine {
  id: "mol:TGF_b",
  name: "TGF-β",
  name_cn: "转化生长因子β",
  gene: "TGFB1",
  function: "抗炎细胞因子，促进SMC增殖和胶原合成→稳定纤维帽；抑制巨噬细胞活化",
  tissue_specificity: "广泛表达",
  clinical: "TGF-β促进斑块稳定；与IFN-γ作用相反",
  evidence: "Ruiz-Ortega M et al, Cardiovasc Res 2007"
});


// ============================================================
//  SECTION 3: 炎症因子 (Pro-inflammatory Cytokines)
// ============================================================

CREATE (il1b:Molecule:Cytokine {
  id: "mol:IL1B",
  name: "IL-1β",
  name_cn: "白介素1β",
  gene: "IL1B",
  function: "关键促炎因子，NLRP3炎症小体激活caspase-1剪切pro-IL-1β→成熟IL-1β",
  tissue_specificity: "巨噬细胞（主要）",
  clinical: "CANTOS试验证实靶向IL-1β可降低心血管事件15%",
  evidence: "Ridker PM et al, NEJM 2017 (CANTOS)"
});

CREATE (il6:Molecule:Cytokine {
  id: "mol:IL6",
  name: "IL-6",
  name_cn: "白介素6",
  gene: "IL6",
  function: "IL-1β下游关键介质，刺激肝脏产生CRP和纤维蛋白原",
  tissue_specificity: "巨噬细胞、T细胞、内皮细胞",
  clinical: "IL-6是IL-1β→CRP通路的关键中间环节；Ziltivekimab靶点",
  evidence: "Ridker PM et al, Lancet 2020"
});

CREATE (tnfa:Molecule:Cytokine {
  id: "mol:TNF_a",
  name: "TNF-α",
  name_cn: "肿瘤坏死因子α",
  gene: "TNF",
  function: "强效促炎因子，激活NF-κB，促进内皮激活和巨噬细胞浸润",
  tissue_specificity: "巨噬细胞（主要）",
  clinical: "TNF-α上调PCSK9表达（间接升高LDL-C）；促斑块炎症",
  evidence: "Rezaie-Majd A et al, Arterioscler Thromb Vasc Biol 2006"
});

CREATE (il18:Molecule:Cytokine {
  id: "mol:IL18",
  name: "IL-18",
  name_cn: "白介素18",
  gene: "IL18",
  function: "NLRP3炎症小体下游因子，促进IFN-γ产生（Th1极化）",
  tissue_specificity: "巨噬细胞",
  clinical: "IL-18是AS独立风险因子；连接固有免疫和适应性免疫",
  evidence: "Blankenberg S et al, Circulation 2003"
});

CREATE (mcp1:Molecule:Chemokine {
  id: "mol:MCP1",
  name: "MCP-1/CCL2",
  name_cn: "单核细胞趋化蛋白1",
  gene: "CCL2",
  function: "关键趋化因子，招募单核细胞从血液进入血管内膜→分化为巨噬细胞",
  tissue_specificity: "内皮细胞、SMC、巨噬细胞（受oxLDL诱导）",
  clinical: "MCP-1是单核细胞浸润内膜的'邀请函'",
  evidence: "Yla-Herttuala S et al, PNAS 1991"
});


// ============================================================
//  SECTION 4: 黏附分子 (Adhesion Molecules)
// ============================================================

CREATE (vcam1:Molecule:AdhesionMolecule {
  id: "mol:VCAM1",
  name: "VCAM-1",
  name_cn: "血管细胞黏附分子1",
  gene: "VCAM1",
  function: "内皮表面黏附分子，NF-κB上调表达→捕获血液中的单核细胞",
  tissue_specificity: "激活的内皮细胞",
  clinical: "VCAM-1是内皮激活和早期AS的标志",
  evidence: "Cybulsky MI et al, J Clin Invest 2001"
});

CREATE (icam1:Molecule:AdhesionMolecule {
  id: "mol:ICAM1",
  name: "ICAM-1",
  name_cn: "细胞间黏附分子1",
  gene: "ICAM1",
  function: "内皮表面黏附分子，协助单核细胞和T细胞黏附",
  tissue_specificity: "激活的内皮细胞",
  clinical: "ICAM-1升高与AS风险增加相关",
  evidence: "Blankenberg S et al, Circulation 2003"
});


// ============================================================
//  SECTION 5: 基质金属蛋白酶 (MMPs)
// ============================================================

CREATE (mmp9:Molecule:Protease {
  id: "mol:MMP9",
  name: "MMP-9",
  name_cn: "基质金属蛋白酶9",
  gene: "MMP9",
  function: "降解IV型胶原和弹性蛋白→削弱纤维帽→斑块破裂",
  tissue_specificity: "巨噬细胞（NF-κB诱导）",
  clinical: "MMP-9是斑块不稳定的关键效应分子",
  evidence: "Galis ZS et al, J Clin Invest 1994"
});

CREATE (mmp2:Molecule:Protease {
  id: "mol:MMP2",
  name: "MMP-2",
  name_cn: "基质金属蛋白酶2",
  gene: "MMP2",
  function: "降解基底膜IV型胶原→促进SMC迁移和斑块重塑",
  tissue_specificity: "SMC、内皮细胞",
  clinical: "MMP-2参与血管重塑和斑块稳定性调节",
  evidence: "Galis ZS et al, Ann N Y Acad Sci 1995"
});


// ============================================================
//  SECTION 6: 消退介质 (Resolution Mediators)
// ============================================================

CREATE (il10:Molecule:AntiInflammatory {
  id: "mol:IL10",
  name: "IL-10",
  name_cn: "白介素10",
  gene: "IL10",
  function: "关键抗炎因子，抑制NF-κB激活→减少促炎因子产生；促进M2巨噬细胞极化",
  tissue_specificity: "调节性T细胞、M2巨噬细胞",
  clinical: "IL-10水平低与AS风险增加相关",
  evidence: "Pinderski LJ et al, Circulation 2002"
});

CREATE (resolvin:Molecule:LipidMediator {
  id: "mol:Resolvin",
  name: "Resolvin",
  name_cn: "消退素",
  function: "ω-3脂肪酸衍生的促消退介质（SPM），主动终止炎症反应",
  subtypes: "RvD1, RvD2, RvE1 等",
  tissue_specificity: "巨噬细胞",
  clinical: "Resolvin促进炎症消退；ω-3脂肪酸的部分获益可能通过SPM介导",
  evidence: "Serhan CN, Nature Reviews Immunology 2014"
});


// ============================================================
//  SECTION 7: 临床炎症标志物
// ============================================================

CREATE (hscrp:Biomarker:InflammationMarker {
  id: "biomarker:hsCRP",
  name: "hs-CRP",
  name_cn: "超敏C反应蛋白",
  gene: "CRP",
  unit: "mg/L",
  normal_range: "< 1.0 低风险; 1.0-3.0 中风险; > 3.0 高风险",
  function: "肝脏在IL-6刺激下产生，是全身炎症的标志物",
  clinical_significance: "ASCVD独立风险因子；CANTOS试验证实降炎症可降低CV事件",
  evidence: "Ridker PM et al, NEJM 2000 (PHS); Ridker, NEJM 2017 (CANTOS)"
});

CREATE (plaque_rupture:Disease:ClinicalEvent {
  id: "event:PlaqueRupture",
  name: "斑块破裂",
  name_en: "Plaque Rupture",
  description: "薄纤维帽断裂→脂质核心暴露→血栓形成→急性冠脉综合征",
  pathogenesis: "MMP降解胶原 + SMC凋亡 + 炎症浸润 → 纤维帽变薄 → 破裂",
  clinical: "急性心肌梗死和不稳定型心绞痛的直接原因",
  icd11: "BA41"
});


// ============================================================
//  SECTION 8: 炎症轴核心关系 (Inflammation Relationships)
// ============================================================

// --- 脂质触发炎症 ---
MATCH (oxldl:Particle {id:"particle:oxLDL"}), (tlr4:Molecule {id:"mol:TLR4"})
CREATE (oxldl)-[:ACTIVATES {
  mechanism: "oxLDL作为内源性DAMP激活TLR4信号通路",
  evidence: "Stewart CR et al, Nat Immunol 2010",
  evidence_level: "B"
}]->(tlr4);

MATCH (oxldl:Particle {id:"particle:oxLDL"}), (cd36:Molecule {id:"mol:CD36"})
CREATE (oxldl)-[:ACTIVATES {
  mechanism: "CD36无限制摄取oxLDL→泡沫细胞; 同时作为TLR4/6共受体",
  evidence: "Endemann G et al, JBC 1993",
  evidence_level: "B"
}]->(cd36);

MATCH (oxldl:Particle {id:"particle:oxLDL"}), (sra:Molecule {id:"mol:SR_A"})
CREATE (oxldl)-[:ACTIVATES {
  mechanism: "SR-A无限制摄取oxLDL→泡沫细胞形成",
  evidence: "Kodama T et al, Nature 1990",
  evidence_level: "B"
}]->(sra);

MATCH (oxldl:Particle {id:"particle:oxLDL"}), (mcp1:Molecule {id:"mol:MCP1"})
CREATE (oxldl)-[:INDUCES {
  mechanism: "oxLDL刺激内皮细胞和SMC产生MCP-1→招募单核细胞",
  evidence: "Yla-Herttuala S et al, PNAS 1991",
  evidence_level: "B"
}]->(mcp1);


// --- 炎症小体通路 ---
MATCH (nlrp3:Molecule {id:"mol:NLRP3"}), (il1b:Molecule {id:"mol:IL1B"})
CREATE (nlrp3)-[:ACTIVATES {
  mechanism: "NLRP3炎症小体激活caspase-1→剪切pro-IL-1β→成熟IL-1β分泌",
  evidence: "Duewell P et al, Nature 2010",
  evidence_level: "A"
}]->(il1b);

MATCH (nlrp3:Molecule {id:"mol:NLRP3"}), (il18:Molecule {id:"mol:IL18"})
CREATE (nlrp3)-[:ACTIVATES {
  mechanism: "NLRP3同时激活caspase-1→剪切pro-IL-18→成熟IL-18",
  evidence: "Duewell P et al, Nature 2010",
  evidence_level: "B"
}]->(il18);


// --- TLR4 → NF-κB 信号 ---
MATCH (tlr4:Molecule {id:"mol:TLR4"}), (nfkb:Molecule {id:"mol:NF_kB"})
CREATE (tlr4)-[:ACTIVATES {
  mechanism: "TLR4→MyD88→IRAK→TRAF6→IKK→NF-κB核转位",
  evidence: "Akira S, Takeda K, Nat Rev Immunol 2004",
  evidence_level: "B"
}]->(nfkb);


// --- NF-κB 下游效应 ---
MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (il1b:Molecule {id:"mol:IL1B"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调pro-IL-1β转录",
  evidence_level: "B"
}]->(il1b);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (il6:Molecule {id:"mol:IL6"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调IL-6转录",
  evidence_level: "B"
}]->(il6);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (tnfa:Molecule {id:"mol:TNF_a"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调TNF-α转录",
  evidence_level: "B"
}]->(tnfa);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (mmp9:Molecule {id:"mol:MMP9"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调MMP-9转录→降解胶原→纤维帽变薄",
  evidence: "Galis ZS et al, J Clin Invest 1994",
  evidence_level: "B"
}]->(mmp9);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (vcam1:Molecule {id:"mol:VCAM1"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调内皮VCAM-1表达→单核细胞黏附",
  evidence: "Cybulsky MI et al, J Clin Invest 2001",
  evidence_level: "B"
}]->(vcam1);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (icam1:Molecule {id:"mol:ICAM1"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调内皮ICAM-1表达",
  evidence_level: "B"
}]->(icam1);

MATCH (nfkb:Molecule {id:"mol:NF_kB"}), (mcp1:Molecule {id:"mol:MCP1"})
CREATE (nfkb)-[:ACTIVATES {
  mechanism: "NF-κB上调MCP-1转录→单核细胞趋化",
  evidence_level: "B"
}]->(mcp1);


// --- IL-1β → IL-6 → CRP 级联 ---
MATCH (il1b:Molecule {id:"mol:IL1B"}), (il6:Molecule {id:"mol:IL6"})
CREATE (il1b)-[:ACTIVATES {
  mechanism: "IL-1β刺激巨噬细胞和T细胞产生IL-6",
  evidence: "Dinarello CA, Blood 1996",
  evidence_level: "A"
}]->(il6);

MATCH (il6:Molecule {id:"mol:IL6"}), (hscrp:Biomarker {id:"biomarker:hsCRP"})
CREATE (il6)-[:INDUCES {
  mechanism: "IL-6通过JAK-STAT3信号刺激肝细胞产生CRP",
  evidence: "Heinrich PC et al, Biochem J 1990",
  evidence_level: "A"
}]->(hscrp);


// --- IL-18 → IFN-γ ---
MATCH (il18:Molecule {id:"mol:IL18"}), (ifng:Molecule {id:"mol:IFN_g"})
CREATE (il18)-[:ACTIVATES {
  mechanism: "IL-18与IL-12协同诱导T细胞产生IFN-γ（Th1极化）",
  evidence: "Okamura H et al, Nature 1995",
  evidence_level: "B"
}]->(ifng);


// --- IFN-γ vs TGF-β 斑块稳定性轴 ---
MATCH (ifng:Molecule {id:"mol:IFN_g"}), (mmp9:Molecule {id:"mol:MMP9"})
CREATE (ifng)-[:ACTIVATES {
  mechanism: "IFN-γ诱导巨噬细胞产生MMP-9→降解纤维帽",
  evidence_level: "B"
}]->(mmp9);

MATCH (ifng:Molecule {id:"mol:IFN_g"}), (mmp2:Molecule {id:"mol:MMP2"})
CREATE (ifng)-[:ACTIVATES {
  mechanism: "IFN-γ诱导SMC产生MMP-2→基底膜降解",
  evidence_level: "B"
}]->(mmp2);

MATCH (tgfb:Molecule {id:"mol:TGF_b"}), (mmp9:Molecule {id:"mol:MMP9"})
CREATE (tgfb)-[:INHIBITS {
  mechanism: "TGF-β抑制MMP-9表达→保护纤维帽",
  evidence: "Wang M et al, Circulation 2010",
  evidence_level: "B"
}]->(mmp9);


// --- MMP → 斑块破裂 ---
MATCH (mmp9:Molecule {id:"mol:MMP9"}), (pr:Disease {id:"event:PlaqueRupture"})
CREATE (mmp9)-[:RISK_FOR {
  mechanism: "MMP-9降解IV型胶原→纤维帽变薄(<65μm)→斑块破裂",
  evidence: "Galis ZS et al, J Clin Invest 1994",
  evidence_level: "A"
}]->(pr);


// --- 抗炎/消退通路 ---
MATCH (il10:Molecule {id:"mol:IL10"}), (nfkb:Molecule {id:"mol:NF_kB"})
CREATE (il10)-[:INHIBITS {
  mechanism: "IL-10通过SOCS3抑制NF-κB信号→减少促炎因子",
  evidence: "Pinderski LJ et al, Circulation 2002",
  evidence_level: "B",
  feedback: "negative"
}]->(nfkb);

MATCH (il10:Molecule {id:"mol:IL10"}), (tnfa:Molecule {id:"mol:TNF_a"})
CREATE (il10)-[:INHIBITS {
  mechanism: "IL-10抑制TNF-α产生",
  evidence_level: "B"
}]->(tnfa);

MATCH (resolvin:Molecule {id:"mol:Resolvin"}), (nfkb:Molecule {id:"mol:NF_kB"})
CREATE (resolvin)-[:INHIBITS {
  mechanism: "Resolvin通过ALX/FPR2受体抑制NF-κB→主动消退炎症",
  evidence: "Serhan CN, Nat Rev Immunol 2014",
  evidence_level: "B"
}]->(nfkb);


// --- TNF-α → PCSK9 正反馈（炎症加重血脂异常） ---
MATCH (tnfa:Molecule {id:"mol:TNF_a"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (tnfa)-[:ACTIVATES {
  mechanism: "TNF-α上调PCSK9转录→LDLR降解增加→LDL-C↑→更多oxLDL→炎症加重",
  evidence: "Rezaie-Majd A et al, ATVB 2006",
  evidence_level: "C",
  feedback: "positive"
}]->(pcsk9);


// --- 巨噬细胞与炎症节点的关系 ---
MATCH (mac:Organ {id:"organ:macrophage"}), (tlr4:Molecule {id:"mol:TLR4"})
CREATE (tlr4)-[:EXPRESSED_IN {relative_level: "high"}]->(mac);

MATCH (mac:Organ {id:"organ:macrophage"}), (nlrp3:Molecule {id:"mol:NLRP3"})
CREATE (nlrp3)-[:EXPRESSED_IN {relative_level: "high"}]->(mac);

MATCH (mac:Organ {id:"organ:macrophage"}), (cd36:Molecule {id:"mol:CD36"})
CREATE (cd36)-[:EXPRESSED_IN {relative_level: "high"}]->(mac);

MATCH (mac:Organ {id:"organ:macrophage"}), (il1b:Molecule {id:"mol:IL1B"})
CREATE (il1b)-[:EXPRESSED_IN {relative_level: "high", note: "主要来源"}]->(mac);

MATCH (mac:Organ {id:"organ:macrophage"}), (nfkb:Molecule {id:"mol:NF_kB"})
CREATE (nfkb)-[:EXPRESSED_IN {relative_level: "high"}]->(mac);


// --- 炎症节点与血管壁的关系 ---
MATCH (vw:Organ {id:"organ:vascular_wall"}), (vcam1:Molecule {id:"mol:VCAM1"})
CREATE (vcam1)-[:EXPRESSED_IN {relative_level: "moderate", note: "内皮激活时高表达"}]->(vw);

MATCH (vw:Organ {id:"organ:vascular_wall"}), (icam1:Molecule {id:"mol:ICAM1"})
CREATE (icam1)-[:EXPRESSED_IN {relative_level: "moderate"}]->(vw);

MATCH (vw:Organ {id:"organ:vascular_wall"}), (mmp9:Molecule {id:"mol:MMP9"})
CREATE (mmp9)-[:EXPRESSED_IN {note: "斑块内巨噬细胞"}]->(vw);


// --- 疾病关联 ---
MATCH (hscrp:Biomarker {id:"biomarker:hsCRP"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (hscrp)-[:BIOMARKER_OF {
  role: "独立风险因子; hs-CRP > 2 mg/L 提示残余炎症风险",
  evidence_level: "A",
  trial: "CANTOS, JUPITER, PHS"
}]->(ascvd);

MATCH (pr:Disease {id:"event:PlaqueRupture"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (pr)-[:RISK_FOR {
  note: "斑块破裂是急性冠脉综合征的直接原因"
}]->(ascvd);


// ============================================================
//  SECTION 9: 负反馈环路标注 (Feedback Loop Annotations)
// ============================================================

// --- 反馈环路1: 胆固醇稳态（SREBP2 环路） ---
// SREBP-2 → LDLR↑ → LDL清除↑ → 细胞内胆固醇↑ → SREBP-2↓ (negative feedback)
MATCH (srebp2:Molecule {id:"mol:SREBP2"}), (ldlr:Molecule {id:"mol:LDLR"})
WHERE NOT (srebp2)-[:ACTIVATES {feedback:"negative_cholesterol"}]->(ldlr)
SET srebp2.feedback_loop_cholesterol = "SREBP2→LDLR→LDL清除→胆固醇↑→SREBP2↓ (负反馈)";

// --- 反馈环路2: SREBP2-PCSK9 反弹效应 ---
// 他汀→HMGCR抑制→胆固醇↓→SREBP2激活→LDLR↑+PCSK9↑→PCSK9降解LDLR→抵消效果
MATCH (statin:Drug {id:"drug:Statin"}), (pcsk9:Molecule {id:"mol:PCSK9"})
WHERE NOT (statin)-[:INDIRECTLY_INCREASES]->(pcsk9)
MATCH (statin:Drug {id:"drug:Statin"}), (pcsk9:Molecule {id:"mol:PCSK9"})
CREATE (statin)-[:INDIRECTLY_INCREASES {
  mechanism: "他汀抑制HMGCR→胆固醇↓→SREBP2激活→同时上调PCSK9→反弹效应",
  clinical_note: "他汀联合PCSK9i可避免此反弹，LDL-C降幅从63%提升到80%+",
  evidence: "Seidah NG et al, PNAS 2003",
  feedback: "statin_rebound"
}]->(pcsk9);

// --- 反馈环路3: 炎症-血脂正反馈（恶性循环） ---
// oxLDL→TLR4→NF-κB→TNF-α→PCSK9↑→LDLR↓→LDL-C↑→更多oxLDL
MATCH (oxldl:Particle {id:"particle:oxLDL"}), (ascvd:Disease {id:"disease:ASCVD"})
WHERE NOT (oxldl)-[:RISK_FOR {feedback:"inflammatory_vicious_cycle"}]->(ascvd)
MATCH (oxldl:Particle {id:"particle:oxLDL"}), (ascvd:Disease {id:"disease:ASCVD"})
CREATE (oxldl)-[:RISK_FOR {
  mechanism: "oxLDL驱动炎症→炎症上调PCSK9→LDL-C↑→更多oxLDL（正反馈恶性循环）",
  feedback: "inflammatory_vicious_cycle",
  evidence: "Libby P, Nat Med 2002"
}]->(ascvd);


// ============================================================
//  SECTION 10: 将炎症节点分配到通路
// ============================================================

// 炎症节点属于 lipid_inflammation 通路
MATCH (n)
WHERE n.id IN [
  "mol:TLR4", "mol:NLRP3", "mol:CD36", "mol:SR_A",
  "mol:NF_kB", "mol:IL1B", "mol:IL6", "mol:TNF_a",
  "mol:IL18", "mol:MCP1", "mol:IFN_g", "mol:TGF_b",
  "mol:VCAM1", "mol:ICAM1", "mol:MMP9", "mol:MMP2",
  "mol:IL10", "mol:Resolvin",
  "biomarker:hsCRP", "event:PlaqueRupture"
]
SET n.pathway = "lipid_inflammation";


// ============================================================
//  SECTION 11: 验证查询
// ============================================================

// 新增节点统计
MATCH (n)
WHERE n.pathway = "lipid_inflammation"
RETURN labels(n)[0] AS 类型, count(n) AS 数量;

// 全局统计
MATCH (n) WITH count(n) AS nodes
MATCH ()-[r]->() WITH nodes, count(r) AS edges
RETURN nodes, edges, round(edges * 1.0 / nodes, 2) AS avg_degree;

// 炎症轴关系链
MATCH p = (oxldl:Particle {id:"particle:oxLDL"})-[*1..4]->(hscrp:Biomarker {id:"biomarker:hsCRP"})
RETURN p LIMIT 3;

// 查找所有负反馈环路标注
MATCH (a)-[r]->(b)
WHERE r.feedback IS NOT NULL
RETURN a.name AS source, type(r) AS relation, b.name AS target, r.feedback AS 环路类型;
