[파티션 설계](https://yj.gitbooks.io/mariadb-tutorial/content/c02_4_partition_design.html)

파티션 사용을 고려해야 할 상황

파티션 테이블은 단일 테이블 사이즈가 20G 이상이 예상될 때 고려하는 것이 좋다.
일반적으로 이력/내역과 같이 장기간 데이터를 보관하는 테이블에 대해서 보관주기를 설정하고, 날짜를 기준으로 RANGE PARTITION으로 구성하는 것을 권장한다.
각 파티션별로 저장될 파일을 따로 지정할 수 있으므로 물리적인 저장소 분리가 필요할 때도 고려해볼 수 있다.
과다한 INSERT가 발생하는 테이블에 대해서는 SUBPARTITION (혹은 PARTITION레벨)에서 HASH나 KEY형식의 파티션을 생성하여 INSERT 경합에 따른 INDEX LATCH나 Mutex 락을 최소화하도록 한다
파티션 제약

파티셔닝 키는 반드시 PK에 포함되어야 한다.
Max partition 개수는 8192개이다. (subpartition 수 포함)
추가 제약조건(유니크 속성)을 부여할 수 없다.
Innodb partition 테이블에는 foreign key 생성을 할 수 없다.
FullText Index를 지원하지 않으며, Temporary table은 파티션 생성이 블가하다.
Subpartition은 HASH/KEY PARTITION만 지원한다.
파티션 테이블 ALTER명령어시 DML은 LOCKING된다. (ONLINE DDL수행하더라도 SELECT만 허용)
PARTITION TABLE생성후 SQL_MODE변경시 DATA corruption이나 loss 가 발생할 수 있다.
파티션 테이블의 인덱스는 모두 로컬 인덱스이다. 글로벌 인덱스는 지원하지 않는다.
파티션된 테이블에서 데이터는 파티션 내에서만 정렬이 된다.
AUTO_INCREMENT 속성을 갖는 테이블에서 파티션을 만들려면 파티션키가 되는 컬럼과 AUTO_INCREMENT 속성을 갖는 컬럼을 묶어서 PK로 생성해야 한다.
파티션키가 되는 컬럼에 NULL이 들어오면 해당 레코드는 가장 작은 파티션으로 들어간다.
파티션 키 값은 정수(INT)를 사용하는 것이 기본이지만 RANGE 파티션과 LIST 파티션에서는 "RANGE COLUMNS" 키워드를 사용하면 INT, STRING, DATE, DATETIME 타입을 그대로 파티션키로 사용할 수 있다.
PARTITION BY 표현식에 사용할 수 있는 함수들
ABS(), CEILING(), DAY(), DAYOFMONTH(), DAYOFWEEK(), DAYOFYEAR(), DATEDIFF(), EXTRACT(), FLOOR(), HOUR(), MICROSECOND(), MINUTE(), MOD(), MONTH(), QUARTER(), SECOND(), TIME_TO_SEC(), TO_DAYS(), WEEKDAY(), YEAR(), YEARWEEK()
파티션 타입

RANGE 파티션 타입
범위에 따라 파티션을 설정하는 방법
예) 월단위 파티션을 갖는 테이블 생성
CREATE TABLE `test`.`tab_partition` 
(
 `seq` int unsigned auto_increment not null,
 `regist_dt` datetime not null default current_timestamp,
 `contents` varchar(1000),
 PRIMARY KEY (`seq`, `regist_dt`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY RANGE COLUMNS (regist_dt)
(
PARTITION p201601 VALUES LESS THAN ('2016-02-01 00:00:00'),
PARTITION p201602 VALUES LESS THAN ('2016-03-01 00:00:00'),
PARTITION p201603 VALUES LESS THAN ('2016-04-01 00:00:00'),
PARTITION pmaxvalues VALUES LESS THAN MAXVALUE
);
예) 날짜타입을 갖는 테이블에서 연단위 파티션을 갖는 테이블 생성
CREATE TABLE `test`.`tab_partition` 
(
 `seq` int unsigned auto_increment not null,
 `regist_dt` datetime not null default current_timestamp,
 `contents` varchar(1000),
 PRIMARY KEY (`seq`, `regist_dt`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY RANGE (YEAR(regist_dt))
(
PARTITION p2014 VALUES LESS THAN (2015),
PARTITION p2015 VALUES LESS THAN (2016),
PARTITION p2016 VALUES LESS THAN (2017),
PARTITION pmaxvalues VALUES LESS THAN MAXVALUE
);
LIST 파티션 타입
목록에 따라 파티션을 설정하는 방법
예)
CREATE TABLE `test`.`tab_partition` 
(
 `seq` int unsigned auto_increment not null,
 `region_cd` varchar(10) not null,
 `regist_dt` datetime not null default current_timestamp,
 `contents` varchar(1000),
 PRIMARY KEY (`seq`, `region_cd`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY LIST COLUMNS (`region_cd`)
(
PARTITION p_asia VALUES IN ('KOREA', 'CHINA'),
PARTITION p_europe VALUES IN ('FRANCE', 'ITALIA'),
PARTITION p_america VALUES IN ('CANADA', 'USA'),
PARTITION p_other VALUES IN (NULL)
);
HASH 파티션 타입
파티션은 필요하지만 파티션할 기간이나 특정 값의 집합을 정의하기 모호할 때 사용하는 파티션 타입이다.
예)
CREATE TABLE `test`.`tab_partition` 
(
 `seq` int unsigned auto_increment not null,
 `regist_dt` datetime not null default current_timestamp,
 `contents` varchar(1000),
 PRIMARY KEY (`seq`, `regist_dt`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY HASH (TO_DAYS(regist_dt))
PARTITIONS 12;
Partition Pruning의 한계

Partition Pruning 이란? 조건에 부합하는 파티션만 선택적으로 사용하게 하는 기능
명시적으로 파티션키에 해당하는 실제 값을 정의해야만 특정 파티션을 선택한다.
RANGE, REF, EQ_REF 등올 조인시 해당 정보를 기준으로 특정 파티션을 선택하지 못한다.
조인방식	설명
RANGE	=, <>, >, >=, <, <=, IS NULL, BETWEEN, IN 연산자를 사용한 비교/범위 검색
REF	PRIMARY KEY 또는 UNIQUE INDEX가 아닌 일반적인 인덱스를 활용한 JOIN
EQ_REF	PRIMARY KEY 또는 UNIQUE INDEX를 활용한 JOIN
