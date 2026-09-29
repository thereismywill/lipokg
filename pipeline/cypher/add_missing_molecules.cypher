// ============================================================
//  补充缺失的分子节点（解决孤立反应问题）
//  添加时间: 2026-06-13
// ============================================================

// LSR - 脂蛋白受体
CREATE (lsr:Molecule:Receptor {
  id: "mol:LSR",
  name: "LSR",
  name_cn: "脂蛋白受体",
  gene: "LSR",
  uniprot: "Q86X29",
  function: "脂蛋白受体，参与VLDL和LDL的清除",
  tissue_specificity: "肝脏",
  clinical: "可能与脂蛋白代谢异常相关"
});

// HDLBP - HDL结合蛋白
CREATE (hdlbp:Molecule:Receptor {
  id: "mol:HDLBP",
  name: "HDLBP",
  name_cn: "HDL结合蛋白",
  gene: "HDLBP",
  uniprot: "Q00341",
  function: "结合HDL，参与胆固醇逆向转运",
  tissue_specificity: "广泛表达",
  clinical: "可能影响HDL功能"
});

// FDPS - 法尼基二磷酸合酶（胆固醇合成）
CREATE (fdps:Molecule:Enzyme {
  id: "mol:FDPS",
  name: "FDPS",
  name_cn: "法尼基二磷酸合酶",
  gene: "FDPS",
  uniprot: "P14324",
  ec: "2.5.1.10",
  reaction: "DMAPP + IPP → FPP",
  function: "胆固醇合成通路中的关键酶",
  tissue_specificity: "肝脏",
  clinical: "双膦酸盐类药物靶点（骨质疏松治疗）"
});

// CH25H - 胆固醇25-羟化酶
CREATE (ch25h:Molecule:Enzyme {
  id: "mol:CH25H",
  name: "CH25H",
  name_cn: "胆固醇25-羟化酶",
  gene: "CH25H",
  uniprot: "O95992",
  ec: "1.14.19.39",
  reaction: "胆固醇 → 25-羟胆固醇",
  function: "生成25-羟胆固醇（LXR配体），调控胆固醇代谢",
  tissue_specificity: "巨噬细胞、肝脏",
  clinical: "25-羟胆固醇是重要的氧化甾醇，调节LXR/SREBP信号"
});

// OSBP - 氧化甾醇结合蛋白
CREATE (osbp:Molecule:Transporter {
  id: "mol:OSBP",
  name: "OSBP",
  name_cn: "氧化甾醇结合蛋白",
  gene: "OSBP",
  uniprot: "P22059",
  function: "转运25-羟胆固醇等氧化甾醇，在ER和高尔基体之间交换脂质",
  tissue_specificity: "广泛表达",
  clinical: "参与细胞内胆固醇运输和信号传导"
});

// STARD5 - StAR相关脂质转移蛋白5
CREATE (stard5:Molecule:Transporter {
  id: "mol:STARD5",
  name: "STARD5",
  name_cn: "StAR相关脂质转移蛋白5",
  gene: "STARD5",
  uniprot: "Q9NRN5",
  function: "结合并转运胆汁酸（DCA、LCA）",
  tissue_specificity: "肝脏、肾脏",
  clinical: "参与胆汁酸代谢和运输"
});


// ============================================================
//  连接这些分子到孤立反应
// ============================================================

// LSR 相关
MATCH (lsr:Molecule {id:"mol:LSR"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8933292"})
CREATE (lsr)-[:SUBSTRATE_OF {source:"补全"}]->(rxn);

MATCH (lsr:Molecule {id:"mol:LSR"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8933258"})
CREATE (lsr)-[:SUBSTRATE_OF {source:"补全"}]->(rxn);

// HDLBP
MATCH (hdlbp:Molecule {id:"mol:HDLBP"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8858252"})
CREATE (hdlbp)-[:SUBSTRATE_OF {source:"补全"}]->(rxn);

// FDPS
MATCH (fdps:Molecule {id:"mol:FDPS"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-9717841"})
CREATE (fdps)-[:CATALYZES {source:"补全"}]->(rxn);

// CH25H
MATCH (ch25h:Molecule {id:"mol:CH25H"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-191983"})
CREATE (ch25h)-[:CATALYZES {source:"补全"}]->(rxn);

// OSBP
MATCH (osbp:Molecule {id:"mol:OSBP"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8867667"})
CREATE (osbp)-[:CATALYZES {source:"补全"}]->(rxn);

MATCH (osbp:Molecule {id:"mol:OSBP"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8868402"})
CREATE (osbp)-[:CATALYZES {source:"补全"}]->(rxn);

// STARD5
MATCH (stard5:Molecule {id:"mol:STARD5"}), (rxn:Reaction {id:"rxn:reactome:R-HSA-8873850"})
CREATE (stard5)-[:SUBSTRATE_OF {source:"补全"}]->(rxn);


// ============================================================
//  验证
// ============================================================

// 新增分子
MATCH (n:Molecule)
WHERE n.id IN ["mol:LSR", "mol:HDLBP", "mol:FDPS", "mol:CH25H", "mol:OSBP", "mol:STARD5"]
RETURN n.id AS 分子ID, n.name AS 名称, labels(n)[1] AS 类型;

// 再次检查孤立节点
MATCH (n:Reaction)
WHERE NOT (n)--()
RETURN count(n) AS 剩余孤立反应;

// 全局统计
MATCH (n) WITH count(n) AS nodes
MATCH ()-[r]->() WITH nodes, count(r) AS edges
RETURN nodes, edges, round(edges * 1.0 / nodes, 2) AS avg_degree;
