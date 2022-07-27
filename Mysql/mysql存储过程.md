### 设置分隔符

```mysql
DELIMITER //  //--将//声明为当前的分割符
```

### 增删改存储过程

```mysql
--增
CREATE PROCEDURE 过程名 ([in/out/inout]参数 type  [default] ) 

--删
DROP  PROCEDURE IF EXISTS 过程名
这个语句被用来移除一个存储程序。不能在一个存储过程中删除另一个存储过程，只能调用另一个存储过程

--改
ALTER PROCEDURE 存储过程名 SQL语句代码块(过程体)
```

### 传参

```sql
--传参
in -传入参数: 接收参数的值
out -传出参数: 从存过内部传值给调用者(创建一个变量接收 例 : @name)
inout - 从外部接收一个参数,经过修改后传出
例  set @name = 'ceshi'
	call procedure_name(@name,@name)
    
 
```



### 查看存储过程

```mysql
--查看一个已存在的存储过程
SHOW CREATE PROCEDURE 存储过程名
--列出所有的存储过程
SHOW  PROCEDURE  STATUS
```

### 存储过程的调用

```mysql
CALL 存储过程名(参数列表)
```

### 执行

```sql
BEGIN ... END   --这是存储过程过程体的固定语法，你需要执行的SQL功能就写在这中间。
```



### 变量

```mysql
局部变量
DECLARE  变量名  类型 ;
DECLARE var_name[,...] type [DEFAULT value];

用户变量
用户自定义,当前会话(链接)有效 , 可以在存过之外访问
@var_name
set @var_name = 
```

- DECLARE仅被用在BEGIN ... END复合语句里，并且必须在复合语句的开头，在任何其它语句之前。
- 值可以被指定为一个表达式，不需要为一个常数。
- 如果没有DEFAULT子句，初始值为NULL。
- 局部变量的作用范围在它被声明的BEGIN ... END块内。

### 设置变量

```mysql
SET 语句

SET var_name = name
被参考变量可能是子程序内声明的变量，或者是全局服务器变量。
这允许SET a=x, b=y, ...这样的扩展语法。
其中不同的变量类型（局域声明变量及全局和集体变量）可以被混合起来。
这也允许把局部变量和一些只对系统变量有意义的选项合并起来。

SELECT ... INTO语句 把选定的列直接存储到变量中

SELECT col_name[,...] INTO var_name[,...] FROM
table_name where 
返回的结果只能是单行单列
变量名不能和列名一样。
```

### 系统变量

```sql
系统变量-全局变量
由系统提供,在整个数据库中有效

@@global.var_name

查看全局变量
show @@global variables;

查看某个全局变量
show @@global.auto_increment(全局变量名字)

修改全局变量的值
set global sort_buffer_size = 40000;
set @@global.sort_buffer_size = 40000;

系统变量-会话变量
在当前会话中有效
查看会话变量
show @@session variables;

查看某个全局变量
show @@session.auto_increment(会话变量名字)

修改全局变量的值
set session sort_buffer_size = 40000;
set @@session.sort_buffer_size = 40000;
```



### 游标

游标是用来存储查询结果 集 的数据类型,在存储过程和函数中可以使用光标对结果集进行循环的处理.

光标的使用包括光标的声明,OPEN,FETCH和CLOSE

```mysql
格式:
-- 声明
declare cursor_name cursor for select_sql
-- 打开
open cursor_name
-- 取值
fetch cursor_name into var_name [, var_name] ..
-- 关闭
close cursor_name
```

注：存储过程临时字段定义需要在游标定义之前。

示例:

```mysql
delimiter ;;
drop procedure if exists `proc_test` ;;
CREATE PROCEDURE `proc_test`()
BEGIN
    -- 定义变量
    DECLARE done INT DEFAULT FALSE;    DECLARE field_1 VARCHAR(20);
    DECLARE field_2 VARCHAR(20);-- 创建游标，并存储数据
    DECLARE cur_list CURSOR FOR SELECT id, name FROM user;
    -- 游标中的内容执行完后将done设置为true
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    -- 打开游标
    OPEN cur_list;
    -- 执行循环
    read_loop : LOOP
        -- 取游标中的值
        FETCH cur_list INTO field_1, field_2;
        -- 判断是否结束循环，一定要放到FETCH之后，因为在fetch不到的时候才会设置done为true
        -- 如果放到fetch之前，先判断done，这个时候done的值还是之前的循环的值，因此就会导致循环一次
        IF done THEN
            LEAVE read_loop;
        END IF;
        --  执行SQL操作
        SET @sql_insert = CONCAT("insert into user_bak(id, name) VALUES ('", field_1, "','", field_2 ,"')");
        PREPARE sqlli FROM @sql_insert;
            EXECUTE  sqlli;
        COMMIT;
    END LOOP read_loop;
    -- 释放游标
    CLOSE cur_list;
END
;;
delimiter;
```

### 流程控制-循环

