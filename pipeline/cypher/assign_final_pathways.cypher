// 最终一轮通路分配

// 胆固醇合成后期中间体
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS 'Squalene' OR r.name CONTAINS 'squalene'
       OR r.name CONTAINS 'LAN' OR r.name CONTAINS 'lanosterol'
       OR r.name CONTAINS 'cholesta-' OR r.name CONTAINS 'diMe'
       OR r.name CONTAINS 'ZYMSTNL' OR r.name CONTAINS 'zymostenol'
       OR r.name CONTAINS 'DHCR' OR r.name CONTAINS 'CYP51'
       OR r.name CONTAINS 'TM7SF2' OR r.name CONTAINS 'MSMO1'
       OR r.name CONTAINS 'NSDHL' OR r.name CONTAINS 'HSD17B7'
       OR r.name CONTAINS 'SC5D' OR r.name CONTAINS 'LBR'
       OR r.name CONTAINS '7-dehydro' OR r.name CONTAINS 'desmosterol'
       OR r.name CONTAINS 'lathosterol' OR r.name CONTAINS 'zymosterone')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// BlackBoxEvent: 基因表达、转运、内吞等
MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
  AND (b.name CONTAINS 'APOA4' OR b.name CONTAINS 'APOA5'
       OR b.name CONTAINS 'APOC2' OR b.name CONTAINS 'CIDEC'
       OR b.name CONTAINS 'FGF21' OR b.name CONTAINS 'LMF'
       OR b.name CONTAINS 'LDL' OR b.name CONTAINS 'VLDLR'
       OR b.name CONTAINS 'PCSK9' OR b.name CONTAINS 'ACAC'
       OR b.name CONTAINS 'CHOL' OR b.name CONTAINS 'CHEST'
       OR b.name CONTAINS 'Endocytosis' OR b.name CONTAINS 'Degradation')
MATCH (p:Pathway {id:"pathway:endogenous"})
MERGE (b)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 剩余的含 apoA 的 BlackBoxEvent → RCT
MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
  AND (b.name CONTAINS 'apoA' OR b.name CONTAINS 'HDL')
MATCH (p:Pathway {id:"pathway:rct"})
MERGE (b)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 最终验证
MATCH (r)-[:BELONGS_TO_PATHWAY]->(p:Pathway)
RETURN p.id AS 通路, count(r) AS 反应数 ORDER BY 反应数 DESC;

MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
RETURN count(r) AS 未分配Reaction;

MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
RETURN count(b) AS 未分配BlackBoxEvent;
