# LipoKG Schema Documentation

## Overview

LipoKG is a comprehensive knowledge graph for lipoprotein metabolism research, integrating data from STRING v12.0, ClinVar, KEGG, Reactome, WikiPathways, DisGeNET, and OMIM. The dataset is distributed in two tiers:

- **Core Schema** (7 node types, 7 relationship types): Distributed as CSV files for universal compatibility
- **Extended Schema** (32 node types, 26 relationship types; 25 additional node types, 19 additional relationship types): Available in the full Neo4j database dump

---

## Core Schema (CSV Distribution)

### Node Types

#### STRINGProtein (1,852 nodes)
Proteins from STRING database v12.0

**Properties:**
- `ensembl_id` (string): Ensembl protein identifier (e.g., "ENSP00000252519")
- `name` (string): Gene symbol (e.g., "LDLR")
- `description` (string): Protein description from STRING
- `string_id` (string): STRING database identifier

#### Particle (7 nodes)
Lipoprotein particles as first-class entities: Chylomicron, VLDL, IDL, LDL, HDL, Lp(a), Remnant

**Properties:**
- `name` (string): Particle name
- `description` (string): Biological description
- `density_class` (string): Ultracentrifugation density fraction
- `major_lipid` (string): Predominant lipid cargo

#### Molecule (57 nodes)
Small molecules, drugs, proteins, and metabolites relevant to lipoprotein metabolism

**Properties:**
- `name` (string): Molecule name or identifier
- `type` (string): Molecule type ("protein", "drug", "lipid", "enzyme", "receptor", "transporter", "transcription_factor", "cytokine", "adhesion_molecule", "protease", "sensor", "lipid_mediator")
- `source` (string): Data source ("UniProt", "DrugBank", "LIPID MAPS")

#### Disease (27 nodes)
Disease and trait entities related to lipoprotein metabolism from OMIM, DisGeNET, GLGC 2021, and Orphanet

**Properties:**
- `name` (string): Disease/trait name (e.g., "Familial Hypercholesterolemia", "LDL cholesterol levels")
- `source` (string): Source database ("OMIM", "DisGeNET", "GWAS_Catalog", "Orphanet")
- `mondo_id`/`efo_id` (string): MONDO or EFO ontology identifier

#### ClinVarVariant (4,042 nodes)
Pathogenic and likely pathogenic genetic variants from ClinVar (January 2024). Variants of uncertain significance and conflicting classifications excluded.

**Properties:**
- `variant_id` (string): ClinVar variation identifier
- `clinical_significance` (string): "Pathogenic", "Likely pathogenic", "Conflicting classifications of pathogenicity", etc.
- `review_status` (string): Review status in ClinVar

#### KEGGGene (52 nodes)
Genes from KEGG pathway hsa04979 "Lipid and atherosclerosis"

**Properties:**
- `name` (string): Gene symbol (e.g., "LDLR")
- `kegg_id` (string): KEGG gene identifier (e.g., "hsa:3949")

#### Pathway (15 nodes)
Biological pathways from KEGG, Reactome, and WikiPathways

**Properties:**
- `name` (string): Pathway name
- `source` (string): Source database ("KEGG", "Reactome", "WikiPathways")
- `pathway_id` (string): Pathway identifier (e.g., "hsa04979", "R-HSA-174824", "WP5242")

### Relationship Types

#### STRING_INTERACTS (31,878 edges)
Protein-protein interactions from STRING database (combined_score ≥ 700)

**Properties:**
- `source` (string): Source protein Ensembl ID
- `target` (string): Target protein Ensembl ID
- `score` (integer): Interaction confidence score (0-1000), threshold ≥700
- `combined_score` (integer): Combined interaction score (same as score)

#### COMPONENT_OF (48 edges)
Protein is a component of a lipoprotein particle (structural, exchangeable, receptor, anchoring, assembly, modification, regulator)

**Properties:**
- `protein` (string): Gene symbol
- `particle` (string): Particle name
- `component_type` (string): Type of component relationship

#### MODIFIES (23 edges)
Enzyme modifies a lipoprotein particle (hydrolysis, esterification, exchange, transfer, degradation, inhibition)

**Properties:**
- `enzyme` (string): Gene symbol
- `particle` (string): Particle name
- `modification_type` (string): Type of enzymatic modification

#### ASSEMBLED_BY (8 edges)
Particle assembly depends on an assembly protein

**Properties:**
- `particle` (string): Particle name
- `assembly_protein` (string): Gene symbol
- `assembly_stage` (string): Stage of particle assembly
- `tissue` (string): Tissue context

#### DISEASE_ASSOCIATION (238 edges)
Gene/protein-disease/trait associations from DisGeNET (35), OMIM (20), GLGC 2021 (111), Orphanet (50), and expert curation (22)

**Properties:**
- `source` (string): Gene symbol
- `target` (string): Disease/trait name
- `source_db` (string): Source database ("OMIM", "DisGeNET", "GWAS_Catalog", "Orphanet")
- `score` (float): Association score where applicable

#### VARIANT_OF (4,042 edges)
Links ClinVar variants to their associated genes

**Properties:**
- `variant` (string): ClinVar variant ID
- `gene` (string): Associated gene symbol
- `significance` (string): Clinical significance

#### MEMBER_OF (242 edges)
Links genes to pathways they participate in

**Properties:**
- `gene` (string): Gene symbol
- `pathway` (string): Pathway name
- `source` (string): Pathway database ("KEGG", "Reactome", "WikiPathways")

---

## Extended Schema (Neo4j Full Distribution)

The full Neo4j database includes 25 additional node types and 19 additional relationship types derived from Reactome pathway annotations and manual expert curation. These enable advanced queries about biochemical reactions, enzyme-substrate relationships, drug-target interactions, and disease progression.

