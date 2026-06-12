CREATE SCHEMA cdm;
GRANT ALL ON SCHEMA cdm TO current_user;
ALTER ROLE current_user SET search_path TO cdm, public;
