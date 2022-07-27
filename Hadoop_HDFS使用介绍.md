## Hadoop 

#### 一、概念

#### 1. 简介 

狭义上:Hadoop是Apache一款开源的java软件,是一个大数据分析处理平台.

主要包括三部分: 

- **HDFS**:分布式文件系统,解决海量数据存贮问题
- **MapRedues**:分布式计算框架 ,解决大量数据计算问题
- **YARN**:集群资源管理与调度

广义上: Hadoop 生态圈



#### 2.  Hadoop之父:Doug Cutting  道尔卡丁



#### 3.  特点

- 分布式、扩容能力强

```
不再注重单机能力，看重的是集群整体能力。
动态扩容，缩容
```

- 成本低

```
在集群下 单机成本很低 可以是普通服务器组成集群
```

- 效率高，并发能力好

- 可靠性

  ```
  能自动维护数据的多份复制，并且在任务失败后能自
  动地重新部署（redeploy）计算任务。所以 Hadoop 的按位存储和处理数据的能
  力值得人们信赖。
  
  ```

- 通用性强

## HDFS

#### 1.架构

​		HDFS 采用 master/slave 架构。 一般一个 HDFS 集群是有一个 Namenode 和一定数目的 Datanode 组成。

  	 Namenode 是 HDFS 集群主节点， Datanode 是 HDFS 集群从节点，两种角色各司其职，共同协调完成分布式的文件存储服务。  

#### 2. 存储

​		HDFS 中的文件在物理上是分块存储（block） 的，块的大小可以通过配置参数来规定，默认大小是 **128M**。  

#### 3. Namenode 元数据管理

​		**目录结构及文件分块位置信息叫做元数据**。 Namenode 负责维护整个
hdfs 文件系统的目录树结构，以及每一个文件所对应的 block 块信息（ block 的id，及所在的 datanode 服务器）。  

#### 4. Datanode 数据存储

​		文件的各个 block 的具体存储管理由 datanode 节点承担。 每一个 block 都可以在多个 datanode 上。 Datanode 需要定时向 Namenode 汇报自己持有的 block信息。  

#### 5.副本机制

​		为了容错，文件的所有 block 都会有副本。每个文件的 block 大小和副本系数都是可配置的。应用程序可以指定某个文件的副本数目。副本系数可以在文件创建的时候指定，也可以在之后改变。
​		**副本数量**也可以通过参数设置 **dfs.replication**，**默认是 3**。  

#### 6.一次写入，多次读出  

​		HDFS 是设计成适应**一次写入，多次读出**的场景， 且**不支持文件的修改**。
​		正因为如此， HDFS 适合用来做大数据分析的底层存储服务，并不适合用来做网盘等应用，因为，**修改不方便，延迟大，网络开销大，成本太高**。  

#### 7.工作机制

​		NameNode 负责管理整个文件系统元数据； DataNode 负责管理具体文件数据块存储； Secondary NameNode 协助 NameNode 进行元数据的备份。
​		HDFS 的内部工作机制对客户端保持透明，**客户端请求访问 HDFS 都是通过向NameNode 申请来进行**。  

==详细步骤解析：==

1、 client 发起文件上传请求， 通过 RPC 与 NameNode 建立通讯,NameNode检查目标文件是否已存在，父目录是否存在，返回是否可以上传；
2、 client 请求第一个 block 该传输到哪些 DataNode 服务器上；
3、 NameNode 根据配置文件中指定的备份数量及副本放置策略进行文件分
配，返回可用的 DataNode 的地址，如： A， B， C；
注： 默认存储策略由 BlockPlacementPolicyDefault 类支持。也就是日常生活中提到最经典的 **3 副本策略**。
**1st replica 如果写请求方所在机器是其中一个 datanode,则直接存放在本地,否则随机在集群中选择一个 datanode.
2nd replica 第二个副本存放于不同第一个副本的所在的机架.
3rd replica 第三个副本存放于第二个副本所在的机架,但是属于不同
的节点**  

![image-20210817220146791](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210817220146791.png)

