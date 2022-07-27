# Hadoop服务启动流程

## Zookeeper 分布式协调软件

本质:分布式小文件存储系统

* 基础环境

```
IP
主机名
hosts映射
防火墙关闭
时间同步
ssh免密登录
```

* JDK环境

* ZK集群启动

  * 每台机器单独启动

    ```shell
    #在哪个目录执行启动命令 默认启动日志就生成当前路径下 叫做zookeeper.out
    
    /export/server/zookeeper/bin/zkServer.sh  start|stop|status
    
    #3台机器启动完毕之后 可以使用status查看角色是否正常。
    #还可以使用jps命令查看zk进程是否启动。
    [root@node3 ~]# jps
    2034 Jps
    1980 QuorumPeerMain  #zk 的Java进程
    ```

---

**附:**

扩展：编写shell脚本 一键脚本启动。

- 本质：在node1机器上执行shell脚本，由==shell程序通过ssh免密登录==到各个机器上帮助执行命令。

- 一键关闭脚本

  ```shell
  [root@node1 ~]# vim stopZk.sh
    
  #!/bin/bash
  hosts=(node1 node2 node3)
  for host in ${hosts[*]}
  do
   ssh $host "/export/server/zookeeper/bin/zkServer.sh stop"
  done
  ```

- 一键启动脚本

  ```shell
  [root@node1 ~]# vim startZk.sh
    
  #!/bin/bash
  hosts=(node1 node2 node3)
  for host in ${hosts[*]}
  do
   ssh $host "source /etc/profile;/export/server/zookeeper/bin/zkServer.sh start"
  done
  ```

- 注意：关闭java进程时候 根据进程号 直接杀死即可就可以关闭。启动java进程的时候 需要JDK。

- shell程序ssh登录的时候不会自动加载/etc/profile 需要shell程序中自己加载。



---

zk的操作

- 第一种客户端：自带shell客户端

```shell
/export/server/zookeeper/bin/zkCli.sh -server ip

#如果不加-server 参数 默认去连接本机的zk服务 localhost:2181
#如果指定-server 参数 就去连接指定机器上的zk服务


#退出客户端端 ctrl+c
```

基本操作

- 创建

  - 查看

```shell
[zk: node2(CONNECTED) 28] ls /itcast   #查看指定路径下有哪些节点
[aaa0000000000, bbbb0000000002, aaa0000000001]
[zk: node2(CONNECTED) 29] get /

zookeeper   itcast
[zk: node2(CONNECTED) 29] get /itcast  #获取znode的数据和stat属性信息
1111
cZxid = 0x200000003   #创建事务ID
ctime = Fri May 21 16:20:37 CST 2021 #创建的时间
mZxid = 0x200000003   #上次修改时事务ID
mtime = Fri May 21 16:20:37 CST 2021  #上次修改的时间
pZxid = 0x200000009
cversion = 3
dataVersion = 0  #数据版本号  只要有变化 就自动+1
aclVersion = 0
ephemeralOwner = 0x0   #如果为0 表示永久节点 如果是sessionID数字 表示临时节点
dataLength = 4   #数据长度
numChildren = 3  #子节点个数
```

- 更新节点

  ```shell
    set path data
  ```

  

- 删除节点

```shell
 [zk: node2(CONNECTED) 43] ls /itcast
  [aaa0000000000, bbbb0000000002, aaa0000000001]
  [zk: node2(CONNECTED) 44] delete /itcast/bbbb0000000002
  [zk: node2(CONNECTED) 45] delete /itcast               
Node not empty: /itcast
  [zk: node2(CONNECTED) 46] rmr /itcast  #递归删除
```

- quota==限制==    软性限制

- 限制某个节点下面可以创建几个子节点 数据大小。

  - 超过限制，zk不会强制禁止操作 而是在日志中给出warn警告提示

