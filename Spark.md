### Spark

#### 简介:

Spark是一个**大规模数据处理**的统一分析引擎

ＲＤＤ：弹性分布式数据集

#### 特点：

- 速度快
- 易用性强: 有API 简单
- 通用性好:支持的编程语言(R\Sql\Python\Java\Scala)很多,可以实现的功能多(SQL计算\流计算\机器学习计算\图计算)
- 支持多种运行方式(YARN\Mesos\K8S\云环境\HBase)

#### 为什么Spark框架快?

1. 数据结构

Spark框架将要处理的数据封装到集合RDD中，调用RDD中的函数处理数据，RDD数据可以放到内存中,内存不足可以放到硬盘中

2. **以线程(Thread)方式运行Task任务**

MapReduce中的Task是以进行Process方式运行,Spark的Task以线程Thread运行,线程运行在进程中,启动和销毁比较快.

#### 运行模式

1. **本地运行(单机)**:一般用来做开发和测试

2. **集群模式**:用于生产环境,正式使用

3. **云平台模式**(共有云平台\KuberNetes容器调度):运行生产环境

工作中的开发模式:

在本地模式中进行代码开发,在集群模式中进行功能上线.

#### Spark 架构角色



- Master 管理角色 整个集群的管理者
- Worker 工作角色 提供Execute的管理者
- Driver 角色:单个任务的管理
- Executor 单个任务的执行者

![image-20210831212802973](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210831212802973.png)



一个Master下有多个Worker管理工作,一个Worker中有一个Driver管理多个Executor工作,Executor的结果会汇聚到Driver输出.

##### 名词解释

（1）Application：指的是用户编写的Spark应用程序，包含了含有一个Driver功能的代码和分布在集群中多个节点上运行的Executor代码。
（2）Driver:运行Application的main函数并创建SparkContext，SparkContext的目的是为了准备Spark应用程序的运行环境。SparkContext负责资源的申请、任务分配和监控等。当Executor运行结束后，Driver负责关闭SparkContext；
（3）Job：一个Application可以产生多个Job，其中Job由Spark Action触发产生。每个Job包含多个Task组成的并行计算。
（4）Stage：每个Job会拆分为多个Task，作为一个TaskSet,称为Stage；Stage的划分和调度是由DAGScheduler负责的。Stage分为Result Stage和Shuffle Map Stage；
（5）Task：Application的运行基本单位，Executor上的工作单元。其调度和 管理由TaskScheduler负责。
（6）RDD：Spark基本计算单元，是Spark最核心的东西。表示已被分区、被序列化、不可变的、有容错机制的、能被并行操作的数据集合。
（7） DAGScheduler:根据Job构建基于Stage的DAG，划分Stage依据是RDD之间的依赖关系。
（8）TaskScheduler：将TaskSet提交给Worker运行，每个Worker运行了什么Task于此处分配。同时还负责监控、汇报任务运行情况等。

#### 运行环境

| 对比       | Local                       | StandAlone                  | StandAlone HA      | YARN Client                                     | YARN Cluster         |
| ---------- | --------------------------- | --------------------------- | ------------------ | ----------------------------------------------- | -------------------- |
| Master角色 | Local进程本身               | Master独立进程              | Master独立进程     | ResourceManager                                 | ResourceManager      |
| Worker角色 | Local进程本身               | Worker独立进程              | Worker独立进程     | NodeManager                                     | NodeManager          |
| Driver     | 运行在Local进程内           | 运行在Master中              | 运行在Master中     | 运行在提交任务的客户端中(pyspark, spark-submit) | 运行在容器内         |
| Executor   | 无                          | 运行在Worker中              | 运行在Worker中     | 运行在容器内                                    | 运行在容器内         |
| 适用场景   | 开发/测试(不要用于生产环境) | 开发/测试(不要用于生产环境) | 开发/测试/生产均可 | 开发/测试/`生产`均可                            | 开发/测试/`生产`均可 |

