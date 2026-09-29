// ============================================================
//  补全反应的通路归属（基于反应名称智能匹配）
// ============================================================

// 1. 脂蛋白组装/重塑/清除相关 → endogenous 或 exogenous
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'chylomicron' OR r.name CONTAINS 'CM '
       OR r.name CONTAINS 'apoB-48' OR r.name CONTAINS 'APOB-48')
MATCH (p:Pathway {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'VLDL' OR r.name CONTAINS 'LDL'
       OR r.name CONTAINS 'IDL' OR r.name CONTAINS 'Lp(a)')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 2. HDL / 逆向胆固醇转运
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'HDL' OR r.name CONTAINS 'APOA'
       OR r.name CONTAINS 'apoA' OR r.name CONTAINS 'cholesterol efflux'
       OR r.name CONTAINS 'LCAT' OR r.name CONTAINS 'ABCA1'
       OR r.name CONTAINS 'ABCG1' OR r.name CONTAINS 'SR-BI')
MATCH (p:Pathway {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 3. LPL / HL / 脂解相关
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'LPL' OR r.name CONTAINS 'lipase'
       OR r.name CONTAINS 'LIPC' OR r.name CONTAINS 'hepatic lipase'
       OR r.name CONTAINS 'ANGPTL' OR r.name CONTAINS 'GPIHBP1'
       OR r.name CONTAINS 'LMF')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 4. 胆固醇合成 / 胆汁酸 / SREBP / 胆固醇稳态
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'cholesterol' OR r.name CONTAINS 'CHOL'
       OR r.name CONTAINS 'sterol' OR r.name CONTAINS 'SREBP'
       OR r.name CONTAINS 'HMGCR' OR r.name CONTAINS 'HMG-CoA'
       OR r.name CONTAINS 'bile' OR r.name CONTAINS 'CYP7A1'
       OR r.name CONTAINS 'CYP27A1' OR r.name CONTAINS 'CYP8B1'
       OR r.name CONTAINS 'mevalonate' OR r.name CONTAINS 'isoprenoid'
       OR r.name CONTAINS 'farnesyl' OR r.name CONTAINS 'squalene'
       OR r.name CONTAINS 'lanosterol' OR r.name CONTAINS 'desmosterol'
       OR r.name CONTAINS 'lathosterol' OR r.name CONTAINS '7-dehydrocholesterol')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 5. CETP / PLTP / 脂质交换
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'CETP' OR r.name CONTAINS 'PLTP'
       OR r.name CONTAINS 'lipid exchange' OR r.name CONTAINS 'lipid transfer')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 6. PCSK9 / LDLR / 受体介导的内吞
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'PCSK9' OR r.name CONTAINS 'LDLR'
       OR r.name CONTAINS 'endocytosis' OR r.name CONTAINS 'receptor-mediated')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 7. MTTP / 脂蛋白组装
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'MTTP' OR r.name CONTAINS 'microsomal triglyceride')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);


// ============================================================
//  验证
// ============================================================

// 各通路的反应数
MATCH (r)-[:BELONGS_TO_PATHWAY]->(p:Pathway)
RETURN p.id AS 通路, count(r) AS 反应数 ORDER BY 反应数 DESC;

// 仍无归属的反应
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
RETURN count(r) AS 未分配数;

// 未分配的反应样本
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
RETURN r.name AS 名称 LIMIT 10;