```shell
[zk: node2(CONNECTED) 47] create /itheima 111
Created /itheima
[zk: node2(CONNECTED) 49] listquota /itheima   #查看限制
absolute path is /zookeeper/quota/itheima/zookeeper_limits
quota for /itheima does not exist.

2021-05-21 16:54:42,697 [myid:3] - WARN  [CommitProcessor:3:DataTree@388] - Quota exceeded: /itheima count=6 limit=3
```

---

**Zookeeper监听机制Watch**

- 监听机制

  - 监听实现需要几步？

  ```shell
  #1、设置监听 
  
  #2、执行监听
  
  #3、事件发生，触发监听 通知给设置监听的   回调callback
  ```

  - zk中的监听是什么？

    - 谁监听谁？

      ```
      客户端监听zk服务
      ```

    - 监听什么事？

      ```
      监听zk上目录树znode的变化情况。 znode增加了 删除了 增加子节点了 不见了
      ```

  - zk中监听实现步骤

    ```shell
    #1、设置监听 然后zk服务执行监听
    ls path [watch]
    	没有watch 没有监听 就是查看目录下子节点个数
    	有watch  有监听  设置监听子节点是否有变化
    get path [watch]
    	监听节点数据是否变化
    	
    e.g: get /itheima  watch	
    #2、触发监听 
    set /itheima 2222  #修改了被监听的节点数据 触发监听
    
    #3、回调通知客户端
    WATCHER::
    
    WatchedEvent state:SyncConnected type:NodeDataChanged path:/itheima
    ```

  - zk的监听特性

    - ==先注册 再触发==

    - ==一次性的监听==

    - ==异步通知==

    - ==通知是使用event事件来封装的==

      ```
      state:SyncConnected type:NodeDataChanged path:/itheima
      
      type：发生了什么
      path:哪里发生的
      ```

  - zk中监听类型

    - 连接状态事件监听  系统自动触发 用户如果不关心可以忽略不计
    - 上述所讲的是用户自定义监听 主要监听zk目录树的变化  这类监听必须先注册 再监听。

- ==总结：zk的很多功能都是基于这个特殊文件系统而来的。==

  - ==特殊1：znode有临时的特性。==
  - ==特殊2：znode有序列化的特性。顺序==
  - ==特殊3：zk有监听机制 可以满足客户端去监听zk的变化。==
  - ==特殊4：在非序列化节点下，路径是唯一的。不能重名。==

---



**zk典型应用**

- 数据发布与订阅

- 提供集群选举

- 分布式锁服务

  - 排他锁

    ```
    排他锁（Exclusive Locks），又被称为写锁或独占锁，如果事务T1对数据对象O1加上排他锁，那么整个加锁期间，只允许事务T1对O1进行读取和更新操作，其他任何事务都不能进行读或写。
    ```

  - 共享锁

    ```
    共享锁（Shared Locks），又称读锁。如果事务T1对数据对象O1加上了共享锁，那么当前事务只能对O1进行读取操作，其他事务也只能对这个数据对象加共享锁，直到该数据对象上的所有共享锁都释放。
    ```

-----





## Hadoop 集群启动

Hadoop集群启动

单节点单进程逐个手动启动

- HDFS集群

  ```shell
  #hadoop2.x版本命令
  hadoop-daemon.sh start|stop  namenode|datanode|secondarynamenode
  
  #hadoop3.x版本命令
  hdfs --daemon start|stop namenode|datanode|secondarynamenode
  ```

- YARN集群

  ```shell
  #hadoop2.x版本命令
  yarn-daemon.sh start|stop resourcemanager|nodemanager
  
  #hadoop3.x版本命令
  yarn --daemon start|stop resourcemanager|nodemanager
  ```

- 优点：精准的控制每个角色每个进程的启停。避免了群起群停（时间成本）。

脚本一键启动

- 前提：==配置好免密登录。ssh==

  ```
  ssh-copy-id node1.itcast.cn
  ssh-copy-id node2.itcast.cn
  ssh-copy-id node3.itcast.cn
  ```

