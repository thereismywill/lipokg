// ============================================================
//  器官 → 功能细胞 重构脚本
//  将所有 Organ 节点替换为具体的功能细胞类型
// ============================================================

// ===== 第1步: 创建功能细胞节点 =====

CREATE (hep:Cell {
  id: "cell:hepatocyte",
  name: "肝细胞",
  name_en: "Hepatocyte",
  svg: "/cells/hepatocyte.svg",
  description: "肝脏的主要功能细胞，负责VLDL组装、胆固醇合成、LDL清除、胆汁酸合成",
  key_functions: "VLDL组装分泌、LDLR介导LDL清除、HMGCR胆固醇合成、CYP7A1胆汁酸合成、PCSK9分泌",
  organ_origin: "liver"
});

CREATE (ent:Cell {
  id: "cell:enterocyte",
  name: "肠上皮细胞",
  name_en: "Enterocyte",
  svg: "/cells/enterocyte.svg",
  description: "小肠吸收上皮细胞，负责膳食脂质吸收和CM组装",
  key_functions: "NPC1L1介导胆固醇吸收、MTP协助CM组装、ApoB-48合成、CM分泌入淋巴",
  organ_origin: "intestine"
});

CREATE (adi:Cell {
  id: "cell:adipocyte",
  name: "脂肪细胞",
  name_en: "Adipocyte",
  svg: "/cells/adipocyte.svg",
  description: "脂肪组织的主要储能细胞，餐后LPL活性高，摄取FFA储存为TG",
  key_functions: "餐后LPL高表达(胰岛素诱导)、FFA储存为TG、ANGPTL4分泌(空腹)、ApoC-III分泌",
  organ_origin: "adipose"
});

CREATE (myo:Cell {
  id: "cell:myocyte",
  name: "肌细胞",
  name_en: "Myocyte",
  svg: "/cells/myocyte.svg",
  description: "骨骼肌和心肌细胞，空腹时LPL活性高，氧化FFA供能",
  key_functions: "空腹LPL高表达(PPARα上调)、FFA氧化供能、VLDLR表达",
  organ_origin: "muscle"
});

CREATE (endo:Cell {
  id: "cell:endothelial",
  name: "内皮细胞",
  name_en: "Endothelial Cell",
  svg: "/cells/endothelial.svg",
  description: "血管内皮细胞，表达LPL(通过GPIHBP1锚定)、黏附分子、EL",
  key_functions: "GPIHBP1锚定LPL、VCAM-1/ICAM-1表达(NF-κB诱导)、EL表达、NO分泌",
  organ_origin: "vascular_wall"
});

CREATE (mac:Cell {
  id: "cell:macrophage",
  name: "巨噬细胞",
  name_en: "Macrophage",
  svg: "/cells/macrophage.svg",
  description: "免疫系统吞噬细胞，在血管壁摄取oxLDL形成泡沫细胞，参与炎症反应",
  key_functions: "CD36/SR-A摄取oxLDL→泡沫细胞、ABCA1/ABCG1胆固醇外流→RCT、NLRP3炎症小体、IL-1β/TNF-α分泌",
  organ_origin: "immune"
});


// ===== 第2步: 迁移 OCCURS_IN 关系 =====

// 小肠 → 肠上皮细胞
MATCH (r)-[rel:OCCURS_IN]->(o:Organ {id:"organ:intestine"})
WITH r, rel
MATCH (c:Cell {id:"cell:enterocyte"})
CREATE (r)-[:OCCURS_IN {source:rel.source, note:"肠上皮细胞"}]->(c)
WITH r, rel DELETE rel;

// 肝脏 → 肝细胞
MATCH (r)-[rel:OCCURS_IN]->(o:Organ {id:"organ:liver"})
WITH r, rel
MATCH (c:Cell {id:"cell:hepatocyte"})
CREATE (r)-[:OCCURS_IN {source:rel.source, note:"肝细胞"}]->(c)
WITH r, rel DELETE rel;

// 脂肪组织 → 脂肪细胞
MATCH (r)-[rel:OCCURS_IN]->(o:Organ {id:"organ:adipose"})
WITH r, rel
MATCH (c:Cell {id:"cell:adipocyte"})
CREATE (r)-[:OCCURS_IN {source:rel.source, note:"脂肪细胞"}]->(c)
WITH r, rel DELETE rel;

// 骨骼肌/心肌 → 肌细胞
MATCH (r)-[rel:OCCURS_IN]->(o:Organ {id:"organ:muscle"})
WITH r, rel
MATCH (c:Cell {id:"cell:myocyte"})
CREATE (r)-[:OCCURS_IN {source:rel.source, note:"肌细胞"}]->(c)
WITH r, rel DELETE rel;

// 巨噬细胞(器官) → 巨噬细胞(细胞)
MATCH (r)-[rel:OCCURS_IN]->(o:Organ {id:"organ:macrophage"})
WITH r, rel
MATCH (c:Cell {id:"cell:macrophage"})
CREATE (r)-[:OCCURS_IN {source:rel.source, note:"巨噬细胞"}]->(c)
WITH r, rel DELETE rel;


// ===== 第3步: 迁移 EXPRESSED_IN 关系 =====

// 小肠 → 肠上皮细胞
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:intestine"})
WITH m, rel
MATCH (c:Cell {id:"cell:enterocyte"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;

// 肝脏 → 肝细胞
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:liver"})
WITH m, rel
MATCH (c:Cell {id:"cell:hepatocyte"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;

// 脂肪组织 → 脂肪细胞
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:adipose"})
WITH m, rel
MATCH (c:Cell {id:"cell:adipocyte"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;

// 骨骼肌/心肌 → 肌细胞
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:muscle"})
WITH m, rel
MATCH (c:Cell {id:"cell:myocyte"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;

// 血管壁 → 内皮细胞
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:vascular_wall"})
WITH m, rel
MATCH (c:Cell {id:"cell:endothelial"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;

// 巨噬细胞(器官) → 巨噬细胞(细胞)
MATCH (m)-[rel:EXPRESSED_IN]->(o:Organ {id:"organ:macrophage"})
WITH m, rel
MATCH (c:Cell {id:"cell:macrophage"})
CREATE (m)-[:EXPRESSED_IN {source:"迁移", relative_level:rel.relative_level, note:rel.note}]->(c)
WITH m, rel DELETE rel;


// ===== 第4步: 为 EL (内皮脂肪酶) 添加正确的细胞归属 =====
// EL 之前归属到血管壁，现在改为内皮细胞
MATCH (el:Molecule {id:"mol:EL"})
WHERE NOT (el)-[:EXPRESSED_IN]->(:Cell {id:"cell:endothelial"})
MATCH (c:Cell {id:"cell:endothelial"})
CREATE (el)-[:EXPRESSED_IN {source:"修正", relative_level:"high", note:"内皮脂肪酶，内皮细胞表达"}]->(c);

// GPIHBP1 也需要内皮细胞
MATCH (g:Molecule {id:"mol:GPIHBP1"})
WHERE NOT (g)-[:EXPRESSED_IN]->(:Cell {id:"cell:endothelial"})
MATCH (c:Cell {id:"cell:endothelial"})
CREATE (g)-[:EXPRESSED_IN {source:"修正", relative_level:"high", note:"GPI锚定在内皮细胞表面"}]->(c);


// ===== 第5步: 删除旧 Organ 节点 =====
MATCH (o:Organ)
WHERE NOT (o)--()
DELETE o;

// 检查是否还有残留关系
MATCH (o:Organ)
RETURN o.id AS 残留器官, labels(o) AS 标签;
