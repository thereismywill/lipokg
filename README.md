# LipoKG: Lipoprotein Metabolism Knowledge Graph

## Overview

LipoKG is a comprehensive knowledge graph integrating multi-source data for lipoprotein metabolism research. This dataset combines protein-protein interactions, genetic variants, disease associations, and pathway information from high-quality databases including STRING, ClinVar, KEGG, Reactome, and WikiPathways.

## Dataset Description

### Scope
- **Domain:** Lipoprotein metabolism and cardiovascular disease
- **Organism:** Homo sapiens
- **Data sources:** STRING v12.0, ClinVar, KEGG, Reactome, WikiPathways, DisGeNET, OMIM, GLGC 2021 (Graham et al.), Orphanet
- **Release date:** 2026

### Statistics
- **Core schema total nodes:** 6,052
- **Core schema total edges:** 36,479
- **Extended schema total nodes:** 6,463 (Neo4j dump)
- **Extended schema total edges:** 37,165 (Neo4j dump)
- **Core node types:** 7 (STRINGProtein, Particle, Molecule, Disease, ClinVarVariant, KEGGGene, Pathway)
- **Core edge types:** 7 (STRING_INTERACTS, COMPONENT_OF, MODIFIES, ASSEMBLED_BY, DISEASE_ASSOCIATION, VARIANT_OF, MEMBER_OF)
- **Extended schema:** 31 node types (24 additional), 25 relationship types (18 additional) (Neo4j only)

### Coverage Validation

**ETL Completeness:**
- **KEGG hsa04979 (Lipid and atherosclerosis):** 89.5% coverage (119/133 genes)
- **Reactome lipoprotein pathways:** 90.9% coverage (50/55 genes)
- **WikiPathways lipid pathways:** 87.7% coverage (71/81 genes)
- **Overall pathway completeness:** 84.8% (167/197 unique reference genes)

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
Biological pathways (15 nodes: 1 KEGG, 10 Reactome, 4 WikiPathways)
- `name`: Pathway name
- `source`: Data source (e.g., "KEGG", "Reactome", "WikiPathways")
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
- **Coverage:** 4,042 pathogenic/likely pathogenic variants across 48 genes (top genes: LDLR 2,267; DHCR7 315; APOB 256; MTTP 191; LPL 168)
- **Filters:** Clinical significance: pathogenic/likely pathogenic; minimum review status: criteria provided, single submitter
- **URL:** https://www.ncbi.nlm.nih.gov/clinvar/
- **License:** Public domain

### KEGG
- **Description:** Kyoto Encyclopedia of Genes and Genomes
- **Pathway:** hsa04979 (Lipid and atherosclerosis)
- **Coverage:** 52 genes
- **URL:** https://www.kegg.jp
- **License:** KEGG is free for academic use

### Reactome
- **Description:** Free, open-source, curated and peer-reviewed pathway database
- **Pathways:** 10 lipoprotein metabolism pathways
- **Coverage:** 111 gene memberships
- **URL:** https://reactome.org
- **License:** Creative Commons Attribution 4.0 International

### WikiPathways
- **Description:** Open science platform for community collection, curation and publication of biological pathways
- **Pathways:** 4 lipid metabolism pathways (WP5242, WP4842, WP5243, WP5244)
- **Coverage:** 79 gene memberships
- **URL:** https://www.wikipathways.org
- **License:** Creative Commons Attribution 4.0 International

### DisGeNET v7.0
- **Description:** Disease-gene association knowledge platform
- **Coverage:** 35 gene-disease associations (score ≥ 0.3)
- **URL:** https://www.disgenet.org
- **License:** CC BY-NC-SA 4.0

### OMIM
- **Description:** Online Mendelian Inheritance in Man
- **Coverage:** 20 curated Mendelian gene-disease associations
- **URL:** https://www.omim.org
- **License:** Custom (academic use)

### GLGC 2021 (Graham et al.)
- **Description:** Genome-wide association study catalog, Global Lipids Genetics Consortium 2021 results
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
MATCH (g:KEGGGene)-[:MEMBER_OF]->(p:Pathway {name: 'Lipid and atherosclerosis'})
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
4. **Static snapshot:** Data collected June 2026; no temporal information
5. **Human data only:** No cross-species integration
6. **KEGGGene/STRINGProtein duplication:** Resolved via MAPS_TO cross-references in extended schema

## Citation

If you use this dataset in your research, please cite:

```bibtex
@article{lipoKG2026,
  title={LipoKG: A Knowledge Graph Dataset for Lipoprotein Metabolism Research},
  author={Zhang, Ke and Zhao, Junyi and Yu, Yang},
  journal={Scientific Data},
  year={2026},
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
- **Email:** yyu@sdfmu.edu.cn
- **GitHub:** https://github.com/thereismywill/lipokg

## Changelog

### Version 1.2.0 (2026-09)
- Re-fetched GLGC 2021 GWAS associations from source summary statistics (113 variant-trait / 111 gene-trait pairs)
- Corrected disease layer: removed fabricated GWAS edges; DISEASE_ASSOCIATION 318 → 238; core edges 36,559 → 36,479
- Added data/extended/ (6 CSV files: drug targets, drug diseases, enzyme substrates, affects_gene, particle_all_links, isoform_links)
- Added Figure 3 Panel C (gene-level annotation depth); fixed Figure 5 Panel D axis bug; removed Figure 6

### Version 1.1.0 (2026-06)
- Updated ClinVar variant filtering (Pathogenic/Likely pathogenic only, 4,042 variants)
- Populated protein descriptions for all STRINGProtein nodes
- Corrected Reactome coverage to 90.9% after apolipoprotein gene inclusion
- Added Gene Ontology independent validation (GO:0042157, 92.3%)
- Reconciled schema documentation (core CSV vs. extended Neo4j)

### Version 1.0.0 (2024-01)
- Initial release
- Integrated STRING v12.0 protein interactions
- Added ClinVar pathogenic variants
- Included KEGG, Reactome, and WikiPathways pathways
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

This work was supported by Shandong Provincial Hospital Affiliated to Shandong First Medical University.

We thank the maintainers of STRING, ClinVar, KEGG, Reactome, and WikiPathways for making their data publicly available.