- HDFS集群

  ```
  start-dfs.sh 
  stop-dfs.sh 
  ```

- YARN集群

  ```shell
  start-yarn.sh
  stop-yarn.sh
  ```

- 更狠的

  ```shell
  start-all.sh
  stop-all.sh
  
  [root@node1 ~]# start-all.sh 
  This script is Deprecated. Instead use start-dfs.sh and start-yarn.sh
  ```

集群进程确认和错误排查

- 确认是否成功

  ```shell
  [root@node1 ~]# jps
  8000 DataNode
  8371 NodeManager
  8692 Jps
  8264 ResourceManager
  7865 NameNode
  ```

- 如果进程不在  ==看启动运行日志！！！！！！！！！！！！！==

  ```shell
  #默认情况下 日志目录
  cd /export/server/hadoop-3.3.0/logs/
  
  #注意找到对应进程名字 以log结尾的文件
  ```

Hadoop初体验

- Hadoop Web UI页面

  - HDFS集群   http://namenode_host:9870
  - YARN集群  http://resourcemanager_host:8088
  
  ```
  http://node1:9870/dfshealth.html#tab-overview
  ```

初体验之HD==FS==

- 本质就是存储文件的  和标准文件系统一样吗？

  - 也是有目录树结构，也是从根目录开始的。
  - 文件是文件、文件夹是文件夹（对于zk来说）
  - 和linux很相似
  - 上传小文件好慢。==为什么慢？和分布式有没有关系？==

体验之MapReduce+yarn

- MapReduce是分布式程序 yarn是资源管理 给程序提供运算资源。 Connecting to ResourceManager

  ```shell
  [root@node1 mapreduce]# pwd
  /export/server/hadoop-3.3.0/share/hadoop/mapreduce
  
  hadoop jar hadoop-mapreduce-examples-3.3.0.jar pi  2 2
  ```

- MR程序运行首先连接YRAN ResourceManager，连接它干什么的？==要资源==。

- MR程序好像是两个阶段 ，==先Map 再Reduce==。

- 数据量这么小的情况下，为什么MR这么慢？   MR适合处理大数据场景还是小数据场景？

---

Hadoop辅助功能

MapReduce jobhistory服务

- 背景

  ```
  默认情况下，yarn上关于MapReduce程序执行历史信息、执行记录不会永久存储；
  一旦yarn集群重启 之前的信息就会消失。
  ```

- 功能

  ```
  保存yarn上已经完成的MapReduce的执行信息。
  ```

- 配置

  - 因为需求修改配置。==重启hadoop集群==才能生效。

    ```xml
    vim mapred-site.xml
    
    <property>
    	<name>mapreduce.jobhistory.address</name>
    	<value>node1:10020</value>
    </property>
    
    <property>
    	<name>mapreduce.jobhistory.webapp.address</name>
    	<value>node1:19888</value>
    </property>
    ```

  - scp同步给其他机器

    ```shell
    scp /export/server/hadoop-3.3.0/etc/hadoop/mapred-site.xml node2:/export/server/hadoop-3.3.0/etc/hadoop/
    
    scp /export/server/hadoop-3.3.0/etc/hadoop/mapred-site.xml node3:/export/server/hadoop-3.3.0/etc/hadoop/
    ```

  - 重启hadoop集群

  - 自己手动启停jobhistory服务。

    ```shell
    #hadoop2.x版本命令
    mr-jobhistory-daemon.sh start|stop historyserver
    
    #hadoop3.x版本命令
    mapred --daemon start|stop historyserver
    
    [root@node1 ~]# jps
    13794 JobHistoryServer
    13060 DataNode
    12922 NameNode
    13436 NodeManager
    13836 Jps
    13327 ResourceManager
    ```

---

HDFS 垃圾桶机制

