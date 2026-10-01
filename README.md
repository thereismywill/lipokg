# LipoKG: Lipoprotein Metabolism Knowledge Graph

## Overview

LipoKG is a comprehensive knowledge graph integrating multi-source data for lipoprotein metabolism research. This dataset combines protein-protein interactions, genetic variants, disease associations, and pathway information from high-quality databases including STRING, ClinVar, KEGG, Reactome, and WikiPathways.

## Dataset Description

### Scope
- **Domain:** Lipoprotein metabolism and cardiovascular disease
- **Organism:** Homo sapiens
- **Data sources:** STRING v12.0, ClinVar, KEGG, Reactome, DisGeNET, OMIM, GLGC 2021 (Graham et al.), Orphanet
- **External reference set (not imported):** WikiPathways lipid pathways (Table S29)
- **Release date:** 2026

### Statistics
- **Core schema total nodes:** 6,214
- **Core schema total edges:** 36,568
- **Whole-graph total nodes:** 6,639 (6,214 core + 425 extended types)
- **Whole-graph total edges:** 41,497 (36,568 core + 4,929 extended types)
- **Core node types:** 7 (STRINGProtein, Particle, Molecule, Disease, ClinVarVariant, KEGGGene, Pathway)
- **Core edge types:** 7 (STRING_INTERACTS, COMPONENT_OF, MODIFIES, ASSEMBLED_BY, DISEASE_ASSOCIATION, VARIANT_OF, MEMBER_OF)
- **Extended schema:** 32 node types (25 additional), 26 relationship types (19 additional) (Neo4j only)

### Coverage Validation

**ETL Completeness:**
- **KEGG hsa05417 (Lipid and atherosclerosis):** 72.7% coverage (157/216 genes)
- **Reactome lipoprotein pathways:** 85.9% coverage (61/71 genes)
- **WikiPathways lipid pathways:** 79.3% coverage (73/92 genes)
- **Overall pathway completeness:** 74.9% (259/346 unique reference genes)

**Independent Validation:**
- **Gene Ontology GO:0042157 (lipoprotein metabolic process):** 92.3% coverage (132/143 genes)
- **GLGC 2021 GWAS loci:** 64.9% coverage (244/376 genome-wide significant loci)
- **ClinGen dosage-sensitive genes:** 100% coverage (25/25 definitive + moderate-evidence genes)
- **Published review gene lists:** 95.9% coverage (93/97 genes)
- **Expert-curated 54-gene reference set:** 100% coverage (54/54)

## Data Files

### Node Data

#### `data/string_proteins.csv`
Proteins from STRING database (1,852 nodes)
- `ensembl_id`: Ensembl protein identifier
- `name`: Gene symbol
- `description`: Protein description
- `string_id`: STRING database identifier

#### `data/particles.csv`
Lipoprotein particles as first-class entities (7 nodes: Chylomicron, VLDL, IDL, LDL, HDL, Lp(a), Remnant)
- `name`: Particle name
- `description`: Biological description
- `density_class`: Ultracentrifugation density fraction
- `major_lipid`: Predominant lipid cargo

#### `data/molecules.csv`
Small molecules, drugs, and metabolites (57 nodes)
- `name`: Molecule name or identifier
- `type`: Molecule type (e.g., "drug", "metabolite")
- `source`: Data source (e.g., "DrugBank", "HMDB")

#### `data/diseases.csv`
Disease and trait entities (27 nodes)
- `name`: Disease/trait name
- `source`: Data source (e.g., "MONDO", "OMIM", "GWAS_Catalog", "Orphanet")
- `mondo_id`/`efo_id`: Standard ontology identifier

#### `data/clinvar_variants.csv`
Genetic variants from ClinVar
- `variant_id`: ClinVar variant identifier
- `clinical_significance`: Clinical significance (e.g., "Pathogenic", "Benign")
- `review_status`: Review status in ClinVar

#### `data/kegg_genes.csv`
Genes from KEGG database
- `name`: Gene symbol
- `kegg_id`: KEGG gene identifier

#### `data/pathways.csv`
Biological pathways (13 nodes: 1 KEGG, 12 Reactome)
- `name`: Pathway name
- `source`: Data source ("KEGG" or "Reactome")
- `pathway_id`: Pathway identifier

### Relationship Data

#### `data/string_interactions.csv`
Protein-protein interactions from STRING
- `source`: Source protein Ensembl ID
- `target`: Target protein Ensembl ID
- `score`: Interaction confidence score (0-1000)
- `combined_score`: Combined interaction score

