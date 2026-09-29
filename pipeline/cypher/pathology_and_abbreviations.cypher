// ============================================================
//  重大重构：疾病→病理状态、缩写名、外部链接、表达谱
// ============================================================

// ===== 第1步：为所有分子节点添加缩写和外部链接 =====

// 载脂蛋白缩写
MATCH (m:Molecule {id:"mol:ApoA1"})
SET m.abbrev = "ApoA-I", m.abbrev_cn = "载脂A1",
    m.uniprot_id = "P02647", m.hpa_id = "ENSG00000118125", m.genecards_id = "APOA1",
    m.reactome_id = "R-HSA-216756";

MATCH (m:Molecule {id:"mol:ApoA2"})
SET m.abbrev = "ApoA-II", m.abbrev_cn = "载脂A2",
    m.uniprot_id = "P02652", m.hpa_id = "ENSG00000158352", m.genecards_id = "APOA2";

MATCH (m:Molecule {id:"mol:ApoB100"})
SET m.abbrev = "ApoB", m.abbrev_cn = "载脂B",
    m.uniprot_id = "P04114", m.hpa_id = "ENSG00000084674", m.genecards_id = "APOB";

MATCH (m:Molecule {id:"mol:ApoC1"})
SET m.abbrev = "ApoC-I", m.abbrev_cn = "载脂C1",
    m.uniprot_id = "P02654", m.hpa_id = "ENSG00000130208", m.genecards_id = "APOC1";

MATCH (m:Molecule {id:"mol:ApoC2"})
SET m.abbrev = "ApoC-II", m.abbrev_cn = "载脂C2",
    m.uniprot_id = "P02655", m.hpa_id = "ENSG00000104853", m.genecards_id = "APOC2";

MATCH (m:Molecule {id:"mol:ApoC3"})
SET m.abbrev = "ApoC-III", m.abbrev_cn = "载脂C3",
    m.uniprot_id = "P02656", m.hpa_id = "ENSG00000105239", m.genecards_id = "APOC3";

MATCH (m:Molecule {id:"mol:ApoE"})
SET m.abbrev = "ApoE", m.abbrev_cn = "载脂E",
    m.uniprot_id = "P02649", m.hpa_id = "ENSG00000130203", m.genecards_id = "APOE";

MATCH (m:Molecule {id:"mol:ApoA_"})
SET m.abbrev = "Apo(a)", m.abbrev_cn = "脂蛋白a",
    m.uniprot_id = "P08519", m.hpa_id = "ENSG00000198670", m.genecards_id = "LPA";

// 酶缩写
MATCH (m:Molecule {id:"mol:LPL"})
SET m.abbrev = "LPL", m.abbrev_cn = "脂解酶",
    m.uniprot_id = "P06858", m.hpa_id = "ENSG00000175445", m.genecards_id = "LPL",
    m.reactome_id = "R-HSA-174757";

MATCH (m:Molecule {id:"mol:HL"})
SET m.abbrev = "HL", m.abbrev_cn = "肝脂酶",
    m.uniprot_id = "P11150", m.hpa_id = "ENSG00000166914", m.genecards_id = "LIPC";

MATCH (m:Molecule {id:"mol:LCAT"})
SET m.abbrev = "LCAT", m.abbrev_cn = "卵胆转",
    m.uniprot_id = "P04180", m.hpa_id = "ENSG00000166912", m.genecards_id = "LCAT";

MATCH (m:Molecule {id:"mol:EL"})
SET m.abbrev = "EL", m.abbrev_cn = "内皮酶",
    m.uniprot_id = "Q9Y5X9", m.hpa_id = "ENSG00000101670", m.genecards_id = "LIPG";

MATCH (m:Molecule {id:"mol:ACAT"})
SET m.abbrev = "ACAT", m.abbrev_cn = "酰胆转",
    m.uniprot_id = "P35510", m.hpa_id = "ENSG00000124795", m.genecards_id = "SOAT1";

MATCH (m:Molecule {id:"mol:HMGCR"})
SET m.abbrev = "HMGCR", m.abbrev_cn = "还甲酶",
    m.uniprot_id = "P04035", m.hpa_id = "ENSG00000113161", m.genecards_id = "HMGCR",
    m.reactome_id = "R-HSA-191273";

// 受体/转运蛋白缩写
MATCH (m:Molecule {id:"mol:LDLR"})
SET m.abbrev = "LDLR", m.abbrev_cn = "低密受",
    m.uniprot_id = "P01130", m.hpa_id = "ENSG00000130164", m.genecards_id = "LDLR",
    m.reactome_id = "R-HSA-174824";