4、 client 请求 3 台 DataNode 中的一台 A 上传数据（本质上是一个 RPC 调
用，建立 pipeline）， A 收到请求会继续调用 B，然后 B 调用 C，将整个
pipeline 建立完成， 后逐级返回 client；
5、 client 开始往 A 上传第一个 block（先从磁盘读取数据放到一个本地内
存缓存），以 packet 为单位（默认 64K）， A 收到一个 packet 就会传给 B，
B 传给 C； A 每传一个 packet 会放入一个应答队列等待应答。
6、 数据被分割成一个个 packet 数据包在 pipeline 上依次传输，在
pipeline 反方向上，逐个发送 ack（命令正确应答），最终由 pipeline
中第一个 DataNode 节点 A 将 pipeline ack 发送给 client;
7、 当一个 block 传输完成之后， client 再次请求 NameNode 上传第二个
block 到服务器。  

#### 8.HDFS读取数据流程

![image-20210818204841958](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818204841958.png)



详细步骤解析：
1、 Client 向 NameNode 发起 RPC 请求， 来确定请求文件 block 所在的位置；
2、 NameNode 会视情况返回文件的部分或者全部 block 列表，对于每个 block，NameNode 都会返回含有该 block 副本的 DataNode 地址；
3、 这些返回的 DN 地址，会按照集群拓扑结构得出 DataNode 与客户端的距
离，然后进行排序，排序两个规则：网络拓扑结构中距离 Client 近的排靠前；心跳机制中超时汇报的 DN 状态为 STALE，这样的排靠后；
4、 Client 选取排序靠前的 DataNode 来读取 block，如果客户端本身就是
DataNode,那么将从本地直接获取数据；
5、 底 层 上 本 质 是 建 立 FSDataInputStream ， 重 复 的 调 用 父 类
DataInputStream 的 read 方法，直到这个块上的数据读取完毕； 一旦到
达块的末尾， DFSInputStream 关闭连接并继续定位下一个块的下一个
DataNode；
6、 当读完列表的 block 后，若文件读取还没有结束，客户端会继续向
NameNode 获取下一批的 block 列表； 一旦客户端完成读取，它就会调用
close() 方法。
7、 读取完一个 block 都会进行 checksum 验证，如果读取 DataNode 时出现
错误，客户端会通知 NameNode，然后再从下一个拥有该 block 副本的DataNode 继续读。
8、 NameNode 只是返回 Client 请求包含块的 DataNode 地址，并不是返回请求块的数据；
9、 最终读取来所有的 block 会合并成一个完整的最终文件  

## HDFS操作

#### ==**shell命令行**== 

Hadoop 提供了文件系统的 shell 命令行客户端，使用方法如下：

```shell
hadoop fs <args>  
```

本地文件系统，命令示例如下：

```
hadoop fs -ls file:///root/
```

如果使用的文件系统是 HDFS，则使用 hdfs dfs 也是可以的，此时

```shell
hadoop fs <args> = hdfs dfs <args>  
```