#### `data/disease_associations.csv`
Gene/protein-disease/trait associations (238 edges from DisGeNET, OMIM, GLGC 2021, Orphanet, and expert curation)
- `source`: Gene/protein name
- `target`: Disease/trait name
- `source_db`: Data source ("DisGeNET", "OMIM", "GWAS_Catalog", "Orphanet")
- `score`: Association score (DisGeNET score or GWAS p-value, where applicable)

#### `data/particle_protein_links.csv`
Protein-particle component relationships (48 COMPONENT_OF edges)
- `protein`: Gene symbol
- `particle`: Particle name
- `component_type`: Type (structural, exchangeable, receptor, etc.)

#### `data/enzyme_particle_links.csv`
Enzyme-particle modification relationships (23 MODIFIES edges)
- `enzyme`: Gene symbol
- `particle`: Particle name
- `modification_type`: Type of modification (hydrolysis, exchange, etc.)

#### `data/assembly_links.csv`
Particle assembly protein relationships (8 ASSEMBLED_BY edges)
- `particle`: Particle name
- `assembly_protein`: Gene symbol
- `assembly_stage`: Stage of assembly

#### `data/clinvar_relationships.csv`
ClinVar variant-gene relationships
- `variant`: ClinVar variant ID
- `gene`: Associated gene name
- `significance`: Clinical significance

#### `data/pathway_memberships.csv`
Gene-pathway memberships
- `gene`: Gene name
- `pathway`: Pathway name
- `source`: Pathway database source

### Metadata

#### `data/graph_statistics.json`
Comprehensive graph statistics including:
- Node counts by type
- Edge counts by type
- Total node and edge counts

## Data Sources

### STRING v12.0
- **Description:** Protein-protein interaction database
- **Coverage:** 1,852 proteins, 31,878 interactions
- **Confidence threshold:** combined_score ≥ 700 (high confidence)
- **Additional curation:** 47 literature-mined interactions below threshold (Supplementary Table S12)
- **URL:** https://string-db.org
- **License:** Creative Commons Attribution 4.0 International

### ClinVar
- **Description:** Archive of reports of relationships among variations and phenotypes
- **Coverage:** 4,042 pathogenic/likely pathogenic variants across 61 genes (top genes: LDLR 2,267; DHCR7 315; APOB 256; MTTP 191; LPL 168)
- **Filters:** Clinical significance: pathogenic/likely pathogenic; minimum review status: criteria provided, single submitter
- **URL:** https://www.ncbi.nlm.nih.gov/clinvar/
- **License:** Public domain

### KEGG
- **Description:** Kyoto Encyclopedia of Genes and Genomes
- **Pathway:** hsa05417 (Lipid and atherosclerosis), 216 genes
- **Coverage:** 157 of the 216 genes (72.7%) are represented in the protein graph
- **URL:** https://www.kegg.jp
- **License:** KEGG is free for academic use

### Reactome
- **Description:** Free, open-source, curated and peer-reviewed pathway database
- **Pathways:** 12 lipoprotein metabolism pathways
- **Coverage:** 115 gene memberships
- **URL:** https://reactome.org
- **License:** Creative Commons Attribution 4.0 International

### WikiPathways
- **Description:** Open science platform for community collection, curation and publication of biological pathways
- **Reference set:** 4 lipid metabolism pathways (WP3965, WP430, WP554, WP206), 92 genes — used for coverage validation only, NOT imported into the graph
- **Coverage:** 73 of the 92 reference genes (79.3%) are represented in the protein graph
- **URL:** https://www.wikipathways.org
- **License:** Creative Commons Attribution 4.0 International

### DisGeNET v7.0
- **Description:** Disease-gene association knowledge platform
- **Coverage:** 35 gene-disease associations (expert-curated; deposited rows carry no association score)
- **URL:** https://www.disgenet.org
- **License:** CC BY-NC-SA 4.0

### OMIM
- **Description:** Online Mendelian Inheritance in Man
- **Coverage:** 20 curated Mendelian gene-disease associations
- **URL:** https://www.omim.org
- **License:** Custom (academic use)

### GLGC 2021 (Graham et al.)
- **Description:** Global Lipids Genetics Consortium 2021 trans-ancestry meta-analysis of blood lipid traits (Graham et al., *Nature* 2021, PMID 34887591)
- **Coverage:** 111 genome-wide significant gene-trait associations (p < 5×10⁻⁸) for four lipid traits
- **URL:** https://csg.sph.umich.edu/willer/public/glgc-lipids2021/
- **License:** CC0

### Orphanet
- **Description:** Rare disease and orphan drug database
- **Coverage:** 50 gene-disease associations across 7 rare lipoprotein disorders
- **URL:** https://www.orpha.net
- **License:** CC BY 4.0

