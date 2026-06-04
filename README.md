# omop-example: Understanding OMOP Vocabularies
Healthcare has a number of standards or governing:
 * Conditions (e.g. SNOMED, ICD-10)
 * Drugs (e.g. RxNorm, NCD codes, South African NAPPI codes)
 * Medical Procedures (e.g. ICD-10-PCS, CPT)

OHDSI (Observational Health Data Sciences and Informatics) brought some order to this by introducing *standardized vocabularies* in the Observational Medical Outcomes Partnership (OMOP)
common data model (CDM). This repository shows how concepts in one standard (e.g. ICD-10) are mapped to another standard (e.g. SNOMED). The ideas of diseases, drugs, procedures are collectively called
*concepts* and OMOP provides mappings of a concept from a particular concept to a standardized concept.

## Prerequisites for running this example
This example populates OMOP data into tables in a PostgresQL database. To run and query the database, you'll need:
 * Docker
 * the `psql` CLI

## Checking out and running the code

```bash
git clone https://github.com/hammingweight/omop-example.git
cd omop-example
```

There is an enormous amount of data that needs to be populated in the database. The data is in a zip file that has been split over 12 files of 50MB each. To reconstruct the zip file

```bash
cat x* > data.zip
unzip data.zip
```
