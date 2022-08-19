## MySQL索引

### 介绍

索引是通过某种算法,构建出一个数据模型,用于快速找出在某个列中有一特定值的行

### 索引建立原则

- 更新频繁的列不应设置索引
- 数据量小的表不要使用索引
- 重复数据多的字段不设置索引(重复数据大于15%)
- 首先考虑对where和order涉及的列上建索引

### 分类

方法分类:

- Hash索引

- B+Tree索引

按功能分类

#### 单列索引:

一个索引只包含单个列,一个表中可以有多个单列索引

##### 普通索引

MySQL中基本索引类型,没有限制,允许在索引中插入重复值和空值,只是为了查询更快一点

```sql
建表时在列名创建后
index index_name(列名)

直接创建
create index index_name on 表名(列名);

修改表结构添加
alter table 表名 add index(列名);
```



##### 唯一索引

索引的列值必须唯一,允许有控制.

如果是组合索引,则列值组合必须唯一

```sql
unique index  index_name(列名) 
创建语法与普通索引相似
```



##### 主键索引

唯一,不允许为null 是特殊的唯一索引

创建主键时,自动添加

#### 组合索引/复合索引

建立索引时使用多个字段

可以创建为组合普通索引或组合唯一索引

最左原则,条件必须包括第一个字段才会使用到索引

```
create index index_name on table_name(字段1,字段2)
```



#### 全文索引

主要是用来查找文本中的关键字,而不是直接与索引中的值相比较,更像是一个搜索引擎,基于相似度查询,而不是简单的where语句

速度比like+%快很多,但是会存在精度问题

只有字段数据类型为 char,varchar ,text才可以建全文索引

在有数据时建立全文索引比空表建全文索引速度快

mysql的全文索引有两个变量,==最小搜索长度和最大搜索长度==,如果搜索的词不在这两个范围内则不能使用全文索引

```sql
查看最大最小长度
show variables like '%ft%';
innodb 引擎最小 3字节 最大84字节
```

创建

```sql
建表时创建
create table table_name(
	fulltext (字段名) --创建全文索引
)

添加全文索引
create fulltext index index_name on table_name(字段名)

修改表结构添加
alter table table_name add fulltext index_name(字段名)
```

使用全文索引

```sql
select * from tbale_nam where match(添加过全文索引的字段名1,2..) against('关键字'); -- 需要在3-84个字节之间
```



#### 空间索引

mysql5.7版本之后才有,支持 OpenGIS几何数据模型

空间索引是对空间数据类型的字段建立的索引

==mysql中的空间索引数据类型有4种,为GEOMETRY , POINT ,LINESTRING , POLYGON==

mysql使用SPATIAL关键字进行扩展,使得能够用于创建正规索引类型的语法创建空间索引

创建空间索引的列,必须将其声明为 not null

![image-20220107012900366](F:\笔记\mysql\图\image-20220107012900366-16414901428521.png)

创建

```sql
例
create table table_name(
geom_point geometry --空间类型 not null comment '经纬度',
spatial key index_name(geom_point)
);

```



### 查看索引

```sql
查看数据库中的所有索引
select * from mysql.`innodb_index_stats` a where a.`database_name`='库名'

查看表中所有索引
select * from mysql.`innodb_index_stats` a where a.`database_name`='库名' and a.table_name like '%表名%'

查看表中所有索引
show index from 表名;
```

### 删除索引

```
drop index 索引名 on 表名;

alter table 表名 drop index 索引名
```

