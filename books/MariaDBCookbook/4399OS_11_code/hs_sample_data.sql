CREATE DATABASE IF NOT EXISTS test;
USE test;
DROP TABLE IF EXISTS hs_test;
CREATE TABLE hs_test (
  id SERIAL PRIMARY KEY,
  givenname varchar(64),
  surname varchar(64)
);
INSERT INTO hs_test VALUES 
  (1,"William","Hartnell"), (2,"Patrick","Troughton"),
  (3,"John","Pertwee"), (4,"Tom","Baker"),
  (5,"Peter","Davison"), (6,"Colin","Baker");
