  



## MySql操作

​    mysql语句结尾必须有  ;

​	数据表的一行称为记录
​	数据表的一列称为字段 

​    表名，字段名可以用中文，不用加单引号
​    **属性值(内容)则需要加单引号**

## 数据库操作

### 1.查看所有数据库

```mysql
show databases ;
```



### 2.创建数据库

```mysql
create database data_name char set=utf8 ;
```

### 3.进入数据库

```mysql
use data_name ;
```

### 4.查看当前使用的数据库

```mysql
select database() ;
#查看当前数据的创建方式;查看数据库的编码表 
show create database data_name; 
```

### 5.删除数据库

```mysql
drop database data_name ;
```

### 6.修改数据库

```mysql
#修改数据库的编码格式
alter database data_name character set 编码格式 ; 
```



## 表结构操作

### 1.查看当前数据库中的所有表

```mysql
show tables ; #查看当前库中有多少个表
show create table tab_name; #查看创建表使用的语句
show full table 查看所有表的类型(表|视图)
desc tab_name; # 查看当前表的描述信息

```

#### 查看表注释,结构信息

```sql
show  full columns from  tab_name;
```



### 2.创建表

```mysql
#create table 表名(
	列名 类型(长度),
	列名 类型(长度)
	);
####################################################
create table students(
id int unsigned primary key auto_increment not null,
    #int类型 无符号 主键  自动递增 非空
name varchar(20) not null ,
age tinyint unsigned default 0 ,
height decimal(5,2),
gender enum('男','女')
    #枚举  值只能是括号中的
);


```

```sql
临时表
create temporary table tbl_name
规则：每个会话只能看到自己创建的临时表，不同的会话可以创建相同表名称的临时表。临时表的表名可以和永久表的名字相同。
好处：可以利用临时表保存一些临时数据，断开会话自动清除数据
坏处：
1.与服务器意外断开会话，临时表将被删除。
 2.临时表只对创建会话可见，所以和线程池连接技术不能同时共用
　　　3.可能会跟永久表冲突，导致重连之后误操作永久表种的数据。为了避免删除相同表明的永久表，执行删除表结构的时候可以使用drop temporary table_name;
```



### 3.修改表

```mysql
#可以对表名,列名,列的类型,列的约束进行增删改
alter table 表名 增/删/改 列名 类型(长度) 约束;

# 1 增加列
alter table 表名 add 列名 类型(长度) 约束;

#2 修改列的类型 
alter table 表名 modify 列名 类型(长度) 约束;

#3 修改列名	
alter table 表名 change 旧列名 新列名 类型(长度) 约束;

#4 修改表名
rename table 旧表名 to 新表名

#5 修改表的编码集 
alter table 表名 character set 编码集; 

#6 删除列 
alter table 表名 drop 列名;

#修改注释
alter table test1 comment '修改后的表的注释;

#修改字段的注释	
alter table test1 modify column field_name int comment ‘修改后的字段注释’;

-- 注意：字段名和字段类型照写就行
```


### 4.删除表

```mysql
#删除表 
drop table 表名;
#清空表
truncate t
```

## 表内容操作

### 1.向表中插入数据

```mysql
insert into 表名( values(数据1,按顺序填写),(数据2);
#自动填充的id 可以用0 ,有默认值的可以用default
insert into 表名(列名,列名,....) values (值,值,.....),(数据2);
#如果给所有列添加数据可以省略列名,自增长数据可以用0或null,时间需要用''

如果数据库中已经存在该条记录就更新,没有就增加 (需要有主键a)
insert into 表名(列明,列名.) values('a','b','c') on duplicate key update b = 'b',c = 'c';
               
INSERT INTO table2 SELECT * FROM table1;
INSERT INTO table2(column_name(s))SELECT column_name(s)
FROM table1;
               
              
```


### 2.修改表中的数据
```mysql
update 表名 set 列名=值,列名=值... where条件语句;
#注意:如果不加条件,会将整列的所有值修改
```

### 3.删除记录

```mysql
#物理删除
#删除后id值会接着之前的增加数据可找回
delete from 表名 where条件语句; 

#彻底删除整张表的内容,删除速度快
truncate table 表名; 

#逻辑删除
#添加删除表示字段,0表示未删除 1表示删除
alter table 表名 add is_delete bit default 0;
#逻辑删除字段
update 表名 set is_delete=1 where 条件;
#逻辑删除后查看数据
select * from 表名 where is_delete=0;
```