MATCH (m:Molecule {id:"mol:LRP1"})
SET m.abbrev = "LRP1", m.abbrev_cn = "相关受",
    m.uniprot_id = "Q07954", m.hpa_id = "ENSG00000182379", m.genecards_id = "LRP1";

MATCH (m:Molecule {id:"mol:SR_BI"})
SET m.abbrev = "SR-BI", m.abbrev_cn = "清道受",
    m.uniprot_id = "Q8WTV0", m.hpa_id = "ENSG00000059804", m.genecards_id = "SCARB1";

MATCH (m:Molecule {id:"mol:VLDLR"})
SET m.abbrev = "VLDLR", m.abbrev_cn = "极低受",
    m.uniprot_id = "P98155", m.hpa_id = "ENSG00000147852", m.genecards_id = "VLDLR";

MATCH (m:Molecule {id:"mol:ABCA1"})
SET m.abbrev = "ABCA1", m.abbrev_cn = "转运A1",
    m.uniprot_id = "O95477", m.hpa_id = "ENSG00000165029", m.genecards_id = "ABCA1";

MATCH (m:Molecule {id:"mol:ABCG1"})
SET m.abbrev = "ABCG1", m.abbrev_cn = "转运G1",
    m.uniprot_id = "P45844", m.hpa_id = "ENSG00000160179", m.genecards_id = "ABCG1";

MATCH (m:Molecule {id:"mol:NPC1L1"})
SET m.abbrev = "NPC1L1", m.abbrev_cn = "尼曼C1",
    m.uniprot_id = "Q9UHC9", m.hpa_id = "ENSG00000138075", m.genecards_id = "NPC1L1";

MATCH (m:Molecule {id:"mol:MTP"})
SET m.abbrev = "MTP", m.abbrev_cn = "甘转蛋",
    m.uniprot_id = "P55157", m.hpa_id = "ENSG00000164687", m.genecards_id = "MTTP";

MATCH (m:Molecule {id:"mol:GPIHBP1"})
SET m.abbrev = "GPIHBP", m.abbrev_cn = "锚定蛋",
    m.uniprot_id = "Q8IV16", m.hpa_id = "ENSG00000153510", m.genecards_id = "GPIHBP1";

// 调控因子缩写
MATCH (m:Molecule {id:"mol:PCSK9"})
SET m.abbrev = "PCSK9", m.abbrev_cn = "枯蛋9",
    m.uniprot_id = "Q8NBP7", m.hpa_id = "ENSG00000169174", m.genecards_id = "PCSK9";

MATCH (m:Molecule {id:"mol:ANGPTL3"})
SET m.abbrev = "ANG3", m.abbrev_cn = "管素3",
    m.uniprot_id = "Q9Y5C1", m.hpa_id = "ENSG00000132855", m.genecards_id = "ANGPTL3";

MATCH (m:Molecule {id:"mol:ANGPTL4"})
SET m.abbrev = "ANG4", m.abbrev_cn = "管素4",
    m.uniprot_id = "Q9BY76", m.hpa_id = "ENSG00000167772", m.genecards_id = "ANGPTL4";

MATCH (m:Molecule {id:"mol:ANGPTL8"})
SET m.abbrev = "ANG8", m.abbrev_cn = "管素8",
    m.uniprot_id = "Q9H9S8", m.hpa_id = "ENSG00000260111", m.genecards_id = "ANGPTL8";

MATCH (m:Molecule {id:"mol:SREBP2"})
SET m.abbrev = "SREBP", m.abbrev_cn = "固调",
    m.uniprot_id = "P36956", m.hpa_id = "ENSG00000124575", m.genecards_id = "SREBF2";

MATCH (m:Molecule {id:"mol:LXR"})
SET m.abbrev = "LXR", m.abbrev_cn = "肝X",
    m.uniprot_id = "Q13133", m.hpa_id = "ENSG00000000003", m.genecards_id = "NR1H3";

MATCH (m:Molecule {id:"mol:PPARa"})
SET m.abbrev = "PPARa", m.abbrev_cn = "过增a",
    m.uniprot_id = "Q03181", m.hpa_id = "ENSG00000186951", m.genecards_id = "PPARA";

MATCH (m:Molecule {id:"mol:CETP"})
SET m.abbrev = "CETP", m.abbrev_cn = "胆转蛋",
    m.uniprot_id = "P11597", m.hpa_id = "ENSG00000146635", m.genecards_id = "CETP";

