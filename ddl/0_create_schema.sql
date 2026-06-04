CREATE SCHEMA cdm;
GRANT ALL ON SCHEMA cdm TO omop;
ALTER ROLE omop SET search_path TO cdm, public;
