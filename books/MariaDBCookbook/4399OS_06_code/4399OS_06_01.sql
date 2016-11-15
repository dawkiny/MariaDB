CREATE DATABASE IF NOT EXISTS temp;
CREATE TABLE temp.doctors (
  id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  given_names varchar(255),
  surname varchar(255),
  birthdate date);

INSERT temp.doctors VALUES
  (1,'William','Hartnell','1908-01-08'),
  (2,'Patrick','Troughton','1920-03-25'),
  (3,'Jon','Pertwee','1919-07-07'),
  (4,'Tom','Baker','1934-01-20'),
  (5,'Peter','Davison','1951-04-13'),
  (6,'Colin','Baker','1943-06-08'),
  (7,'Sylvester','McCoy','1943-08-20'),
  (8,'Paul','McGann','1959-11-14'),
  (9,'Christopher','Eccleston','1964-02-16'),
  (10,'David','Tennant','1971-04-18'),
  (11,'Matt','Smith','1982-10-28'),
  (12,'Peter','Capaldi','1958-04-14');