MATCH (m:Molecule {id:"mol:PLTP"})
SET m.abbrev = "PLTP", m.abbrev_cn = "磷转蛋",
    m.uniprot_id = "P55058", m.hpa_id = "ENSG00000101263", m.genecards_id = "PLTP";

// 炎症相关分子缩写
MATCH (m:Molecule {id:"mol:TLR4"})
SET m.abbrev = "TLR4", m.abbrev_cn = "托受4",
    m.uniprot_id = "O00206", m.hpa_id = "ENSG00000174058", m.genecards_id = "TLR4";

MATCH (m:Molecule {id:"mol:NLRP3"})
SET m.abbrev = "NLRP3", m.abbrev_cn = "炎体3",
    m.uniprot_id = "Q96P20", m.hpa_id = "ENSG00000165827", m.genecards_id = "NLRP3";

MATCH (m:Molecule {id:"mol:CD36"})
SET m.abbrev = "CD36", m.abbrev_cn = "清道36",
    m.uniprot_id = "Q08857", m.hpa_id = "ENSG00000135218", m.genecards_id = "CD36";

MATCH (m:Molecule {id:"mol:SR_A"})
SET m.abbrev = "SR-A", m.abbrev_cn = "清道A",
    m.uniprot_id = "P21757", m.hpa_id = "ENSG00000147065", m.genecards_id = "MSR1";

MATCH (m:Molecule {id:"mol:NF_kB"})
SET m.abbrev = "NFkB", m.abbrev_cn = "核因子",
    m.uniprot_id = "P19838", m.hpa_id = "ENSG00000109320", m.genecards_id = "NFKB1";

MATCH (m:Molecule {id:"mol:IL1B"})
SET m.abbrev = "IL1b", m.abbrev_cn = "白介1b",
    m.uniprot_id = "P01584", m.hpa_id = "ENSG00000125538", m.genecards_id = "IL1B";

MATCH (m:Molecule {id:"mol:IL6"})
SET m.abbrev = "IL-6", m.abbrev_cn = "白介6",
    m.uniprot_id = "P05231", m.hpa_id = "ENSG00000136244", m.genecards_id = "IL6";

MATCH (m:Molecule {id:"mol:TNF_a"})
SET m.abbrev = "TNFa", m.abbrev_cn = "肿坏a",
    m.uniprot_id = "P01375", m.hpa_id = "ENSG00000230108", m.genecards_id = "TNF";

MATCH (m:Molecule {id:"mol:IL18"})
SET m.abbrev = "IL18", m.abbrev_cn = "白介18",
    m.uniprot_id = "Q14116", m.hpa_id = "ENSG00000150782", m.genecards_id = "IL18";

MATCH (m:Molecule {id:"mol:MCP1"})
SET m.abbrev = "MCP1", m.abbrev_cn = "趋化1",
    m.uniprot_id = "P13500", m.hpa_id = "ENSG00000108691", m.genecards_id = "CCL2";

MATCH (m:Molecule {id:"mol:IFN_g"})
SET m.abbrev = "IFNg", m.abbrev_cn = "干扰g",
    m.uniprot_id = "P01579", m.hpa_id = "ENSG00000111536", m.genecards_id = "IFNG";

MATCH (m:Molecule {id:"mol:TGF_b"})
SET m.abbrev = "TGFb", m.abbrev_cn = "转因b",
    m.uniprot_id = "P01137", m.hpa_id = "ENSG00000105329", m.genecards_id = "TGFB1";

MATCH (m:Molecule {id:"mol:VCAM1"})
SET m.abbrev = "VCAM1", m.abbrev_cn = "黏附1",
    m.uniprot_id = "P19320", m.hpa_id = "ENSG00000162692", m.genecards_id = "VCAM1";

MATCH (m:Molecule {id:"mol:ICAM1"})
SET m.abbrev = "ICAM1", m.abbrev_cn = "黏附I",
    m.uniprot_id = "P05362", m.hpa_id = "ENSG00000090339", m.genecards_id = "ICAM1";

MATCH (m:Molecule {id:"mol:MMP9"})
SET m.abbrev = "MMP9", m.abbrev_cn = "基质9",
    m.uniprot_id = "P14780", m.hpa_id = "ENSG00000100985", m.genecards_id = "MMP9";

