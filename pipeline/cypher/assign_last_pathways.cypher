// 最后一轮：胆汁酸中间体 + 基因表达事件

// 胆汁酸合成中间体
MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
  AND (r.name CONTAINS '5beta-cholestan' OR r.name CONTAINS '4-cholesten'
       OR r.name CONTAINS 'THCA' OR r.name CONTAINS 'DHCA'
       OR r.name CONTAINS '3alpha,7alpha' OR r.name CONTAINS '3alpha, 7alpha'
       OR r.name CONTAINS '12alpha' OR r.name CONTAINS 'trihydroxy'
       OR r.name CONTAINS 'dihydroxy' OR r.name CONTAINS 'cholestanoate'
       OR r.name CONTAINS 'tetrol' OR r.name CONTAINS 'VLCS'
       OR r.name CONTAINS 'BACS' OR r.name CONTAINS 'conjugated with Coenzyme'
       OR r.name CONTAINS 'bile' OR r.name CONTAINS 'BAAT'
       OR r.name CONTAINS 'SLC27A' OR r.name CONTAINS '27-al'
       OR r.name CONTAINS '26-al' OR r.name CONTAINS '26-triol'
       OR r.name CONTAINS '27-tetrol' OR r.name CONTAINS 'trihydroxy-5beta'
       OR r.name CONTAINS 'albumin' OR r.name CONTAINS 'lysoPC'
       OR r.name CONTAINS 'lysophosphatidylcholine')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 基因表达事件
MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
  AND (b.name CONTAINS 'Expression of' OR b.name CONTAINS 'expression'
       OR b.name CONTAINS 'FDPS' OR b.name CONTAINS 'FDFT1'
       OR b.name CONTAINS 'SQLE' OR b.name CONTAINS 'GGPS'
       OR b.name CONTAINS 'MVK' OR b.name CONTAINS 'IDI'
       OR b.name CONTAINS 'FASN' OR b.name CONTAINS 'SCD'
       OR b.name CONTAINS 'ELOVL' OR b.name CONTAINS 'GPAM')
MATCH (p:Pathway {id:"pathway:cholesterol_homeostasis"})
MERGE (b)-[:BELONGS_TO_PATHWAY {source:"智能分配"}]->(p);

// 最终统计
MATCH (n)-[:BELONGS_TO_PATHWAY]->(p:Pathway)
RETURN p.id AS 通路, count(n) AS 成员数 ORDER BY 成员数 DESC;

MATCH (r:Reaction)
WHERE NOT (r)-[:BELONGS_TO_PATHWAY]->()
RETURN count(r) AS 剩余未分配Reaction;

MATCH (b:BlackBoxEvent)
WHERE NOT (b)-[:BELONGS_TO_PATHWAY]->()
RETURN count(b) AS 剩余未分配BlackBoxEvent;
