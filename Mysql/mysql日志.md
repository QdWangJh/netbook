### 分类

#### 错误日志

记录了当mysql启动和停止时,一级服务器在运行过程中发生任何严重错误时的相关信息.当数据库出现任何障碍导致无法正常使用时,可以先查看此日志

默认存放目录为mysql的数据目录,名称为hostname.err(hostname主机名)

```mysql
查看日志
show variables like 'log_error';
```



#### 二进制日志

记录了索引的DDL语句和DML语句,但是不包括查询语句,应用于灾备恢复,mysql的主从复制,就是通过binlog实现

mysql 8.0默认开启

其他版本开启方法:

需要配置文件开启,并配置MYSQL的日志格式

windows系统:my.ini	Linux系统:my.cnf

```ini
#配置开启binlog日志,日志文件前缀为mysqlbin---生成的文件名 mysqlbin.000001 ....
log_bin=mysqlbin

#配置二进制日志格式
binlog_format=STATEMENT
```

##### 日志格式

STATEMENT

该日志格式在日志文件中记录的都是SQL语句,每一条对数据的修改都会记录在日志文件中,通过mysql提供的mysqlbinlog工具可以看到每条语句的文本



ROW(默认)

记录的是每一行数据的内容



MIXED

包括了STATEMENT和ROW的内容



##### 使用

```mysql
查看是否开启了binlog日志
show variables like 'log_bin';

查看binlog的格式
show variables like 'binlog_format';

查看所有日志
show binlog events;

查看最新的日志
show master status

查看指定的binlog日志
show binlog events in 'binlog.00010'; 

show binlog events in 'binlog.00010'  from 1000  -- 指定偏移量 查看Pos 1000之后的数据  可再加limit 分页;

清空所有binlog日志
reset master
```



#### 查询日志

记录了所有操作语句

默认 不开启

```sql
# 开启查询日志 0 关闭 1开启
general_log = 1

#设置日志文件名,默认为 hostname.log
general_log_file=file_name
```

##### 使用

```sql
查看是否开启
show variables like 'general_log';

-- 在本次连接中 暂时开启 (如果文件中已经配置则不需要)

set global general_log = 1;

可以在文件中查看日志
```



#### 慢查询日志

记录执行时间超过参数 long_query_time 值兵器扫描记录不小于 min_examined_row_limit 的所有的sql语句

long_query_time默认为10s 最小为0,可精确到微秒

```sql
#开启慢查询日志 1开启 0 关闭
slow_query_log = 1

#指定文件名
slow_query_log_file=slow_query.log

#设置超过时间
log_query_time = 10 
```

##### 使用

```sql
查看是否开启
show variables like 'slow_query_log'

临时开启

set global slow_query_log =1; 
```