MATCH (m:Molecule {id:"mol:MMP2"})
SET m.abbrev = "MMP2", m.abbrev_cn = "基质2",
    m.uniprot_id = "P08253", m.hpa_id = "ENSG00000049540", m.genecards_id = "MMP2";

MATCH (m:Molecule {id:"mol:IL10"})
SET m.abbrev = "IL10", m.abbrev_cn = "白介10",
    m.uniprot_id = "P22301", m.hpa_id = "ENSG00000135686", m.genecards_id = "IL10";

MATCH (m:Molecule {id:"mol:Resolvin"})
SET m.abbrev = "RvD", m.abbrev_cn = "消退素",
    m.genecards_id = "ALOX15";

// 其他分子缩写
MATCH (m:Molecule {id:"mol:LSR"})
SET m.abbrev = "LSR", m.abbrev_cn = "脂受",
    m.uniprot_id = "Q86X29", m.genecards_id = "LSR";

MATCH (m:Molecule {id:"mol:HDLBP"})
SET m.abbrev = "HDLBP", m.abbrev_cn = "HDL结",
    m.uniprot_id = "Q00341", m.genecards_id = "HDLBP";

MATCH (m:Molecule {id:"mol:FDPS"})
SET m.abbrev = "FDPS", m.abbrev_cn = "法尼合",
    m.uniprot_id = "P14324", m.genecards_id = "FDPS";

MATCH (m:Molecule {id:"mol:CH25H"})
SET m.abbrev = "CH25H", m.abbrev_cn = "胆羟酶",
    m.uniprot_id = "O95992", m.genecards_id = "CH25H";

MATCH (m:Molecule {id:"mol:OSBP"})
SET m.abbrev = "OSBP", m.abbrev_cn = "甾醇结",
    m.uniprot_id = "P22059", m.genecards_id = "OSBP";

MATCH (m:Molecule {id:"mol:STARD5"})
SET m.abbrev = "STAR5", m.abbrev_cn = "甾醇5",
    m.uniprot_id = "Q9NRN5", m.genecards_id = "STARD5";

// ===== 第2步：为细胞节点添加缩写和表达谱字段 =====
MATCH (c:Cell {id:"cell:hepatocyte"})
SET c.abbrev = "肝细胞", c.abbrev_en = "Hepato";

MATCH (c:Cell {id:"cell:enterocyte"})
SET c.abbrev = "肠上皮", c.abbrev_en = "Entero";

MATCH (c:Cell {id:"cell:adipocyte"})
SET c.abbrev = "脂肪", c.abbrev_en = "Adipo";

MATCH (c:Cell {id:"cell:myocyte"})
SET c.abbrev = "肌细胞", c.abbrev_en = "Myo";

MATCH (c:Cell {id:"cell:endothelial"})
SET c.abbrev = "内皮", c.abbrev_en = "Endo";

MATCH (c:Cell {id:"cell:macrophage"})
SET c.abbrev = "巨噬", c.abbrev_en = "Macro";

// ===== 第3步：为颗粒节点添加缩写 =====
MATCH (p:Particle {id:"particle:CM"})
SET p.abbrev = "CM", p.abbrev_cn = "乳糜";

MATCH (p:Particle {id:"particle:CM_remnant"})
SET p.abbrev = "CM残", p.abbrev_cn = "糜残";

MATCH (p:Particle {id:"particle:VLDL"})
SET p.abbrev = "VLDL", p.abbrev_cn = "极低密";

MATCH (p:Particle {id:"particle:IDL"})
SET p.abbrev = "IDL", p.abbrev_cn = "中密";

MATCH (p:Particle {id:"particle:LDL"})
SET p.abbrev = "LDL", p.abbrev_cn = "低密";

MATCH (p:Particle {id:"particle:HDL_nascent"})
SET p.abbrev = "HDL新", p.abbrev_cn = "高密新";

MATCH (p:Particle {id:"particle:HDL_mature"})
SET p.abbrev = "HDL", p.abbrev_cn = "高密";

MATCH (p:Particle {id:"particle:Lpa"})
SET p.abbrev = "Lp(a)", p.abbrev_cn = "脂a";

MATCH (p:Particle {id:"particle:oxLDL"})
SET p.abbrev = "oxLDL", p.abbrev_cn = "氧低密";

