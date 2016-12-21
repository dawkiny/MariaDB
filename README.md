# ```MariaDB```

## Install on Ubuntu


```sh
sudo apt-get update
apt-get install mariadb-server
```


## Run ```MariaDB```

```sh
systemctl start mysql
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'mysql.service'.
Authenticating as: dawkiny,,, (dawkiny)
Password: 
==== AUTHENTICATION COMPLETE ===
```
## Securing ```MariaDB```
```sh
sudo mysql_secure_installation 
-------------------------------------------------------------------------
[sudo] password for dawkiny: 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

You already have a root password set, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
-------------------------------------------------------------------------
```

```sh
sudo mysql -uroot -p
```

---
## DDL

### CREATE Statements

### ALTER Statements

### DROP Statements

---
## DML

### INSERT Statements

### UPDATE Statements

### DELETE Statements

### SELECT Statements

#### SELECT DISTINCT Statements

#### WHERE Statements

#### GROUP BY Statements

#### ORDER BY Statements

#### JOIN Statements

---
## DCL

### GRANT Statements

### REVOKE Statements

### SET TRANSACTION Statements

### BEGIN Statements

### COMMIT Statements

### ROLLBACK Statements

### SAVEPOINT Statements

### LOCK Statements

---
## Cursors

* Declare  
* Open  
* Fetch  
* Update  
* Delete  
* Close  

## Functions

## Dynamic SQL  
 * PREPARE  
 * EXECUTE


---

```
http://egloos.zum.com/finetia/v/1626003
```

---
Innodb는 delete를 사용한 다음 optimize라는 명령을 실행해줘야 Data가 모두 삭제되고 삭제된 Data만큼의 디스크 용량이 확보.
```sql
OPTIMIZE TABLE [table];
```
'lock wait timeout exceeded try restarting transaction'  Message:  
1. my.cnf에 innodb_lock_wait_timeout의 값을 높게 설정한다. (default = 50s)  

MySQL은 기본적으로 auto commit을 사용하도록 설정되어 있는데  
이를 막고 트랜잭션을 사용하겠다고 선언해주는 것이다.  
쉽게 이야기해 delete작업을 진행하기 전에  

```sql
START TRANSACTION;
```
을 선언해서 트랜잭션을 시작하겠다고 선언한 다음 delete 작업을 진행하고  
해당 과정을 마치겠다는 의미의  
```sql
COMMIT;
```
을 선언해주면 lock 관련 오류 메세지를 보지 않아도 되는 것이다. 그 다음 마지막으로   
```sql
OPTIMIZE TABLE [table];
```

```
###### 퍼포먼스 & 메모리 관련 ######
#  MYSQL 메모리 사용 간단 공식
# innodb_buffer_pool_size + key_buffer + max_connections * (join_buffer + record_buffer + sort_buffer + thread_stack + tmp_table_size + 2MB)
 
# show status like 'max%' 의 max_used_connections를 체크 ( 최대 값보다 10% 크게 설정 )
max_connections = 100
 
# 인덱스를 위한 버퍼 공간, 키버퍼의 크기는 공유된 쓰레드의 크기이며 중복된 키를 자주 사용할 경우 속도 증진
# show status like 'key%'의 key_blocks_used를 체크
# 1. 메모리가 충분할 경우 key_buffer = (key_blocks_used * 1024) * (2 or 3)
# 2. 메모리가 불충분할 경우 key_buffer = (key_blocks_used * 1024)
# [ key_reads/ key_read_request <0.01 ] [ key_write / key_write_request = 1 ] 일경우 만족
key_buffer = 64M
max_allowed_packet = 25M
 
# MySQL 서버가 한번에 열수 있는 테이블의 개수설정
# show status like 'open%'의 opened_tables 값이 클 경우 table_cache 를 늘림
# max_connections 값이 100 일 경우 100*n (조인해서 열수 있는 최대 테이블 개수)
table_cache =256 # Checked opened tables and adjusted accordingly after running for a while.
 
# order by, group by 절을 빠르게 하기 위해서 sort_buffer 값을 조절
# 많은 연속적인 테이블 스캔이 이루어진다면 record_buffer 값을 조절
# max_used_connection이 높은 경우 대략 (sort_buffer + record_buffer < 8M) 로 잡아준다.
sort_buffer_size = 4M
net_buffer_length = 8K
read_buffer_size = 1M
read_rnd_buffer_size = 2M
myisam_sort_buffer_size = 8M


default-character-set=utf8
character-set-server=utf8
collation-server=utf8_general_ci
```