```mysql
分类:
while
[标签:]while 条件  do
	循环体
end while[标签]
-- 标签可以指定结束哪个 while 循环 可以省略 ,可以自己随意定义

repeat
[标签:] repeat 
	循环体;
until 条件表达式  (先循环,到达条件后跳出)
end repeat[标签];

loop
[标签:]loop
	循环体;
	if 条件表达式 then
		leave [标签];
	end if;
end loop [标签];
-- 先循环,到达条件后跳出  
-- 不加 if 会死循环

控制(跳出)
leave (break) 结束当前所在的循环
leave [标签]
iterate (continue) 结束本次循环继续xiayic
iterate [标签]
```

### 流程控制-判断 

```mysql
if 判断	
	if  ...   then   ...
	elseif ... then ..,
	else ...
	end if
	
case 判断
格式一
case case_value
	when 条件1 then...
	when 条件2 then...
	else ...
end case

格式二
case 
	when  变量=条件1 then...
	when  变量=条件2 then...
	else ...
end case
```



### REPEAT...END REPEAT

执行操作后检查结果

```mysql
	 DECLARE v INT;
      SET v=0;
      REPEAT
        INSERT INTO t VALUES(v);
        SET v=v+1;
        UNTIL v>=5
        END REPEAT;
```

### select语句拼接

```sql
set @day_1 = DATE_FORMAT(DATE_SUB(date_day,INTERVAL 1 DAY),'%Y%m%d');
set @day_2 = DATE_FORMAT(DATE_SUB(date_day,INTERVAL 2 DAY),'%Y%m%d');
set @day_1_2 = right(@day_1,2);
set @day_2_2 = right(@day_2,2);
set @sql = CONCAT('
		SELECT
		''话路控制'' as ''名称'',    -- 名称
		ma as ''',@day_2_2,'日峰值'',   -- 前 2 天的峰值
		mb as ''',@day_1_2,'日峰值'',   -- 前 1 天的峰值
		FORMAT(round(mb/ma,2),2)as ''增幅'', -- 峰值的增幅
		fa as ''',@day_2_2,'日合计（万）'',    -- 前 2 天的总量
		fb as ''',@day_1_2,'日合计（万）'',  -- 前 1 天的总量
		FORMAT(round(fb/fa,2),2) as ''增幅''   -- 总量的增幅
	from
	(SELECT
		MAX(call_control+0) as ma ,
		round(SUM(call_control+0)/10000,2) as fa
	from ti_kafka_monitor
	where day_id=',@day_2,')a  -- 前 2 天的数据
	JOIN
	(SELECT
		MAX(call_control+0) as mb,
		round(SUM(call_control+0)/10000,2) as fb
	from ti_kafka_monitor
	where day_id= ',@day_1,' )b -- 前 1 天的数据
                  ')
    PREPARE stmt FROM @sql;  -- 预编译拼接完成的sql
    EXECUTE stmt; -- 开始
```





### START TRANSACTION

```mysql
START TRANSACTION; -- 整个存储过程指定为一个事务
commit; -- 语句1。必须主动提交	

使整个存储过程成为一个原子操作：在存储过程主体开始部分，指定开始一个事务。语句 2 失败，语句 1 不会被 commit(提交)到数据库中，存储过程将会在调用时抛出一个异常。
```

### 异常处理-HANDLER

```mysql
-- 定义句柄
DECLARE handler_action HANDLER
-- 条件值(遇到何种异常触发)
	FOR condition_value [,condition_value]...
-- 触发后执行的操作(自己设置)
	statement

-- 遇到异常的处理方式
handler_action:{
-- 跳出本次异常继续下一次
-- 结束程序
	CONTINUE | EXIT 
}
-- 异常触发条件
condition_value:{
-- 异常编码
	mysql_error_code
-- 异常名称
	| condition_name
-- 异常的状态
	| sqlwarning
	| not found
	| sqlexception
}

例:
declare continue handler
for 1329 
set flage = 0 
```

### 预编译

```sql
暂时理解: 需要将sql语句进行预编译
prepare create_table from @select_create_table(设置好的sql语句变量/不能使用局部变量)

-- 开始进行预编译
execute create_table;

-- 关闭预编译
DEALLOCATE prepare creat_table;
```



### 触发器

mysql 中只有 insert ,delete , update才能触发 触发器,多用于做日志 (少用)

不能对本表进行触发操作

```sql
只有一个执行语句
create trigger 触发器名 before | after 触发事件(create | delete | update)	on 表名 for each row 
执行语句;

创建多个执行语句
delimiter //
create trigger 触发器名 before | after 触发事件	on 表名 for each row 
begin
	执行语句列表;
end//

```

###### NEW 和 OLD

NEW 和 OLD 可以记录操作的具体信息(修改前/后的字段内容)

![image-20220104003300575](F:\笔记\mysql\图\image-20220104003300575-16412275836121.png)

使用方法:

```sql
在执行语句中直接使用 NEW.字段名 / OLD.字段名
```

###### 查看触发器