**Shell 常用命令介绍**
**-ls**
使用方法： hadoop fs -ls [-h] [-R] <args>
功能： **显示文件**、 **目录**信息。
示例： hadoop fs -ls /user/hadoop/file1
**-mkdir**
使用方法： hadoop fs -mkdir [-p] <paths>
功能： 在 hdfs 上**创建目录**， -p 表示会创建路径中的各级父目录。
示例： hadoop fs -mkdir – p /user/hadoop/dir1
**-put**
使用方法： hadoop fs -put [-f] [-p] [ -|<localsrc1> .. ]. <dst>
功能： 将单个 src 或多个 srcs **从本地文件系统复制到目标文件系统**。
-p：保留访问和修改时间，所有权和权限。
-f：覆盖目的地（如果已经存在）
示例： hadoop fs -put -f localfile1 localfile2 /user/hadoop/hadoopdir
**-get**
使用方法： hadoop fs -get [-ignorecrc] [-crc] [-p] [-f] <src> <localdst>
-ignorecrc：跳过对下载文件的 CRC 检查。
-crc：为**下载**的文件写 CRC 校验和。
功能： 将文件复制到本地文件系统。
示例： hadoop fs -get hdfs://host:port/user/hadoop/file localfile
**-appendToFile**
使用方法： hadoop fs -appendToFile <localsrc> ... <dst>
功能：**追加**一个文件到已经存在的文件末尾
示例： hadoop fs -appendToFile localfile /hadoop/hadoopfile
北京市昌平区建材城西路金燕龙办公楼一层 电话： 400-618-9090
**-cat**
使用方法： hadoop fs -cat [-ignoreCrc] URI [URI ...]
功能：**显示文件内容**到 stdout
示例： hadoop fs -cat /hadoop/hadoopfile
**-tail**
使用方法： hadoop fs -tail [-f] URI
功能： 将文件的**最后一千字节内容显示**到 stdout。
-f 选项将在文件增长时输出附加数据。
示例： hadoop fs -tail /hadoop/hadoopfile
**-chgrp**
使用方法： hadoop fs -chgrp [-R] GROUP URI [URI ...]
功能：更改**文件组的关联**。用户必须是文件的所有者，否则是超级用户。
-R 将使改变在目录结构下递归进行。
示例： hadoop fs -chgrp othergroup /hadoop/hadoopfile
**-chmod**
功能： 改变文件的**权限**。使用-R 将使改变在目录结构下递归进行。
示例： hadoop fs -chmod 666 /hadoop/hadoopfile
**-chown**
功能： 改变文件的**拥有者**。使用-R 将使改变在目录结构下递归进行。
示例： hadoop fs -chown someuser:somegrp /hadoop/hadoopfile
**-cp**
功能：从 hdfs 的一个路径**拷贝** hdfs 的另一个路径
示例： hadoop fs -cp /aaa/jdk.tar.gz /bbb/jdk.tar.gz.2
**-mv**
功能：在 hdfs 目录中移动文件
示例： hadoop fs -mv /aaa/jdk.tar.gz /
**-getmerge**
功能：**合并**下载多个文件
示例：比如 hdfs 的目录 /aaa/下有多个文件:log.1, log.2,log.3,...
hadoop fs -getmerge /aaa/log.* ./log.sum
**-rm**
功能： **删除**指定的文件。只删除非空目录和文件。 -r 递归删除。
示例： hadoop fs -rm -r /aaa/bbb/
**-df**
功能：**统计**文件系统的**可用空间**信息
示例： hadoop fs -df -h /
**-du**
功能： **显示目录中所有文件大小**，当只指定一个文件时，显示此文件的大小。
示例： hadoop fs -du /user/hadoop/dir1
**-setrep**
功能： **改变**一个文件的**副本系数**。 -R 选项用于递归改变目录下所有文件的副本
系数。
示例： hadoop fs -setrep -w 3 -R /user/hadoop/dir1  

## HDFS其他功能

#### 1.集群内部文件拷贝 scp  

```shell
cd /export/softwares/
scp -r jdk-8u141-linux-x64.tar.gz root@node2:/export/
```

#### 2.跨集群之间的数据拷贝 distcp  

```shell
bin/hadoop distcp hdfs://node1:8020/jdk-8u141-linux-x64.tar.gz hdfs://cluster2:9000/
```

#### 3.Archive档案使用(**小文件的归档**)

HDFS 并不擅长存储小文件，因为每个文件最少一个 block，每个 block 的
元数据都会在 NameNode 占用内存，如果存在**大量的小文**件，它们**会吃掉**
**NameNode 节点的大量内存**。
Hadoop Archives 可以有效的处理以上问题， 它可以把**多个文件归档成为**
**一个文件**，归档成一个文件后还可以透明的访问每一个文件。  

**创建 Archive**  

```shell
hadoop archive -archiveName name -p <parent> <src>* <dest>
```

其中-archiveName 是指要创建的存档的名称。 比如 test.har， archive 的
名字的扩展名应该是*.har。 -p 参数指定文件存档文件（src）的相对路径。
举个例子： -p /foo/bar a/b/c e/f/g
这里的/foo/bar 是 a/b/c 与 e/f/g 的父路径，
所以完整路径为/foo/bar/a/b/c 与/foo/bar/e/f/g
例如：如果你只想存档一个目录/input 下的所有文件:  

```shell
hadoop archive -archiveName test.har -p /input /outputdir
```

这样就会在/outputdir 目录下创建一个名为 test.har 的存档文件。  