- 背景  在windows叫做回收站 

  ```shell
  在默认情况下 hdfs没有垃圾桶 意味着删除操作直接物理删除文件。
  
  [root@node1 ~]# hadoop fs -rm /itcast/1.txt
  Deleted /itcast/1.txt
  ```
  
- 功能：和回收站一种  在删除数据的时候 先去垃圾桶 如果后悔可以复原。

- 配置

  ```xml
  在core-site.xml中开启垃圾桶机制
  
  指定保存在垃圾桶的时间。单位分钟
  
  <property>
  	<name>fs.trash.interval</name>
  	<value>1440</value>
  </property>
  ```

- 集群同步配置 重启hadoop服务。

  ```shell
  [root@node1 hadoop]# pwd
  /export/server/hadoop-3.3.0/etc/hadoop
  [root@node1 hadoop]# scp core-site.xml node2:$PWD
  core-site.xml                                              100% 1027   898.7KB/s   00:00    
  [root@node1 hadoop]# scp core-site.xml node3:$PWD
  core-site.xml 
  ```

- 垃圾桶使用

  - 配置好之后 再删除文件  直接进入垃圾桶

    ```
    [root@node1 ~]# hadoop fs -rm /itcast.txt
    INFO fs.TrashPolicyDefault: Moved: 'hdfs://node1:8020/itcast.txt' to trash at: hdfs://node1:8020/user/root/.Trash/Current/itcast.txt
    ```
  
- 垃圾桶的本质就是hdfs上的一个隐藏目录。
  
  ```
    hdfs://node1:8020/user/用户名/.Trash/Current
  ```
  
- 后悔了 需要恢复怎么做？
  
  ```
    hadoop fs -cp /user/root/.Trash/Current/itcast.txt /
  ```
  
- 就想直接删除文件怎么做？
  
  ```shell
    hadoop fs -rm -skipTrash /itcast.txt
     
    [root@node1 ~]#  hadoop fs -rm -skipTrash /itcast.txt
    Deleted /itcast.txt
  ```





## Hive 启动

- 服务器 metastore 启动

  ```shell
  #前台启动 关闭 ctrl+c
  /export/server/apache-hive-3.1.2-bin/bin/hive --service metastore
  #前台启动开启 debug 日志
  /export/server/apache-hive-3.1.2-bin/bin/hive --service metastore --hiveconf 
  hive.root.logger=DEBUG,console 
  #后台启动 进程挂起 关闭使用 jps+ kill -9
  nohup /export/server/apache-hive-3.1.2-bin/bin/hive --service metastore &
  ```

- 第一代客户端 HIve Client  启动\

  在 hive 安装包的 bin 目录下，有 hive 提供的第一代客户端 bin/hive。使 用该客户端可以访问 hive 的 metastore 服务。从而达到操作 hive 的目的。 

  如果需要在其他机器上通过该客户端访问 hive metastore 服务，只需要在 该机器的 hive-site.xml 配置中添加 metastore 服务地址即可。 scp 安装包到另一个机器上，比如 node3：

```shell
scp -r /export/server/apache-hive-3.1.2-bin/ node3:/export/server/

```

​	vim hive-site.xml 内容如下：

```
<configuration>
<property>
 <name>hive.metastore.uris</name>
 <value>thrift://node1:9083</value>
</property>
</configuration>
```

使用下面的命令启动 hive 的客户端：

```
 /export/server/apache-hive-3.1.2-bin/bin/hive
```



- 第二代客户端 Hive Beeline Client 启动

ive 经过发展，推出了第二代客户端 beeline，但是 beeline 客户端不是直 接访问 metastore 服务的，而是需要单独启动 hiveserver2 服务。

在 hive 运行的服务器上，首先启动 metastore 服务，然后启动 hiveserver2 服务。



```
nohup /export/server/apache-hive-3.1.2-bin/bin/hive --service metastore &
nohup /export/server/apache-hive-3.1.2-bin/bin/hive --service hiveserver2 &
```

