1、 mysql8中三种去重方式(分别用sql实现)

distinct
group by（）
row number（） over（partition by 字段 order by 字段）

2、 mysql8中分组求topN（sql实现）

row number（） over（ order by）
rank（）   over（order by）
desc_rank（） over（order by）

3、oracle中行列转换(sql实现)

行转列：pivot
列转行：unpivot

4、linux中查看进程是否存活、端口是否被监听 (命令实现)

netstat -tunlp ｜ grep 端口号

5、linux中查看系统剩余内存、磁盘剩余空间、cpu负载(命令实现)

free -h
df -hl

6. MySQL使用DATE_FORMAT函数从一个日期值里提取各种时间单位

```mysql
SELECT  DATE_FORMAT(time,'%Y-%m-%d') FROM table
```


7. MySQL使用DATEADD和DAY函数计算出当前日期是当前月份的第几天。然后从当前日期里减去该计算结果，并加1，就得到了当前月份的第一天。为了得到当前月份的最后一天，则使用LASTDAY函数

###### 获取当前日期：

select date_format(now(),'%Y-%m-%d');

当前日期是本月第几天

select dayofmonth(now());

日期增加减   加日期date_add      减日期date_sub()

select date_add(now(), interval 1 day); - 加1天

select date_add(now(), interval 1 hour); -加1小时

select date_add(now(), interval 1 minute); - 加1分钟

select date_add(now(), interval 1 second); -加1秒

select date_add(now(), interval 1 microsecond);-加1毫秒

select date_add(now(), interval 1 week);-加1周

select date_add(now(), interval 1 month);-加1月

select date_add(now(), interval 1 quarter);-加1季

select date_add(now(), interval 1 year);-加1年



8. MySQL使用LAST_DAY函数找出2月的最后一天




9.你想把若干行数据重新组合成一行新数据，原始数据集的每一行变换后会作为新数据的一列出现。例如，下面的结果集展示了每个部门的员工人数。
DEPTNO        CNT
------ ----------
    10          3
    20          5
    30          6
你希望把上述结果集重新格式化成下面的输出结果。
DEPTNO_10  DEPTNO_20  DEPTNO_30
--------- ---------- ----------
        3          5          6




10.计算一年有多少天




11. 使用窗口函数完成结果集分页




12.求出每个部门员工薪资的排行前五（窗口函数完成）




13.根据不同维度进行分组聚合，生成各个城市、各个省份及全国汇总的店铺销量数据(不允许用union关键字)




14.以你的实际经验，说下怎样预防全表扫描




15.写sql：1月100,2月200,3月100,4月200.统计如下效果：1月100,2月300,3月400,4月600





16.sqoop 抽数的并行化主要涉及到两个参数：num-mappers：启动N个map来并行导入数据，默认4个；split-by：按照某一列来切分表的工作单元。
   (1)数据如何切分如何并行？





   (2) --query 语句后面必须要加一个 "and $CONDITIONS" 字符串，不加还报错。那$CONDITIONS 到底是干什么用的呢？






   (3) --split-by id 会不会产生数据倾斜问题？如何解决？






   (4)如Sqoop在导出到Mysql时，使用4个Map任务，过程中有2个任务失败，那此时MySQL中存储了另外两个Map任务导入的数据，此时老板正好看到了这个报表数据。而开发工程师发现任务失败后，会调试问题并最终将全部数据正确的导入MySQL，那后面老板再次看报表数据，发现本次看到的数据与之前的不一致,如何解决？






   (5)sqoop 如何处理 null 和 ""




17.如果ETL程序运行较慢，需要分哪几步去找到ETL系统的瓶颈问题。




18.数仓为什么要建模??数仓建模流程??




19.数仓为什么要分层？？




20.hive SQL实现占比、同比、环比计算




21.oozie依赖调度怎么实现？依赖调度过程中发生异常怎么办？




22.部门之间yarn资源的隔离怎么做？怎么配置？任务提交怎么指定？




23.hive中怎么统计每个分层的数据量、表个数？




24.pyspark-sql实现查询mysql中昨天的增加和修改数据

props = {'user': 'root', 'password': '123456', 'driver': 'com.mysql.jdbc.Driver'}
table_df = spark.read.jdbc(
    'jdbc:mysql://node1:3306/?serverTimezone=UTC&characterEncoding=utf8&useUnicode=true',
    'table_name',
    properties=props)