![image-20210818211315696](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211315696.png)

![image-20210818211321226](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211321226.png)

**查看Archive**

```
hadoop fs -ls /outputdir/test.har
```

![image-20210818211503456](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211503456.png)

这里可以看到 har 文件包括： 两个索引文件，多个 part 文件（本例只有一
个）以及一个标识成功与否的文件。 **part 文件是多个原文件的集合**，根据
index 文件去找到原文件。  

例如上述的三个小文件 1.txt 2.txt 3.txt 内容分别为 1， 2， 3。进行
archive 操作之后，三个小文件就归档到 test.har 里的 part-0 一个文件里。

  ![image-20210818211550390](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211550390.png)

![image-20210818211556341](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211556341.png)



archive 作为文件系统层暴露给外界。所以所有的 fs shell 命令都能在
archive 上运行，但是要使用不同的 URI。 Hadoop Archives 的 URI 是：  

```
har://scheme-hostname:port/archivepath/fileinarchive
```

scheme-hostname 格式为 hdfs-域名:端口， 如果没有提供 scheme-hostname，
它会使用默认的文件系统。这种情况下 URI 是这种形式：  

```
har:///archivepath/fileinarchive
```

如果用 har uri 去访问的话， 索引、标识等文件就会隐藏起来，只显示创建
档案之前的原文件：  

![image-20210818211752413](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211752413.png)

![image-20210818211757133](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211757133.png)

![image-20210818211802454](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818211802454.png)

**解压 Archive**  

按顺序解压存档（串行）：  

```
Hadoop fs -cp har:///user/zoo/foo.har /dir1hdfs:/user/zoo/newdir
```

要并行解压存档，请使用 DistCp：  

```
hadoop distcp har:///user/zoo/foo.har/dir1 hdfs:/user/zoo/newdir
```

#### 4.Snapshot快照使用

快照顾名思义，就是**相当于对 hdfs 文件系统做一个备份**，可以通过快照对
指定的文件夹设置备份， 但是**添加快照之后，并不会立即复制所有文件，而是**
**指向同一个文件。当写入发生时，才会产生新文件**。  

**基本使用语法**

开启指定目录的快照功能  

```
hdfs dfsadmin -allowSnapshot 路径
```

禁用指定目录的快照功能（ 默认就是禁用状态）  

```
hdfs dfsadmin -disallowSnapshot 路径
```

给某个路径创建快照 snapshot  

```
hdfs dfs -createSnapshot 路径
```

指定快照名称进行创建快照 snapshot  

```
hdfs dfs -createSanpshot 路径 名称
```

快照重新命名  

```
hdfs dfs -renameSnapshot 路径 旧名称 新名称
```

列出当前用户所有可快照目录  

```
hdfs lsSnapshottableDir
```

比较两个快照的目录不同之处  

```
hdfs snapshotDiff 路径 1 路径 2
```

删除快照 snapshot  

```
hdfs dfs -deleteSnapshot <path> <snapshotName>
```

**快照操作实际案例**  

1、 开启与禁用指定目录的快照

```
hdfs dfsadmin -allowSnapshot /user
Allowing snaphot on /user succeeded
hdfs dfsadmin -disallowSnapshot /user
Disallowing snaphot on /user succeeded
```

2、 对指定目录创建快照
注意：创建快照之前，先要允许该目录创建快照

```
hdfs dfsadmin -allowSnapshot /user
Allowing snaphot on /user succeeded
hdfs dfs -createSnapshot /user
Created snapshot /user/.snapshot/s20190317-210906.549
```

通过 web 浏览器访问快照

```
http://node1:50070/explorer.html#/user/.snapshot/  
```

3、 指定名称创建快照

```
hdfs dfs -createSnapshot /user mysnap1
Created snapshot /user/.snapshot/mysnap1
```

4、重命名快照

```
hdfs dfs -renameSnapshot /user mysnap1 mysnap2
```

5、列出当前用户所有可以快照的目录

```
hdfs lsSnapshottableDir  
```

6、 比较两个快照不同之处

```
hdfs dfs -createSnapshot /user snap1
hdfs dfs -createSnapshot /user snap2
hdfs snapshotDiff snap1 snap2
```