> StandAlone HA 和 YARN模式均可以用在生产环境, 但是极少有企业在生产环境中使用StandAlone HA集群
>
> 大多数使用YARN模式的集群. 因为资源利用率好, 方便

##### YARN环境

**基本原理和架构**
将Spark运行在YARN之上, 本质上就是:
让一个程序的Driver和Executor都运行在YARN的容器内.
根据Driver位置的不同, YARN模式下分为Cluster和Client两种模式

**Spark On YARN集群模式 (Cluster模式)**

![image-20210831222643353](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210831222643353.png)

其中职责分配:
- 资源管理 YARN负责(ResourceManger)
- 任务管理 各程序自己的Driver
- 任务执行 各程序所属的Executor
其中Driver和Executor都运行在容器内, Driver还和程序的ApplicationMaster运行在同一个容器内.

**Spark On YARN客户端模式 (Client模式)**

![image-20210831222832036](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210831222832036.png)

可以看到, 和集群模式的唯一不同点在于:
Driver运行在客户端内存中, 而不是和ApplicationMaster在同一个容器内了.

##### 提交YARN运行

```shell
# 提交YARN运行
SPARK_HOME=/export/server/spark
/bin/spark-submit \
--name NAME # 指定程序运行的名称
--jars JARS #指定第三方java包的位置
--master yarn \ # --必须  | local[*]  -- 本地运行
--deploy-mode client \ #部署模式 client 或者cluster 默认是client
--driver-memory MEM \ #Driver的可用内存(Default:1024M)
--supervise # 当Driver运行异常失败时,可以自己重启
--executor-memory MEM #Executor的内存 (Default:1G).
--total-executor-cores NUM #整个任务可以给Executor多少个CPU核心用
--executor-cores NUM #单个Executor能使用多少CPU核心
--num-executors NUM #Executor应该开启几个
--queue QUEUE_NAME #指定运行的YARN队列(Default:"default").
/examples/src/main/python/pi.py \ #运行的文件位置 --必须
```

要注意, 如果要提交到集群运行, 那么代码中不要指定master
而是通过spark-submit程序的--master选项来决定master是谁.

##### Pycharm 提交运行

```python
# 导入Pyspark
from pyspark import SparkConf,SparkContext
# 构建Spark 的执行环境入口对象  | Driver
conf = Sparkconf().setAppName("name").setMaster("local[*]")
sc = SparkContext(conf = conf) # sc 就是SparkContext对象, 作为执行环境入口
# 读取文件  | Executor
file = sc.textFile("file/path")
# 对数据进行处理,最后输出 .collect()  | Driver
```

**注意事项**

- **Spark On Yarn的本质?**
  将Spark任务的pyspark文件，经过Py4J转换，提交到Yarn的JVM中去运行
-  **Spark On Yarn需要啥?**
  1.需要Yarn集群:已经安装了
  2.需要提交工具:spark-submit命令--在spark/bin目录
  3.需要被提交的PySpark代码:Spark任务的文件，如spark/examples/src/main/python/pi.py中有示例程序,或我们后续自己开发的Spark任务)
  4.需要其他依赖jar:Yarn的JVM运行PySpark的代码经过Py4J转化为字节码，需要Spark的jar包支持!Spark安装目录中有jar包,在spark/jars/中

###### 结论

- 在Spark中Driver是单机的
- 但是Executor不一定,Executor可能有多个,如果有多个,干活的那一部分代码就有多个Executor协同执行



#### 缓存/持久化

缓存就是将RDD的数据 ` 临时`保存下来

由于RDD的数据都是` 过程`数据,使用结束后就被清理,我们可以将需要多次使用的RDD标记为`缓存`,当第二次使用时就可以直接使用,无需再次计算.

##### 优缺点

**优点** :

- 缓存可以让某个RDD的数据不会被Ｓｐａｒｋ清理

  掉，可以重复使用，避免重复计算