---
```

# 쿼리를 캐싱해 놓았다가 똑같은 쿼리가 들어왔을 때 바로 리턴해준다.
# 0: off 쿼리캐쉬 기능을 사용하지 않음 1: on, select sql_no_cache를 제외하고 쿼리캐쉬사용, 2:demand, select sql_cache 사용시만 쿼리캐쉬 사용
# show status like 'qcache%';
#+-------------------------+----------+
 #| Variable_name | Value |
 #+-------------------------+----------+
 #| Qcache_queries_in_cache | 12780 | : 캐시에 등록된 쿼리수
 #| Qcache_inserts | 2084642 | : 캐시에 추가된 쿼리수
 #| Qcache_hits | 173194 | : 캐시에 있는 쿼리를 사용한 수
 #| Qcache_lowmem_prunes | 361897 |
#| Qcache_not_cached | 23724 | : 쿼리를 캐시에 저장하지 않은 수
 #| Qcache_free_memory | 20055720 | : 캐시가 남은 공간
 #| Qcache_free_blocks | 6237 | : 쿼리캐시에서 남은 메모리 블록
 #| Qcache_total_blocks | 32000 | : 쿼리캐시가 사용하는 총 블록 수
 #+-------------------------+----------+ 
query_cache_type=1
query_cache_limit=1M
 
query_cache_size=32M

 
###### 로깅 관련 ######
 
old_passwords = 1
max_binlog_size = 1024M
bin_log_ignore_db = somedatabase [ Binary 파일의 경우 row의 용량이 크므로 ignore]
log-slow-queries = /var/lib/mysql/slowqueries.log
log_query_time = 2 [2초이상의 쿼리를 슬로우 쿼리로 판단]
 
lower_case_table_names
log-bin
server-id = 1
 
[mysqldump]
quick
max_allowed_packet = 25M
default-character-set=utf8
 
[mysql]
no-auto-rehash
default-character-set=utf8
 
[isamchk]
key_buffer = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
 
[myisamchk]
key_buffer = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
 
[mysqlhotcopy]
interactive-timeout
```


---
```
=================================================================
 
튜닝참조
 
=================================================================
 
1. Opened_tables가 크면 table_cache variable의 값이 너무 작은것일지도 모른다
 
2. key_reads가 크면 key_cach의 값이 너무 작은것일지도 모른다
 
3. cache hit rate은 key_reads/key_read_requests이다
 
4. Handler_read_rnd가 크면 MySQL의 모든 테이블을 스캔하는 많은 쿼리가 있다거나 key를 적절히 사용하지 않는 조인들이 있을지 모른다
 
 
5. Threads_created가 크면 thread_cache_size값을 증가시키기를 바랄수도 있다
6. Created_tmp_disk_tables이 크면 디스크대신 임시테이블메모리를 얻기위해 tmp_table_size값을 증가시   키기를 원할 수있다
 
7. 기본적으로 support-files밑에 my-huge.cnf, my-large.cnf, my-medium.cnf, my-small.cnf 를 기본으로        my.cnf 로 바꾸어 사용하면서 조정한다.
 
- memory (>=256M)이고 많은 테이블이 있으며, 적당한 클라이언트수에서 최고 성능을 유지하기 위해
shell> safe_mysqld -O key_buffer=64M -O table_cache=256 -O sort_buffer=4M -O record_buffer=1M &
이러한 옵션으로 서버를 실행하는데, my-cnf에서 이를 수정하여 사용하면 될 것이다.
 
- 128M메모리에 테이블이 적지만, 정렬이 많을 때
shell> mysqld_safe -O key_buffer=16M -O sort_buffer=1M
 
- 메모리는 적지만 많은 연결이 있을 때
shell> mysqld_safe -O key_buffer=512k -O sort_buffer=100k -O record_buffer=100k &
또는
shell> mysqld_safe -O key_buffer=512k -O sort_buffer=16k -O table_cache=32 -O record_buffer=8k -O net_buffer=1K &
 
 
8. group by와 order by작업이 가지고 있는 메모리보다 훨씬 클 경우, 정렬 후 row 읽는 것을 빠르게 하기위해 record_buffer값을 증가시켜라 
 
my.cnf - 2
 
```