7、 删除快照

```
hdfs dfs -deleteSnapshot /user snap1  
```



## NameNode

#### 概述

a、 NameNode 是 HDFS 的核心。
b、 NameNode 也称为 Master。
c、 NameNode 仅存储 HDFS 的元数据： 文件系统中所有文件的目录树，并跟踪整
个集群中的文件。
d、 NameNode 不存储实际数据或数据集。数据本身实际存储在 DataNodes 中。
e、 NameNode 知道 HDFS 中任何给定文件的块列表及其位置。使用此信息
NameNode 知道如何从块中构建文件。
f、 NameNode 并不持久化存储每个文件中各个块所在的 DataNode 的位置信息，
这些信息会在系统启动时从数据节点重建。
g、 NameNode 对于 HDFS 至关重要，当 NameNode 关闭时， HDFS / Hadoop 集群无法访问。
h、 NameNode 是 Hadoop 集群中的单点故障。
i、 NameNode 所在机器通常会配置有大量内存（RAM）。  

## DataNode

#### 概述

a、 DataNode 负责将实际数据存储在 HDFS 中。
b、 DataNode 也称为 Slave。
c、 NameNode 和 DataNode 会保持不断通信。
d、 DataNode 启动时，它将自己发布到 NameNode 并汇报自己负责持有的块列表。
e、 当某个 DataNode 关闭时，它不会影响数据或群集的可用性.NameNode 将安排由其他 DataNode 管理的块进行副本复制。
f、 DataNode 所在机器通常配置有大量的硬盘空间。因为实际数据存储在
DataNode 中。
g、 DataNode 会定期（dfs.heartbeat.interval 配置项配置，默认是 3 秒）向
NameNode 发送心跳，如果 NameNode 长时间没有接受到 DataNode 发送的心跳， NameNode 就会认为该 DataNode 失效。
h、 block 汇报时间间隔取参数 dfs.blockreport.intervalMsec,参数未配置的
话默认为 6 小时.  

## Secondary Namenode  

![image-20210818213325003](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210818213325003.png)

当 HDFS 集群运行一段事件后， 就会出现下面一些问题：

- edit logs 文件(元数据在 内存上的日志文件)会变的很大，怎么去管理这个文件是一个挑战。	
- NameNode 重启会花费很长时间，因为有很多改动要合并到 fsimage 文件上。
-  如果 NameNode 挂掉了，那就丢失了一些改动。 因为此时的 fsimage 文件非常旧。  

因此为了克服这个问题，我们需要一个易于管理的机制来帮助我们**减小 edit logs 文件的大小和得到一个最新的 fsimage 文件**，这样也会减小在 NameNode 上的压力。  

SecondaryNameNode 就是来帮助解决上述问题的，它的职责是**合并 NameNode 的 edit logs 到 fsimage 文件中**。  

## Fsimage、 Edits  

**概述**
**fsimage** 文件其实是 Hadoop 文件系统元数据的一个**永久性的检查点**，其中
包含 Hadoop 文件系统中的所有目录和文件 idnode 的序列化信息；
fsimage 包含 Hadoop 文件系统中的所有目录和文件 idnode 的序列化信息；
对于文件来说，包含的信息有修改时间、访问时间、块大小和组成一个文件块信息等；而对于目录来说，包含的信息主要有修改时间、访问控制权限等信息。  

**edits** 文件存放的是 Hadoop 文件系统的所有**更新操作的路径**，文件系统客户
端执行的所以写操作首先会被记录到 edits 文件中  

NameNode 起来之后， HDFS 中的更新操作会重新写到 edits 文件中，因为
fsimage 文件一般都很大（ GB 级别的很常见），如果所有的更新操作都往 fsimage文件中添加，这样会导致系统运行的十分缓慢，但是如果往 edits 文件里面写就不会这样，每次执行写操作之后，且在向客户端发送成功代码之前， edits 文件都需要同步更新。如果一个文件比较大，使得写操作需要向多台机器进行操作， **只有当所有的写操作都执行完成之后，写操作才会返回成功**，这样的好处是**任何的操作都不会因为机器的故障而导致元数据的不同步**  

