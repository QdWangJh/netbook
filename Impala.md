### 常用命令
#### 外部shell

```shell
impala-shell  --进入Impala的shell命令行
impala-shell -h --帮助 提示
impala-shell -i ip/绑定过ip的主机名 --连接到远程机器
impala-shell -q  'select...' --不进入Impala的shell命令行 直接执行后面的sql
impala-shell -f path/file_name  --执行文件中的sql
impala-shell -c -f path/file_name  --执行文件中的sql 忽略错误继续执行
impala-shell -f path/file_name -o path/out_file --将查询结果保存到文件中
impala-shell -f path/file_name -B -o path/out_file --将查询结果无格式的保存到文件中
impala-shell -f path/file_name -B --print_header -o path/out_file  --将查询到的表头一起导出
impala-shell -f path/file_name -B --output_delimiter ';' -o path/out_file --设置导出数据的分隔符 , 默认 \t
impala-shell -p -- 进入Impala的shell命令行,将执行的sql 详细信息打印出来
impala-shell -v -- 查看版本
impala-shell -r --全量刷新元数据库

```

#### 内部shell
```shell
help --显示帮助信息
explain <sql> --显示执行计划
profile -- (查询后执行)查看最近一次查询的底层信息
shell <shell> -- 不退出 impala-shell 执行linux shell
version --显示版本信息
connect -- 连接远程impalad主机,默认端口21000

refresh <table_name> --增量刷新元数据

invalidate metadata  --全量刷新元数据库(慎用)
history -- 查看历史命令


```


#### 注意点

impala以load方式往表中加载数据,必须先创建分区,insert into 会自动创建

alter table table_name partition(day='');
load data inpath 'path/file' into table table_name partition(day='');

#### 基础命令

增加多个分区
alter table  table_name add partition (day='') partition (day='');
删除分区
alter table table_name drop partition(day='');
查看分区
show partition table_name;

##### 不支持
- impala 不支持 cluster by , distribute by , sort by
- 不支持分桶表
- 不支持 collect_set 和 explode 函数

#### 文件格式
- 文件格式parquet  压缩方式 snappy(默认) / gzip
- 文件格式 text 压缩格式 LZO / gzip /bzip2 / snappy  如果用LZO压缩,必须在hive中创建表和加载数据   如果不指定 stored as 子句的 create table 语句 默认的文件格式是未压缩的

例
```sql
create table table_name(id int)
	 row format delimited
	fields terminated by '\t'
	stored as PARQUET;
```

### 优化
- 使用  compute stats 进行表信息搜集,当一个内容表或分区明显变化,重新计算相关数据表或分区.因为行和不同值的数量差异可能导致impala选择不同的连接顺序时,表中使用的查询
```sql
compute stats table_name;
```