**缺点：**

- 缓存是不可靠的，可能会丢失，如果丢失还是需要重新计算．
- 缓存对于内存的占用，有一定的消耗

##### 缓存设置

```python
from pyspark.storagelevel import StorageLevel
rdd.cache() # 将RDD的数据, 缓存到内存中.
rdd.persist(StorageLevel.MEMORY_ONLY) # 缓存到内存中
rdd.persist(StorageLevel.MEMORY_ONLY_2)# 缓存到内存中, 2
个副本
rdd.persist(StorageLevel.MEMORY_AND_DISK) # 缓存到内存
+硬盘, 先内存, 内存不足放硬盘
rdd.persist(StorageLevel.MEMORY_AND_DISK_2) # 缓存到
内存+硬盘, 先内存, 内存不足放硬盘, 2个副本
rdd.persist(StorageLevel.OFF_HEAP) # 放到系统内存中
rdd.persist(StorageLevel.DISK_ONLY) # 仅放到硬盘中缓存
rdd.persist(StorageLevel.DISK_ONLY_2) # 仅放到硬盘中缓
存, 2个副本
```

**清理缓存**

```python
rdd.unpersist() # 清理这个RDD的缓存
```

cache只有一个默认的缓存级别MEMORY_ONLY ，而persist可以根据情况设置其它的缓存级别。

缓存函数与Transformation函数一样，都是Lazy操作，需要Action函数触发，通常使用count函数触发。

##### RDD存储级别选择

 `Spark 的存储级别的选择，核心问题是在 memory 内存使用率和 CPU 效率之间进行权衡。建议按下面的过程进行存储级别的选择`

`RDD 适合于**默认存储级别**（MEMORY_ONLY），leave them that way。这是 CPU 效率最高的选项，允许 RDD 上的操作尽可能快地运行.`

如果不是，试着使用 MEMORY_ONLY_SER 和 selecting a fast serialization library 以使对象更加节省空间，但仍然能够快速访问。

`不要溢出到磁盘，除非计算您的数据集的函数是昂贵的，或者它们过滤大量的数据。否则，重新计算分区可能与从磁盘读取分区一样快.`

如果需要**快速故障恢复**，请使用复制的存储级别（例如，如果使用 Spark 来服务 来自网络应用程序的请求）。All 存储级别通过重新计算丢失的数据来提供完整的容错能力，但复制的数据可让您继续在 RDD 上运行任务，而无需等待重新计算一个丢失的分区.

##### 何时缓存数据

- l 当**某个RDD被使用多次**的时候，建议缓存此RDD数据
- l 当**某个RDD来之不易，并且使用不止一次**，建议缓存此RDD数据

#### RDD Checkpoint 更加可靠的数据持久化

RDD 数据可以持久化,但是把数据存在内存中,虽然快但是不可靠,也可以把数据存在硬盘上,但也不是完全可靠的.(磁盘会损坏)

Checkpoint 将数据存储在HDFS上,借助HDFS的高容错,高可靠来实现数据最大程度上的安全.

> CheckPoint不再保留血缘关系,而缓存保留
>
> - CheckPoint 从定位上来说,定位为安全存储,也就是可以放HDFS了,不保留血缘关系,是认为不会丢
> - CheckPoint 保留的数据,可以认为是一个快照,这个快照比缓存更难生成,保存起来更容易

**API**

```python
# 先设置CheckPoint保存数据的位置
sc.setCheckpointDir("hdfs://demo01:8020/")
# 选择要保存的rdd 调用checkpoint方法保存
rdd.checkpoint()
# 和缓存一样,checkpoint也需要action触发,因为有了action  rdd才存在
# 触发 checkpoint
rdd.count()
# 再次执行count()函数,此时从checkpoint中读出数据
rdd.count()
```

##### 持久化和Checkpoint的区别