### 4.查询
```mysql
#1.查询表中所有数据
select * from 表名; 

#2 查询指定列符合条件的数据,不加where查询列中全部数据
select 列名,列名... from 表名 where条件语句;  
	
#3.模糊查询
 like ''
where 列名  like''
占位符 %(任意字符串) _任意单个字符
#4.过滤重复数据
select distinct 列名 from 表名 where条件语句;

# 5.排序
select * from 表名 order by 列名 asc(升序)|desc(降序);

# 6.给查询出的列名起别名
select 列名 as 别名,列名 as 别名 from 表名 where条件语句;
as可以省略不写
#7.范围查询
-between and 表示在一个连续的范围内查询
select * from 表名 where 查询内容 between 范围1 and 范围2;

- in 表示在一个非连续的范围内查询
select * from 表名 where in(范围1,范围2,范围3);

#8.空判断查询
- is null 判断为空
- is not null 判断为非空
select * from 表名 where 查询的内容 is null;

#分页查询
公式 count*(page-1)
limit 索引_数据开始的位置可以缩写默认0,一页显示的数量
select * from students limit 0,5
-- 坑点: 当有排序规则, 且做了分页查询. 如果排序的数据有重复项, 就会导致返回的数据是随机的
-- 有可能会导致数据查询有问题
-- 解决方案: 排序规则中, 最后必须有一个唯一值(主键) /或者用嵌套查询
例:
select *
from info where age = (select min(age)from info);

-- 如果不是第一或最后一个则用开窗
例:  查询倒数第三个
select a.emp_no, birth_date, first_name, last_name, gender, hire_date
from (SELECT *, DENSE_RANK() over (order by hire_date desc ) b FROM employees) a
where b = 3;
```



## 字符类型	

### 字符串型

```sql
varchar:变长  char:定长
大数据类型:mysql中:BLOB保存字节数据  TEXT保存字符数据
通常不把文件存储到数据库中(占资源,操作速度慢),把文件的路径(通常在本地磁盘中)存到数据库中
```



### 数值型

```sql
整数: int , bit

小数: decimal

在创建数据表时,数值型有自己的长度
一般不需要指定,使用默认长度
```



### 日期型

```sql
date\time\datetime\timestamp

timestamp 时间戳,显示 是一个long整型值

timestamp和datetime都可以保存年月日时分秒

timestamp在保存时会自动将这一列变成当前保存数据的时间
```



### 枚举型

```sql
enum()  
```



## 约束
### 1.主键约束 

```sql
primary key (一张表中只能有一或两个作为主键约束)
这一列的数据在整个数据表中不重复且自动填充
列名 列的类型 primary key
	
```



### 2.唯一约束

```sql
 unique   # 该列(字段)的值不允许重复
```

​	

### 3.非空约束

```sql
 not null  # 该字段的值不能为空
```



### 4.默认约束

```sql
default 默认值
```



### 5.外键约束

外键约束:对外键字段的值进行更新和插入时会和引用表中字段的数据进行验证，数据如果不合法则更新和插入会失败，保证数据的有效性

```sql
foreign key 约束字段    references 被约束字段

一对一  随便添加

一对多  给多的一方添加约束

-- 为cls_id字段添加外键约束
alter table students add foreign key(cls_id) references classes(id);

```



#### 删除外键约束

```mysql
--需要先获取外键约束的名称,系统自动生成,通过创表语句获取
show create table table_name;
--获取名称后,根据名称来删除
alter table table_name drop foreign key 外键名称

```



### 6. 自增长

```sql
 auto_increment
如果表的主键是 int 类型,可以在主键后面添加 auto_increment ,这一列在添加数据时会自动增长
```




## 聚合函数
### 1.count 统计个数(行数)
```sql
select count(*)/count(列名) from 表名 ; 如果数据中有null则不会被统计
COUNT（*） 将计算表中的所有订单
COUNT（date） 将仅计算date列值不为NULL的行
COUNT(DISTINCT date)只统计date列中非空唯一值的数量
select count(1) from 表名 where条件语句; 实际使用,站内存小
```

​	

### 2.sum 求和
```sql
select sum(列名) from 表名 where条件语句;
```

​	

### 3.ifnull 查询空值,以默认值填充

```sql
ifnull(值,默认值) 
如果这行内容为空,使用默认值,在函数内使用
```



