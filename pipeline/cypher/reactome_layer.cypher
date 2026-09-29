// ⚠ 664 个未映射实体（已跳过）
// ============================================================
//  Reactome 脂蛋白代谢通路 — 自动导入
//  生成时间: 2026-06-13 12:19
//  反应数: 282
// ============================================================


// ====== 新增 Reaction 节点: 282 ======

CREATE (:Reaction {id: "rxn:reactome:R-HSA-174786", name: "ApoB-48 + 40 triacylglycerol + 60 phospholipid => ApoB-48:TG:PL complex", reactome_id: "R-HSA-174786", source: "Reactome", pmids: "8626595, 14732096", compartment: "endoplasmic reticulum lumen, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-174731", name: "Degradation of newly synthesized ApoB-48", reactome_id: "R-HSA-174731", source: "Reactome", pmids: "1848237", compartment: "endoplasmic reticulum lumen", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174741", name: "ApoB-48:TG:PL complex + 100 triacylglycerols + ApoA-I + ApoA-IV => nascent chylomicron", reactome_id: "R-HSA-174741", source: "Reactome", pmids: "12518019, 14732096", compartment: "endoplasmic reticulum lumen", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174587", name: "nascent chylomicron [endoplasmic reticulum lumen] => nascent chylomicron [extracellular]", reactome_id: "R-HSA-174587", source: "Reactome", pmids: "12692552", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174660", name: "nascent chylomicron + spherical HDL:apoC-II:apoC-III:apoE =>spherical  HDL + chylomicron", reactome_id: "R-HSA-174660", source: "Reactome", pmids: "4345202", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8866329", name: "MTTP lipidates APOB-100, forming a pre-VLDL", reactome_id: "R-HSA-8866329", source: "Reactome", pmids: "8626595, 14732096, 11369260, 7803401", compartment: "endoplasmic reticulum lumen, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8866308", name: "pre-VLDL translocates from RER membrane to SER lumen", reactome_id: "R-HSA-8866308", source: "Reactome", pmids: "11369260", compartment: "smooth endoplasmic reticulum, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8866304", name: "pre-VLDL binds lipids to form VLDL", reactome_id: "R-HSA-8866304", source: "Reactome", pmids: "11369260", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8866327", name: "VLDL translocates from SER lumen to extracellular region", reactome_id: "R-HSA-8866327", source: "Reactome", pmids: "22517366", compartment: "smooth endoplasmic reticulum, extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8866321", name: "VLDL binds APOC1 and APOC4", reactome_id: "R-HSA-8866321", source: "Reactome", pmids: "11353333, 21776394, 12700345", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264758", name: "BMP1-3:Zn2+ cleaves pro-APOA1 to APOA1", reactome_id: "R-HSA-264758", source: "Reactome", pmids: "17580958, 17071617, 16548525", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5682084", name: "ZDHCC8 transfers PALM from PALM-CoA to ABCA1 tetramer", reactome_id: "R-HSA-5682084", source: "Reactome", pmids: "19556522", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5682103", name: "4xPALM-C-ABCA1 tetramer translocates from ER membrane to plasma membrane", reactome_id: "R-HSA-5682103", source: "Reactome", pmids: "19556522", compartment: "endoplasmic reticulum membrane, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5682101", name: "PKA phosphorylates 4xPALM-C-p-2S-ABCA1 tetramer", reactome_id: "R-HSA-5682101", source: "Reactome", pmids: "12196520", compartment: "cytosol, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-216727", name: "4xPALM-C-p-2S-ABCA1 tetramer binds APOA1", reactome_id: "R-HSA-216727", source: "Reactome", pmids: "15280376", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-216723", name: "4xPALM-C-p-2S-ABCA1 tetramer transports CHOL from transport vesicle membrane to plasma membrane", reactome_id: "R-HSA-216723", source: "Reactome", pmids: "17604270", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-216757", name: "4xPALM-C-p-2S-ABCA1 tetramer transports PL from transport vesicle membrane to plasma membrane", reactome_id: "R-HSA-216757", source: "Reactome", pmids: "17604270", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-216756", name: "Apolipoprotein A-I binds membrane-associated cholesterol and phospholipid to form a discoidal HDL particle", reactome_id: "R-HSA-216756", source: "Reactome", pmids: "17478755", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-349657", name: "pre-beta HDL binds membrane-associated cholesterol and phospholipid to form a discoidal HDL particle", reactome_id: "R-HSA-349657", source: "Reactome", pmids: "17478755", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784861", name: "HSPG binds LPL dimer", reactome_id: "R-HSA-6784861", source: "Reactome", pmids: "9136889, 7592670", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8857928", name: "GPIHBP1 binds HSPG:LPL dimer", reactome_id: "R-HSA-8857928", source: "Reactome", pmids: "17997385, 21844202, 23020258, 17883852, 19304573", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8856525", name: "ANGPTL8 binds ANGPTL3", reactome_id: "R-HSA-8856525", source: "Reactome", pmids: "24960069, 22569073, 23150577", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784628", name: "PCSK6,FURIN mediate dissociation of 2 x LPL from GPIHBP1:HSPG:LPL dimer", reactome_id: "R-HSA-6784628", source: "Reactome", pmids: "17088546, 20581395, 16109723, 10900462, 8020465", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 9 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784676", name: "PCSK5 mediates dissociation of 2 x LPL from GPIHBP1:HSPG:LPL dimer", reactome_id: "R-HSA-6784676", source: "Reactome", pmids: "17088546, 22740495", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784620", name: "MBTPS1,2 cleaves CREB3L3 to CREB3L3(1-?) and CREB3L3(?-461)", reactome_id: "R-HSA-6784620", source: "Reactome", pmids: "21719679, 19361614", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-6784648", name: "CREB3L3 (1-?) translocates from cytosol to nucleoplasm", reactome_id: "R-HSA-6784648", source: "Reactome", pmids: "20356926, 15800215", compartment: "cytosol, nucleoplasm", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-6784622", name: "APOA4,APOA5,APOC2,CIDEC,FGF21 genes express APOA4,APOA5,APOC2,CIDEC,FGF21 proteins", reactome_id: "R-HSA-6784622", source: "Reactome", pmids: "21666694, 22262056", compartment: "nucleoplasm, cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6785181", name: "LMF1,2 bind LIPC dimer", reactome_id: "R-HSA-6785181", source: "Reactome", pmids: "9379936, 24909692, 17994020", compartment: "endoplasmic reticulum lumen, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-6785178", name: "LMF1,2 transport LIPC dimer from ER lumen to extracellular region", reactome_id: "R-HSA-6785178", source: "Reactome", pmids: "9379936, 24909692, 17994020", compartment: "endoplasmic reticulum lumen, endoplasmic reticulum membrane, extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6785213", name: "LIPC dimer binds heparin", reactome_id: "R-HSA-6785213", source: "Reactome", pmids: "30288870", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5694109", name: "LIPC dimer hydrolyses TAG to DAG and FA", reactome_id: "R-HSA-5694109", source: "Reactome", pmids: "8485124, 15284087, 1301939", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174757", name: "chylomicron => TG-depleted chylomicron + 50 long-chain fatty acids + 50 diacylglycerols", reactome_id: "R-HSA-174757", source: "Reactome", pmids: "3942763, 1279089, 5057882, 8728311, 16200213", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174690", name: "TG-depleted chylomicron + spherical HDL => chylomicron remnant + spherical HDL:apoA-I:apoA-II:apoA-IV:apoC-II:apoC-III", reactome_id: "R-HSA-174690", source: "Reactome", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174739", name: "chylomicron remnant + apoE => chylomicron remnant:apoE complex", reactome_id: "R-HSA-174739", source: "Reactome", pmids: "8300609", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266350", name: "CETP-mediated lipid exchange: LDL gains cholesterol ester", reactome_id: "R-HSA-266350", source: "Reactome", pmids: "17237796, 6619141, 2833496, 9880564, 22363685", compartment: "extracellular region", evidence: "Reactome (reviewed, 7 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-176879", name: "apolipoprotein(a) + LDL => Lp(a)", reactome_id: "R-HSA-176879", source: "Reactome", pmids: "9548923", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9737780", name: "MTTP binds lomitapide", reactome_id: "R-HSA-9737780", source: "Reactome", pmids: "17215532", compartment: "endoplasmic reticulum lumen", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266082", name: "ABCG1-mediated transport of intracellular cholesterol to the cell surface", reactome_id: "R-HSA-266082", source: "Reactome", pmids: "15994327", compartment: "plasma membrane, cytosol, transport vesicle membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266089", name: "Discoidal HDL binds membrane-associated free cholesterol", reactome_id: "R-HSA-266089", source: "Reactome", pmids: "15994327", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264678", name: "LCAT + discoidal HDL <=> LCAT:discoidal HDL complex", reactome_id: "R-HSA-264678", source: "Reactome", pmids: "9829992", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264689", name: "LCAT:discoidal HDL complex <=> LCAT + discoidal HDL", reactome_id: "R-HSA-264689", source: "Reactome", pmids: "9829992", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266303", name: "Spherical HDL binds C and E apolipoproteins", reactome_id: "R-HSA-266303", source: "Reactome", pmids: "16968945", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266299", name: "Spherical HDL binds membrane-associated free cholesterol and phospholipids", reactome_id: "R-HSA-266299", source: "Reactome", pmids: "14559902", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264695", name: "cholesterol + phosphatidylcholine (lecithin) => cholesterol ester + 2-lysophosphatidylcholine (lysolecithin)", reactome_id: "R-HSA-264695", source: "Reactome", pmids: "4335615, 4340992, 9829992", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264679", name: "Serum albumin binds 2-lysophosphatidylcholine", reactome_id: "R-HSA-264679", source: "Reactome", pmids: "4360812, 5865378", compartment: "extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266315", name: "LCAT + spherical HDL <=> LCAT:spherical HDL complex", reactome_id: "R-HSA-266315", source: "Reactome", pmids: "9829992", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266310", name: "LCAT:spherical HDL complex <=> LCAT + spherical HDL", reactome_id: "R-HSA-266310", source: "Reactome", pmids: "9829992", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-266328", name: "CETP-mediated lipid exchange: spherical HDL gains triacylglycerol", reactome_id: "R-HSA-266328", source: "Reactome", pmids: "17237796, 6619141, 2833496", compartment: "extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-349404", name: "CETP + spherical HDL + torcetrapib => CETP:spherical HDL:torcetrapib complex", reactome_id: "R-HSA-349404", source: "Reactome", pmids: "16326978", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8980228", name: "LIPG dimer hydrolyzes HDL-associated TAG to DAG and LCFA", reactome_id: "R-HSA-8980228", source: "Reactome", pmids: "19567873", compartment: "extracellular region", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174657", name: "chylomicron remnant:apoE complex + LDLR => chylomicron remnant:apoE:LDLR complex", reactome_id: "R-HSA-174657", source: "Reactome", pmids: "8300609", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174706", name: "chylomicron remnant:apoE:LDLR complex [plasma membrane] => chylomicron remnant:apoE:LDLR complex [clathrin-coated vesicle] (LDLRAP1-dependent)", reactome_id: "R-HSA-174706", source: "Reactome", pmids: "8300609", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174808", name: "chylomicron remnant:apoE:LDLR complex [coated vesicle membrane] => chylomicron remnant:apoE:LDLR complex [endosome membrane]", reactome_id: "R-HSA-174808", source: "Reactome", compartment: "clathrin-coated endocytic vesicle membrane"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-174624", name: "chylomicron remnant:apoE:LDLR complex => chylomicron remnant:apoE + LDLR", reactome_id: "R-HSA-174624", source: "Reactome", compartment: "endosome lumen, endosome membrane"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8854462", name: "VLDLR binds VLDL", reactome_id: "R-HSA-8854462", source: "Reactome", pmids: "8294473, 17339654, 22461740, 12700345, 26129832", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8854408", name: "APOBR dimer binds VLDLs", reactome_id: "R-HSA-8854408", source: "Reactome", pmids: "9633939, 10191299, 10852956, 12658354, 12700342", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8933292", name: "LSR trimer binds VLDL", reactome_id: "R-HSA-8933292", source: "Reactome", pmids: "10224102, 15265030, 18644789", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8933258", name: "LSR trimer binds LDL", reactome_id: "R-HSA-8933258", source: "Reactome", pmids: "10224102, 15265030, 18644789", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-171122", name: "LDL + LDLR => LDL:LDLR complex", reactome_id: "R-HSA-171122", source: "Reactome", pmids: "221835, 2722848", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-171141", name: "LDL:LDLR complex [plasma membrane] => LDL:LDLR complex [clathrin-coated vesicle] (LDLRAP1-independent)", reactome_id: "R-HSA-171141", source: "Reactome", pmids: "221835, 12221107, 12464675, 15166224, 16179341", compartment: "plasma membrane", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-171059", name: "LDLR:LDL complex [coated vesicle membrane] => LDLR:LDL complex [endosome membrane]", reactome_id: "R-HSA-171059", source: "Reactome", compartment: "clathrin-coated endocytic vesicle membrane"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-171106", name: "LDLR:LDL complex => LDLR + LDL", reactome_id: "R-HSA-171106", source: "Reactome", pmids: "221835", compartment: "endosome membrane, endosome lumen", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8876366", name: "LDL translocates from endosome lumen to lysosome lumen", reactome_id: "R-HSA-8876366", source: "Reactome", pmids: "221835", compartment: "endosome lumen, lysosomal lumen", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8865667", name: "LIPA hydrolyses sterol esters to sterols and fatty acids", reactome_id: "R-HSA-8865667", source: "Reactome", pmids: "1718995, 8112342, 8146180, 9705237, 25699256", compartment: "lysosomal lumen", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8876472", name: "NPC2 binds CHOL", reactome_id: "R-HSA-8876472", source: "Reactome", pmids: "17018531, 25699256", compartment: "lysosomal lumen", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8876484", name: "NPC2 transfers CHOL to NPC1", reactome_id: "R-HSA-8876484", source: "Reactome", pmids: "18772377, 19563754, 25699256", compartment: "lysosomal lumen, lysosomal membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8876485", name: "CHOL translocates from lysosome membrane to ER membrane", reactome_id: "R-HSA-8876485", source: "Reactome", pmids: "18772377, 25699256", compartment: "endoplasmic reticulum membrane, lysosomal membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8876696", name: "SOAT1,2 transfer acyl group to CHOL forming CHEST", reactome_id: "R-HSA-8876696", source: "Reactome", pmids: "9756920, 8407899, 8049197, 10438503, 19141679", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 7 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8876731", name: "CHEST translocates from ER membrane to lipid particle", reactome_id: "R-HSA-8876731", source: "Reactome", pmids: "18566308", compartment: "endoplasmic reticulum membrane, lipid droplet", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6813720", name: "NCEH1 hydrolyzes cholesterol esters", reactome_id: "R-HSA-6813720", source: "Reactome", pmids: "19592704, 20947831, 18782767, 24868095", compartment: "cytosol, endoplasmic reticulum membrane, lipid droplet, transport vesicle membrane", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8937442", name: "CES3 hydrolyses CHEST to CHOL and LCFA(-)", reactome_id: "R-HSA-8937442", source: "Reactome", pmids: "22700792, 20422440", compartment: "cytosol, lipid droplet, transport vesicle membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-171087", name: "LDLR [endosome membrane] => LDLR [plasma membrane]", reactome_id: "R-HSA-171087", source: "Reactome", pmids: "221835", compartment: "endosome membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784734", name: "PCSK9 binds LDLR", reactome_id: "R-HSA-6784734", source: "Reactome", pmids: "17452316, 25915661", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9733403", name: "PCSK9 binds PCSK9 inhibitors", reactome_id: "R-HSA-9733403", source: "Reactome", pmids: "33866776, 19196236", compartment: "extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784735", name: "PCSK9:LDLR bind to Clathrin", reactome_id: "R-HSA-6784735", source: "Reactome", pmids: "22764087", compartment: "plasma membrane, clathrin-coated endocytic vesicle membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6784729", name: "PCSK9:LDLR:Clathrin-coated vesicle transport from plasma membrane to endolysosome", reactome_id: "R-HSA-6784729", source: "Reactome", pmids: "22764087", compartment: "endolysosome membrane, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-6784738", name: "Degradation of PCSK9:LDLR:Clathrin-coated vesicle", reactome_id: "R-HSA-6784738", source: "Reactome", pmids: "22764087", compartment: "endolysosome membrane, clathrin-coated endocytic vesicle membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8858252", name: "HDLBP binds HDL", reactome_id: "R-HSA-8858252", source: "Reactome", pmids: "11284697", compartment: "plasma membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-349637", name: "spherical HDL and SR-BI receptor form a complex at the cell surface", reactome_id: "R-HSA-349637", source: "Reactome", pmids: "9211901", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-349638", name: "Disassembly of SR-BI-bound spherical HDL", reactome_id: "R-HSA-349638", source: "Reactome", pmids: "12788804, 11561168", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-264848", name: "apoA-I binds to CUBN:AMN", reactome_id: "R-HSA-264848", source: "Reactome", pmids: "10371504, 17652309", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-264834", name: "Endocytosis and degradation of apoA-I", reactome_id: "R-HSA-264834", source: "Reactome", pmids: "10371504", compartment: "endosome", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8854628", name: "MYLIP dimer ubiquitinates VLDLR on Lys-839", reactome_id: "R-HSA-8854628", source: "Reactome", pmids: "20427281, 22510808, 22936343, 19520913, 21734303", compartment: "plasma membrane, cytosol", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8855111", name: "VLDLR binds PCSK9", reactome_id: "R-HSA-8855111", source: "Reactome", pmids: "18039658, 21273557", compartment: "plasma membrane, extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8855131", name: "VLDLR:PCSK9 binds Clathrin-coated vesicles", reactome_id: "R-HSA-8855131", source: "Reactome", pmids: "18039658, 17452316", compartment: "extracellular region, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-8855130", name: "VLDLR:PCSK9:Clathrin-coated vesicle translocates from the plasma membrane to lysosomal membrane", reactome_id: "R-HSA-8855130", source: "Reactome", pmids: "17452316, 18039658", compartment: "plasma membrane, lysosomal membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8848215", name: "ACAT2 condenses 2 Ac-CoA to form ACA-CoA", reactome_id: "R-HSA-8848215", source: "Reactome", pmids: "7911016, 9380443", compartment: "cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191323", name: "HMGCS1 condenses Ac-CoA and ACA-CoA to form bHMG-CoA", reactome_id: "R-HSA-191323", source: "Reactome", pmids: "7913309", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191352", name: "HMGCR dimer reduces bHMG-CoA to MVA", reactome_id: "R-HSA-191352", source: "Reactome", pmids: "1967820, 10698924", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9705584", name: "HMGCR dimer binds statins", reactome_id: "R-HSA-9705584", source: "Reactome", pmids: "16128575, 32859023, 12486413, 11349148", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191380", name: "Mevalonate is phosphorylated to mevalonate-5-phosphate", reactome_id: "R-HSA-191380", source: "Reactome", pmids: "14730012, 11111075, 1377680", compartment: "cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191422", name: "Mevalonate-5-phosphate is further phosphorylated", reactome_id: "R-HSA-191422", source: "Reactome", pmids: "16519518, 14729858", compartment: "cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191414", name: "MVD decarboxylates MVA5PP to IPPP", reactome_id: "R-HSA-191414", source: "Reactome", pmids: "8626466", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191382", name: "Isopentenyl pyrophosphate rearranges to dimethylallyl pyrophosphate", reactome_id: "R-HSA-191382", source: "Reactome", pmids: "8806705", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191322", name: "FDPS dimer transfers IPPP to DMAPP", reactome_id: "R-HSA-191322", source: "Reactome", pmids: "10026212, 9741684, 16684881, 33246356", compartment: "cytosol", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9717834", name: "GGPS1 hexamer transfers IPPP to DMAPP", reactome_id: "R-HSA-9717834", source: "Reactome", pmids: "10026212, 9741684, 16684881, 33246356", compartment: "cytosol", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191303", name: "FDPS dimer transfers IPPP to GPP", reactome_id: "R-HSA-191303", source: "Reactome", pmids: "10026212, 9741684, 16684881", compartment: "cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9717830", name: "GGPS1 hexamer transfers IPPP to GPP", reactome_id: "R-HSA-9717830", source: "Reactome", pmids: "10026212, 9741684, 16684881", compartment: "cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9717841", name: "holo-FDPS dimer binds NBPs", reactome_id: "R-HSA-9717841", source: "Reactome", pmids: "10620343, 18937434, 18327899, 11160603, 21420384", compartment: "cytosol", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191405", name: "Two FAPP molecules dimerize to form presqualene diphosphate", reactome_id: "R-HSA-191405", source: "Reactome", pmids: "10896663", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8952137", name: "Phospholipid phosphatase 6 hydrolyses Presqualene diphosphate to presqualene monophosphate", reactome_id: "R-HSA-8952137", source: "Reactome", pmids: "16464866", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191402", name: "Reduction of presqualene diphosphate to form squalene", reactome_id: "R-HSA-191402", source: "Reactome", pmids: "10896663", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191299", name: "Squalene is oxidized to its epoxide", reactome_id: "R-HSA-191299", source: "Reactome", pmids: "10666321", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191366", name: "Squalene 2,3-epoxide cyclizes, forming lanosterol", reactome_id: "R-HSA-191366", source: "Reactome", pmids: "14766201, 8593458, 5918048", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194678", name: "CYP51A1 demethylates LAN", reactome_id: "R-HSA-194678", source: "Reactome", pmids: "8619637, 20149798", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194698", name: "4,4-dimethylcholesta-8(9),14,24-trien-3beta-ol is reduced to 4,4-dimethylcholesta-8(9),24-dien-3beta-ol [TM7SF2]", reactome_id: "R-HSA-194698", source: "Reactome", pmids: "16784888", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194674", name: "4,4-dimethylcholesta-8(9),14,24-trien-3beta-ol is reduced to 4,4-dimethylcholesta-8(9),24-dien-3beta-ol [LBR]", reactome_id: "R-HSA-194674", source: "Reactome", pmids: "12618959", compartment: "nuclear envelope", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194641", name: "4,4-dimethylcholesta-8(9),24-dien-3beta-ol is oxidized to 4-methyl,4-carboxycholesta-8(9),24-dien-3beta-ol", reactome_id: "R-HSA-194641", source: "Reactome", pmids: "8663358", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194642", name: "4-methyl,4-carboxycholesta-8(9),24-dien-3beta-ol is decarboxylated and oxidized to form 4-methylcholesta-8(9),24-dien-3-one", reactome_id: "R-HSA-194642", source: "Reactome", pmids: "14506130", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194689", name: "4-methylcholesta-8(9),24-dien-3-one is reduced to 4-methylcholesta-8(9),24-dien-3beta-ol", reactome_id: "R-HSA-194689", source: "Reactome", pmids: "12829805", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194669", name: "4-methylcholesta-8(9),24-dien-3beta-ol is oxidized to 4-carboxycholesta-8(9),24-dien-3beta-ol", reactome_id: "R-HSA-194669", source: "Reactome", pmids: "8663358", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194718", name: "4-carboxycholesta-8(9),24-dien-3beta-ol is decarboxylated and oxidized to form cholesta-8(9),24-dien-3-one (zymosterone)", reactome_id: "R-HSA-194718", source: "Reactome", pmids: "14506130", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194632", name: "Zymosterone (cholesta-8(9),24-dien-3-one) is reduced to zymosterol (cholesta-8(9),24-dien-3beta-ol)", reactome_id: "R-HSA-194632", source: "Reactome", pmids: "12829805", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-195690", name: "Zymosterol is isomerized to cholesta-7,24-dien-3beta-ol", reactome_id: "R-HSA-195690", source: "Reactome", pmids: "10391218, 10391219", compartment: "endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-195664", name: "Cholesta-7,24-dien-3beta-ol is desaturated to form cholesta-5,7,24-trien-3beta-ol", reactome_id: "R-HSA-195664", source: "Reactome", pmids: "12189593, 12812989", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-196402", name: "Cholesta-5,7,24-trien-3beta-ol is reduced to desmosterol", reactome_id: "R-HSA-196402", source: "Reactome", pmids: "9465114", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-196417", name: "Reduction of desmosterol to cholesterol", reactome_id: "R-HSA-196417", source: "Reactome", pmids: "11519011", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9755937", name: "DHCR24 reduces LAN to 24,25-dhLAN", reactome_id: "R-HSA-9755937", source: "Reactome", pmids: "14404284, 23050906", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9947148", name: "CYP51A1 14-demethylates 24,25-dhLAN to 4,4-diMeCholesta-8,14-dien-3-ol", reactome_id: "R-HSA-9947148", source: "Reactome", pmids: "8797093, 8399332, 8619637", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9946140", name: "TM7SF2 reduces 4,4-diMeCholesta-8,14-dien-3-ol to 4,4-diMe5-cholest-8-en-3-ol", reactome_id: "R-HSA-9946140", source: "Reactome", pmids: "16784888", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9947203", name: "MSMO1 oxidizes 4,4-diMe-5-cholest-8-en-3-ol to 4a-carboxy-4b-me-5a-cholest-8-en-3b-ol", reactome_id: "R-HSA-9947203", source: "Reactome", pmids: "21285510", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9945822", name: "NSDHL decarboxylates 4a-carboxy-4b-methyl-5a-cholest-8-en-3b-ol to 4a-methyl-5a-cholest-8-en-3b-ol", reactome_id: "R-HSA-9945822", source: "Reactome", pmids: "10369263", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9945784", name: "HSD17B7 reduces 4a-methyl-5a-cholest-8-en-3-one to 4a-methyl-5a-cholest-8-en-3b-ol", reactome_id: "R-HSA-9945784", source: "Reactome", pmids: "12829805", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9947207", name: "MSMO1 oxidizes 4a-me-5a-cholest-8-en-3b-ol to 4a-carboxy-5a-cholest-8-ene-3b-ol", reactome_id: "R-HSA-9947207", source: "Reactome", pmids: "21285510", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9945787", name: "NSDHL decarboxylates 4a-carboxy-5a-cholest-8-ene-3b-ol to 5a-cholest-8-en-3-one", reactome_id: "R-HSA-9945787", source: "Reactome", pmids: "10369263", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9945804", name: "HSD17B7 reduces 5a-cholest-8-en-3-one to ZYMSTNL", reactome_id: "R-HSA-9945804", source: "Reactome", pmids: "12829805", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6807064", name: "DHCR24 reduces ZYMOL to ZYMSTNL", reactome_id: "R-HSA-6807064", source: "Reactome", pmids: "14404284, 26114596, 11519011", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6807052", name: "EBP isomerizes ZYMSTNL to LTHSOL", reactome_id: "R-HSA-6807052", source: "Reactome", pmids: "10391219, 10391218, 14404284, 26114596", compartment: "endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6807053", name: "SC5D desaturates LTHSOL to 7-dehydroCHOL", reactome_id: "R-HSA-6807053", source: "Reactome", pmids: "12189593, 14404284, 12812989, 26114596", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6807055", name: "DHCR7 reduces 7-dehydroCHOL to CHOL", reactome_id: "R-HSA-6807055", source: "Reactome", pmids: "14404284, 26114596, 9465114", compartment: "endoplasmic reticulum membrane, cytosol", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5250531", name: "ARV1 transports CHOL from ER membrane to plasma membrane", reactome_id: "R-HSA-5250531", source: "Reactome", pmids: "12145310, 11063737", compartment: "endoplasmic reticulum lumen, endoplasmic reticulum membrane, plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-2317530", name: "SREBP1A,1C,2 binds SCAP:cholesterol:INSIG and is retained in the endoplasmic reticulum", reactome_id: "R-HSA-2317530", source: "Reactome", compartment: "endoplasmic reticulum membrane", go_term: "maintenance of protein complex location"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-2317531", name: "SREBP1A,1C,2 binds SCAP:INSIG:oxysterol and is retained in the endoplasmic reticulum", reactome_id: "R-HSA-2317531", source: "Reactome", compartment: "endoplasmic reticulum membrane", go_term: "maintenance of protein complex location"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655825", name: "SREBP1A,1C,2:SCAP binds CopII Coat Complex", reactome_id: "R-HSA-1655825", source: "Reactome", compartment: "endoplasmic reticulum membrane", go_term: "endoplasmic reticulum to Golgi vesicle-mediated transport"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655834", name: "SREBP1A,1C,2:SCAP translocates to the Golgi", reactome_id: "R-HSA-1655834", source: "Reactome", compartment: "endoplasmic reticulum membrane, ER to Golgi transport vesicle membrane, Golgi membrane", go_term: "endoplasmic reticulum to Golgi vesicle-mediated transport"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-1655842", name: "S1P hydrolyzes SREBP1A,1C,2", reactome_id: "R-HSA-1655842", source: "Reactome", pmids: "10644685, 17449569, 10428864, 8674110, 8156598", compartment: "Golgi membrane", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-1655851", name: "S2P hydrolyzes SREBP1A,1C,2", reactome_id: "R-HSA-1655851", source: "Reactome", pmids: "10805775, 9659902, 8156598, 8674110", compartment: "Golgi membrane, cytosol", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2065549", name: "SREBP1A,1C,2 binds SREBP1A,1C,2 forming dimers", reactome_id: "R-HSA-2065549", source: "Reactome", pmids: "11283257", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2065550", name: "SREBP1A,1C,2 binds Importin beta-1", reactome_id: "R-HSA-2065550", source: "Reactome", pmids: "10397761, 31875875", compartment: "cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655831", name: "SREBP1A,1C,2 translocates to the nucleus", reactome_id: "R-HSA-1655831", source: "Reactome", pmids: "8156598, 8674110, 11283257, 14645851, 10397761", compartment: "cytosol, nucleoplasm", go_term: "protein import into nucleus", evidence: "Reactome (reviewed, 8 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2065539", name: "SREBP1A,1C,2:Importin beta-1 dissociates", reactome_id: "R-HSA-2065539", source: "Reactome", pmids: "10397761", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426160", name: "SREBP1A,1C,2 binds the ACACA promoter", reactome_id: "R-HSA-2426160", source: "Reactome", pmids: "9300785, 18559965", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426153", name: "SREBP1A,1C binds the ACACB promoter", reactome_id: "R-HSA-2426153", source: "Reactome", pmids: "12764144", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2065966", name: "SREBP1A,1C,2 binds the TM7SF2 promoter", reactome_id: "R-HSA-2065966", source: "Reactome", pmids: "20138239, 18654640, 18559965", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426158", name: "SREBP1A,1C binds the GPAM promoter", reactome_id: "R-HSA-2426158", source: "Reactome", pmids: "22634312", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426148", name: "SREBP1A,1C binds the FASN promoter", reactome_id: "R-HSA-2426148", source: "Reactome", pmids: "7592729, 18682402, 10759542, 18559965, 12177166", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 7 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-6800052", name: "SREBP1A,1C binds the SCD gene", reactome_id: "R-HSA-6800052", source: "Reactome", pmids: "18654640, 11414710, 10400691, 11994399, 10585467", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 5 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426154", name: "SREBP1A,2 binds the LSS promoter", reactome_id: "R-HSA-2426154", source: "Reactome", pmids: "18559965, 9748295", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426144", name: "SREBP1A,2 binds the MVD promoter", reactome_id: "R-HSA-2426144", source: "Reactome", pmids: "18559965", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426162", name: "SREBP1A,2 binds the HMGCR promoter", reactome_id: "R-HSA-2426162", source: "Reactome", pmids: "8647822, 18654640, 18559965, 9748295", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426164", name: "SREBP1A,2 binds the SC5DL promoter", reactome_id: "R-HSA-2426164", source: "Reactome", pmids: "18654640, 18559965", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426163", name: "SREBP1A,2 binds the CYP51A1 promoter", reactome_id: "R-HSA-2426163", source: "Reactome", pmids: "18654640, 18559965, 9748295", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426155", name: "SREBP1A,2 binds the DHCR7 promoter", reactome_id: "R-HSA-2426155", source: "Reactome", pmids: "18654640", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426161", name: "SREBP1A,2 binds the GGPS1 promoter", reactome_id: "R-HSA-2426161", source: "Reactome", pmids: "18654640", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426152", name: "SREBP1A,2 binds the IDI1 promoter", reactome_id: "R-HSA-2426152", source: "Reactome", pmids: "18654640", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426157", name: "SREBP1A,2 binds the MVK promoter", reactome_id: "R-HSA-2426157", source: "Reactome", pmids: "18654640", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426156", name: "SREBP1A,2 binds the PMVK promoter", reactome_id: "R-HSA-2426156", source: "Reactome", pmids: "18654640", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426151", name: "SREBP1A,2 binds the SQLE promoter", reactome_id: "R-HSA-2426151", source: "Reactome", pmids: "12083769, 18559965", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426149", name: "SREBP1A,1C,2 binds the ELOVL6 promoter", reactome_id: "R-HSA-2426149", source: "Reactome", compartment: "nucleoplasm"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426147", name: "SREBP1A,1C,2 binds the FDPS promoter", reactome_id: "R-HSA-2426147", source: "Reactome", pmids: "20450493, 8798690, 18654640, 18559965, 12177166", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426150", name: "SREBP1A,1C,2 binds the HMGCS1 promoter", reactome_id: "R-HSA-2426150", source: "Reactome", pmids: "9604010, 18654640, 12177166, 9748295", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-2426146", name: "SREBP1A,1C,2 binds the FDFT1 promoter", reactome_id: "R-HSA-2426146", source: "Reactome", pmids: "9604010, 18654640, 18559965, 9748295", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 4 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655826", name: "Expression of 3-Hydroxy-3-methylglutaryl-coenzyme A Reductase (HMGCR)", reactome_id: "R-HSA-1655826", source: "Reactome", pmids: "8647822", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655827", name: "Expression of 7-Dehydrocholesterol Reductase (DHCR7)", reactome_id: "R-HSA-1655827", source: "Reactome", pmids: "9634533", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655845", name: "Expression of Acetyl CoA Carboxylase 1 (ACACA, ACC1)", reactome_id: "R-HSA-1655845", source: "Reactome", pmids: "7732023", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655830", name: "Expression of Acetyl CoA Carboxylase 2 (ACACB, ACC2)", reactome_id: "R-HSA-1655830", source: "Reactome", pmids: "9099716", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655849", name: "Expression of Acyl-CoA Desaturase (Stearoyl CoA Desaturase, SCD)", reactome_id: "R-HSA-1655849", source: "Reactome", pmids: "7909540, 10400691, 11414710", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655836", name: "Expression of Diphosphomevalonate Decarboxylase (MVD)", reactome_id: "R-HSA-1655836", source: "Reactome", pmids: "8626466", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655835", name: "Expression of ELOVL6", reactome_id: "R-HSA-1655835", source: "Reactome", pmids: "20937905", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655824", name: "Expression of Farnesyl Diphosphate Synthase (FDPS)", reactome_id: "R-HSA-1655824", source: "Reactome", pmids: "1968462", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655850", name: "Expression of Farnesyldiphosphate Farnesyltransferase (FDFT1, Squalene Synthase)", reactome_id: "R-HSA-1655850", source: "Reactome", pmids: "7685352", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655843", name: "Expression of Fatty Acid Synthase (FASN)", reactome_id: "R-HSA-1655843", source: "Reactome", pmids: "7567999", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655832", name: "Expression of Geranylgeranyl Pyrophosphate Synthase (GGPS1)", reactome_id: "R-HSA-1655832", source: "Reactome", pmids: "18726356", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655837", name: "Expression of Glycerol-3-phosphate Acyltransferase (GPAM, GPAT)", reactome_id: "R-HSA-1655837", source: "Reactome", pmids: "20719759", compartment: "nucleoplasm, mitochondrial outer membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655848", name: "Expression of Hydroxymethylglutaryl coenzyme A synthase (HMGCS1)", reactome_id: "R-HSA-1655848", source: "Reactome", pmids: "19088433, 12177166", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655823", name: "Expression of Isopentenyl-diphosphate Delta-isomerase 1 (IDI1)", reactome_id: "R-HSA-1655823", source: "Reactome", pmids: "8020941", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655847", name: "Expression of Lanosterol Demethylase (CYP51A1)", reactome_id: "R-HSA-1655847", source: "Reactome", pmids: "8619637", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655828", name: "Expression of Lanosterol Synthase (LSS)", reactome_id: "R-HSA-1655828", source: "Reactome", pmids: "17925399", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655852", name: "Expression of Lathosterol Oxidase (SC5D, SC5DL)", reactome_id: "R-HSA-1655852", source: "Reactome", pmids: "8976377", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655846", name: "Expression of Mevalonate Kinase (MVK)", reactome_id: "R-HSA-1655846", source: "Reactome", pmids: "1377680", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655839", name: "Expression of Phosphomevalonate Kinase (PMVK)", reactome_id: "R-HSA-1655839", source: "Reactome", pmids: "8663599", compartment: "nucleoplasm, cytosol", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655844", name: "Expression of Squalene Monooxygenase (SQLE)", reactome_id: "R-HSA-1655844", source: "Reactome", pmids: "8626488", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-1655833", name: "Expression of TM7SF2", reactome_id: "R-HSA-1655833", source: "Reactome", pmids: "20138239", compartment: "nucleoplasm, endoplasmic reticulum membrane", go_term: "positive regulation of transcription by RNA polymerase II", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192051", name: "CYP7A1 7-hydroxylates CHOL", reactome_id: "R-HSA-192051", source: "Reactome", pmids: "2384150", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192097", name: "7alpha-hydroxycholesterol is oxidized and isomerized to 4-cholesten-7alpha-ol-3-one", reactome_id: "R-HSA-192097", source: "Reactome", pmids: "12679481, 11067870", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192157", name: "CYP8B1 12-hydroxylates 4CHOL7aOLONE", reactome_id: "R-HSA-192157", source: "Reactome", pmids: "10051404, 1400444", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192067", name: "4-cholesten-7alpha, 12alpha-diol-3-one is reduced to 5beta-cholesten-7alpha, 12alpha-diol-3-one", reactome_id: "R-HSA-192067", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192033", name: "4-cholesten-7alpha-ol-3-one is reduced to 5beta-cholestan-7alpha-ol-3-one", reactome_id: "R-HSA-192033", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192036", name: "5Beta-cholesten-7alpha, 12alpha-diol-3-one is reduced to 5beta-cholestan-3alpha, 7alpha, 12alpha-triol", reactome_id: "R-HSA-192036", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192160", name: "5beta-cholestan-7alpha-ol-3-one is reduced to 5beta-cholestan-3alpha, 7alpha-diol", reactome_id: "R-HSA-192160", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192010", name: "5beta-cholestan-3alpha, 7alpha, 12alpha-triol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-192010", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193537", name: "5beta-cholestan-3alpha, 7alpha-diol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-193537", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191999", name: "CYP27A1 27-hydroxylates 5bCHOL3a,7a,12a-triol", reactome_id: "R-HSA-191999", source: "Reactome", pmids: "1708392, 2019602, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193393", name: "5beta-cholestan-3alpha, 7alpha-diol is hydroxylated to 5beta-cholestan-3alpha, 7alpha, 26-triol", reactome_id: "R-HSA-193393", source: "Reactome", pmids: "1708392, 2019602, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192042", name: "5beta-cholestan-3alpha,7alpha,12alpha,27-tetrol is oxidized to 3alpha,7alpha,12alpha-trihydroxy-5beta-cholestan-27-al", reactome_id: "R-HSA-192042", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193497", name: "5beta-cholestan-3alpha, 7alpha, 26-triol is oxidized to 3alpha, 7alpha-dihydroxy-5beta-cholestan-26-al", reactome_id: "R-HSA-193497", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192054", name: "3alpha,7alpha,12alpha-trihydroxy-5beta-cholestan-27-al is oxidized to 3alpha,7alpha,12alpha-trihydroxy-5beta-cholestanoate (THCA)", reactome_id: "R-HSA-192054", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193460", name: "3alpha, 7alpha-dihydroxy-5beta-cholestan-26-al is oxidized to 3alpha, 7alpha-dihydroxy-5beta-cholestanoate (DHCA)", reactome_id: "R-HSA-193460", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-191971", name: "THCA is translocated from the mitochondrial matrix to the cytosol", reactome_id: "R-HSA-191971", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", go_term: "export from the mitochondrion", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193519", name: "DHCA is translocated from the mitochondrial matrix to the cytosol", reactome_id: "R-HSA-193519", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", go_term: "export from the mitochondrion", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193401", name: "THCA is conjugated with Coenzyme A (SLC27A2 VLCS)", reactome_id: "R-HSA-193401", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193424", name: "DHCA is conjugated with Coenzyme A (SLC27A2 VLCS)", reactome_id: "R-HSA-193424", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192137", name: "THCA is conjugated with Coenzyme A (SLC27A5 BACS)", reactome_id: "R-HSA-192137", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193407", name: "DHCA is conjugated with Coenzyme A (SLC27A5 BACS)", reactome_id: "R-HSA-193407", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-192325", name: "25(R) THCA-CoA is translocated from the cytosol to the peroxisome", reactome_id: "R-HSA-192325", source: "Reactome", pmids: "12543708", compartment: "peroxisomal membrane", go_term: "peroxisomal membrane transport", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193482", name: "25(R) DHCA-CoA is translocated from the cytosol to the peroxisome", reactome_id: "R-HSA-193482", source: "Reactome", pmids: "12543708", compartment: "peroxisomal membrane", go_term: "peroxisomal membrane transport", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192056", name: "Isomerization of 25(R) THCA-CoA to 25(S) THCA-CoA", reactome_id: "R-HSA-192056", source: "Reactome", pmids: "7649182, 11060344, 10655068", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193452", name: "Isomerization of 25(R) DHCA-CoA to 25(S) DHCA-CoA", reactome_id: "R-HSA-193452", source: "Reactome", pmids: "7649182, 11060344, 10655068", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192335", name: "25(S) THCA-CoA is dehydrogenated to 3alpha,7alpha,12alpha-trihydroxy-5beta-cholest-24-enoyl-CoA (THCA-CoA)", reactome_id: "R-HSA-192335", source: "Reactome", pmids: "8943006, 8387517", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193369", name: "25(S) DHCA-CoA is dehydrogenated to 25(S) 3alpha,7alpha-dihydroxy-5beta-cholest-24-enoyl-CoA", reactome_id: "R-HSA-193369", source: "Reactome", pmids: "8943006, 8387517", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192331", name: "3alpha,7alpha,12alpha-trihydroxy-5beta-cholest-24-enoyl-CoA (THCA-CoA) is hydrated to (24R, 25R) 3alpha,7alpha,12alpha,24-tetrahydroxy-5beta-cholestanoyl-CoA", reactome_id: "R-HSA-192331", source: "Reactome", pmids: "8902629", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193535", name: "25(S) 3alpha,7alpha-dihydroxy-5beta-cholest-24-enoyl-CoA is hydrated to (24R, 25R) 3alpha,7alpha,24-trihydroxy-5beta-cholestanoyl-CoA", reactome_id: "R-HSA-193535", source: "Reactome", pmids: "8902629", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193455", name: "(24R, 25R) 3alpha,7alpha,12alpha,24-tetrahydroxy-5beta-cholestanoyl-CoA is oxidized to 3alpha,7alpha,12alpha-trihydroxy-5beta-cholest-24-one-CoA", reactome_id: "R-HSA-193455", source: "Reactome", pmids: "8902629", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193508", name: "(24R, 25R) 3alpha,7alpha,24-trihydroxy-5beta-cholestanoyl-CoA is oxidized to 3alpha,7alpha-dihydroxy-5beta-cholest-24-one-CoA", reactome_id: "R-HSA-193508", source: "Reactome", pmids: "8902629", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192341", name: "Thiolysis of 3alpha,7alpha,12alpha-trihydroxy-5beta-cholan-24-one-CoA yields choloyl-CoA (3alpha,7alpha,12alpha-trihydroxy-5beta-cholan-24-one-CoA) and propionyl CoA", reactome_id: "R-HSA-192341", source: "Reactome", pmids: "1703300, 10706581", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193533", name: "Thiolysis of 3alpha,7alpha-dihydroxy-5beta-cholan-24-one-CoA yields chenodeoxycholoyl-CoA (3alpha,7alpha-dihydroxy-5beta-cholan-24-one-CoA) and propionyl CoA", reactome_id: "R-HSA-193533", source: "Reactome", pmids: "1703300, 10706581", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193385", name: "Hydrolysis of choloyl-CoA to cholate and CoASH", reactome_id: "R-HSA-193385", source: "Reactome", pmids: "11673457, 10092594", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193399", name: "Cholate is translocated from the peroxisomal matrix to the cytosol", reactome_id: "R-HSA-193399", source: "Reactome", pmids: "12543708", compartment: "peroxisomal membrane", go_term: "peroxisomal transport", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192312", name: "Choloyl CoA reacts with glycine or taurine to form glycocholate or taurocholate", reactome_id: "R-HSA-192312", source: "Reactome", pmids: "8034703", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193491", name: "Chenodeoxycholoyl CoA reacts with glycine or taurine to form glycochenodeoxycholate or taurochenodeoxycholate", reactome_id: "R-HSA-193491", source: "Reactome", pmids: "8034703", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-192315", name: "Bile salts are translocated from the peroxisomal matrix to the cytosol", reactome_id: "R-HSA-192315", source: "Reactome", pmids: "12543708", compartment: "peroxisomal membrane", go_term: "peroxisomal membrane transport", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193362", name: "ABCB11 transports bile salts from cytosol to extracellular region", reactome_id: "R-HSA-193362", source: "Reactome", pmids: "12404240, 12404239", compartment: "plasma membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192061", name: "CYP46A1 24-hydroxylates CHOL", reactome_id: "R-HSA-192061", source: "Reactome", pmids: "14640697, 10377398", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193776", name: "Efflux of 24-hydroxycholesterol", reactome_id: "R-HSA-193776", source: "Reactome", pmids: "8790411, 9717719", compartment: "plasma membrane", go_term: "sterol transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193767", name: "Influx of 24-hydroxycholesterol", reactome_id: "R-HSA-193767", source: "Reactome", pmids: "8790411, 9717719", compartment: "plasma membrane", go_term: "sterol import", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192178", name: "CYP39A1 7-hydroxylates 24OH-CHOL", reactome_id: "R-HSA-192178", source: "Reactome", pmids: "10748047", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193789", name: "Cholest-5-ene-3beta,7alpha,24(S)-triol is oxidized and isomerized to 4-cholesten-7alpha,24(S)-diol-3-one", reactome_id: "R-HSA-193789", source: "Reactome", pmids: "12679481, 11067870", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193709", name: "CYP8B1 12-hydroxylates 4CHOL7a,24(S)DIOL", reactome_id: "R-HSA-193709", source: "Reactome", pmids: "10051404, 1400444", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193755", name: "4-cholesten-7alpha,12alpha,24(S)-triol-3-one is reduced to 5beta-cholestan-7alpha,12alpha,24(S)-triol-3-one", reactome_id: "R-HSA-193755", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193746", name: "4-cholesten-7alpha,24(S)-diol-3-one is reduced to 5beta-cholestan-7alpha,24(S)-diol-3-one", reactome_id: "R-HSA-193746", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193781", name: "5Beta-cholestan-7alpha,12alpha,24(S)-triol-3-one is reduced to 5beta-cholestan-3alpha,7alpha,12alpha,24(S)-tetrol", reactome_id: "R-HSA-193781", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193758", name: "5beta-cholestan-7alpha,24(S)-diol-3-one is reduced to 5beta-cholestan-3alpha,7alpha,24(S)-triol", reactome_id: "R-HSA-193758", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193774", name: "5beta-cholestan-3alpha,7alpha,12alpha,24(S)-tetrol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-193774", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193715", name: "5beta-cholestan-3alpha,7alpha,24(S)-triol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-193715", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193787", name: "5beta-cholestan-3alpha,7alpha,12alpha,24(S)-tetrol is hydroxylated to 5beta-cholestan-3alpha,7alpha,12alpha,24(S), 27-pentol", reactome_id: "R-HSA-193787", source: "Reactome", pmids: "1708392, 2019602, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193792", name: "CYP27A1 27-hydroxylates 5β-CHOL3α,7α,24(s)-triol", reactome_id: "R-HSA-193792", source: "Reactome", pmids: "1708392, 2019602, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193780", name: "5beta-cholestan-3alpha,7alpha,12alpha,24(S),27-pentol is oxidized to 3alpha,7alpha,12alpha,24(S)-tetrahydroxy-5beta-cholestan-27-al", reactome_id: "R-HSA-193780", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193719", name: "5beta-cholestan-3alpha,7alpha,24(S),27-tetrol is oxidized to 3alpha,7alpha,24(S)-trihydroxy-5beta-cholestan-27-al", reactome_id: "R-HSA-193719", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193713", name: "3alpha,7alpha,12alpha,24(S)-tetrahydroxy-5beta-cholestan-27-al is oxidized to 3alpha,7alpha,12alpha,24(S)-tetrahydroxy-5beta-cholestanoate (TetraHCA)", reactome_id: "R-HSA-193713", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193737", name: "3alpha,7alpha,24(S)-trihydroxy-5beta-cholestan-27-al is oxidized to 3alpha,7alpha,24(S)-trihydroxy-5beta-cholestanoate (3,7,24THCA)", reactome_id: "R-HSA-193737", source: "Reactome", pmids: "1708392, 9660774", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193722", name: "TetraHCA is translocated from the mitochondrial matrix to the cytosol", reactome_id: "R-HSA-193722", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", go_term: "export from the mitochondrion", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193786", name: "3,7,24THCA is translocated from the mitochondrial matrix to the cytosol", reactome_id: "R-HSA-193786", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", go_term: "export from the mitochondrion", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193766", name: "TetraHCA is conjugated with Coenzyme A (SLC27A5 BACS)", reactome_id: "R-HSA-193766", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193711", name: "3,7,24THCA is conjugated with Coenzyme A (SLC27A5 BACS)", reactome_id: "R-HSA-193711", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193727", name: "TetraHCA is conjugated with Coenzyme A (SLC27A2 VLCS)", reactome_id: "R-HSA-193727", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193743", name: "3,7,24THCA is conjugated with Coenzyme A (SLC27A2 VLCS)", reactome_id: "R-HSA-193743", source: "Reactome", pmids: "10479480, 10749848, 11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193761", name: "25(R) TetraHCA-CoA is translocated from the cytosol to the peroxisome", reactome_id: "R-HSA-193761", source: "Reactome", pmids: "12543708, 12966071", compartment: "cytosol, peroxisomal matrix", go_term: "peroxisomal membrane transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193753", name: "3,7,24THCA-CoA is translocated from the cytosol to the peroxisome", reactome_id: "R-HSA-193753", source: "Reactome", pmids: "12543708, 12966071", compartment: "cytosol, peroxisomal matrix", go_term: "peroxisomal membrane transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193763", name: "Isomerization of 25(R) TetraHCA-CoA to (24R, 25R) 3alpha,7alpha,12alpha,24-tetrahydroxy-5beta-cholestanoyl-CoA", reactome_id: "R-HSA-193763", source: "Reactome", pmids: "7649182, 11060344, 10655068", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193736", name: "Isomerization of 3,7,24THCA-CoA to (24R, 25R) 3alpha,7alpha,24-trihydroxy-5beta-cholestanoyl-CoA", reactome_id: "R-HSA-193736", source: "Reactome", pmids: "7649182, 11060344, 10655068", compartment: "peroxisomal matrix", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192123", name: "CYP27A1 27-hydroxylates CHOL", reactome_id: "R-HSA-192123", source: "Reactome", pmids: "1708392", compartment: "mitochondrial matrix", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193812", name: "Efflux of 27-hydroxycholesterol", reactome_id: "R-HSA-193812", source: "Reactome", compartment: "plasma membrane", go_term: "sterol transport"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-193801", name: "Influx of 27-hydroxycholesterol", reactome_id: "R-HSA-193801", source: "Reactome", pmids: "8790411, 9717719", compartment: "plasma membrane", go_term: "sterol import", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191972", name: "27-hydroxycholesterol is 7alpha-hydroxylated", reactome_id: "R-HSA-191972", source: "Reactome", pmids: "10588945", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193816", name: "Cholest-5-ene-3beta,7alpha,27-triol is oxidized and isomerized to 4-cholesten-7alpha,27-diol-3-one", reactome_id: "R-HSA-193816", source: "Reactome", pmids: "12679481, 11067870", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193845", name: "CYP8B1 12-hydroxylates 4CHOL7a,27DONE", reactome_id: "R-HSA-193845", source: "Reactome", pmids: "10051404, 1400444", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193821", name: "4-cholesten-7alpha,12alpha,27-triol-3-one is reduced to 5beta-cholestan-7alpha,12alpha,27-triol-3-one", reactome_id: "R-HSA-193821", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193824", name: "4-cholesten-7alpha,27-diol-3-one is reduced to 5beta-cholestan-7alpha,27-diol-3-one", reactome_id: "R-HSA-193824", source: "Reactome", pmids: "7508385", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193800", name: "5Beta-cholestan-7alpha,12alpha,27-triol-3-one is reduced to 5beta-cholestan-3alpha,7alpha,12alpha,27-tetrol", reactome_id: "R-HSA-193800", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193841", name: "5beta-cholestan-7alpha,27-diol-3-one is reduced to 5beta-cholestan-3alpha,7alpha,27-triol", reactome_id: "R-HSA-193841", source: "Reactome", pmids: "11158055", compartment: "cytosol", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193832", name: "5beta-cholestan-3alpha,7alpha,12alpha,27-tetrol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-193832", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-193808", name: "5beta-cholestan-3alpha,7alpha,27-triol is translocated from the cytosol to the mitochondrial matrix", reactome_id: "R-HSA-193808", source: "Reactome", pmids: "12543708", compartment: "mitochondrial inner membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-191983", name: "Cholesterol is hydroxylated to 25-hydroxycholesterol", reactome_id: "R-HSA-191983", source: "Reactome", pmids: "9852097", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-192065", name: "CYP7B1 7-hydroxylates 25OH-CHOL", reactome_id: "R-HSA-192065", source: "Reactome", pmids: "10588945", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8867667", name: "OSBPs transport 25OH-CHOL from ER membrane to plasma membrane", reactome_id: "R-HSA-8867667", source: "Reactome", pmids: "11802775, 24742681, 26715851, 17428193, 23830809", compartment: "cytosol, endoplasmic reticulum membrane, plasma membrane", evidence: "Reactome (reviewed, 6 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8868402", name: "OSBP exchanges 25OH-CHOL with PI4P from ER membrane to Golgi membrane", reactome_id: "R-HSA-8868402", source: "Reactome", pmids: "24209621", compartment: "cytosol, endoplasmic reticulum membrane, Golgi membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5340195", name: "NR1H4 binds DCA, CDCA, LCHA", reactome_id: "R-HSA-5340195", source: "Reactome", pmids: "10334993, 10334992, 12393883, 12815072, 16541101", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 8 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-5340251", name: "NR1H4:DCA,CDCA,LCHA binds RXRA and NCOA1,2", reactome_id: "R-HSA-5340251", source: "Reactome", pmids: "10334993, 12815072, 16541101, 11870371, 11387316", compartment: "nucleoplasm", evidence: "Reactome (reviewed, 7 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194187", name: "SLC10A2 transports bile salts and acids and Na+ from extracellular region to cytosol", reactome_id: "R-HSA-194187", source: "Reactome", pmids: "12663868, 14699511, 12486725", compartment: "plasma membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-9733973", name: "Bile salts bind FABP6", reactome_id: "R-HSA-9733973", source: "Reactome", pmids: "7588781, 12486725", compartment: "cytosol", go_term: "bile acid and bile salt transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-9733969", name: "Bile salts dissociate from FABP6", reactome_id: "R-HSA-9733969", source: "Reactome", pmids: "12486725, 7588781", compartment: "cytosol", go_term: "bile acid and bile salt transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194153", name: "ABCC3 transports bile salts from cytosol to extracellular region", reactome_id: "R-HSA-194153", source: "Reactome", pmids: "12704183, 10987286, 12220224", compartment: "plasma membrane, cytosol, extracellular region", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-9733964", name: "SLC51A:SLC51B transports bile salts from cytosol to extracellular region", reactome_id: "R-HSA-9733964", source: "Reactome", pmids: "16317684, 17650074", compartment: "cytosol, plasma membrane, extracellular region", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-9733545", name: "Bile salts and acids bind ALB", reactome_id: "R-HSA-9733545", source: "Reactome", pmids: "13416382, 7077161", compartment: "extracellular region", go_term: "bile acid and bile salt transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:BlackBoxEvent {id: "rxn:reactome:R-HSA-9733960", name: "Bile salts and acids dissociate from ALB", reactome_id: "R-HSA-9733960", source: "Reactome", pmids: "13416382, 7077161", compartment: "extracellular region", go_term: "bile acid and bile salt transport", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194121", name: "SLC10A1 co-transport bile salts and Na+ from extracellular region to cytosol", reactome_id: "R-HSA-194121", source: "Reactome", pmids: "8132774", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194130", name: "Transport (influx) of bile salts and acids by OATP-A", reactome_id: "R-HSA-194130", source: "Reactome", pmids: "7557095", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194083", name: "SLCO1B1 transports ALB:(GCCA,TCCA) from extracellular region to cytosol", reactome_id: "R-HSA-194083", source: "Reactome", pmids: "10358072, 10601278, 11159893", compartment: "plasma membrane", evidence: "Reactome (reviewed, 3 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-194079", name: "SLCO1B3 transports ALB:(GCCA, TCCA) from extracellular region to cytosol", reactome_id: "R-HSA-194079", source: "Reactome", pmids: "11159893", compartment: "plasma membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-8873850", name: "STARD5 binds DCA, LCA", reactome_id: "R-HSA-8873850", source: "Reactome", pmids: "23337244, 23018617", compartment: "cytosol", evidence: "Reactome (reviewed, 2 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-159425", name: "Cytosolic cholate and chenodeoxycholate are conjugated with Coenzyme A (SLC27A5 BACS)", reactome_id: "R-HSA-159425", source: "Reactome", pmids: "11980911", compartment: "cytosol, endoplasmic reticulum membrane", evidence: "Reactome (reviewed, 1 refs)"});
CREATE (:Reaction {id: "rxn:reactome:R-HSA-159431", name: "Cytosolic chenodeoxycholoyl-CoA or choloyl-CoA are conjugated with glycine or taurine", reactome_id: "R-HSA-159431", source: "Reactome", pmids: "8034703, 2037576, 10884298", compartment: "cytosol", go_term: "bile acid metabolic process", evidence: "Reactome (reviewed, 3 refs)"});

// ====== 新增关系: 444 ======

MATCH (r {id:"rxn:reactome:R-HSA-174786"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-174786"}), (n {id:"mol:ApoB100"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:MTP"}), (r {id:"rxn:reactome:R-HSA-174786"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-174786"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174731"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-174741"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoB100"}), (r {id:"rxn:reactome:R-HSA-174741"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:MTP"}), (r {id:"rxn:reactome:R-HSA-174741"})
MERGE (n)-[:INHIBITS {source:"Reactome", reactome_id:"R-HSA-174741"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-174786"}), (r2 {id:"rxn:reactome:R-HSA-174741"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-174587"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-174741"}), (r2 {id:"rxn:reactome:R-HSA-174587"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-174660"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174660"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-174587"}), (r2 {id:"rxn:reactome:R-HSA-174660"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-8866329"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:MTP"}), (r {id:"rxn:reactome:R-HSA-8866329"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-8866329"}]->(r);
MATCH (n {id:"mol:MTP"}), (r {id:"rxn:reactome:R-HSA-8866329"})
MERGE (n)-[:INHIBITS {source:"Reactome", reactome_id:"R-HSA-8866329"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8866308"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866329"}), (r2 {id:"rxn:reactome:R-HSA-8866308"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-8866304"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866308"}), (r2 {id:"rxn:reactome:R-HSA-8866304"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-8866327"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-8866327"}), (n {id:"mol:ApoC1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866304"}), (r2 {id:"rxn:reactome:R-HSA-8866327"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-8866321"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoC1"}), (r {id:"rxn:reactome:R-HSA-8866321"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866327"}), (r2 {id:"rxn:reactome:R-HSA-8866321"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-264758"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-5682084"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-5682084"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-5682084"}), (n {id:"mol:ABCA1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r {id:"rxn:reactome:R-HSA-5682103"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-5682103"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-5682103"}), (n {id:"mol:ABCA1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-5682084"}), (r2 {id:"rxn:reactome:R-HSA-5682103"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-5682101"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-5682101"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-5682101"}), (n {id:"mol:ABCA1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-5682103"}), (r2 {id:"rxn:reactome:R-HSA-5682101"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-216727"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-216727"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-216727"}), (n {id:"mol:ApoA1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-264758"}), (r2 {id:"rxn:reactome:R-HSA-216727"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-216723"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-216723"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-216723"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-216727"}), (r2 {id:"rxn:reactome:R-HSA-216723"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6813720"}), (r2 {id:"rxn:reactome:R-HSA-216723"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8937442"}), (r2 {id:"rxn:reactome:R-HSA-216723"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-216757"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ABCA1"}), (r {id:"rxn:reactome:R-HSA-216757"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-216757"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-216727"}), (r2 {id:"rxn:reactome:R-HSA-216757"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-216756"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-216723"}), (r2 {id:"rxn:reactome:R-HSA-216756"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-216757"}), (r2 {id:"rxn:reactome:R-HSA-216756"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-349657"}), (pw {id:"pathway:rct"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-216723"}), (r2 {id:"rxn:reactome:R-HSA-349657"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-216757"}), (r2 {id:"rxn:reactome:R-HSA-349657"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-349638"}), (r2 {id:"rxn:reactome:R-HSA-349657"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LPL"}), (r {id:"rxn:reactome:R-HSA-6784861"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784861"}), (n {id:"mol:LPL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:LPL"}), (r {id:"rxn:reactome:R-HSA-8857928"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:GPIHBP1"}), (r {id:"rxn:reactome:R-HSA-8857928"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8857928"}), (n {id:"mol:LPL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784861"}), (r2 {id:"rxn:reactome:R-HSA-8857928"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:ANGPTL3"}), (r {id:"rxn:reactome:R-HSA-8856525"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:ANGPTL8"}), (r {id:"rxn:reactome:R-HSA-8856525"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8856525"}), (n {id:"mol:ANGPTL3"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:LPL"}), (r {id:"rxn:reactome:R-HSA-6784628"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784628"}), (n {id:"mol:LPL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r {id:"rxn:reactome:R-HSA-6784628"}), (n {id:"mol:GPIHBP1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:ANGPTL3"}), (r {id:"rxn:reactome:R-HSA-6784628"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-6784628"}]->(r);
MATCH (n {id:"mol:ANGPTL4"}), (r {id:"rxn:reactome:R-HSA-6784628"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-6784628"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784861"}), (r2 {id:"rxn:reactome:R-HSA-6784628"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LPL"}), (r {id:"rxn:reactome:R-HSA-6784676"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784676"}), (n {id:"mol:LPL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r {id:"rxn:reactome:R-HSA-6784676"}), (n {id:"mol:GPIHBP1"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:ANGPTL4"}), (r {id:"rxn:reactome:R-HSA-6784676"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-6784676"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784620"}), (r2 {id:"rxn:reactome:R-HSA-6784648"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784648"}), (r2 {id:"rxn:reactome:R-HSA-6784622"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:HL"}), (r {id:"rxn:reactome:R-HSA-6785181"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6785181"}), (n {id:"mol:HL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:HL"}), (r {id:"rxn:reactome:R-HSA-6785178"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6785178"}), (n {id:"mol:HL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-6785181"}), (r2 {id:"rxn:reactome:R-HSA-6785178"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:HL"}), (r {id:"rxn:reactome:R-HSA-6785213"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6785213"}), (n {id:"mol:HL"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-6785178"}), (r2 {id:"rxn:reactome:R-HSA-6785213"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:HL"}), (r {id:"rxn:reactome:R-HSA-5694109"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-5694109"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-6785213"}), (r2 {id:"rxn:reactome:R-HSA-5694109"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LPL"}), (r {id:"rxn:reactome:R-HSA-174757"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-174757"}]->(r);
MATCH (n {id:"mol:ApoC2"}), (r {id:"rxn:reactome:R-HSA-174757"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-174757"}]->(r);
MATCH (n {id:"mol:ApoC3"}), (r {id:"rxn:reactome:R-HSA-174757"})
MERGE (n)-[:INHIBITS {source:"Reactome", reactome_id:"R-HSA-174757"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-174660"}), (r2 {id:"rxn:reactome:R-HSA-174757"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8857928"}), (r2 {id:"rxn:reactome:R-HSA-174757"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-174757"}), (r2 {id:"rxn:reactome:R-HSA-174690"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174739"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174739"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-174690"}), (r2 {id:"rxn:reactome:R-HSA-174739"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-266350"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:CETP"}), (r {id:"rxn:reactome:R-HSA-266350"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-266350"}), (n {id:"mol:CETP"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-266328"}), (r2 {id:"rxn:reactome:R-HSA-266350"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-176879"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoA_"}), (r {id:"rxn:reactome:R-HSA-176879"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-9737780"}), (pw {id:"pathway:endogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:MTP"}), (r {id:"rxn:reactome:R-HSA-9737780"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-9737780"}), (n {id:"mol:MTP"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:ABCG1"}), (r {id:"rxn:reactome:R-HSA-266082"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-266082"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-216756"}), (r2 {id:"rxn:reactome:R-HSA-266089"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-266082"}), (r2 {id:"rxn:reactome:R-HSA-266089"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LCAT"}), (r {id:"rxn:reactome:R-HSA-264678"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-264678"}), (n {id:"mol:LCAT"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-216756"}), (r2 {id:"rxn:reactome:R-HSA-264678"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LCAT"}), (r {id:"rxn:reactome:R-HSA-264689"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-264689"}), (n {id:"mol:LCAT"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:ApoC3"}), (r {id:"rxn:reactome:R-HSA-266303"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-266303"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:ApoC2"}), (r {id:"rxn:reactome:R-HSA-266303"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-266303"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-266082"}), (r2 {id:"rxn:reactome:R-HSA-266299"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LCAT"}), (r {id:"rxn:reactome:R-HSA-264695"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-264695"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-264695"}), (r2 {id:"rxn:reactome:R-HSA-264679"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LCAT"}), (r {id:"rxn:reactome:R-HSA-266315"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-266315"}), (n {id:"mol:LCAT"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:LCAT"}), (r {id:"rxn:reactome:R-HSA-266310"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-266310"}), (n {id:"mol:LCAT"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-266315"}), (r2 {id:"rxn:reactome:R-HSA-266310"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:CETP"}), (r {id:"rxn:reactome:R-HSA-266328"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-266328"}), (n {id:"mol:CETP"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-266350"}), (r2 {id:"rxn:reactome:R-HSA-266328"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:CETP"}), (r {id:"rxn:reactome:R-HSA-349404"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-349404"}), (n {id:"mol:CETP"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:EL"}), (r {id:"rxn:reactome:R-HSA-8980228"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-8980228"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174657"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174657"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-174657"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174657"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:HL"}), (r {id:"rxn:reactome:R-HSA-174657"})
MERGE (n)-[:INHIBITS {source:"Reactome", reactome_id:"R-HSA-174657"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-174739"}), (r2 {id:"rxn:reactome:R-HSA-174657"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-171087"}), (r2 {id:"rxn:reactome:R-HSA-174657"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-174706"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174706"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174706"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-174657"}), (r2 {id:"rxn:reactome:R-HSA-174706"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-174808"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174808"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174808"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-174706"}), (r2 {id:"rxn:reactome:R-HSA-174808"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-174624"}), (pw {id:"pathway:exogenous"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (n {id:"mol:ApoE"}), (r {id:"rxn:reactome:R-HSA-174624"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-174624"}), (n {id:"mol:ApoE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r {id:"rxn:reactome:R-HSA-174624"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-174808"}), (r2 {id:"rxn:reactome:R-HSA-174624"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:VLDLR"}), (r {id:"rxn:reactome:R-HSA-8854462"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8854462"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866321"}), (r2 {id:"rxn:reactome:R-HSA-8854462"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:ApoB100"}), (r {id:"rxn:reactome:R-HSA-8854408"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8854408"}), (n {id:"mol:ApoB100"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-8866321"}), (r2 {id:"rxn:reactome:R-HSA-8854408"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-171122"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-171122"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-171087"}), (r2 {id:"rxn:reactome:R-HSA-171122"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-171141"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-171141"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-171122"}), (r2 {id:"rxn:reactome:R-HSA-171141"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-171059"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-171059"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-171141"}), (r2 {id:"rxn:reactome:R-HSA-171059"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-171106"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-171106"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-171059"}), (r2 {id:"rxn:reactome:R-HSA-171106"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-171106"}), (r2 {id:"rxn:reactome:R-HSA-8876366"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876366"}), (r2 {id:"rxn:reactome:R-HSA-8865667"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8865667"}), (r2 {id:"rxn:reactome:R-HSA-8876472"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876484"}), (r2 {id:"rxn:reactome:R-HSA-8876472"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876472"}), (r2 {id:"rxn:reactome:R-HSA-8876484"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876484"}), (r2 {id:"rxn:reactome:R-HSA-8876485"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876485"}), (r2 {id:"rxn:reactome:R-HSA-8876696"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8876696"}), (r2 {id:"rxn:reactome:R-HSA-8876731"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-171087"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-171087"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-171106"}), (r2 {id:"rxn:reactome:R-HSA-171087"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-174624"}), (r2 {id:"rxn:reactome:R-HSA-171087"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:PCSK9"}), (r {id:"rxn:reactome:R-HSA-6784734"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-6784734"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784734"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:PCSK9"}), (r {id:"rxn:reactome:R-HSA-9733403"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-9733403"}), (n {id:"mol:PCSK9"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-6784735"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784735"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784734"}), (r2 {id:"rxn:reactome:R-HSA-6784735"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-6784729"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-6784729"}), (n {id:"mol:LDLR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784735"}), (r2 {id:"rxn:reactome:R-HSA-6784729"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:LDLR"}), (r {id:"rxn:reactome:R-HSA-6784738"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-6784729"}), (r2 {id:"rxn:reactome:R-HSA-6784738"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-349638"}), (n {id:"lipid:CE"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-349637"}), (r2 {id:"rxn:reactome:R-HSA-349638"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-264848"}), (r2 {id:"rxn:reactome:R-HSA-264834"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:VLDLR"}), (r {id:"rxn:reactome:R-HSA-8854628"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:PCSK9"}), (r {id:"rxn:reactome:R-HSA-8855111"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (n {id:"mol:VLDLR"}), (r {id:"rxn:reactome:R-HSA-8855111"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8855111"}), (n {id:"mol:PCSK9"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:PCSK9"}), (r {id:"rxn:reactome:R-HSA-8855131"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8855131"}), (n {id:"mol:PCSK9"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (n {id:"mol:PCSK9"}), (r {id:"rxn:reactome:R-HSA-8855130"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-8855130"}), (n {id:"mol:PCSK9"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-75848"}), (r2 {id:"rxn:reactome:R-HSA-8848215"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-8848215"}), (r2 {id:"rxn:reactome:R-HSA-191323"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:HMGCR"}), (r {id:"rxn:reactome:R-HSA-191352"})
MERGE (n)-[:CATALYZES {source:"Reactome", reactome_id:"R-HSA-191352"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-191323"}), (r2 {id:"rxn:reactome:R-HSA-191352"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:HMGCR"}), (r {id:"rxn:reactome:R-HSA-9705584"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r {id:"rxn:reactome:R-HSA-9705584"}), (n {id:"mol:HMGCR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-9757010"}), (r2 {id:"rxn:reactome:R-HSA-9705584"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191352"}), (r2 {id:"rxn:reactome:R-HSA-191380"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191380"}), (r2 {id:"rxn:reactome:R-HSA-191422"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191422"}), (r2 {id:"rxn:reactome:R-HSA-191414"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191414"}), (r2 {id:"rxn:reactome:R-HSA-191382"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191382"}), (r2 {id:"rxn:reactome:R-HSA-191322"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191414"}), (r2 {id:"rxn:reactome:R-HSA-191322"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191382"}), (r2 {id:"rxn:reactome:R-HSA-9717834"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191414"}), (r2 {id:"rxn:reactome:R-HSA-9717834"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191322"}), (r2 {id:"rxn:reactome:R-HSA-191303"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9717834"}), (r2 {id:"rxn:reactome:R-HSA-191303"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191414"}), (r2 {id:"rxn:reactome:R-HSA-191303"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9717834"}), (r2 {id:"rxn:reactome:R-HSA-9717830"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191322"}), (r2 {id:"rxn:reactome:R-HSA-9717830"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191414"}), (r2 {id:"rxn:reactome:R-HSA-9717830"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191303"}), (r2 {id:"rxn:reactome:R-HSA-191405"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9717830"}), (r2 {id:"rxn:reactome:R-HSA-191405"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191405"}), (r2 {id:"rxn:reactome:R-HSA-8952137"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191405"}), (r2 {id:"rxn:reactome:R-HSA-191402"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191402"}), (r2 {id:"rxn:reactome:R-HSA-191299"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191299"}), (r2 {id:"rxn:reactome:R-HSA-191366"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191366"}), (r2 {id:"rxn:reactome:R-HSA-194678"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194678"}), (r2 {id:"rxn:reactome:R-HSA-194698"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194678"}), (r2 {id:"rxn:reactome:R-HSA-194674"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194678"}), (r2 {id:"rxn:reactome:R-HSA-194641"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194698"}), (r2 {id:"rxn:reactome:R-HSA-194641"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194641"}), (r2 {id:"rxn:reactome:R-HSA-194642"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194642"}), (r2 {id:"rxn:reactome:R-HSA-194689"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194689"}), (r2 {id:"rxn:reactome:R-HSA-194669"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194669"}), (r2 {id:"rxn:reactome:R-HSA-194718"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194718"}), (r2 {id:"rxn:reactome:R-HSA-194632"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194632"}), (r2 {id:"rxn:reactome:R-HSA-195690"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-195690"}), (r2 {id:"rxn:reactome:R-HSA-195664"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-195664"}), (r2 {id:"rxn:reactome:R-HSA-196402"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-196402"}), (r2 {id:"rxn:reactome:R-HSA-196417"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191366"}), (r2 {id:"rxn:reactome:R-HSA-9755937"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9755937"}), (r2 {id:"rxn:reactome:R-HSA-9947148"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-76494"}), (r2 {id:"rxn:reactome:R-HSA-9947148"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9947148"}), (r2 {id:"rxn:reactome:R-HSA-9946140"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9946140"}), (r2 {id:"rxn:reactome:R-HSA-9947203"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-76494"}), (r2 {id:"rxn:reactome:R-HSA-9947203"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9947203"}), (r2 {id:"rxn:reactome:R-HSA-9945822"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9945822"}), (r2 {id:"rxn:reactome:R-HSA-9945784"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9945784"}), (r2 {id:"rxn:reactome:R-HSA-9947207"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-76494"}), (r2 {id:"rxn:reactome:R-HSA-9947207"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9947207"}), (r2 {id:"rxn:reactome:R-HSA-9945787"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9945787"}), (r2 {id:"rxn:reactome:R-HSA-9945804"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194632"}), (r2 {id:"rxn:reactome:R-HSA-6807064"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6807064"}), (r2 {id:"rxn:reactome:R-HSA-6807052"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9945804"}), (r2 {id:"rxn:reactome:R-HSA-6807052"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6807052"}), (r2 {id:"rxn:reactome:R-HSA-6807053"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-76494"}), (r2 {id:"rxn:reactome:R-HSA-6807053"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6807053"}), (r2 {id:"rxn:reactome:R-HSA-6807055"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-5250531"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-196417"}), (r2 {id:"rxn:reactome:R-HSA-5250531"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6807055"}), (r2 {id:"rxn:reactome:R-HSA-5250531"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-2317530"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-2317531"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-1655825"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r {id:"rxn:reactome:R-HSA-1655834"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-1655825"}), (r2 {id:"rxn:reactome:R-HSA-1655834"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-1655842"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-1655834"}), (r2 {id:"rxn:reactome:R-HSA-1655842"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-1655851"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-1655842"}), (r2 {id:"rxn:reactome:R-HSA-1655851"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-2065549"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-1655851"}), (r2 {id:"rxn:reactome:R-HSA-2065549"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-2065550"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065549"}), (r2 {id:"rxn:reactome:R-HSA-2065550"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-1655831"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065550"}), (r2 {id:"rxn:reactome:R-HSA-1655831"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-2065539"}), (pw {id:"pathway:cholesterol_homeostasis"})
MERGE (r)-[:BELONGS_TO_PATHWAY {source:"Reactome"}]->(pw);
MATCH (r1 {id:"rxn:reactome:R-HSA-1655831"}), (r2 {id:"rxn:reactome:R-HSA-2065539"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426160"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426153"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2065966"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426158"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426148"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-6800052"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426154"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426144"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-2426162"}), (n {id:"mol:HMGCR"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426162"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426164"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426163"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426155"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426161"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426152"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426157"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065550"}), (r2 {id:"rxn:reactome:R-HSA-2426156"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426151"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426149"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426147"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426150"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065539"}), (r2 {id:"rxn:reactome:R-HSA-2426146"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:PPARa"}), (r {id:"rxn:reactome:R-HSA-1655826"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-1655826"}]->(r);
MATCH (n {id:"mol:HMGCR"}), (r {id:"rxn:reactome:R-HSA-1655826"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-1655826"}]->(r);
MATCH (n {id:"mol:HMGCR"}), (r {id:"rxn:reactome:R-HSA-1655826"})
MERGE (n)-[:INHIBITS {source:"Reactome", reactome_id:"R-HSA-1655826"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-400143"}), (r2 {id:"rxn:reactome:R-HSA-1655826"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426162"}), (r2 {id:"rxn:reactome:R-HSA-1655826"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426155"}), (r2 {id:"rxn:reactome:R-HSA-1655827"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426160"}), (r2 {id:"rxn:reactome:R-HSA-1655845"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426153"}), (r2 {id:"rxn:reactome:R-HSA-1655830"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-6800052"}), (r2 {id:"rxn:reactome:R-HSA-1655849"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426144"}), (r2 {id:"rxn:reactome:R-HSA-1655836"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426149"}), (r2 {id:"rxn:reactome:R-HSA-1655835"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426147"}), (r2 {id:"rxn:reactome:R-HSA-1655824"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:PPARa"}), (r {id:"rxn:reactome:R-HSA-1655850"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-1655850"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-400143"}), (r2 {id:"rxn:reactome:R-HSA-1655850"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426146"}), (r2 {id:"rxn:reactome:R-HSA-1655850"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426148"}), (r2 {id:"rxn:reactome:R-HSA-1655843"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426161"}), (r2 {id:"rxn:reactome:R-HSA-1655832"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426158"}), (r2 {id:"rxn:reactome:R-HSA-1655837"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"mol:PPARa"}), (r {id:"rxn:reactome:R-HSA-1655848"})
MERGE (n)-[:ACTIVATES {source:"Reactome", reactome_id:"R-HSA-1655848"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-400143"}), (r2 {id:"rxn:reactome:R-HSA-1655848"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426150"}), (r2 {id:"rxn:reactome:R-HSA-1655848"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426152"}), (r2 {id:"rxn:reactome:R-HSA-1655823"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426163"}), (r2 {id:"rxn:reactome:R-HSA-1655847"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426154"}), (r2 {id:"rxn:reactome:R-HSA-1655828"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426164"}), (r2 {id:"rxn:reactome:R-HSA-1655852"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426157"}), (r2 {id:"rxn:reactome:R-HSA-1655846"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426156"}), (r2 {id:"rxn:reactome:R-HSA-1655839"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2426151"}), (r2 {id:"rxn:reactome:R-HSA-1655844"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-2065966"}), (r2 {id:"rxn:reactome:R-HSA-1655833"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r {id:"rxn:reactome:R-HSA-192051"}), (n {id:"lipid:FC"})
MERGE (r)-[:PRODUCES {source:"Reactome"}]->(n);
MATCH (r1 {id:"rxn:reactome:R-HSA-5340195"}), (r2 {id:"rxn:reactome:R-HSA-192051"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (n {id:"lipid:FC"}), (r {id:"rxn:reactome:R-HSA-192097"})
MERGE (n)-[:SUBSTRATE_OF {source:"Reactome"}]->(r);
MATCH (r1 {id:"rxn:reactome:R-HSA-192051"}), (r2 {id:"rxn:reactome:R-HSA-192097"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192097"}), (r2 {id:"rxn:reactome:R-HSA-192157"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192157"}), (r2 {id:"rxn:reactome:R-HSA-192067"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192097"}), (r2 {id:"rxn:reactome:R-HSA-192033"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192067"}), (r2 {id:"rxn:reactome:R-HSA-192036"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192033"}), (r2 {id:"rxn:reactome:R-HSA-192160"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192036"}), (r2 {id:"rxn:reactome:R-HSA-192010"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192160"}), (r2 {id:"rxn:reactome:R-HSA-193537"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192010"}), (r2 {id:"rxn:reactome:R-HSA-191999"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193537"}), (r2 {id:"rxn:reactome:R-HSA-193393"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191999"}), (r2 {id:"rxn:reactome:R-HSA-192042"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193832"}), (r2 {id:"rxn:reactome:R-HSA-192042"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193393"}), (r2 {id:"rxn:reactome:R-HSA-193497"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193808"}), (r2 {id:"rxn:reactome:R-HSA-193497"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192042"}), (r2 {id:"rxn:reactome:R-HSA-192054"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193497"}), (r2 {id:"rxn:reactome:R-HSA-193460"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192054"}), (r2 {id:"rxn:reactome:R-HSA-191971"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193460"}), (r2 {id:"rxn:reactome:R-HSA-193519"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191971"}), (r2 {id:"rxn:reactome:R-HSA-193401"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193519"}), (r2 {id:"rxn:reactome:R-HSA-193424"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191971"}), (r2 {id:"rxn:reactome:R-HSA-192137"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193519"}), (r2 {id:"rxn:reactome:R-HSA-193407"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192137"}), (r2 {id:"rxn:reactome:R-HSA-192325"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193401"}), (r2 {id:"rxn:reactome:R-HSA-192325"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193424"}), (r2 {id:"rxn:reactome:R-HSA-193482"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193407"}), (r2 {id:"rxn:reactome:R-HSA-193482"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192325"}), (r2 {id:"rxn:reactome:R-HSA-192056"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193482"}), (r2 {id:"rxn:reactome:R-HSA-193452"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192056"}), (r2 {id:"rxn:reactome:R-HSA-192335"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193452"}), (r2 {id:"rxn:reactome:R-HSA-193369"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192335"}), (r2 {id:"rxn:reactome:R-HSA-192331"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193369"}), (r2 {id:"rxn:reactome:R-HSA-193535"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192331"}), (r2 {id:"rxn:reactome:R-HSA-193455"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193763"}), (r2 {id:"rxn:reactome:R-HSA-193455"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193535"}), (r2 {id:"rxn:reactome:R-HSA-193508"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193736"}), (r2 {id:"rxn:reactome:R-HSA-193508"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193455"}), (r2 {id:"rxn:reactome:R-HSA-192341"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193508"}), (r2 {id:"rxn:reactome:R-HSA-193533"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192341"}), (r2 {id:"rxn:reactome:R-HSA-193385"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193385"}), (r2 {id:"rxn:reactome:R-HSA-193399"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192341"}), (r2 {id:"rxn:reactome:R-HSA-192312"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193533"}), (r2 {id:"rxn:reactome:R-HSA-193491"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192312"}), (r2 {id:"rxn:reactome:R-HSA-192315"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193491"}), (r2 {id:"rxn:reactome:R-HSA-192315"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192315"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194121"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194130"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194079"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194083"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-159431"}), (r2 {id:"rxn:reactome:R-HSA-193362"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192061"}), (r2 {id:"rxn:reactome:R-HSA-193776"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193776"}), (r2 {id:"rxn:reactome:R-HSA-193767"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193767"}), (r2 {id:"rxn:reactome:R-HSA-192178"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192178"}), (r2 {id:"rxn:reactome:R-HSA-193789"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193789"}), (r2 {id:"rxn:reactome:R-HSA-193709"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193709"}), (r2 {id:"rxn:reactome:R-HSA-193755"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193789"}), (r2 {id:"rxn:reactome:R-HSA-193746"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193755"}), (r2 {id:"rxn:reactome:R-HSA-193781"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193746"}), (r2 {id:"rxn:reactome:R-HSA-193758"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193781"}), (r2 {id:"rxn:reactome:R-HSA-193774"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193758"}), (r2 {id:"rxn:reactome:R-HSA-193715"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193774"}), (r2 {id:"rxn:reactome:R-HSA-193787"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193715"}), (r2 {id:"rxn:reactome:R-HSA-193792"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193787"}), (r2 {id:"rxn:reactome:R-HSA-193780"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193792"}), (r2 {id:"rxn:reactome:R-HSA-193719"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193780"}), (r2 {id:"rxn:reactome:R-HSA-193713"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193719"}), (r2 {id:"rxn:reactome:R-HSA-193737"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193713"}), (r2 {id:"rxn:reactome:R-HSA-193722"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193737"}), (r2 {id:"rxn:reactome:R-HSA-193786"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193722"}), (r2 {id:"rxn:reactome:R-HSA-193766"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193786"}), (r2 {id:"rxn:reactome:R-HSA-193711"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193722"}), (r2 {id:"rxn:reactome:R-HSA-193727"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193786"}), (r2 {id:"rxn:reactome:R-HSA-193743"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193727"}), (r2 {id:"rxn:reactome:R-HSA-193761"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193766"}), (r2 {id:"rxn:reactome:R-HSA-193761"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193743"}), (r2 {id:"rxn:reactome:R-HSA-193753"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193711"}), (r2 {id:"rxn:reactome:R-HSA-193753"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193761"}), (r2 {id:"rxn:reactome:R-HSA-193763"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193753"}), (r2 {id:"rxn:reactome:R-HSA-193736"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-192123"}), (r2 {id:"rxn:reactome:R-HSA-193812"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193812"}), (r2 {id:"rxn:reactome:R-HSA-193801"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-5340195"}), (r2 {id:"rxn:reactome:R-HSA-191972"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-191972"}), (r2 {id:"rxn:reactome:R-HSA-193816"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193816"}), (r2 {id:"rxn:reactome:R-HSA-193845"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193845"}), (r2 {id:"rxn:reactome:R-HSA-193821"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193816"}), (r2 {id:"rxn:reactome:R-HSA-193824"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193821"}), (r2 {id:"rxn:reactome:R-HSA-193800"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193824"}), (r2 {id:"rxn:reactome:R-HSA-193841"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193800"}), (r2 {id:"rxn:reactome:R-HSA-193832"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-193841"}), (r2 {id:"rxn:reactome:R-HSA-193808"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-5340195"}), (r2 {id:"rxn:reactome:R-HSA-192065"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-5340195"}), (r2 {id:"rxn:reactome:R-HSA-5340251"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-5340195"}), (r2 {id:"rxn:reactome:R-HSA-194187"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194187"}), (r2 {id:"rxn:reactome:R-HSA-9733973"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9733973"}), (r2 {id:"rxn:reactome:R-HSA-9733969"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9733969"}), (r2 {id:"rxn:reactome:R-HSA-194153"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9733964"}), (r2 {id:"rxn:reactome:R-HSA-9733545"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194153"}), (r2 {id:"rxn:reactome:R-HSA-9733545"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194153"}), (r2 {id:"rxn:reactome:R-HSA-194121"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-9733545"}), (r2 {id:"rxn:reactome:R-HSA-194121"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194153"}), (r2 {id:"rxn:reactome:R-HSA-194130"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194153"}), (r2 {id:"rxn:reactome:R-HSA-194083"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194153"}), (r2 {id:"rxn:reactome:R-HSA-194079"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-194130"}), (r2 {id:"rxn:reactome:R-HSA-159425"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);
MATCH (r1 {id:"rxn:reactome:R-HSA-159425"}), (r2 {id:"rxn:reactome:R-HSA-159431"})
MERGE (r1)-[:PRECEDES {source:"Reactome"}]->(r2);

// ============================================================
//  验证查询
// ============================================================

// Reactome 导入的反应数
MATCH (n) WHERE n.source = 'Reactome' RETURN labels(n)[0] AS type, count(n) AS count;

// Reactome 导入的边数
MATCH ()-[r]->() WHERE r.source = 'Reactome' RETURN type(r) AS edge_type, count(r) AS count;

// 全局统计
MATCH (n) WITH count(n) AS nodes MATCH ()-[r]->() WITH nodes, count(r) AS edges
RETURN nodes, edges, round(edges * 1.0 / nodes, 2) AS avg_degree;