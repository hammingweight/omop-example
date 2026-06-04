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

## Checking out the code

```bash
git clone https://github.com/hammingweight/omop-example.git
cd omop-example
```

There is an enormous amount of data that needs to be populated in the database. The data is in a zip file that has been split over 12 files of 50MB each. To reconstruct the zip file

```bash
cat x* > data.zip
unzip data.zip
```

## Running the database
The `compose.yml` file spins up a PostgreQL database with a persistent volume. To access the database, you can login as the `omop` with the password `omop`:

```bash
docker compose up -d
```

The `.sql` scripts create the common data model schema (`cdm`) and populate the tables. To run the scripts

```
export PGPASSWORD=omop
psql -h localhost -p 5432 -U omop -d omop -f 0_create_schema.sql
psql -h localhost -p 5432 -U omop -d omop -f 1_ddl.sql
psql -h localhost -p 5432 -U omop -d omop -f 2_primary_keys.sql
psql -h localhost -p 5432 -U omop -d omop -f 3_indices.sql
psql -h localhost -p 5432 -U omop -d omop -f 4_populate.sql
psql -h localhost -p 5432 -U omop -d omop -f 5_constraints.sql
```

## Querying the OMOP data
Suppose that we want to find what the ICD-10 code 'K27.3' desscribes. First, open a shell to the database

```bash
psql -h localhost -p 5432 -U omop -d omop
```

Issue the following query

```sql
SELECT concept_id,domain_id,concept_name FROM cdm.concept WHERE vocabulary_id='ICD10' AND concept_code='K27.3';
```

The following result is returned

```text
 concept_id | domain_id |                               concept_name                               
------------+-----------+--------------------------------------------------------------------------
   45538515 | Condition | Peptic ulcer, site unspecified, acute without haemorrhage or perforation
(1 row)
```

The result shows that the ICD-10 code corresponds to a *condition*, specifically a peptic ulcer.

However ICD-10 does not provide the standardized vocabulary for medical conditions in OMOP. We can use the `concept_id` and the `CONCEPT_RELATION` table to get the `concept_id` for the
standardized code for a peptic ulcer.

```sql
SELECT concept_id_2 FROM cdm.concept_relationship WHERE concept_id_1='45538515' and relationship_id='Maps to';
```

The result:

```textSELECT concept_name,vocabulary_id,concept_code,standard_concept FROM cdm.concept WHERE concept_id='4163865';

 concept_id_2 
--------------
      4163865
(1 row)
```

Now we can use the value of `concept_id_2` to get the standardized code for a peptic ulcer using the `CONCEPT` table again

```sql
SELECT concept_name,vocabulary_id,concept_code,standard_concept FROM cdm.concept WHERE concept_id='4163865';
```

which returns

```text
                         concept_name                          | vocabulary_id | concept_code | standard_concept 
---------------------------------------------------------------+---------------+--------------+------------------
 Acute peptic ulcer without hemorrhage AND without perforation | SNOMED        | 45485004     | S
(1 row)

```

So the standardized concept of the ICD-10 condition with code 'K27.3' should be encoded using the SNOMED code 45485004.