```mysql
select round(avg(ifnull(height,25611)),2) from students where gender = '男';
```



### 4.round设置保留的小数位

```sql
round(列名,截取的小数位) 

保留几位小数,在函数外使用

TRUNCATE(X,D)
直接截取需要保留的小数位

返回被舍去至小数点后D位的数字X。若D的值为0,则结果不带有小数点或不带有小数部分。可以将D设为负数,若要截去(归零)X小数点左起第D位开始后面所有低位的值. 

 concat(num*100,"%")
 转为百分比
 concat(TRUNCATE(X*100,D),"%")
 x
1.ceil() / ceiling（） 向上取整 ex： ceil（1.2） = 2

2.floor() 向下取整 ex： floor（1.2） = 1

```



### 5.avg 平均数
select avg(列) from表名

### 6.max , min 最高 , 最低
select max(列名)/mix(列名) from 表名;

### 7.group by 分组函数
group by 列名;  # 在 from 表名 之后;

分组后,select只能出现**被分组的列和聚合函数**

```mysql
select gender,count(*)from students group by gender ;
```

group_concat(字段名): 统计每个分组指定字段的信息集合，每个信息之间使用逗号进行分割

```sql
-- 根据gender字段进行分组， 查询gender字段和分组的name字段信息
select gender,group_concat(name) from students group by gender;
```

with rollup的作用是：在最后记录后面新增一行，显示select查询时聚合函数的统计和计算结果

```sql
-- 根据gender字段进行分组，汇总总人数
select gender,count(*) from students group by gender with rollup;
```

> 标准SQL不允许在GROUP BY子句中引用别名,但在MySQL中允许 在 GROUP BY 中使用列别名

==**group by 1 是指分组第一个查询的字段**== 2.3...

### 8. having 

在分组之后需要使用where条件语句时使用having替换where

having 条件语句



## 连接查询

### 1.内连接

查询两个表中符合条件的共有记录

- inner join 就是内连接查询关键字
- on 就是连接查询条件

```sql
select 字段 from 表1 inner join 表2 on 表1.字段1 = 表2.字段2
```

### 2. 右连接查询

以右表为主根据条件查询左表数据，如果根据条件查询左表数据不存在使用null值填充

```sql
select 字段 from 表1 right join 表2 on 表1.字段1 = 表2.字段2
```

### 3. 左连接查询

以左表为主根据条件查询右表数据，如果根据条件查询右表数据不存在使用null值填充

```sql
select 字段 from 表1 left join 表2 on 表1.字段1 = 表2.字段2
left anti join
```

### 全连接

```sql
select 字段 from 表1 full join 表2 on 表1.字段1 = 表2.字段2  相当于没有条件的 inner join
```

### 4. 自连接查询

左表和右表是同一个表，根据连接查询条件查询两个表中的数据。

- 自连接查询必须对表起别名

### 各种连接取值 例子:

<img src=".\图\image-20211222095649336.png" alt="image-20211222095649336" style="zoom: 200%;" />



### 交叉连接 cross join

如果不带WHERE条件子句，它将会返回被连接的两个表的==笛卡尔积==，返回结果的行数等于==两个表行数的乘积==；

```sql
举例,下列A、B、C 执行结果相同，但是效率不一样：

A:SELECT * FROM table1 CROSS JOIN table2

B:SELECT * FROM table1,table2

C:select * from table1 a inner join table2 b


A:select * from table1 a cross join table2 b where a.id=b.id (注：cross join后加条件只能用where,不能用on)

B:select a.*,b.* from table1 a,table2 b where a.id=b.id

C:select * from table1 a inner join table2 b on a.id=b.id

一般不建议使用方法A和B，因为如果有WHERE子句的话，往往会先生成两个表行数乘积的行的数据表然后才根据WHERE条件从中选择。 

因此，如果两个需要求交际的表太大，将会非常非常慢，不建议使用。
```

### 外连接：OUTER JOIN

外连接就是求两个集合的并集。(两张表拼起来没有的补null)从笛卡尔积的角度讲就是从笛卡尔积中挑出ON子句条件成立的记录，然后加上左表中剩余的记录，最后加上右表中剩余的记录。另外==MySQL不支持OUTER JOIN==,可以对左右连接的结果用union连接

