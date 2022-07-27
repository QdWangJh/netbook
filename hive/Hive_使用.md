## Hive Sql  -- DDL --建表语句

### 一 创建表

#### 分区表

```sql
create table tab_name(a b,c d)
partitioned by (list_name 字段类型) -- 分区字段
-- 分区字段不能与已有的列名重复
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ’\t’ -- 指定字段分隔符为 \t  默认为'\001' 默认不需要指定
lines terminated by '\n' -- 指定行分割符为 \n 默认 \r

comment "word";
-- comment 注释

-- 加上 if not exists 忽略异常 (例:表已存在)
create table if not exists tab_name(a b,c d);

-- 创建后将文件上传到hive在hdfs的目录上
-- 在HDFS的默认存储路径
hdfs dfs -put  /文件路径/文件
/user/hive/warehouse/数据库名.db/表名
```

#### 外部表

H ive 外部表关联数据文件有两种方
式： 一种是把外部表数据位置直接关联到数据文件所在目录上，这种方式适合数据文件已经在
HDFS 中存在： 另外一种方式是创建表时指定外部表数据目录， 随后把数据加载到该目录下。

```sql
-- 外部表  关键字 external
create external table tab_name(a b,c d)
row format delimited
fields terminated by '\t'
location '/文件位置';
```

-- 内外部表的区别
内部表在删除时,会把元数据和数据都删除
外部表在删除时,只删除元数据,HDFS上的数据文件不会被删除。

#### 存储路径

```sql
-- 在建表的时候 可以使用location关键字指定表的路径在HDFS任意位置
create table tab_name(a b,c d)
location '/path' --指定表在hdfs上的存储路径
```

#### 桶表

```sql
create table table_name(id int) clustered by(id) into 8 buckets;
-- 指定分桶字段 必须是表中存在字段
-- 分几个桶
```



### 二 查看建表信息

```sql
desc tab_name
```



###  三 Hive 读写 HDFS 上的文件

写文件

```sql
row format delimited
[fields terminated by char]  #指定字段之间的分隔符
[collection items terminated by char]  #指定集合元素之间的分隔符
[map keys terminated by char]         #指定map类型kv之间的分隔符
[lines terminated by char]            #指定换行符
```



```sql
-- 建表
create table if not exists tab_name(a b,c d)
row format delimited -- 行格式分隔
fields terminated by ' ' -- 字段之间的分隔符
collection items terminated by ' ' -- 集合元素之间的分隔符
map keys terminated by ' '; -- 集合key,values之间的分隔符

-- 上传数据
hadoop fs -put file_name /path/tab_name

-- 读取

select * from tab_name

-- 将HDFS的数据加载到hive
load data local inpath 'path/file_name' into table tab_name;

```



如果,建表不指定分割符 则默认为 \001  (不可见),针对复合类型的数据 要想直接从文件中解析成功 还必须配合分隔符指定的语法。





### 查看建表语句

```sql
show create table table_name
```

### 查看表结构

```sql
desc table_name;
```

### 插入数据

```sql
insert overwrite table table_name partition () select 语句;
```



### 查看表的位置

```sql
desc formatted table_name
```



### hive常用交互命令

1.“-e”不进入hive的交互窗口执行sql语句

```sql
bin/hive -e "select id from student;"
```

2.“-f”执行脚本中sql语句

```sql
bin/hive -f /opt/module/datas/hive.sql
```

(3)执行文件中的sql语句并将结果写入文件中(注：可能含有其他的表信息，如表头)

```sql
bin/hive -f /opt/module/datas/hive.sql > /opt/module/datas/hive_result.txt
```

在hive cli命令窗口中如何查看hdfs文件系统

```
dfs -ls /;
```

3.在hive cli命令窗口中如何查看linux本地系统

```sql
! ls /opt/module/datas;
```

4.查看在hive中输入的所有历史命令

(1)进入到当前用户的根目录/root或/home/itstar

(2)查看. hivehistory文件

```
cat .hivehistory
```



### group by  order by注意点

```sql
group by 后面跟原字段名,不能跟别名
where中不能使用别名
order by 后面要跟别名
```

### hive执行顺序

```mysql
from …on … join …where … group by … having … select … distinct … order by … limit
```

### hive中截取小数

```sql
round(column_name,2)                 四舍五入截取(这种方法慎用，有时候结果不是你想要的)

regexp_extract(column_name,'([0-9]*.[0-9][0-9])',1)      正则匹配截取，不做四舍五入，只是单纯的当作字符串截取

cast(column_name as decimal(10,2))        cast函数截取（推荐使用）

```

不能用 TRUNCATE 来截取小数

### hive的行列转换

#### explode() 行转列

- explode(array) 列表中的每个元素生成一行
- explode(MAP) map中每个key-value对，生成一行，key为一列，value为一列

```mysql
explode(array)
select explode(列) from 表
```

![image-20211223160201221](F:\笔记\hive\图\image-20211223160201221.png)

![image-20211223160226595](F:\笔记\hive\图\image-20211223160226595.png)

限制:

- 必须将要炸裂的字段搞成array格式,或者map格式
- 不能与别的字段一起用
- 不允许多个explode()嵌套
- 不能与分组排序函数连用

解决方法:

###### lateral view

```sql
SELECT pageid, adid
FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid;
```

![image-20211223162133761](F:\笔记\hive\图\image-20211223162133761.png)

![image-20211223162205293](F:\笔记\hive\图\image-20211223162205293.png)

###### 多个lateral view

![image-20211223162450267](F:\笔记\hive\图\image-20211223162450267.png)

```sql
from后只有一个lateral view：

SELECT myCol1, col2 FROM baseTable
LATERAL VIEW explode(col1) myTable1 AS myCol1;
```

![image-20211223162526526](F:\笔记\hive\图\image-20211223162526526.png)

- 多个lateral view：

```sql
SELECT myCol1, myCol2 FROM baseTable
LATERAL VIEW explode(col1) myTable1 AS myCol1
LATERAL VIEW explode(col2) myTable2 AS myCol2;
```

![image-20211223162612503](F:\笔记\hive\图\image-20211223162612503.png)

###### Outer Lateral Views

如果array类型的字段为空，但依然需返回记录，可使用outer关键词

```sql
select * from src LATERAL VIEW OUTER explode(array()) C AS a
```

结果中的记录数为src表的记录数，只是a字段为NULL。

![image-20211223163219889](F:\笔记\hive\图\image-20211223163219889.png)



### 获取时间

获取当前时间戳

```sql
unix_timestamp()
```

获取当前时间

```sql
from_unixtime(unix_timestamp())
2022-01-05 14:36:49
```

### 正则

```sql
regexp_extract
语法: regexp_extract(string subject, string pattern, int index)
返回值: string
说明：将字符串subject按照pattern正则表达式的规则拆分，返回index指定的字符。
regexp_extract(字段,'正则',1)
数据量大容易内存溢出

正则替换
regexp_replace
语法: regexp_replace(string A, string B, string C)
返回值: string
说明：将字符串A中的符合java正则表达式B的部分替换为C。注意，在有些情况下要使用转义字符,类似oracle中的regexp_replace函数。

```