spark.sql("""
    select * from table_name where substring(create_time,1,10) = 'yesterday'
""")


25.pyspark-sql实现topn、累积和、连续访问

    props = {'user': 'root', 'password': '123456', 'driver': 'com.mysql.jdbc.Driver'}
    table_df = spark.read.jdbc(
        'jdbc:mysql://node1:3306/?serverTimezone=UTC&characterEncoding=utf8&useUnicode=true',
        'table_name',
        properties=props)
    spark.sql("""
        select * from table_name order by x desc limit n;
        select distinct userid,
                date_format(visitdate, '%Y-%m') as '月份',
                sum(visitcount)as '小计',
                sum(sum(visitcount)) over(partition by userid order by date_format(visitdate, '%Y-%m')) '累计'
from users group by userid, date_format(visitdate, '%Y-%m');
        select userid from(
            select userid,monthid,lead(monthid, 2) over (partition by userid) as a
            from user) tmp1 where monthid+2 = a;
    """)

26、现有如下数据文件需要处理
格式：CSV
位置：hdfs：//myhdfs/input.csv
大小：100GB
字段：用户ID，位置ID，开始时间，停留时长(分钟)
4行样例：
User A， Location A， 2018-01-01 08：00：00， 60
User A， Location A， 2018-01-01 09：00：00， 60
User A， Location B， 2018-01-01 10：00：00， 60
User A， Location A， 2018-01-01 11：00：00， 60
解读：
样例数据中的数据含义是：
用户User A，在Location A位置
从8点开始，停留了60分钟
用户User A，在Location A位置,  从9点开始，停留了60分钟
用户User A，在Location B位置，从10点开始，停留了60分钟
用户user A， 在Location A位置， 从11点开始，停留了60分钟
处理逻辑：
1·对同一个用户，在同一个位置，连续的多条记录进行合并
2·合并原则：开始时间取最早时间，停留时长加和
要求：请使用Spark Sql处理

spark_conf = SparkConf().setAppName("PySparkExample").setMaster("local[2]")
sc = SparkContext(conf=spark_conf)
inputrdd = sc.textFile("//myhdfs/input.csv")
inputrdd.map(lambda line: line.strip().split(', '))
        .map(lambda word: )


27、 使用spark sql实现如下逻辑
product_no      lac_id  moment  start_time      user_id county_id       staytime        city_id
13429100031     22554   8       2013-03-11 08:55:19.151754088   571     571     282     571
13429100082     22540   8       2013-03-11 08:58:20.152622488   571     571     270     571
13429100082     22691   8       2013-03-11 08:56:37.149593624   571     571     103     571
13429100087     22705   8       2013-03-11 08:56:51.139539816   571     571     220     571
13429100087     22540   8       2013-03-11 08:55:45.150276800   571     571     66      571
13429100082     22540   8       2013-03-11 08:55:38.140225200   571     571     133     571
13429100140     26642   9       2013-03-11 09:02:19.151754088   571     571     18      571
13429100082     22691   8       2013-03-11 08:57:32.151754088   571     571     287     571
13429100189     22558   8       2013-03-11 08:56:24.139539816   571     571     48      571
13429100349     22503   8       2013-03-11 08:54:30.152622440   571     571     211     571
字段解释：
product_no：用户手机号；
lac_id：用户所在基站；
start_time：用户在此基站的开始时间；
staytime：用户在此基站的逗留时间。

需求描述：
根据lac_id和start_time知道用户当时的位置，根据staytime知道用户各个基站的逗留时长。根据轨迹合并连续基站的staytime。
最终得到每一个用户按时间排序在每一个基站驻留时长

期望输出举例：
13429100082     22540   8       2013-03-11 08:58:20.152622488   571     571     270     571
13429100082     22691   8       2013-03-11 08:56:37.149593624   571     571     390     571
13429100082     22540   8       2013-03-11 08:55:38.140225200   571     571     133     571
13429100087     22705   8       2013-03-11 08:56:51.139539816   571     571     220     571
13429100087     22540   8       2013-03-11 08:55:45.150276800   571     571     66      571