## Usage

### Neo4j Import

To load this dataset into Neo4j:

```bash
# Start Neo4j
neo4j start

# Import nodes
neo4j-admin import \
  --nodes=data/string_proteins.csv \
  --nodes=data/particles.csv \
  --nodes=data/molecules.csv \
  --nodes=data/diseases.csv \
  --nodes=data/clinvar_variants.csv \
  --nodes=data/kegg_genes.csv \
  --nodes=data/pathways.csv

# Import relationships
neo4j-admin import \
  --relationships=data/string_interactions.csv \
  --relationships=data/particle_protein_links.csv \
  --relationships=data/enzyme_particle_links.csv \
  --relationships=data/assembly_links.csv \
  --relationships=data/disease_associations.csv \
  --relationships=data/clinvar_relationships.csv \
  --relationships=data/pathway_memberships.csv
```

### Python/NetworkX

```python
import pandas as pd
import networkx as nx

# Load nodes
proteins = pd.read_csv('data/string_proteins.csv')
molecules = pd.read_csv('data/molecules.csv')
diseases = pd.read_csv('data/diseases.csv')

# Load edges
interactions = pd.read_csv('data/string_interactions.csv')
associations = pd.read_csv('data/disease_associations.csv')

# Create graph
G = nx.Graph()

# Add nodes
for _, row in proteins.iterrows():
    G.add_node(row['name'], type='protein', ensembl_id=row['ensembl_id'])

for _, row in molecules.iterrows():
    G.add_node(row['name'], type='molecule')

for _, row in diseases.iterrows():
    G.add_node(row['name'], type='disease')

# Add edges
for _, row in interactions.iterrows():
    G.add_edge(row['source'], row['target'], 
               type='STRING_INTERACTS', score=row['score'])

for _, row in associations.iterrows():
    G.add_edge(row['source'], row['target'], 
               type='DISEASE_ASSOCIATION', source_db=row['source_db'])

# Analyze
print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
```

### Cypher Query Examples

```cypher
// Find all proteins interacting with APOE
MATCH (p:STRINGProtein {name: 'APOE'})-[:STRING_INTERACTS]-(interactor)
RETURN interactor.name, interactor.description

// Find all pathogenic variants in LDLR
MATCH (v:ClinVarVariant)-[:VARIANT_OF]->(g:STRINGProtein {name: 'LDLR'})
WHERE v.clinical_significance = 'Pathogenic'
RETURN v.variant_id, v.clinical_significance

// Find all genes in KEGG lipid pathway
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Cholesterol metabolism'})
RETURN g.name, g.kegg_id

// Find diseases associated with multiple lipoprotein genes
MATCH (g:STRINGProtein)-[:DISEASE_ASSOCIATION]->(d:Disease)
WHERE g.name IN ['APOB', 'LDLR', 'PCSK9', 'APOE']
RETURN d.name, COUNT(DISTINCT g) AS gene_count
ORDER BY gene_count DESC
```

## Quality Control

### Data Validation
1. **Source verification:** All data sources verified for authenticity and version
2. **Format validation:** CSV files validated for correct format and encoding
3. **Completeness check:** Coverage analysis against reference pathway databases
4. **Consistency check:** Cross-validation of gene identifiers across sources

### Known Limitations
1. **STRING confidence threshold:** Only high-confidence interactions (combined_score ≥ 700) included; 47 additional literature-mined interactions manually curated
2. **ClinVar variants:** Restricted to pathogenic/likely pathogenic with minimum review status "criteria provided, single submitter"
3. **Protein/gene conflation:** 23 of 82 seed genes (28%) have functionally distinct isoforms
4. **Static snapshot:** Data collected January 2024; no temporal information
5. **Human data only:** No cross-species integration
6. **KEGGGene/STRINGProtein duplication:** Resolved via MAPS_TO cross-references in extended schema

## Citation

If you use this dataset in your research, please cite:

```bibtex
@article{lipoKG2024,
  title={LipoKG: A Comprehensive Knowledge Graph for Lipoprotein Metabolism Research},
  author={[Author Names]},
  journal={Scientific Data},
  year={2024},
  doi={10.5281/zenodo.21318099}
}
```

## License

This dataset is released under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

You are free to:
- **Share:** Copy and redistribute the material in any medium or format
- **Adapt:** Remix, transform, and build upon the material for any purpose, even commercially

Under the following terms:
- **Attribution:** You must give appropriate credit, provide a link to the license, and indicate if changes were made

## Contact

