sqoop抽取数据mysql_hdfs_mysql

-- 导入hdfs import
-- 必要参数
sqoop import \
--connect 'jdbc:mysql://10.10.0.50:3306/ai_manager?useUnicode=true&characterEncoding=utf-8' \ #jdbc连接数据库
--username hadoop \ #账号
--password passwd \ #密码
--target-dir /hadoop_path \ #hadoop存储路径
--query "select id
        from table_name
        where 1=1 and \$CONDITIONS " \ #执行sql,查询出需要导入的数据,where后面不管有无条件都需要加and \$CONDITIONS "
--num-mappers 1 \ #指定map个数 无特殊要求1个就可以

-- 特殊参数
--delete-target-dir \ #每次导入前删除目录下的历史文件(增量导入)




-- 导出到mysql export
sqoop export \
--export-dir /user/hive/tmp/t_historical_earnings_data \ #hadoop存储路径
--connect 'jdbc:mysql://10.10.0.138:3306/tyyreport?useUnicode=true&characterEncoding=utf-8' \ #jdbc连接数据库
--username hadoop \ #账号
--password Rfx,1118Ys \ #密码
--table table_name \ #导出到mysql的表名
--update-mode allowinsert #更新模式(updateonly：只更新 allowinsert：没有更新的情况，将数据插入)更新消耗时间较长数据量大时会报超时错误
--update-key <column> # 数据更新时,依据的字段
--columns 'id, <column>' #数据导入的字段