在 node3 上使用 beeline 客户端进行连接访问。

```
/export/server/apache-hive-3.1.2-bin/bin/beeline
beeline> ! connect jdbc:hive2://node1:10000
Enter username for jdbc:hive2://node1:10000: root  #服务器的用户名
Enter password for jdbc:hive2://node1:10000:	#服务器linux的密码
```



-----

# -----------------------------------------

## HDFS 使用( Hadoop Distribute File System)分布式文件系统

#### HDFS辅助工具

4.1、==跨集群==复制数据 distcp（distributed copy）

- 功能：实现在不同的hadoop集群之间进行数据复制同步。

- 用法：

  ```shell
  #同一个集群内 复制操作
  hadoop fs -cp /zookeeper.out /itcast
  
  #跨集群复制操作
  hadoop distcp hdfs://node1:8020/1.txt  hdfs:node5:8020/itcast
  ```

4.2、文件归档工具 archive

- 背景

  ```
  hdfs的架构设计不适合小文件存储的。
  因为小文件不管多小 都需要一定的元数据记录它 元数据保存在内存中的，
  如果集群小文件过多 就会造成内存被撑爆。 俗称 小文件吃内存。
  ```

- archive功能

  - 将一批小文件归档一个档案文件。
  - 底层是通过==MapReduce程序将小文件进行合并的。启动yarn集群执行mr程序==。
  - 企业中可以根据时间 定时进行归档，比如一周创建一个档案。

- 使用

  ```shell
  #创建档案
  hadoop archive -archiveName test.har -p /small /outputdir
  
  基于自己的需求 删除小文件 减少对内存的消耗
  hadoop fs -rm /small/*
  
  #查看档案文件 --归档之后的样子
  [root@node1 ~]# hadoop fs -ls hdfs://node1:8020/outputdir/test.har
  Found 4 items
  hdfs://node1:8020/outputdir/test.har/_SUCCESS
  hdfs://node1:8020/outputdir/test.har/_index
  hdfs://node1:8020/outputdir/test.har/_masterindex
  hdfs://node1:8020/outputdir/test.har/part-0
  
  #查看档案文件 --归档之前的样子
  [root@node1 ~]# hadoop fs -ls har://hdfs-node1:8020/outputdir/test.har
  Found 3 items
   har://hdfs-node1:8020/outputdir/test.har/1.txt
   har://hdfs-node1:8020/outputdir/test.har/2.txt
   har://hdfs-node1:8020/outputdir/test.har/3.txt
  
  #从档案文件中提取文件
  [root@node1 ~]# hadoop fs -cp har://hdfs-node1:8020/outputdir/test.har/* /small/
  [root@node1 ~]# hadoop fs -ls /small
  Found 3 items
  -rw-r--r--   3 root supergroup          2 2021-05-24 17:58 /small/1.txt
  -rw-r--r--   3 root supergroup          2 2021-05-24 17:58 /small/2.txt
  -rw-r--r--   3 root supergroup          2 2021-05-24 17:58 /small/3.txt
  ```

- 注意

  - archive没有压缩的功能 就是简单的==合二为一的操作 减少小文件个数==。

4.3、HDFS snapshot快照

- 功能：对文件系统的某一时刻状态进行拍照 相当于备份。

- 注意：使用快照之前 需要先==开启快照==的功能。通常针对指定的重要的目录创建快照。

- 栗子

  ```shell
  [root@node1 ~]# hdfs snapshotDiff /small mykz1 mykz2
  Difference between snapshot mykz1 and snapshot mykz2 under directory /small:
  M       .
  +       ./a.txt
  -       ./1.txt
  ```