For questions or feedback about this dataset:
- **Email:** [corresponding author email]
- **GitHub:** [repository URL]

## Changelog

### Version 1.2.1 (2026-10)

- **KEGG layer re-retrieved** as `hsa05417` "Lipid and atherosclerosis" (216 genes), replacing `hsa04979`
  "Cholesterol metabolism" (52 genes). The two gene sets overlap in only 6 genes, so coverage figures change.
- **Reactome layer rebuilt** from the Content Service API: 282 reactions imported, with 12 plasma lipoprotein
  pathways (71 genes) retained as an independent reference set.
- **WikiPathways reference set constructed** from the official 2026-09-10 GMT release — 4 lipoprotein/lipid
  pathways (WP3965, WP430, WP554, WP206; 92 genes). Still a reference set only; no WikiPathways nodes are
  imported, and none ever were.
- **Added `data/LICENSE.md`**: a per-file and per-source **layered licence**. Components whose sources permit
  it are released under CC0; layers derived from sources with more restrictive terms (CC BY-NC-SA,
  academic-use-only, custom) retain those terms. The repository-level CC BY 4.0 label does not override them.
- Documentation (README, SCHEMA, USAGE_TUTORIAL, CYPHER_EXAMPLES, metadata) resynchronised with the counts above.

### Version 1.2.0 (2026-07)

- **Added `data/extended/`** with the six extended-schema CSV exports (drug_targets, drug_diseases,
  enzyme_substrates, affects_gene, particle_all_links, isoform_links). Earlier releases described this
  directory but did not include it.
- **Added a gene-level annotation coverage matrix** (`Table_S24_gene_level_coverage.csv`, also distributed
  with the manuscript as Supplementary Table S24). It records, for each of the 1,910 genes in the dataset,
  membership in each core layer (particle, pathway, disease/GWAS, ClinVar variant), the STRING interaction
  degree, and the number of non-STRING layers.
- **Added a per-file inventory** with byte sizes and row counts (`Table_S25_Deposited_File_Inventory.csv`),
  so that the counts reported in the manuscript can be checked file by file.
- **Corrected the disease layer per-source counts** to match the deposited `data/disease_associations.csv`:
  DisGeNET 35, OMIM 20, GLGC 2021 111, Orphanet 50, expert curation 22 (238 total).
- Gene symbols were normalised to HGNC nomenclature; query by HGNC symbol or Ensembl ID.

#### Gene-level annotation coverage at a glance

| Layer (denominator = 1,852 proteins in the interaction graph) | Genes | Share |
|---|---|---|
| Pathway membership | 211 | 11.4% |
| Disease / GWAS association | 62 | 3.3% |
| ClinVar variant annotation | 43 | 2.3% |
| Particle membership | 31 | 1.7% |
| **Any non-STRING layer** | **252** | **13.6%** |
| **Two or more non-STRING layers** | **48** | **2.6%** |
| **STRING connectivity only** | **1,600** | **86.4%** |

Multi-layer annotation is concentrated in the curated 82-gene lipoprotein core (64.6% carry at least one
additional layer). Proteins reachable only through 1-hop interaction expansion should be read as interaction
context rather than as multi-layer annotations.

### Version 1.1.0 (2026-06)
- Updated ClinVar variant filtering (Pathogenic/Likely pathogenic only, 4,042 variants)
- Populated protein descriptions for all STRINGProtein nodes
- Corrected Reactome coverage to 85.9% (61/71) after re-fetching from Reactome API
- Added Gene Ontology independent validation (GO:0042157, 92.3%)
- Reconciled schema documentation (core CSV vs. extended Neo4j)

### Version 1.0.0 (2026-06)
- Initial release
- Integrated STRING v12.0 protein interactions
- Added ClinVar pathogenic variants
- Included KEGG and Reactome pathways (WikiPathways was used as an external reference set only)
- Coverage validation against reference databases

## FAIR Compliance

This dataset follows FAIR principles:

### Findable
- Persistent identifier (DOI) assigned by Zenodo
- Rich metadata including description, keywords, and provenance
- Indexed in Zenodo search

### Accessible
- Open access under CC BY 4.0 license
- Data available in standard formats (CSV, JSON)
- No authentication required

### Interoperable
- Uses standard vocabularies and ontologies
- Data in widely-supported formats (CSV, JSON)
- Includes schema documentation

### Reusable
- Clear licensing (CC BY 4.0)
- Comprehensive documentation
- Quality control and validation performed
- Provenance information included

## Acknowledgments

This work was supported by [funding information].

We thank the maintainers of STRING, ClinVar, KEGG, Reactome, and WikiPathways for making their data publicly available.
