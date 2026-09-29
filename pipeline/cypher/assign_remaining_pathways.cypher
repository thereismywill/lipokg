// 补全剩余反应的通路归属

// 甲羟戊酸通路中间体 → 胆固醇稳态
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'Mevalonate' OR r.name CONTAINS 'MVA'
       OR r.name CONTAINS 'isopentenyl' OR r.name CONTAINS 'IPPP'
       OR r.name CONTAINS 'dimethylallyl' OR r.name CONTAINS 'DMAPP'
       OR r.name CONTAINS 'geranyl' OR r.name CONTAINS 'GPP'
       OR r.name CONTAINS 'farnesyl' OR r.name CONTAINS 'FPP'
       OR r.name CONTAINS 'geranylgeranyl' OR r.name CONTAINS 'GGPP'
       OR r.name CONTAINS 'ACAT2' OR r.name CONTAINS 'Ac-CoA'
       OR r.name CONTAINS 'CREB3L3' OR r.name CONTAINS 'MBTPS'
       OR r.name CONTAINS 'GGPS' OR r.name CONTAINS 'FDPS'
       OR r.name CONTAINS 'MVD' OR r.name CONTAINS 'PMVK'
       OR r.name CONTAINS 'MVK' OR r.name CONTAINS 'HMGCS'
       OR r.name CONTAINS 'IDI' OR r.name CONTAINS 'IDI1'
       OR r.name CONTAINS 'IDI2')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// BlackBoxEvent 类型的反应
MATCH (r:BlackBoxEvent)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'cholesterol' OR r.name CONTAINS 'sterol'
       OR r.name CONTAINS 'SREBP' OR r.name CONTAINS 'HMG'
       OR r.name CONTAINS 'mevalonate' OR r.name CONTAINS 'bile'
       OR r.name CONTAINS 'CYP' OR r.name CONTAINS 'ACAT'
       OR r.name CONTAINS 'CREB3L3')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 验证
MATCH (r)-[:BELONGS_TO_PATHWAY]->(p:Pathway)
RETURN p.id AS 通路, count(r) AS 反应数 ORDER BY 反应数 DESC;

MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
RETURN count(r) AS 未分配反应;

MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
RETURN count(b) AS 未分配BlackBoxEvent;