- 意外收获

  > 拥有快照能力的目录 客观层面也被保护 无法执行删除操作。

  ```shell
  [root@node1 ~]# hadoop fs -rm -r /small
  21/05/24 18:13:21 INFO fs.TrashPolicyDefault: Namenode trash configuration: Deletion interval = 1440 minutes, Emptier interval = 0 minutes.
  rm: Failed to move to trash: hdfs://node1:8020/small: The directory /small cannot be deleted since /small is snapshottable and already has snapshots
  ```

-----

#### HDFS namenode元数据管理机制

namenode元数据

- 元数据是什么

  ```shell
  元数据（Metadata），又称中介数据、中继数据，为描述数据的数据（data about data），主要是描述数据属性（property）的信息，用来支持如指示存储位置、历史数据、资源查找、文件记录等功能。
  
  #记录数据的数据 描述数据的数据
  ```

- hdfs中元数据指的是什么

  - 文件系统的元数据（namespace、块的位置）
  - datanodes状态信息（健康、磁盘使用率）

- 回想首次启动HDFS集群的时候 进行format操作

  - 本质就是初始化操作  初始化namenode工作目录和元数据文件。

  - 元数据存储的目录由参数dfs.namenode.name.dir决定  在NN部署机器的本地linux文件系统中

    ```
    针对课程环境 最终目录
    
    /export/data/hadoopdata/dfs/name
    ```


secondarynamenode功能职责

- 要想成为namenode的备份 需要具备两个东西
  - 数据状态要和namenode保持一致。
  - 承担和namenode一样的职责
- ==secondarynamenode根本不是namenode的备份，其主要职责帮助nameNode进行元数据的合并==。

---

#### HDFS 安全模式

- 安全模式（safe mode）是HDFS集群处于一种保护状态，==文件系统只可以读，不可以写==。

- 安全模式如何进入离开的？

  - 自动进入离开

    ```shell
    #在HDFS集群刚启动时候 会自动进入 为了演示方便  使用单个进程逐个启动方式
    
    #step1：启动namenode
    hadoop-daemon.sh start namenode
    
    #step2: 执行事务性操作 报错
    [root@node1 ~]# hadoop fs -mkdir /aaaa
    mkdir: Cannot create directory /aaaa. Name node is in safe mode.
    
    Safe mode is ON. The reported blocks 0 needs additional 52 blocks to reach the threshold 0.9990 of total blocks 52. The number of live datanodes 0 has reached the minimum number 0. Safe mode will be turned off automatically once the thresholds have been reached.
    
    #1、条件1:已经汇报的block达到总数据块的 0.999
    #2、条件2:存活的dn数量大于等于0  说明这个条件不严格
    
    
    #step3:依次手动启动datanode
    hadoop-daemon.sh start datanode
    
    Safe mode is ON. The reported blocks 52 has reached the threshold 0.9990 of total blocks 52. The number of live datanodes 2 has reached the minimum number 0. In safe mode extension. Safe mode will be turned off automatically in 25 seconds.
    #3、条件3:满足12条件的情况下 持续30s 结束自动离开安全模式
    
    Safemode is off.
    
    
    #为什么集群刚启动的时候 要进入安全模式 
    文件系统元数据不完整 无法对外提供可高的文件服务  属于内部的元数据汇报、校验、构建的过程。
    
    ```

  - 手动进入离开

    ```shell
    hdfs dfsadmin -safemode enter
    hdfs dfsadmin -safemode leave
    
    Safe mode is ON. It was turned on manually. Use "hdfs dfsadmin -safemode leave" to turn safe mode off.
    
    #运维人员可以手动进入安全模式 进行集群的维护升级等动作 避免了群起群停浪费时间。
    ```

- 安全模式的注意事项

  - 刚启动完hdfs集群之后 等安全模式介绍才可以正常使用文件系统  文件系统服务才是正常可用。
  - 后续如果某些软件依赖HDFS工作，必须先启动HDFS且等安全模式结束才可以使用你的软件。
  -  启动-->启动成功-->==可用==（安全模式结束） 

-----