### Extended Node Types

| Node Type | Count | Description |
|-----------|-------|-------------|
| Reaction | 238 | Biochemical reactions in lipoprotein metabolism |
| BlackBoxEvent | 56 | Abstracted biological events |
| Drug | 32 | Pharmacological agents targeting lipoprotein pathways |
| Particle | 7 | Lipoprotein particle types (Chylomicron, VLDL, IDL, LDL, HDL, Lp(a), Remnant) |
| Apolipoprotein | 9 | Apolipoprotein structural components |
| Regulator | 9 | Regulatory proteins (PCSK9, ANGPTL3, etc.) |
| Biomarker | 9 | Clinical biomarkers for lipid disorders |
| Enzyme | 8 | Metabolic enzymes (LPL, LIPC, LCAT, etc.) |
| Receptor | 7 | Lipoprotein receptors (LDLR, LRP1, etc.) |
| PathologyState | 7 | Disease states and clinical phenotypes |
| Transporter | 6 | Lipid transporters (ABCA1, NPC1L1, etc.) |
| Cytokine | 6 | Inflammatory mediators |
| Cell | 6 | Cell types involved in lipid metabolism |
| Lipid | 5 | Lipid species |
| InflammationSensor | 2 | Innate immune sensors (NLRP3, TLR4) |
| ScavengerReceptor | 2 | Scavenger receptors (SR-A, CD36) |
| AdhesionMolecule | 2 | Vascular adhesion molecules |
| Protease | 2 | Matrix metalloproteinases |
| TranscriptionFactor | 1 | SREBP-2 |
| Chemokine | 1 | MCP-1/CCL2 |
| AntiInflammatory | 1 | IL-10 |
| LipidMediator | 1 | Resolvin |
| InflammationMarker | 1 | CRP |
| ClinicalEvent | 1 | Plaque rupture |
| KEGGPathway | 1 | KEGG pathway container |

### Extended Relationship Types

| Relationship | Count | Description |
|--------------|-------|-------------|
| AFFECTS_GENE | 5,954 | Variant-gene regulatory effects |
| BELONGS_TO_PATHWAY | 346 | Detailed pathway membership |
| PRECEDES | 271 | Temporal ordering of reactions |
| SUBSTRATE_OF | 59 | Enzyme-substrate relationships |
| PRODUCES | 49 | Reaction products |
| EXPRESSED_IN | 39 | Tissue expression context |
| ACTIVATES | 36 | Protein activation |
| TARGETS | 29 | Drug-target interactions |
| CATALYZES | 26 | Enzyme-catalyzed reactions |
| COMPONENT_OF | 25 | Structural composition |
| MAPS_TO | 24 | Cross-database identifier mappings |
| TREATS | 20 | Drug-disease treatment relationships |
| INHIBITS | 17 | Inhibitory interactions |
| BIOMARKER_OF | 16 | Biomarker-disease associations |
| CAUSED_BY | 15 | Disease etiology |
| AFFECTS_LEVEL | 15 | Effects on lipid levels |
| OCCURS_IN | 12 | Cellular localization |
| RISK_FOR | 10 | Risk factor associations |
| TRANSFORMS_INTO | 8 | Particle transformations |
| TRANSPORTS | 6 | Transport relationships |
| LIGAND_OF | 5 | Receptor-ligand pairs |
| INDIRECTLY_INCREASES | 2 | Indirect upregulation |
| INDUCES | 2 | Induction relationships |
| PROGRESSES_TO | 1 | Disease progression |

---

## Data Sources

| Source | Version | Access Date | License | Coverage |
|--------|---------|-------------|---------|----------|
| STRING | v12.0 | 2024-01-15 | CC BY 4.0 | 1,852 proteins, 31,878 interactions |
| ClinVar | 2024-01 | 2024-01-20 | Public domain | 4,042 pathogenic/likely pathogenic variants |
| KEGG | 2024-01 | 2024-01-10 | Academic use | hsa04979, 52 genes |
| Reactome | v87 | 2026-06-13 | CC BY 4.0 | 12 pathways, 115 gene memberships |
| WikiPathways | 2024-01 | 2024-01-18 | CC BY 4.0 | 4 pathways, 79 gene memberships |
| DisGeNET | v7.0 (≥0.3) | 2024-01-08 | CC BY-NC-SA 4.0 | 35 gene-disease associations |
| OMIM | 2024-01 | 2024-01-05 | Custom | 20 gene-disease associations |
| GLGC 2021 (Graham et al.) | 2024-01 | 2024-01-25 | CC0 | 111 gene-trait associations |
| Orphanet | 2024-01 | 2024-01-22 | CC BY 4.0 | 50 gene-disease associations (7 disorders) |

## Statistics Summary

| Metric | Value |
|--------|-------|
| **Core Schema (CSV)** | |
| Core node types | 7 |
| Core relationship types | 7 |
| Core total nodes | 6,054 |
| Core total edges | 36,483 |
| **Extended Schema (Neo4j)** | |
| Additional node types | 24 |
| Additional relationship types | 18 |
| Total node types | 31 |
| Total relationship types | 25 |
| Total nodes | 6,475 |
| Total edges | 37,177 |

## Coverage Validation

- **KEGG hsa04979:** 89.5% coverage (119/133 genes)
- **Reactome lipoprotein pathways:** 85.9% coverage (61/71 genes)
- **WikiPathways lipid pathways:** 87.7% coverage (71/81 genes)
- **Overall coverage:** 83.0% (161/194 unique genes)
- **Gene Ontology GO:0042157:** 92.3% coverage (132/143 genes)

## Version Information

- **Version:** 1.1.0
- **Release date:** 2026-06-22
- **Data collection date:** 2024-01