---
```
출처 :  http://synap.tistory.com/entry/인트라원을-통해서-본-MySQL-튜닝
 
서버당 파라미터

# InnoDB, unlike MyISAM, uses a buffer pool to cache both indexes and
# row data. The bigger you set this the less disk I/O is needed to
# access data in tables. On a dedicated database server you may set this
# parameter up to 80% of the machine physical memory size. Do not set it
# too large, though, because competition of the physical memory may
# cause paging in the operating system.  Note that on 32bit systems you
# might be limited to 2-3.5G of user level memory per process, so do not
# set it too high.
innodb_buffer_pool_size = 256M
#innodb_buffer_pool_size = 1G

# Query cache is used to cache SELECT results and later return them
# without actual executing the same query once again. Having the query
# cache enabled may result in significant speed improvements, if your
# have a lot of identical queries and rarely changing tables. See the
# "Qcache_lowmem_prunes" status variable to check if the current value
# is high enough for your load.
# Note: In case your tables change very often or if your queries are
# textually different every time, the query cache may result in a
# slowdown instead of a performance improvement.
query_cache_size = 32M
#query_cache_size = 128M


접속당 파라미터

# Sort buffer is used to perform sorts for some ORDER BY and GROUP BY
# queries. If sorted data does not fit into the sort buffer, a disk
# based merge sort is used instead - See the "Sort_merge_passes"
# status variable. Allocated per thread if sort is needed.
sort_buffer_size = 4M
#sort_buffer_size = 8M
 
# This buffer is used for the optimization of full JOINs (JOINs without
# indexes). Such JOINs are very bad for performance in most cases
# anyway, but setting this variable to a large value reduces the
# performance impact. See the "Select_full_join" status variable for a
# count of full JOINs. Allocated per thread if full join is found
join_buffer_size = 4M
#join_buffer_size = 8M

# How many threads we should keep in a cache for reuse. When a client
# disconnects, the client's threads are put in the cache if there aren't
# more than thread_cache_size threads from before.  This greatly reduces
# the amount of thread creations needed if you have a lot of new
# connections. (Normally this doesn't give a notable performance
# improvement if you have a good thread implementation.)
thread_cache = 4


로그관련 파라미터

# Enable binary logging. This is required for acting as a MASTER in a
# replication configuration. You also need the binary log if you need
# the ability to do point in time recovery from your latest backup.
#log_bin
 
# Enable the full query log. Every query (even ones with incorrect
# syntax) that the server receives will be logged. This is useful for
# debugging, it is usually disabled in production use.
#log
 
# Log slow queries. Slow queries are queries which take more than the
# amount of time defined in "long_query_time" or which do not use
# indexes well, if log_long_format is enabled. It is normally good idea
# to have this turned on if you frequently add new queries to the
# system.
log_slow_queries
 
# All queries taking more than this amount of time (in seconds) will be
# trated as slow. Do not use "1" as a value here, as this will result in
# even very fast queries being logged from time to time (as MySQL
# currently measures time with second accuracy only).
long_query_time = 2
```

---
```
쿼리 캐시 이해 못 하는 것

- 어플리케이션 read/write 비율은 알고 있어야지
- 쿼리 캐시 설계는 CPU 사용과 읽기 성능 간의 타협
- 쿼리 캐시 크기를 늘린다고 읽기 성능이 좋아지는게 아님. heavy read라도 마찬가지.
- 과도한 CPU 사용을 막기 위해 무효화 할 때는 캐시 항목들을 뭉텅이로 날려버림
- 한마디로 SELECT가 참조하는 테이블 데이터 하나라도 변경되면 그 테이블 캐시는 다 날라간다는 얘기임
- 수직 테이블 파티셔닝으로 처방
* Product와 ProductCount를 쪼갠다든지..
* 자주 변하는 것과 변하지 않는 것을 쪼개는게 중요하다 이 말임.

인덱스 컬럼에 함수 쓰는 것

- 함수에 인덱스 컬럼 넣어 호출하면 당연히 인덱스 못 탄다
- 함수를 먼저 계산해서 상수로 만든 다음에 = 로 연결해야 인덱스 탈 수 있다.
* 여기 실행 계획 보면 LIKE도 range type 인덱스 타는 것 보임

인덱스 빼먹거나 쓸모없는 인덱스 만들어 놓는 것

- 인덱스 분포도(selectivity)가 허접하면 안 쓴다.
- S = d/n
* d = 서로 다른 값의 수 (# of distinct values)
* n = 테이블의 전체 레코드 수
- 쓸모없는 인덱스는 INSERT/UPDATE/DELETE를 느리게 할 뿐..
- FK는 무조건 인덱스 걸어라. (물론 FK 제약 걸면 인덱스 자동으로 생긴다.)
- WHERE나 GROUP BY 표현식에서 쓰이는 컬럼은 인덱스 추가를 고려할 것
- covering index 사용을 고려할 것
- 인덱스 컬럼 순서에 유의할 것!

 join 안 쓰는 짓

- 서브쿼리는 join으로 재작성해라
- 커서 제거해라
- 좋은 Mysql 성능을 내려면 기본
- 집합 기반으로 생각해야지 루프 돌리는거 생각하면 안 된다.

 

Deep Scan 고려하지 않는 것

- 검색엔진 크러울러가 쓸고 지나갈 수 있다.
- 이 경우 계속해서 전체 집합을 정렬한 다음 LIMIT로 가져와야 하니 무진장 느려진다.
- 어떻게든 집합을 작게 줄인 다음 거기서 LIMIT 걸어 가져올 것

 

InnoDB 테이블에서 WHERE 조건절 없이 SELECT COUNT(*) 하는 짓

- InnoDB 테이블에서는 조건절 없이 COUNT(*) 하는게 느리다.
- 각 레코드의 transaction isolation을 유지하는 MVCC 구현이 복잡해서 그렇다는..
- 트리거 걸어서 메모리 스토리지 엔진 쓰는 테이블에 통계를 별도로 유지하면 된다.

 AUTO_INCREMENT 안 쓰는 것

- PK를 AUTO_INCREMENT로 쓰는건 무진장 최적화 되어 있음
* 고속 병행 INSERT 가능
* 잠금 안 걸리고 읽으면서 계속 할 수 있다는!
- 새 레코드를 근처에 놓음으로써 디스크와 페이지 단편화를 줄임
- 메모리와 디스크에 핫 스팟을 생성하고 스와핑을 줄임

 

ON DUPLICATE KEY UPDATE를 안 쓰는 것

- 레코드가 있으면 업데이트하고 없으면 인서트하고 이런 코드 필요없다!! 다 날려버려라!!
- 서버에 불필요하게 왔다갔다 할 필요가 없어짐
- 5-6% 정도 빠름
- 데이터 입력이 많다면 더 커질 수 있음

```


