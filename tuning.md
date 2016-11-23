 SELECT SQL_CALC_FOUND_ROWS * FROM City ORDERBY BY id LIMIT 0, 2;
 
 SELECT FOUND_ROWS() AS TOTAL;
 
 
 ORDER BY  & GROUP BY

 

GROUP BY는 ORDER BY 앞에 온다
   둘 다 AS로 정의된 필드를 사용할 수 있음
   둘 다 여러 개의 필드를 사용할 수 있음
   GROUP BY와 ORDER BY에 서로 다른 필드를 사용 가능
   GROUP BY를 사용할 경우
    - 반드시 해당 필드를 SELECT해야 한다
    - 더 추려내기 위하여 HAVING 조건절을 사용할 수 있다
   ORDER BY를 사용할 경우
    - 역차순 정렬을 원하는 경우 DESC를 사용
    - 칼럼 번호로 구분 가능
    - ORDER BY를 위해 반드시 해당 필드를 SELECT할 필요는 없음

 

SUM, AVG, COUNT, MAX, MIN, STD(표준편차)

 

GROUP_CONCAT() : 그룹에서 연결된 문자형 결과값을 얻는다.
mysql> SELECT continent, GROUP_CONCAT(distinct region)
    -> FROM country GROUP BY continent; 
+---------------+-----------------------------------------------------+
| continent     | GROUP_CONCAT(distinct region)                       |
+---------------+-----------------------------------------------------+
| Asia          | Eastern Asia,Middle East,Southeast Asia,Southern a… |
| Europe        | Southern Europe,Baltic Countries,Eastern Europe,Nor…|
| North America | Central America,Caribbean,North America             |
| Africa        | Central Africa,Eastern Africa,Western Africa,Northe…|
| Oceania       | Australia and New Zealand,Melanesia,Polynesia,Micr… |
| Antarctica    | Antarctica                                          |
| South America | South America                                       |
+---------------+-----------------------------------------------------+
7 rows in set (0.00 sec)

 

GROUP BY … WITH ROLLUP은 GROUP BY에 사용된 
    칼럼의 데이터를 합계하여 요약된 데이터를 만든다. 
   - 요약 row는 GROUP BY의 가장 좌측 칼럼이 바뀔 때 마다 
     생성된다
   - NULL은 어떠한 칼럼이 요약 row를 만드는데 사용되었는지를
     표시하기 위해 사용된다
   - 요약 row는 쿼리의 수행이 모두 완료 된 다음에 추가되므로
     HAVING 또는 유사한 방법으로 참조할 수 없다

 

mysql> SELECT continent, name, SUM(Population)
    -> FROM Country
    -> GROUP BY continent, name
    -> WITH ROLLUP;
+---------------+------------------------+-----------------+
| continent     | name                   | SUM(Population) |
+---------------+------------------------+-----------------+
| Asia          | Afghanistan            |        22720000 |
| Asia          | Armenia                |         3520000 |
| Asia          | Azerbaijan             |         7734000 |
| Asia          | Bahrain                |          617000 |
| Asia          | Bangladesh             |       129155000 |
| …             | …                      |            …    |
| South America | Venezuela              |        24170000 |
| South America | NULL                   |       345780000 |
| NULL          | NULL                   |      6078749450 |
+---------------+------------------------+-----------------+

CASE WHEN

 

mysql> SELECT CASE Code
    ->  WHEN 'USA' THEN '1. USA'
    ->  WHEN 'DEU' THEN '2. Germany'
    ->  WHEN 'FRA' THEN '3. Fraance'
    ->  WHEN 'GBR' THEN '4. UK'
    ->  ELSE '5. Rest of World' END AS Area,
    ->  SUM(GNP), SUM(population), SUM(SurfaceArea)
    -> FROM Country
    -> GROUP BY Area;
+------------------+-------------+-----------------+------------------+
| Area             | SUM(GNP)    | SUM(population) | SUM(SurfaceArea) |
+------------------+-------------+-----------------+------------------+
| 1. USA           |  8510700.00 |       278357000 |       9363520.00 |
| 2. Germany       |  2133367.00 |        82164700 |        357022.00 |
| 3. Fraance       |  1424285.00 |        59225700 |        551500.00 |
| 4. UK            |  1378330.00 |        59623400 |        242900.00 |
| 5. Rest of World | 15914029.65 |      5638602400 |     138441364.90 |
+------------------+-------------+-----------------+------------------+
5 rows in set (0.00 sec)

 

mysql> SELECT CASE
    ->  WHEN Code='USA' THEN '1. USA'
    ->  WHEN Continent='Europe' THEN '2. Europe'
    ->  WHEN Continent='Asia'   THEN '3. Asia'
    ->  WHEN Continent='North America'  THEN '4. N. America'
    ->  ELSE '5. Rest of World' END AS Area,
    ->  SUM(GNP), SUM(Population), SUM(SurfaceArea)
    -> FROM Country
    -> GROUP BY Area;
+------------------+------------+-----------------+------------------+
| Area             | SUM(GNP)   | SUM(Population) | SUM(SurfaceArea) |
+------------------+------------+-----------------+------------------+
| 1. USA           | 8510700.00 |       278357000 |       9363520.00 |
| 2. Europe        | 9498865.00 |       730074600 |      23049133.90 |
| 3. Asia          | 7655392.00 |      3705025700 |      31881005.00 |
| 4. N. America    | 1177927.20 |       204636000 |      14850950.00 |
| 5. Rest of World | 2517827.45 |      1199879900 |      69811698.00 |
+------------------+------------+-----------------+------------------+
5 rows in set (0.00 sec)