// ===== 第4步：为脂质节点添加缩写 =====
MATCH (l:Lipid {id:"lipid:TG"}) SET l.abbrev = "TG", l.abbrev_cn = "甘三";
MATCH (l:Lipid {id:"lipid:CE"}) SET l.abbrev = "CE", l.abbrev_cn = "胆酯";
MATCH (l:Lipid {id:"lipid:FC"}) SET l.abbrev = "FC", l.abbrev_cn = "游胆";
MATCH (l:Lipid {id:"lipid:PL"}) SET l.abbrev = "PL", l.abbrev_cn = "磷脂";
MATCH (l:Lipid {id:"lipid:FFA"}) SET l.abbrev = "FFA", l.abbrev_cn = "游脂";

// ===== 第5步：为药物节点添加缩写 =====
MATCH (d:Drug {id:"drug:Statin"}) SET d.abbrev = "Statin", d.abbrev_cn = "他汀";
MATCH (d:Drug {id:"drug:Ezetimibe"}) SET d.abbrev = "EZE", d.abbrev_cn = "依折";
MATCH (d:Drug {id:"drug:PCSK9i"}) SET d.abbrev = "PCSKi", d.abbrev_cn = "PCSK抑";
MATCH (d:Drug {id:"drug:Inclisiran"}) SET d.abbrev = "Incli", d.abbrev_cn = "因克";
MATCH (d:Drug {id:"drug:Fibrate"}) SET d.abbrev = "Fibra", d.abbrev_cn = "贝特";
MATCH (d:Drug {id:"drug:Bempedoic_acid"}) SET d.abbrev = "Bempe", d.abbrev_cn = "本培";
MATCH (d:Drug {id:"drug:Lomitapide"}) SET d.abbrev = "Lomit", d.abbrev_cn = "洛米";
MATCH (d:Drug {id:"drug:Evinacumab"}) SET d.abbrev = "Evina", d.abbrev_cn = "依维";
MATCH (d:Drug {id:"drug:Volanesersen"}) SET d.abbrev = "Volan", d.abbrev_cn = "沃兰";
MATCH (d:Drug {id:"drug:Olezarsen"}) SET d.abbrev = "Oleza", d.abbrev_cn = "奥莱";
MATCH (d:Drug {id:"drug:Icosapent_ethyl"}) SET d.abbrev = "IPE", d.abbrev_cn = "鱼油";
MATCH (d:Drug {id:"drug:Niacin"}) SET d.abbrev = "Niaci", d.abbrev_cn = "烟酸";

// ===== 第6步：为标志物节点添加缩写 =====
MATCH (b:Biomarker {id:"biomarker:LDL_C"}) SET b.abbrev = "LDL-C", b.abbrev_cn = "低密胆";
MATCH (b:Biomarker {id:"biomarker:HDL_C"}) SET b.abbrev = "HDL-C", b.abbrev_cn = "高密胆";
MATCH (b:Biomarker {id:"biomarker:TG"}) SET b.abbrev = "TG", b.abbrev_cn = "甘三";
MATCH (b:Biomarker {id:"biomarker:TC"}) SET b.abbrev = "TC", b.abbrev_cn = "总胆";
MATCH (b:Biomarker {id:"biomarker:ApoB"}) SET b.abbrev = "ApoB", b.abbrev_cn = "载脂B";
MATCH (b:Biomarker {id:"biomarker:ApoA1"}) SET b.abbrev = "ApoA1", b.abbrev_cn = "载脂A1";
MATCH (b:Biomarker {id:"biomarker:Lpa"}) SET b.abbrev = "Lp(a)", b.abbrev_cn = "脂a";
MATCH (b:Biomarker {id:"biomarker:non_HDL_C"}) SET b.abbrev = "nHDL", b.abbrev_cn = "非高密";
MATCH (b:Biomarker {id:"biomarker:hsCRP"}) SET b.abbrev = "hsCRP", b.abbrev_cn = "超敏C";

// ===== 第7步：添加病理状态数据 =====

// 创建病理状态节点（PathologyState）
CREATE (ps_normal:PathologyState {
  id: "state:normal",
  name: "正常生理状态",
  name_en: "Normal Physiology",
  description: "健康成人空腹状态的脂代谢正常通路",
  color: "#2ECC71",
  icon: "🟢"
});

