# Sqoop数据采集

## 命令:

### **从数据库中导入到Hive中  / import**

-- query 里面不能有分号

如果换行-- query 中的sql必须顶格

换行 \ 后面不能有空格

注意:windows(\r\n)和linux(\n)的换行符

```shell
sqoop import \
--connect jdbc:oracle:thin:@oracle.bigdata.cn:1521:helowin #指定JDBC的链接字符串  \必要
--username ciss # 数据库的用户名  \必要
--password 123456 #密码\必要
--password-file # 设置用于存放认证密码的文件路径
-P #从控制台读取输入的密码

--target-dir hdfs://path #指定导入HDFS的目标路径 \必要
-- query 指定查询条件
只要有--query+sql，就需要加\$CONDITIONS，哪怕只有一个maptask
\$CONDITIONS 放在where后面   and  \$CONDITIONS

--table <table_name>  #导入的源表表名
--where "'2021-01-01'=to_char(CREATE_TIME ,'yyyy-mm-dd')" <where clause>#指定导出时所使用的查询条件

--split-by <column-name> # 指定按照哪个列去分割数据 一般为主键
--columns <col,col,col…> #从表中导出指定的一组列的数据
--fields-terminated-by ' ' #指定数据的分隔符


--bindir <path> #存放sqoop产生的java代码对于的class文件及jar包
--outdir <path> #存放sqoop生产的java代码
-Dmapreduce.job.user.classpath.first=true #解决找不到Avro类库的问题。
--as-avrodatafile # 以avro文件格式读取导入
--as-parquetfile #以parquetfile文件格读取读导入
--as-sequencefile #以sequencefile读取导入
--as-textfile #以普通文本文件格式读取导入

--compression-codec <c> #指定Hadoop 的codec(编码)方式
-z,--compress # 启用压缩
--compression-codec <> #指定压缩的压缩码
-m,--num-mappers <num> #使用n个map任务并行导入数据
--split-by <column> #按字段分割map，结合参数m进行使用
--direct #直接导入模式(优化导入速度)
--direct-split-size <n> #分割输入stream的字节大小(在直接导入模式下)
--fetch-size <n> # 从数据库中批量读取记录数
--null-string <null-string> #指定列为字符串类型，使用指定字符串替换值为null的该类列的值
--null-non-string <null-string> #如果指定列为非字符串类型，使用指定字符串替换值为null的该类列的值

--verbose #打印详细的运行信息

--update-mode allowinsert  # 判断导入的表中与导入数据是否有一致的 allowinsert -- 如果有就更新同时插入新纪录。
--update-key id # 以哪个字段来判断

--delete-target-dir #删除导入目标目录（如果存在）
```

> 注意：前面还需要加上一个-Dmapreduce.job.user.classpath.first=true，否则运行sqoop的时候会抛出找不到Avro类库的问题。

```sh
附加 : 不常用
--driver <class-name> #指定要使用的JDBC驱动类
--connection-param-file <filename> #可选，指定存储数据库连接参数的属性文件
```

```
1.更新导出（updateonly模式）
– update-key，更新标识，即根据某个字段进行更新，例如id，可以指定多个更新标识的字段，多个字段之间用逗号分隔。

– updatemode，指定updateonly（默认模式），仅仅更新已存在的数据记录，不会插入新纪录。

2.更新导出（allowinsert模式）
– update-key，更新标识，即根据某个字段进行更新，例如id，可以指定多个更新标识的字段，多个字段之间用逗号分隔。

– updatemod，指定allowinsert，更新已存在的数据记录，同时插入新纪录。实质上是一个insert & update的操作
```



#### 示例:

2：将mysql表中数据导入到hdfs中 imports

```shell
bin/sqoop import \
--connect jdbc:mysql://172.16.71.27:3306/babasport \
--username root \
--password root \
--table test_tb
```

注意下 \ 的位置 少个空格都会报错

 数据默认以逗号隔开 可以根据需求进行指定

3:导入数据至指定hdfs目录

```shell
bin/sqoop import \
--connect jdbc:mysql://hadoop-senior.ibeifeng.com:3306/test \
--username root \
--password 123456 \
--table my_user \
--target-dir /user/beifeng/sqoop/imp_my_user \
--num-mappers 1
```

>  ps：  num-mappers 1   指定执行MapReduce的个数为1
>
> ​			target-dir 指定hdfs的目录
>
> ​	 		sqoop 底层的实现就是MapReduce,import来说，仅仅运行Map Task

  4:将数据按照parquet文件格式导出到hdfs指定目录

```shell
bin/sqoop import \
--connect jdbc:mysql://172.16.71.27:3306/babasport \
--username root \
--password root \
--table test_tb \
--target-dir /user/xuyou/sqoop/imp_my_user_parquet \
--fields-terminated-by '@' \
--num-mappers 1 \
--as-parquetfile  
```

> ps   fields-terminated-by '@'   数据已@隔开  
>
> 　as-parquetfile   数据按照parquet文件格式存储
>
> ​    columns id,name  这个属性 可以只导入id已经name 这两个列的值