---
```
3. 파티셔닝은 인덱스의 크기를 작게하여 테이블 자체를 효율적으로 작게 나눌 수 있게 된다. 또한, MySQL 5.7.2 DMR에서 상당히 개선된 내부적인 인덱스 잠금(index->lock) 경합(contention)도 줄여 준다.

4. InnoDB의 압축 기능을 사용하자. 몇몇 부하 종류의(특별히 많은 char/varchar/text형 컬럼이있는 경우) 압축 기능은 데이터를 압축해 성능 저하의 곡선을 완만하게 해준다. 또한, 일반적으로 용량이 작은 SSD를 사용해도 된다. InnoDB의 압축 기능은 Facebook에서 제공한 여러가지 패치 덕택에 MySQL 5.6에서는 크게 개선 되었다.

5. 정렬후 대용량의 데이터를 테이블에 로드해라. 정렬된 데이터를 인서트하는 것은, 페이지 분할(메모리 상에 없는 테이블에서 성능은 악화되는)이 작게 될 것이고, 대용량 데이터의 로드는 테이블의 용량과는 특별히 관계가 없지만, redo 로그의 압축 부하를 줄여주는데 도움을 준다.

6. 테이블에서 불필요한 인덱스를 지우자. 체인지 버퍼 기능을 비활성화시키는 UNIQUE 키를 특히 주의하자. 제약 조건을 사용할 이유가 없는 경우, UNIQUE 키를 사용하지 않고 일반적인 INDEX를 사용하자.

7. 5, 6에서 관련된 PRIMARY KEY의 종류도 중요하다. 성능 저하를 빠르게 만들어버리는 GUID와 같은 데이터 타입보다, INT나 BIGINT를 사용하자. PRIMERY KEY가 없는 것도 성능에 부정적인 영향을 준다.

8. 새 테이블에 대용량 데이터를 로드할 경우 PRIMARY KEY가 아닌 인덱스는 나중에 만들자. 모든 데이터가 로드된 후 인덱스를 만든다면, InnoDB는 pre-sort와 및 대용량 로드 프로세스(빠르고 인덱스가 좀 더 콤팩트한 인덱스를 만드는)를 적용 할 수 있게 된다. 이 최적화는 MySQL 5.5에서 이루어졌다.

9. 메모리가 많으면 많을수록 도움을 받을 수 있다. 최근의 메모리의 실제 가격을 비교해 보면 새로운 데이터 베이스 서버에 너무 적은 메모리를 적용하는 것을 자주 볼 수 있다. 간단한 조언을 해 보면, SHOW ENGINE INNODB STATUS의 결과에서 BUFFER POOL AND MEMORY의 reads/s의 보여주고(읽고 있음을 나타냄), Free buffers(이것도 BUFFER POOL AND MEMORY 아래에 있다)의 수가 0이면 메모리를 더 늘리면 혜택이 얻을 수 있다.(innodb_buffer_pool_size를 잘 최적화했다는 가정하에. 이 문서를 참고).

10. 메모리 뿐만 아니라, SSD도 도움이 된다. 그래프의 곡선이 하향이 되는 이유는 테이블이 커져서 일어나는 IO 속성 때문이다. 하드 디스크가 초당 200 오퍼레이션(IOPS)을 수행하는데 반해, 일반적인 SSD는 20000 IOPS 이상 수행이 가능하다.
```
