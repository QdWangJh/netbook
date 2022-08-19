shell 获取mysql中的值赋值变量

```shell
select_sql="select max(UPDATE_TIME) from TB_XBT_ORIGINA_LOG_UP;"

db_data=`mysql -h 10.10.0.138 -P3306 -uhadoop -pRfx,1118Ys  xbtserial -Bse "${select_sql}"`

echo $db_data
```

导出数据
　　1、导出整个数据库

　　mysqldump -u 用户名 -p数据库名 > 导出的文件名

　　mysqldump -u breezelark-p mydb > mydb.sql

　　2、导出一个表(包括数据结构及数据)

　　mysqldump -u 用户名 -p数据库名 表名> 导出的文件名

　　mysqldump -u lingxi -p mydb mytb> mytb.sql

　　3、导出一个数据库结构(无数据只有结构)

　　mysqldump -u lingxi -p -d --add-drop-table mydb >mydb.sql

　　-d 没有数据–add-drop-table 在每个create语句之前增加一个drop table
　　4 把查询结果写入文件
　　select * from tableA  INTO OUTFILE '/path/file.txt'

执行脚本导入数据

source file.sql