28、使用spark sql实现如下逻辑
订单表：gdm_ord_det_sum， 其中user_pin：用户编号，sku_name：商品名称，
sale_q tty：销售数量(单位：件) ，sale_ord_dt：下单日期， sale_ord_id：订单号，
brand_name：品牌名称， sku_price：商品价格item_first_cate_name：商品一级分类名
称， item_second_cate_name：商品二级分类名称， item_third_cate_name：商品三级分
类名称
1，统计近30天每天有多少订单，有多少件商品卖出(提示：一单中可有多件商品)，共卖
出多少种三级品类
2，统计出2017年11月11日当天每个一级品类下销量排名前五的品牌
3，另已知
商品属性表gdm_item_sku_da， 其中sku_name：商品名称， pct：佣金百分比，
commission：佣金， com_control：佣金分配方式(1为百分比， 2为差额)，佣
金计算方式为当佣金分配方式=1时，佣金为商品价格*佣金百分比，当佣金分配方式=2
时，佣金为商品属性表中佣金
试统计：
商品名称，商品一级分类名称，商品二级分类名称，商品三级分类名称，佣金，商
品在2017-06-18有多少人购买，商品在2017-06-18共售出多少件




29、spark sql清洗时常用到哪些函数?

map
flatmap
filter
reduceByKey


30、RDD,DAG,Stage怎么理解?

RDD: RDD是一个抽象的弹性的分布式数据集一个阶段的输出结果会作为下一个阶      段的输入,它代表一个不可变的、可分区的内部元素可并行计算 的集合。
Spark 里的计算都是通过操作 RDD 完成的
DAG：有向无环图，描述了RDD的依赖关系，每个节点代表一个RDD
回溯算法：倒推 产生的， 触发算子产生job，通过回溯算法产生DAG
Stage：DAG构建过程中，将每个算子放入Stage中，每遇见一个宽依赖算子，构建一个新的stage，每个Stage转换为一个TaskSet：Task集合
每个RDD转换成的TaskSet中有几个Task，由stage中RDD的最大分区数来决定


31、宽依赖 窄依赖怎么理解?

宽依赖：多个子RDD的分区依赖同一个父RDD的Partition
窄依赖：每一个父RDD的Partition最多被子RDD的 一个Partition使用


32、Stage是基于什么原理分割task的?

stage 下的一个任务执行单元，一般来说，一个 rdd 有多少个 partition，就 会有多少个 task，因为每一个 task 只是处理一个partition 上的数据。


33、Spark为什么快?

Spark是基于内存计算的,Spark是以线程的方式运行


34、Transformation和action是什么?区别?举几个常用方法

Transformation: 转换算子, 
Action: 触发算子, 
区别: 转换算子产生的RDD是lazy模式,不会产生shuflle
     触发算子会产生shuflle
常用的算子: Transformation: map, flatmap,filter,groupByKey,repartition
          Action: foreach, reduceByKey, count, first,tail,saveAsTextFile


35、RDD怎么理解

RDD是一个抽象的弹性的分布式数据集一个阶段的输出结果会作为下一个阶      段的输入,它代表一个不可变的、可分区的内部元素可并行计算 的集合。


36、spark 作业提交流程是怎么样的，client和 cluster 有什么区别，各有什么作用

流程: 1. 将我们编写的程序,调用spark-submit脚本提交任务到集群上运行
      2. 初始化SparkContext对象
      3. 根据提交的作业模式启动Driver,并向Master请求资源启动     Executor
      4.Executor启动后反向注册到Driver中,等待Driver分配task
      5.任务执行完成，进程 kill。
区别:client是Driver运行在客户端本地,
    cluster是Driver运行在YARN或者Standalone集群上
作用: 


37、spark on yarn 作业执行流程，yarn-client 和 yarn cluster 有什么区别

流程:
区别:yarn-client:Driver运行在本地
    yarn cluster: Driver运行在Yarn集群上某的NodeManager节点上


38、spark sql 你使用过没有，在哪个项目里面使用的？




39、spark Rdd 是怎么容错的，基本原理是什么?




40、hive在换到sparksql时，有没有遇到内存的问题？




41、说一说spark中常用的算子有哪些,都有什么用？



42、HDFS上存储了一个大小10G不可分割压缩格式的文件(gzip格式)，当有一个mr任务去读取这个文件的时候会产生多少个map task？spark去读取这种不可分割格式的大文件时是怎么处理的呢？







