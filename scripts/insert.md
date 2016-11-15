# Insert Statements

## Insert from csv

If the schema is the same between csv and the target table:
```mariadb
LOAD DATA LOCAL INFILE "filePath" 
INTO TABLE dbName.tableName 
FIELDS TERMINATED BY ",";
```

If csv is huge:
```mariadb
ALTER TABLE dbName.tableName DISABLE KEYS;
LOAD DATA local INFILE "filePath" 
INTO TABLE dbName.tableName FIELDS TERMINATED BY ",";
ALTER TABLE dbName.tableName ENABLE KEYS;
```

If the schemas are different:
```mariadb
LOAD DATA LOCAL INFILE 'file_name'
INTO TABLE table_name
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(column1,column2,column3, ...);
```