```sql
SELECT * FROM t_blog LEFT JOIN t_type ON t_blog.Id=t_type.id
UNION
SELECT * FROM t_blog RIGHT JOIN t_type ON t_blog.Id=t_type.id;
```

### USING子句

当模式设计对联接表的==列==采用了==相同的命名==样式时，就可以使用 USING 语法来简化 ON 语法，格式为：USING(column_name)。

SELECT *时，USING会==去除USING指定的列==，而ON不会。

```sql
SELECT * FROM t_blog INNER JOIN t_type USING(id);
```

原表

![image-20211223150505092](F:\笔记\mysql\图\image-20211223150505092.png)

![image-20211223150514709](F:\笔记\mysql\图\image-20211223150514709.png)

结果

![image-20211223150528038](.\图\image-20211223150528038.png)

### 5.子查询

在一个 select 语句中,嵌入了另外一个 select 语句, 那么被嵌入的 select 语句称之为子查询语句，外部那个select语句则称为主查询.

**主查询和子查询的关系:**

1. 子查询是嵌入到主查询中
2. 子查询是辅助主查询的,要么充当条件,要么充当数据源
3. 子查询是可以独立存在的语句,是一条完整的 select 语句

```sql
select name from classes where id in (select cls_id from students where cls_id is not null);

```

### 自然连接：NATURE JOIN

自然连接就是USING子句的简化版，它找出两个表中相同的列作为连接条件进行连接。有**左自然连接**，**右自然连接**和**普通自然连接**之分。在t_blog和t_type示例中，两个表相同的列是id，所以会拿id作为连接条件。
另外千万分清下面三条语句的区别 。
自然连接:SELECT * FROM t_blog NATURAL JOIN t_type;
笛卡尔积:SELECT * FROM t_blog NATURA JOIN t_type;
笛卡尔积:SELECT * FROM t_blog NATURE JOIN t_type;

```sql
SELECT * FROM t_blog NATURAL JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog,t_type WHERE t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog INNER JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog INNER JOIN t_type USING(id);

    +----+-------+--------+------------+
    | id | title | typeId | name       |
    +----+-------+--------+------------+
    |  1 | aaa   |      1 | C++        |
    |  2 | bbb   |      2 | C          |
    |  3 | ccc   |      3 | Java       |
    |  4 | ddd   |      4 | C#         |
    |  5 | eee   |      4 | Javascript |
    +----+-------+--------+------------+

    SELECT * FROM t_blog NATURAL LEFT JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog LEFT JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog LEFT JOIN t_type USING(id);

    +----+-------+--------+------------+
    | id | title | typeId | name       |
    +----+-------+--------+------------+
    |  1 | aaa   |      1 | C++        |
    |  2 | bbb   |      2 | C          |
    |  3 | ccc   |      3 | Java       |
    |  4 | ddd   |      4 | C#         |
    |  5 | eee   |      4 | Javascript |
    |  6 | fff   |      3 | NULL       |
    |  7 | ggg   |      2 | NULL       |
    |  8 | hhh   |   NULL | NULL       |
    |  9 | iii   |   NULL | NULL       |
    | 10 | jjj   |   NULL | NULL       |
    +----+-------+--------+------------+

    SELECT * FROM t_blog NATURAL RIGHT JOIN t_type;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog RIGHT JOIN t_type ON t_blog.id=t_type.id;
    SELECT t_blog.id,title,typeId,t_type.name FROM t_blog RIGHT JOIN t_type USING(id);

    +----+------------+-------+--------+
    | id | name       | title | typeId |
    +----+------------+-------+--------+
    |  1 | C++        | aaa   |      1 |
    |  2 | C          | bbb   |      2 |
    |  3 | Java       | ccc   |      3 |
    |  4 | C#         | ddd   |      4 |
    |  5 | Javascript | eee   |      4 |
    +----+------------+-------+--------+
```



## 拆表

将一张表的多列数据拆分,用id值链接,达到简化数据的效果,但是当电脑运行资源比存储资源较低时不建议使用用

```sql
-- 创建商品分类表
create table good_cates(
    id int not null primary key auto_increment, 
    name varchar(50) not null
);
-- 查询goods表中商品的分类信息
select cate_name from goods group by cate_name;

-- 将查询结果插入到good_cates表中
insert into good_cates(name) select cate_name from goods group by cate_name;

将goods表中的分类名称更改成商品分类表中对应的分类id

-- 查看goods表中的商品分类名称对应的商品分类id
select * from goods inner join good_cates on goods.cate_name = good_cates.name;

-- 把该语句中from 后的语句理解为一张虚表  
update goods g inner join good_cates gc on g.cate_name=gc.name set g.cate_name=gc.id;

```



