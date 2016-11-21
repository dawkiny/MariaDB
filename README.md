# MariaDB


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