1. **存储位置**
   - Persist 和 Cache 只能保存在本地磁盘和内存中
   - Checkpoint 可以保存数据到本地硬盘和HDFS上
2. **生命周期**
   - Cache 和 Persist 会在程序结束后被清除或者手动调用 unpersist 方法
   - Checkpoint 的RDD在程序结束后依然存在,程序可以再次调用
3. **Lineage(血缘)**
   - Persist 和 Cache 不会丢掉RDD间的依赖关系，因为这种缓存是不可靠的，出现错误后需要回溯依赖链重新计算
   - Checkpoint 会斩断依赖链,因为Checkpoint 会把结果保存在HDFS中,更加安全,一般不需要回溯依赖链.

> Cache 和 Persist 之后的RDD 再执行Checkpoint 是无效的

#### jieba 分词库 使用

```python
# 导入jieba库
import jieba
# True 全模式,可重复组词
list1 = jieba.cut("str",cut_all=True)
# False 精确模式(默认)可以不加 cut_all
list1 = jieba.cut("str",cut_all=False)
# 搜索引擎模式(大致与全模式相同)
list1 = jieba.cut_for_search("str")
```

#### Spark 调用分析数据流程

```python
# 1.导入pyspark包 SparkContext , SparkConf
from pyspark import SparkContext,SparkConf
# 2.创建应用程序入口SparkContext 实例对象
conf = SparkConf().setAppName("").setMaster("local[*]")
sc = SparkContext.getOrCreate(conf)
# 3.从文件系统加载数据,创建RDD数据集
rdd = sc.textFile("/file_path").取出文件中的有效内容
# 4.调用集合RDD中函数处理分析数据
使用rdd函数,对文件内的数据进行分析处理,例:聚合,求和,最大等
```

 

### 共享变量

#### 广播变量

概念: 将一个变量表记为广播变量后,这个变量要和RDD的数据进行关联,这个变量将会被广播到每一个Executor 的内存上

为什么要这样做?

- 如果不将其标记为广播变量,这个变量就会发送到每一个分区上,如果标记了,只给每个Executor发送,这样,由于Executor内可以运行许多分区,Exxcutor拿到一份,就等同于内部分区都能拿到

通过广播变量优化了:

- 内存占用小了,从每个分区(Task)都有一份,变成了Executor独一份,内部分区共享
- 节省了网络IO,因为发送的数据量少了,网络的开销也低了

使用:

```python
使用时将变量注册成为广播变量
sparkContext.broadcast(要共享的数据)
```



#### 累加器

如果在**分布式**系统中, 想在RDD计算中完成值的累加, 是比较困难的.
因为, RDD底层是有分区的, 各个分区各自为战, 各自累加各自的所以, 最终整体结果是不准确的.
如果要进行整体(不理会分区)的累加, 可以使用Spark提供的累加器

```python
累加器使用时需注册
注册一个累加器,参数是初始值
acmlt = sc.accumulator(0)
```

##### 注意事项:

由于累加器是作用在 ＲＤＤ　算子内的

要注意，如果有多个　action　存在，那么很有可能累加器的算子会被多次执行，导致结果被多次累加

###### 解决方法

对　ＲＤＤ　加缓存或者放入　CheckPoint　中，这样ＲＤＤ不会被多次计算，避免了累加器的多次调用．

## **Spark内核调度**

Spark Scheduler（任务调度），**组织任务去处理RDD中每个分区的数据，根据RDD的依赖关系构建ＤＡＧ　基于DAG划分Stage　将每个Stage中的任务发到指定节点运行**．

#### DAG　：有向无环图

ＤＡＧ是Ｓｐａｒｋ代码中关于算子之间前后调用的一个图解

有向：有前后方向，也就是RDD之间的血缘(依赖)关系.

无环: 不会形成闭环,也就是肯定会结束,靠Action算子结束

有一个Action , 就会有一条 DAG,就会形成一个Job

一份代码(一个Appliaction(应用程序))中可以有多个Job(Action) 