## 窗口函数

> MYSQL 8.0 之后，加入了窗口函数功能，简化了数据分析工作中查 询语句的书写,窗口函数是类似于可以返回聚合值的函数，例如SUM()，COUNT()， MAX()。但是窗口函数又与普通的聚合函数不同，它不会对结果进行分 组，使得输出中的行数与输入中的行数相同。

### 窗口函数的优点

> * 简单 
    * 窗口函数更易于使用。在上面的示例中，与使用聚合函数然后 合并结果相比，使用窗口函数仅需要多一行就可以获得所需要 的结果。 
> * 快速 
    * 这一点与上一点相关，使用窗口函数比使用替代方法要快得 多。当你处理成百上千个千兆字节的数据时，这非常有用。
> * 多功能性 
    * 最重要的是，窗口函数具有多种功能，比如，添加移动平均 线，添加行号和滞后数据，等等。

### 格式

```mysql
SELECT SUM() OVER(PARTITION BY ___ ORDER BY ___) FROM Table
```

### OVER()的基本用法

> OVER (...) 的最基本用法： OVER() 意思是处理整列所有的数据,括号中添加条件过滤
>
> OVER()前需要配合函数使用(聚合函数,rank()等)

### PARTITION BY 的基本用法

```mysql
<window_function> OVER (PARTITION BY column1, column2 ...
column_n)
```

> PARTITION BY 的作用与 GROUP BY 类似：将数据按照传入的列进行 分组，与 GROUP BY 的区别是， PARTITION BY 不会改变结果的行数

####  PARTITION BY与GROUP BY区别

> ① group by是分组函数，partition by是分析函数
>
>  ② 在执行顺序上：
>
> ```mysql
> from > where > group by >聚合函数> having >窗口函数>select> order by > partition by
> ```
>
>  而partition by应用在以上关键字之后，可以简单理解为就是在执行完select 之后，在所得结果集之上进行partition by分组
>
>  ③ partition by相比较于group by，能够在保留全部数据的基础上，只对其 中某些字段做分组排序（类似excel中的操作），而group by则只保留参与分 组的字段和聚合函数的结果（类似excel中的pivot透视表） 



## 排序函数

取第几条时,需要用子查询

### rank

```mysql
select rank() over(order by ) from
```

rank 函数会在排序后生成一列序号记录,序号会在值相同的记录上标记相同的数字,在下一个不同的记录上,根据当前的记录标记序号,如有三条相同的记录标记为1,下一个记录则标记为4.

### dense_rank

```mysql
select dense_rank() over(order by ) from
```

dense_rank 函数会在排序后生成一列序号标记,序号会在值相同的记录上标记相同的数字,在下一个不同的记录上,接着上一个标记加1继续标记,如有三条相同的记录标记为1,下一个记录则标记为2.

### row_number

```mysql
select row_number() over(order by) from	
```

row_number 函数会在排序后生成一列序号记录,以行为标准,每一行生成一个数字序号

## 分组函数

### ntile(x)

```mysql
select ntile(x) over(order by) from
```

NTILE(X) 函数将数据分成X组，并给每组分配一个数字（1，2， 3....)

## window frames 自定义窗口

> 窗口框架（Window frames） 可以以当前行为基准，精确的自定义要选 取的数据范围

### rows(当前行)

```mysql
<window function> OVER (...
ORDER BY <order_column>
[ROWS|RANGE] 
)
```

**ROWS 方式，通用的语法如下：**

```mysql
ROWS BETWEEN lower_bound AND upper_bound
```

* BETWEEN ... AND ... 意思是在... 之间，上限 (upper_bund)和下限(lower_bound)的取值为如下5种情况：

  * UNBOUNDED PRECEDING – 对上限无限制
  * PRECEDING – 当前行之前的第 n 行 （ n ，填入具体数字如：5 PRECEDING ）
  * CURRENT ROW – 仅当前行
  * FOLLOWING –当前行之后的第 n 行 （ n ，填入具体数字如：5 FOLLOWING ）
  * UNBOUNDED FOLLOWING – 对下限无限制

* 需要注意的是：lower bound 需要在 upper bound之前，比 如： ...ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING 是错误的写法