CREATE (ps_atherosclerosis:PathologyState {
  id: "state:atherosclerosis",
  name: "动脉粥样硬化",
  name_en: "Atherosclerosis",
  description: "LDL浸润内膜→氧化→泡沫细胞→斑块形成→纤维帽→斑块破裂",
  color: "#E74C3C",
  icon: "🔴",
  affected_nodes: "particle:oxLDL,mol:CD36,mol:SR_A,mol:NF_kB,mol:MMP9,mol:VCAM1,mol:ICAM1,mol:MCP1,mol:IL1B,mol:TNF_a,mol:IL6,mol:NLRP3,mol:TLR4,biomarker:hsCRP",
  enhanced_edges: "oxLDL->CD36,oxLDL->SR_A,oxLDL->TLR4,CD36->NF_kB,NF_kB->MMP9,NF_kB->VCAM1,NF_kB->MCP1,TLR4->NF_kB,NLRP3->IL1B,IL1B->IL6,IL6->hsCRP"
});

CREATE (ps_thrombosis:PathologyState {
  id: "state:thrombosis",
  name: "血栓形成",
  name_en: "Thrombosis",
  description: "斑块破裂→组织因子暴露→凝血级联→血栓形成→急性冠脉综合征",
  color: "#C0392B",
  icon: "🟤",
  affected_nodes: "particle:oxLDL,mol:MMP9,mol:MMP2,mol:TNF_a,mol:IFN_g,mol:IL1B,event:PlaqueRupture",
  enhanced_edges: "MMP9->PlaqueRupture,MMP2->PlaqueRupture,TNF_a->MMP9,IFN_g->MMP9,IFN_g->MMP2"
});

CREATE (ps_nafld:PathologyState {
  id: "state:nafld",
  name: "脂肪肝",
  name_en: "NAFLD/MASLD",
  description: "VLDL分泌不足→肝脏TG堆积→脂肪变性→炎症→纤维化",
  color: "#F39C12",
  icon: "🟡",
  affected_nodes: "cell:hepatocyte,particle:VLDL,mol:MTP,mol:HMGCR,mol:ACAT,mol:SREBP2,mol:ANGPTL3,lipid:TG",
  enhanced_edges: "MTP->VLDL,HMGCR->SREBP2,SREBP2->ANGPTL3,ACAT->TG"
});

CREATE (ps_metabolic_syndrome:PathologyState {
  id: "state:metabolic_syndrome",
  name: "代谢综合征",
  name_en: "Metabolic Syndrome",
  description: "胰岛素抵抗→脂肪细胞LPL↓→TG↑→小密LDL↑→HDL-C↓→致AS脂三联征",
  color: "#E67E22",
  icon: "🟠",
  affected_nodes: "cell:adipocyte,mol:LPL,mol:ANGPTL4,particle:VLDL,particle:LDL,particle:HDL_mature,mol:TNF_a,biomarker:TG,biomarker:HDL_C",
  enhanced_edges: "TNF_a->LPL,ANGPTL4->LPL,LPL->TG,VLDL->LDL"
});

CREATE (ps_pancreatitis:PathologyState {
  id: "state:pancreatitis",
  name: "高TG性胰腺炎",
  name_en: "HTG Pancreatitis",
  description: "TG>11.3mmol/L→CM阻塞毛细血管→局部LPL水解→FFA毒性→胰腺炎",
  color: "#8E44AD",
  icon: "🟣",
  affected_nodes: "particle:CM,lipid:TG,lipid:FFA,mol:LPL,mol:ApoC2,mol:ApoC3,biomarker:TG",
  enhanced_edges: "CM->LPL,LPL->FFA,ApoC2->LPL,ApoC3->LPL"
});

CREATE (ps_familial_hc:PathologyState {
  id: "state:familial_hc",
  name: "家族性高胆",
  name_en: "Familial Hypercholesterolemia",
  description: "LDLR/APOB/PCSK9突变→LDL清除障碍→LDL-C极度升高→早发ASCVD",
  color: "#2C3E50",
  icon: "⚫",
  affected_nodes: "mol:LDLR,mol:ApoB100,mol:PCSK9,particle:LDL,mol:ABCA1,drug:Statin,drug:PCSK9i,drug:Inclisiran",
  enhanced_edges: "LDLR->LDL,ApoB100->LDLR,PCSK9->LDLR,Statin->HMGCR,PCSK9i->PCSK9"
});

// ===== 第8步：将疾病节点标记为废弃（不删除，前端过滤） =====
MATCH (d:Disease)
SET d.deprecated = true,
    d.note = "已替换为病理状态(PathologyState)模型";

// 验证
MATCH (ps:PathologyState)
RETURN ps.id AS 状态ID, ps.name AS 名称, ps.icon AS 图标;

MATCH (d:Disease) RETURN count(d) AS 已废弃疾病数;

MATCH (m:Molecule) WHERE m.abbrev IS NOT NULL RETURN count(m) AS 有缩写的分子数;