5:\* 在实际的项目中，要处理的数据，需要进行初步清洗和过滤
\* 某些字段过滤
\* 条件
\* join

```shell
bin/sqoop import \
--connect jdbc:mysql://hadoop-senior.ibeifeng.com:3306/test \
--username root \
--password 123456 \
--query 'select id, account from my_user where $CONDITIONS' \
--target-dir /user/beifeng/sqoop/imp_my_user_query \
--num-mappers 1
```

> ps：  query 这个属性代替了 table 可以通过用sql 语句来导出数据
> （where $CONDITIONS' 是固定写法 如果需要条件查询可以 select id, account from my_user where $CONDITIONS' and id > 1）

6:压缩导入至hdfs的数据 可以指定格式

```shell
bin/sqoop import \
--connect jdbc:mysql://hadoop-senior.ibeifeng.com:3306/test \
--username root \
--password 123456 \
--table my_user \
--target-dir /user/beifeng/sqoop/imp_my_sannpy \
--delete-target-dir \
--num-mappers 1 \
--compress \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec \
--fields-terminated-by '\t'
```

> ps：compress 这个属性 是 开启压缩功能
>
>    compression-codec 这个属性是 指定压缩的压缩码 本次是SnappyCodec



##### Python脚本

```python
!/usr/bin/env python

  coding = "utf-8"
  author = "itcast"

  import os
  import subprocess 
  import datetime #获取实时时间
  import time
  import logging  #打印日志信息包

  biz_date = '20210101'
  biz_fmt_date = '2021-01-01'
  dw_parent_dir = '/data/dw/ods/one_make/full_imp'
  workhome = '/opt/sqoop/one_make'
  full_imp_tables = workhome + '/full_import_tables.txt'
  if os.path.exists(workhome + '/log'):
      os.system('make ' + workhome + '/log')

  orcl_srv = 'oracle.bigdata.cn'
  orcl_port = '1521'
  orcl_sid = 'helowin'
  orcl_user = 'ciss'
  orcl_pwd = '123456'

  sqoop_import_params = 'sqoop import -Dmapreduce.job.user.classpath.first=true --outdir %s/java_code --as-avrodatafile' % workhome
  sqoop_jdbc_params = '--connect jdbc:oracle:thin:@%s:%s:%s --username %s --password %s' % (orcl_srv, orcl_port, orcl_sid, orcl_user, orcl_pwd)

load hadoop/sqoop env

  subprocess.call("source /etc/profile", shell=True) #shell = True 用shell执行命令
  print('executing...')

read file

  fr = open(full_imp_tables)
  for line in fr.readlines():
      tblName = line.rstrip('\n')
      # parallel execution import
      sqoopImportCommand = '''
      %s %s --target-dir %s/%s/%s --table %s -m 1 &
      ''' % (sqoop_import_params, sqoop_jdbc_params, dw_parent_dir, tblName, biz_date, tblName.upper())
      # parallel execution import
      subprocess.call(sqoopImportCommand, shell=True)
      # cur_time=date "+%F %T"
      # cur_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
      logging.basicConfig(level=logging.INFO,  # 控制台打印的日志级别
                          filename='%s/log/%s_full_imp.log' % (workhome, biz_fmt_date),
                          # 模式，有w和a，w就是写模式，每次都会重新写日志，覆盖之前的日志; a是追加模式，默认如果不写的话，就是追加模式
                          filemode='a',
                          # 日志格式
                          format='%(asctime)s - %(pathname)s[line:%(lineno)d] - %(levelname)s: %(message)s')
      # logging.info(cur_time + ' : ' + sqoopImportCommand)
      logging.info(sqoopImportCommand)
      time.sleep(15)
```

###### 故障

如果出现故障，可以使用以下方式来kill所有任务

- 先用yarn application -list命令获取当前运行的所有命令

- 再用yarn application -kill命令杀掉所有的MapReduce任务



### 从Hive中导出到数据库 / export

```shell
sqoop export 
--export-dir /hive/warehouse/dc_test.db/t_class1  #hive中数据文件的位置
--connect jdbc:mysql://172.17.210.180/dc_scheduler_client #指定JDBC链接
--username <name> #账号
--password  <password> #密码
--columns '' 指定导出到表的列名
--update-key <column> # 数据更新时,依据的字段
--update-mode allowinsert #更新模式(updateonly：只更新 allowinsert：没有更新的情况，将数据插入)
--table <table_name> #目的端的表名
--input-fields-terminated-by '\0' # hive中的数据字段分隔符
-m <num> #指定导出时的 map 任务数
--bindir /root/tmp #存放sqoop产生的java代码对于的class文件及jar包
--outdir /root/tmp #存放sqoop生产的java代码
--input-null-string '\\N' #当输出的字段为字符串并且为空时，用指定的字符替换
--input-null-non-string '\\N' #当输出的字段不是字符串且为空时，用指定的字符替换
```

> 导出与导入有部分参数名相同