* 如果在我们定义window frames 的边界时，使用了 CURRENT ROW 作为 上边界或者下边界，可以使用如下简略写法：

  * ROWS UNBOUNDED PRECEDING 等价于 BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  * ROWS n PRECEDING 等价于 BETWEEN n PRECEDING AND CURRENT ROW
  * ROWS CURRENT ROW 等价于 BETWEEN CURRENT ROW AND CURRENT ROW
  * 注意，这种简略的写法不适合 FOLLOWING 的情况

  

### range(多行)

RANGE （范围）考虑的是具体取值,与rows 方法使用相类似,是取一类值(范围)的总和.

**Range使用BETWEEN AND**

* 和使用 ROWS 一样，使用 RANGE 一样可以通过 BETWEEN ... AND... 来自定义窗口
* 在使用 RANGE 时，我们一般用
  * RANGE UNBOUNDED PRECEDING
  * RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  * RANGE CURRENT ROW
* 但是在使用 RANGE 确定窗口大小是，一般不与 n PRECEDING 或 n FOLLOWING 一起使用
  * 使用ROWS，通过当前行计算前n行/后n行，很容易确定窗口大小
  * 使用RANGE，是通过行值来进行判断，如果使用3 PRECEDING 或 3 FOLLOWING 需要对当前行的值进行-3 或者+3操作，具体能选中几行 很难确定，通过WINDOW FRAMES 我们希望定义的窗口大小是固定 的、可预期的，但当RANGE 和n PRECEDING 或 n FOLLOWING 具体会 选中几行数据，跟随每行取值不同而发生变化，窗口大小很可能不 固定

### 默认的window frames

* 没有写 range 或 rows 这样的语句，这种情 况下，会有一个默认的window frames 在工作，分两种情况：
  * 如果在OVER（...）中没有ORDER BY子句，则所有行视为一个window frames
  * 如果在OVER（...）中指定了ORDER BY子句，则会默认添加 RANGE UNBOUNDED PRECEDING 作为window frames



### case  when(自定义分组)

```mysql
SELECT
product_id,
product_name,
units_in_stock,
CASE
WHEN units_in_stock > 100 THEN 'high'
WHEN units_in_stock > 50 THEN 'moderate'
WHEN units_in_stock > 0 THEN 'low'
WHEN units_in_stock = 0 THEN 'none'
END AS availability
FROM products;
```



CASE WHEN中else    的使用

```mysql
SELECT
order_id,
customer_id,
ship_country,
CASE
WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN
0.0
ELSE 10.0
END AS shipping_cost
FROM orders
```

如果不满足其他条件，则执行 ELSE 。



CASE WHEN 和 COUNT

```mysql
SELECT
COUNT(CASE
WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN
order_id
END) AS free_shipping,
COUNT(CASE
WHEN ship_country != 'USA' AND ship_country != 'Canada'
THEN order_id
END) AS paid_shipping
FROM orders;
```





## 分析函数  

与聚类函数不同的地方是，分析函数只引用窗口中的单个行

### LEAD(X)函数

```mysql
LEAD(name) OVER(ORDER BY ...)
```

* 将以 ORDER BY 排序后的顺序，返回当前行的下一行所 对应的值，并在新列中显示
* 注意：最后一列没有下一列结果所以显示NULL
* LEAD() 中传入的列名与排序的列可以不同

**LEAD(x,y)**

* LEAD函数还可以传入两个参数：
  * 参数1 跟传入一个参数时的情况一样：一列的列名
  * 参数2 代表了偏移量，如果传入2 就说明要以当前行为基准，向前移 动两行作为返回值

**LEAD(x,y,z)**

* lead函数也可以接收三个参数，第三个参数用来传入默认值，应用场景 是当使用lead函数返回null的时候，可以用第三个参数传入的默认值进 行填充

###  LAG(x)函数

LAG(x)函数与LEAD(x)用法类似**,LAG返回当前行之前的值**

###  FIRST_VALUE(x)函数

**FISRT_VALUE函数，返回指定列的第一个值**

* 可以配合order by 取最大最小值

###  LAST_VALUE(x)函数

**LAST_VALUE(x)返回最后一个值**

* LAST_VALUE 与 window frame