#### 宽窄依赖

窄依赖:前面RDD的一个分区,将其数据**全部给后面**的**某一个**分区

宽依赖(Shuffle):前面RDD的一个分区,将其数据给了后面的**多个分区**

判断条件:从前到后,不分叉,是窄依赖

​				从前到后分叉就是宽依赖

**用途**: 基于宽窄依赖,将一个DAG(job)**划分成不同的阶段**(stage)

- 对于窄依赖，RDD之间的数据不需要进行Shuffle，多个数据处理可以在同一台机器的内存中完成，所以窄依赖在Spark中被划分为同一个Stage；
- 对于宽依赖，由于Shuffle的存在，必须等到父RDD的Shuffle处理完成后，才能开始接下来的计算，所以会在此处进行Stage的切分。

#### 划分阶段的用途

- 划分完阶段(分区)后,阶段内都是**窄依赖**
- 如果分区数量一致,可以走**内存迭代**
- 在同一个Executor内的不同RDD的分区之间可以进行**内存迭代(内存交互),无需走网络**

我们所需要做的是,基于机器的资源(Executor的数量),去提高并行度

#### Stag

从前往后,遇到一个宽依赖就切割一个Stage

#### Pipeline

在同一个Stage中,会有多个算子,每一个算子形成一个pipeline

#### Task

一个pipeline内的全部RDD分区计算,可以由一个任务(Task)全包

#### Taskset

Taskset指的是一个阶段(stage)内的全部task(Pipeline)的统称

#### 为什么说Spark是内存迭代框架

Spark基于宽窄依赖, 将DAG划分成不同的Stage(阶段)
每一个阶段的内部, 都是窄依赖
由于是窄依赖, 从前到后是1对1的, 那么在这个场景下, 我们可以让一个并行组成PipLine
一个PipLine可以交由一个Task处理
那么这从前到后的处理 统统不需要网络, 直接在内存里面进行计算.
只有遇到宽依赖的时候 ,才不得不将数据的一部分通过网络发送给其它的Task

#### 在内存迭代的场景下如何提高性能

1. 在硬件资源足够的前提下, 提高并行的PipLine数量, 极大的增加性能
2. 尽量确保 前后RDD的 分区数量一致, 用以确保一个阶段内是100%内存
迭代.
3. 尽量减少产生宽依赖的算子, 因为宽依赖是前面的一个分区给后面的多个分区提供数据
比如, 前面一个分区 给后面3个分区提供数据, 也就最多1/3可以走内存,剩下2/3肯定走网络

#### 面试题: 为什么Spark比MapReduce快

因为, Spark可以做内存迭代
而MapReduce的数据迭代是由HDFS硬盘作为中转. 效率极慢

标准回答:
1. Spark基于DGA和宽窄依赖划分, 确保了阶段内都是窄依赖, 可以组成PipLine内存迭代管道, 进行内存迭代.
2. Spark的算子, 实在是比MapReduce多太多. Spark基本上复杂任务都
能在一个Application中完成. 但是MapReduce只有2个算子map和reduce
这个限制导致复杂的计算任务, 写一个MapReduce程序很难做完, 一般会前后串接很多的MapReduce
Map和Reduce之间都是走硬盘传输, 多个MapReduce之间还是走硬盘传输, 更慢了

#### 常见的宽依赖算子

```python
reduceByKey 分组聚合
groupBy 自定义分组
groupByKey 按key分组
repartition(不是100%都是宽依赖)(一般增加分区是宽依赖, 减少分区
是窄依赖)
partitionBy 自定义分区(等同于自定义分组, 数据总是乱七八糟互发)
foldByKey 分组聚合
aggragateByKey 分组聚合
sortBy 如果增加分区排序, 也是宽依赖
sortByKey 如果增加分区排序, 也是宽依赖
```

> 宽依赖算子
> 1. 要么加分区
> 2. 要么分组了 (数据归类)