### 建立avro格式表

(1) hive引擎

```sql
create external table if not exists one_make_ods.ciss_service_workorder comment '派工单'partitioned by (dt string)row format serde 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'stored as avro location '/data/dw/ods/one_make/incr_imp/ciss4.ciss_service_workorder'TBLPROPERTIES ('avro.schema.url'='hdfs:///data/dw/ods/avsc/CISS4_CISS_SERVICE_WORKORDER.avsc');
```

(2) sparksql引擎

```sql
create external table if not exists one_make_ods.ciss_service_workorder comment '派工单'partitioned by (dt string)row format serde 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'stored as inputformat 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'location '/data/dw/ods/one_make/incr_imp/ciss4.ciss_service_workorder'TBLPROPERTIES ('avro.schema.url'='hdfs:///data/dw/ods/avsc/CISS4_CISS_SERVICE_WORKORDER.avsc');
```



### 导入分区数据到表中

数据文件直接导入hdfs中,数据库查询不到内容,需要导入数据

```sql
-- 修改表  table_name 添加 如果 不存在 分区 (分区的列表名 = 分区字段) 指定分区位置 'path'

alter table one_make_ods.ciss_service_workorder add if not exists partition (dt='20210101') location '/data/dw/ods/one_make/incr_imp/ciss4.ciss_service_workorder/20210101'
```





# Yarn的调度配置

### 查看最小调度单位

- 为了能够并行的执行多个任务，我们需要调整下`yarn-site.xml`的调度器配置

  `yarn.scheduler.capacity.maximum-am-resource-percent`，该参数的意义集群中可用于运行application master的资源比例上限，这通常用于限制并发运行的应用程序数目。默认是0.1，简单来理解就是AM能够使用的资源最大不能超过YARN管理的资源的10%，我们当前的内存是8G，0.1相当于能使用的也就是不到1G，而YARN配置的**最小调度单元是1G**。

- 为了提高JOB的并发量，把AM的占比调整为0.8。

```shell
docker exec -it hadoop bash
# 进入hadoop容器后编辑yarn配置文件
source /etc/profile
vim ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
```

```xml
<property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>512</value>
</property>
<property>
        <name>yarn.nodemanager.pmem-check-enabled</name>
        <value>false</value>
</property>
<property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
</property>
<property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>16384</value>
</property>
```

```xml
<!-- vim ${HADOOP_HOME}/etc/hadoop/capacity-scheduler.xml -->
<property>
    <name>yarn.scheduler.capacity.maximum-am-resource-percent</name>
    <value>0.8</value>
</property>
```



- 修改完配置后重启yarn

```
stop-yarn.sh
start-yarn.sh
```

- 在Yarn的web界面查看配置

### 开启MapReduce的uber模式

- 在Sqoop运行作业时，我们可以注意到每一个Job会打印当前是否运行在uber模式。

- 当前，我们需要导入的有100多张，执行每个sqoop命令都需要启动一个MapReduce程序，重新向ResourceManager申请资源，然后启动Application Master，AM再申请资源启动Container运行MapTask和ReduceTask。而每次创建Container其实就是启动一个JVM虚拟机。

- 针对这些小作业，如果我们直接每个任务都只运行在一个AM Container中，这样比起AM向RM申请资源，然后NM再启动、关闭资源要高效很多。当然这就要求，作业要足够的“小”。

- 基于上述场景，我们可以使用Uber模式（超级任务）来优化这些小作业。这种方式，会在一个JVM中顺序执行这些小作业。我们可以通过参数来配置最大的MapTask数量（默认9个）、最大的Reduce数量（默认1个）、以及最大的数据量大小（默认大小是一个Block的大小）。

注意，但我们配置Uber模式的时候，需要按照以下规则：

- 1. `yarn.app.mapreduce.am.resource.mb`必须大于`mapreduce.map.memory.mb`和`mapreduce.reduce.memory.mb`
  2. `yarn.app .mapreduce.am.resource.cpu-vcores`必须大于`mapreduce.map.cpu.vcores`和`mapreduce.map.cpu.vcores`

- MapTask和ReduceTask的配置如下：

```xml
<property>
  <name>mapreduce.map.memory.mb</name>
  <value>1024</value>
  <source>mapred-default.xml</source>
</property>
<property>
  <name>mapreduce.reduce.memory.mb</name>
  <value>1024</value>
  <source>mapred-default.xml</source>
</property>
<property>
  <name>mapreduce.map.cpu.vcores</name>
  <value>1</value>
  <source>mapred-default.xml</source>
</property>
<property>
  <name>mapreduce.reduce.cpu.vcores</name>
  <value>1</value>
  <source>mapred-default.xml</source>
</property>
```

- 说明，当前的配置是可以支持Uber模式的。所以，接下来，我们来配置Uber模式。我们只需要把mapred-site.xml中加入以下配置即可。

```xml
<property>
  <name>mapreduce.job.ubertask.enable</name>
  <value>true</value>
</property>
```

重启yarn，使uber模式生效