* 当 OVER 子句中包含 ORDER BY 时，如果我们不显式定义window frame，SQL会自动带上默认的window frame语句：

  RANGE UNBOUNDED PRECEDING , 意味着我们的查询范围被限定在 第一行到当前行（ current row )

  如果想通过LAST_VALUE 与ORDER BY配合得到所有数据排序后的最 后一个值，需要吧window frame语句写成

  RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 或者 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

* FIRST_VALUE 使用默认的window frame就可以正常工作，但是 LAST_VALUE 想要得到预期的结果需要手动修改window frame

* 与 FISRT_VALUE 类似，我们在使用 LAST_VALUE 时，传入的字段与排 序的字段可以有区别

  

### NTH_VALUE(x,n)函数

**NTH_VALUE(x,n) 函数返回 x列，按指定顺序的第n个值**

**LAST_VALUE 和 NTH_VALUE 通常要求把window frame修改成 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING **



## with 公用表达式

* 公用表表达式 CTE（ common table expression）与子查询十分类似，

```mysql
WITH some_name AS (
-- your CTE
)
SELECT
...
FROM some_name


WITH some_name AS (
-- your CTE
),

some_name as(
    CTE
)
SELECT
...
FROM some_name




```

* 需要给CTE起一个名字（上面的例子中使用了 some_name )，具体的查 询语句写在括号中
* 在括号后面，就可以通过 SELECT 将CTE的结果当作一张表来使用
* 将CTE称为“内部查询”，其后的部分称为“外部查询”
* 需要先定义CTE，即在外部查询的 SELECT 之前定义CTE
* 创建临时表时不能用with as 用子查询



## 行列转换

```mysql
mysql
多行转多列  union all
多列转多行  case when
单列转多行 concat_ws(分割符,返回类型(可指定数据类型(列名 as 数据类型))) as 新列名

mysql没有 explode(爆炸函数)hive中有
mysql中实现:
SELECT    substring_index(substring_index(a.chain,'_',b.help_topic_id + 1    ),    '_' ,- 1    ) AS ID
FROM
    (select '1_11_1223_1242' as chain) a  
JOIN mysql.help_topic b ON b.help_topic_id <
(length(a.chain) - length( replace(a.chain, '_', '')  ) + 1)


```

<img src=".\图\image-20211223153610522.png" alt="image-20211223153610522" style="zoom:150%;" />



orcal
行转列：pivot
列转行：unpivot





## 视图

视图 view 是一个虚拟表,本质是根据sql语句获取 动态 的数据集,并为其命名,可以当做表来使用

视图中只放了视图的定义,并没有放数据 , 查询时数据库会从原表中取出数据, ==原表数据发生改变, 视图的数据也会发生改变==

###### 作用:

- 简化代码,可以把重复使用的查询封装成视图
- 安全 , 可以使用视图对不同用户显示不同的内容



###### 创建

```sql
create [or replace] [algorithm = {undefined | merge | temptable}]
view view_name [(column_list)]
as select_statement
[with [cascaded | local] check option]

参数说明:
or replace 如果视图存在则替换

algorithm 选择视图的算法: undefined 默认
merge 可以修改视图内容,修改的内容会同步到表中(默认)
temptable 临时视图,只可以查看内容,无法修改

view_name  视图名

column_list 指定视图中字段名称,默认是与表中相同

select_statement 一个完整的查询语句

[with [cascaded | local] check option] 设置更新视图时需要在该视图的权限范围内

```

###### 修改

```sql
alter view 视图名 as select语句
```

###### 更新

```sql
update 视图名 set 字段 = ' '  where 条件

insert into 视图名  values( )

更新视图的限制 以下情况不能更新:
聚合函数
distinct
group by
having
union union all
子查询
join等
```

###### 重命名

```sql
rename table 视图名 to 新视图名
```

###### 删除视图

```sql
drop view if exists 视图名
```



## 隐式类型转换

```sql
隐式转换的规则：

a. 两个参数至少有一个是 NULL 时，比较的结果也是 NULL，例外是使用 <=> 对两个 NULL 做比较时会返回 1，这两种情况都不需要做类型转换
b. 两个参数都是字符串，会按照字符串来比较，不做类型转换
c. 两个参数都是整数，按照整数来比较，不做类型转换
d. 十六进制的值和非数字做比较时，会被当做二进制串
e. 有一个参数是 TIMESTAMP 或 DATETIME，并且另外一个参数是常量，常量会被转换为 timestamp
f. 有一个参数是 decimal 类型，如果另外一个参数是 decimal 或者整数，会将整数转换为 decimal 后进行比较，如果另外一个参数是浮点数，则会把 decimal 转换为浮点数进行比较
g. 所有其他情况下，两个参数都会被转换为浮点数再进行比较
```