```sql
show triggers;
```

###### 删除

```sql
drop trigger if exists 触发器名
```



### 事件

```mysql
-- 定时任务job(从这天起，每一天执行一次)

CREATE EVENT 存储过程名

ON SCHEDULE EVERY 1 DAY STARTS '2017-05-11 01:00:00' ON COMPLETION PRESERVE ENABLE

DO

call 存储过程名;

```



### MySQL存储过程的基本函数

#### 字符串类

```mysql
CHARSET(str) //返回字串字符集
CONCAT (string2 [,... ]) //连接字串
INSTR (string ,substring ) //返回substring首次在string中出现的位置,不存在返回0
LCASE (string2 ) //转换成小写
LEFT (string2 ,length ) //从string2中的左边起取length个字符
LENGTH (string ) //string长度
LOAD_FILE (file_name ) //从文件读取内容
LOCATE (substring , string [,start_position ] ) 同INSTR,但可指定开始位置
LPAD (string2 ,length ,pad ) //重复用pad加在string开头,直到字串长度为length
LTRIM (string2 ) //去除前端空格
REPEAT (string2 ,count ) //重复count次
REPLACE (str ,search_str ,replace_str ) //在str中用replace_str替换search_str
RPAD (string2 ,length ,pad) //在str后用pad补充,直到长度为length
RTRIM (string2 ) //去除后端空格
STRCMP (string1 ,string2 ) //逐字符比较两字串大小,
SUBSTRING (str , position [,length ]) //从str的position开始,取length个字符,
注：mysql中处理字符串时，默认第一个字符下标为1，即参数position必须大于等于1
TRIM([[BOTH|LEADING|TRAILING] [padding] FROM]string2) //去除指定位置的指定字符
UCASE (string2 ) //转换成大写
RIGHT(string2,length) //取string2最后length个字符
SPACE(count) //生成count个空格
```

#### **数学类**

```mysql
CEILING (number2 ) //向上取整
FLOOR (number2 ) //向下取整
CONV(number2,from_base,to_base) //进制转换
HEX (DecimalNumber ) //转十六进制
BIN (decimal_number ) //十进制转二进制
HEX (DecimalNumber ) //转十六进制
注：HEX()中可传入字符串，则返回其ASC-11码，如HEX('DEF')返回4142143
也可以传入十进制整数，返回其十六进制编码，如HEX(25)返回19
ABS (number2 ) //绝对值
LEAST (number , number2 [,..]) //求最小值
MOD (numerator ,denominator ) //求余
SQRT(number2) //开平方
POWER (number ,power ) //求指数
RAND([seed]) //随机数
FORMAT (number,decimal_places ) //保留小数位数
ROUND (number [,decimals ]) //四舍五入,decimals为小数位数] 注：返回类型并非均为整数
SIGN (number2 ) // 正数返回1，负数返回-1

```

#### 日期时间类

```mysql
ADDTIME (date2 ,time_interval ) //将time_interval加到date2
CONVERT_TZ (datetime2 ,fromTZ ,toTZ ) //转换时区
CURRENT_DATE ( ) //当前日期
CURRENT_TIME ( ) //当前时间
CURRENT_TIMESTAMP ( ) //当前时间戳
DATE (datetime ) //返回datetime的日期部分
DATE_FORMAT (datetime ,FormatCodes ) //使用formatcodes格式显示datetime '%Y%m%d'
EXTRACT (interval_name FROM date ) //从date中提取日期的指定部分
DATE_ADD (date2 , INTERVAL d_value d_type ) //在date2中加上日期或时间
DATE_SUB (date2 , INTERVAL d_value d_type ) //在date2上减去一个时间
TIMEDIFF (datetime1 ,datetime2 ) //两个时间差
DATEDIFF (date1 ,date2 ) //两个日期差
HOUR(datetime) //小时
DAY (date ) //返回日期的天
MONTHNAME (date ) //英文月份名
DAYNAME (date ) //英文星期
DAYOFWEEK (date ) //星期(1-7) ,1为星期天
DAYOFYEAR (date ) //一年中的第几天
MAKEDATE (year ,day ) //给出年及年中的第几天,生成日期串
WEEK (date_time [,start_of_week ]) //第几周
YEAR (datetime ) //年份
DAYOFMONTH(datetime) //月的第几天
LAST_DAY(date) //date的月的最后日期
MICROSECOND(datetime) //微秒
MONTH(datetime) //月
last_day(curdate()) + INTERVAL 1 DAY - INTERVAL 1 SECOND // 当前月最后一秒
last_day(curdate()) - INTERVAL 2 month  + interval 86400 second // 上个月第一天0秒
MAKETIME (hour ,minute ,second ) //生成时间串
NOW ( ) //当前时间
SEC_TO_TIME (seconds ) //秒数转成时间
TIME_TO_SEC (time ) //时间转秒数
STR_TO_DATE (string ,format ) //字串转成时间,以format格式显示
MINUTE(datetime) //分返回符号,正负或0

```