##  	运行脚本

```sql
source   path.sql
```



## 查看当前支持的存储引擎  

```sql
show engines;
```



## 映射表(跨服务器查询)

1.确认开启Federated引擎

  查询FEDERATED功能是否开启：

```sql
show engines;
```

2、如果状态为NO则需修改my.ini文件，增加一行federated配置：

在[mysqld]下面添加 federated,然后重启mysql

![img](F:\笔记\mysql\图\1317185-20190226163138519-1240194401.png)

3.建立映射表

  注意：

  \- 表名可以不同，但表结构要完全相同

```sql
ENGINE=InnoDB 要改成 ENGINE=FEDERATED
```

  \- 添加最下面一行：

```sql
CONNECTION='mysql://用户名(数据库用户名):密码(数据库密码)@ip:端口/数据库名/表名'
```

![image-20211227152524989](F:\笔记\mysql\图\image-20211227152524989-16405899264092.png)

###### 连接异常 authentication plugin 'caching_sha2_password' 

mysql 8.0 默认使用 caching_sha2_password 身份验证机制 —— 从原来的 mysql_native_password 更改为 caching_sha2_password。 
从 5.7 升级 8.0 版本的不会改变现有用户的身份验证方法，但新用户会默认使用新的 caching_sha2_password 。

客户端不支持新的加密方式。

修改用户的密码和加密方式。在命令行模式下进入mysql。

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
```





##  查表结构

```sql
SELECT
COLUMN_NAME 字段名称,
COLUMN_TYPE 数据类型,
IF(IS_NULLABLE='NO','是','否') AS '必填',
COLUMN_COMMENT 注释
FROM
INFORMATION_SCHEMA.COLUMNS
where
-- Finance为数据库名称，到时候只需要修改成你要导出表结构的数据库即可
table_schema ='Finance'
AND
-- user为表名，到时候换成你要导出的表的名称
-- 如果不写的话，默认会查询出所有表中的数据，这样可能就分不清到底哪些字段是哪张表中的了
table_name = 'user'
order by COLLATION_NAME 
-- 按照字段名排序 
```

## 查询数据库中所有表名

```sql
select table_name from information_schema.tables where table_schema='csdb' and table_type='base table';
```



## 自动生成插入时间 

```sql
`insert_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '自动插入数据入mysql时间'
```

CURRENT_TIMESTAMP 表示当插入数据的时候，该字段默认值为当前时间



**ON UPDATE CURRENT_TIMESTAMP**
表示每次更新这条数据的时候，该字段都会更新成当前时间





## 列名与关键字冲突

```
用"(`)"将有冲突的字段框起来，，键盘上1边上那个键。
```



## LOCATE()

①.LOCATE(字符串1,字符串2)

返回字符串1在字符串2中第一次出现的位置，只要字符串2中包含字符串1，那么返回值必然大于0。

 ②.LOCATE(字符串1,字符串2,pos)

返回字符串1在字符串2中第一次出现的位置，从位置pos开始算起；

如果返回0，表示从pos位置开始之后没有了

**常用于判断是否包含**



## 计算时间差

```sql
源数据时间戳 结果为秒级

select
  xl_timestamp,createtime
  ,unix_timestamp(createtime,'yyyyMMddHHmmss')
  ,(unix_timestamp(xl_timestamp,'yyyyMMddHHmmss')
  -unix_timestamp(SUBSTRING(createtime,0,14) ,'yyyyMMddHHmmss')) as ts
 from ti_txzl_signal
where
 day_id ='20220116' AND createtime between '202201160100' and '202201160300'
```

## 查看字符串中指定字符的位置

```
INSTR(str,substr)
MySQLl的内置函数INSTR(str,substr)，作用是获取子串第一次出现的位置，如果没有找到则返回0，也可以看作是返回substr字符串在str字段名中第一次出现的位置。
```

## COALESCE()到非[null]值即停止并返回

```
COALESCE(expression_1,expression_2, ...,expression_n)依次参考各参数表达式，遇到非[null]值即停止并返回该值。如果所有的表达式都是空值，最终将返回一个空值。
```

