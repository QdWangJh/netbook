## 监听端口

在 job 文件夹下创建 FLume Agent 的配置文件 flume-netcat-logger.conf

```shell
vim flume-netcat-logger.conf
```

在该配置文件中添加如下内容：

```shell
# example.conf: A single-node Flume configuration
# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Describe/configure the source
a1.sources.r1.type = netcat
a1.sources.r1.bind = localhost
a1.sources.r1.port = 44444

# Describe the sink
a1.sinks.k1.type = logger

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1

```

注：a1 为 agent 的名称

开启 Flume 监听窗口

写法一：

```shell
bin/flume-ng agent --conf conf --conf-file job/flume-netcat-logger.conf --name a1 -Dflume.root.logger=INFO,console
```

写法二：

```shell
bin/flume-ng agent -c conf -f job/flume-netcat-logger.conf -n a1 -Dflume.root.logger=INFO,console
```

---





## 监控单个追加文件

### （一）输出到控制台

创建 flume-file-logger.conf 文件

```shell
vim flume-file-logger.conf
```

配置该文件内容

```shell
# Name the components on this agent
a2.sources = r2
a2.sinks = k2
a2.channels = c2

# Describe/configure the source
a2.sources.r2.type = exec
a2.sources.r2.command = tail -F /hadoop/hive-2.3.6/logs/hive.log


# Describe the sink
a2.sinks.k2.type = logger

# Use a channel which buffers events in memory
a2.channels.c2.type = memory
a2.channels.c2.capacity = 1000
a2.channels.c2.transactionCapacity = 100

# Bind the source and sink to the channel
a2.sources.r2.channels = c2
a2.sinks.k2.channel = c2

```

运行 Flume

```shell
 bin/flume-ng agent -c conf/ -f job/flume-file-logger.conf -n a2 -Dflume.root.logger=INFO,console
```

---

### （二）输出到 HDFS 上

创建 flume-file-hdfs.conf 文件。

```shell
vim flume-file-hdfs.conf
```

配置该文件 

```shell
# Name the components on this agent
a2.sources = r2
a2.sinks = k2
a2.channels = c2

# Describe/configure the source
a2.sources.r2.type = exec
a2.sources.r2.command = tail -F /hadoop/hive-2.3.6/logs/hive.log


# Describe the sink
a2.sinks.k2.type = hdfs
a2.sinks.k2.hdfs.path = hdfs://master:9000/flume/%Y%m%d/%H
#上传文件的前缀
a2.sinks.k2.hdfs.filePrefix = logs- 
#是否按照时间滚动文件夹
a2.sinks.k2.hdfs.round = true
#多少时间单位创建一个新的文件夹
a2.sinks.k2.hdfs.roundValue = 1
#重新定义时间单位
a2.sinks.k2.hdfs.roundUnit = hour
#是否使用本地时间戳
a2.sinks.k2.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a2.sinks.k2.hdfs.batchSize = 10
#设置文件类型，可支持压缩
a2.sinks.k2.hdfs.fileType = DataStream
#多久生成一个新的文件
a2.sinks.k2.hdfs.rollInterval = 30
#设置每个文件的滚动大小
a2.sinks.k2.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a2.sinks.k2.hdfs.rollCount = 0

# Use a channel which buffers events in memory
a2.channels.c2.type = memory
a2.channels.c2.capacity = 1000
a2.channels.c2.transactionCapacity = 100

# Bind the source and sink to the channel
a2.sources.r2.channels = c2
a2.sinks.k2.channel = c2

```

运行 Flume

```shell
bin/flume-ng agent -c conf/ -f job/flume-file-hdfs.conf -n a2
```

---



## 监控目录下多个新文件

使用 Flume 监听整个目录的文件，并上传到 HDFS 上。	

创建配置文件 flume-dir-hdfs.conf

```shell
vim flume-dir-hdfs.conf
```

配置该文件内容

```shell
# Name the components on this agent
a3.sources = r3
a3.sinks = k3
a3.channels = c3

# Describe/configure the source
a3.sources.r3.type = spooldir
a3.sources.r3.spoolDir = /opt/module/flume/upload
a3.sources.r3.fileSuffix = .COMPLETED
a3.sources.r3.fileHeader = true
#忽略所有以.tmp 结尾的文件，不上传
a3.sources.r3.ignorePattern = ([^ ]*\.tmp)

# Describe the sink
a3.sinks.k3.type = hdfs
a3.sinks.k3.hdfs.path =  hdfs://master:9000/flume/%Y%m%d/%H
#上传文件的前缀
a3.sinks.k3.hdfs.filePrefix = upload- 
#是否按照时间滚动文件夹
a3.sinks.k3.hdfs.round = true
#多少时间单位创建一个新的文件夹
a3.sinks.k3.hdfs.roundValue = 1
#重新定义时间单位
a3.sinks.k3.hdfs.roundUnit = hour
#是否使用本地时间戳
a3.sinks.k3.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a3.sinks.k3.hdfs.batchSize = 10
#设置文件类型，可支持压缩
a3.sinks.k3.hdfs.fileType = DataStream
#多久生成一个新的文件
a3.sinks.k3.hdfs.rollInterval = 60
#设置每个文件的滚动大小大概是 128M
a3.sinks.k3.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a3.sinks.k3.hdfs.rollCount = 0

# Use a channel which buffers events in memory
a3.channels.c3.type = memory
a3.channels.c3.capacity = 1000

a3.channels.c3.transactionCapacity = 100
# Bind the source and sink to the channel
a3.sources.r3.channels = c3
a3.sinks.k3.channel = c3


```

启动监控文件夹命令

```shell
bin/flume-ng agent -c conf -f job/flume-dir-hdfs.conf -n a3
```

---



## 监控目录下的多个追加文件

Exec Source 适用于监控一个实时追加的文件，但不能保证数据不丢失；Spooldir Source 能够保证数据不丢失，且能实现断点续传，但延迟较高，不能实时监控；而 Taildir Source 既能实现断点续传，又可以保证数据不丢失，还能够进行实时监控。



使用 Flume 监听整个目录的实时追加的文件，并上传至 HDFS。



**创建配置文件 flume-taildir-hdfs.conf**

```shell
vim flume-taildir-hdfs.conf
```

**配置该文件**

```shell
# Name the components on this agent
a4.sources = r4
a4.sinks = k4
a4.channels = c4

# Describe/configure the source
a4.sources.r4.type = TAILDIR
a4.sources.r4.positionFile = /opt/module/flume/postion/position.json
a4.sources.r4.filegroups = f1 f2
a4.sources.r4.filegroups.f1 = /opt/module/flume/files/file1.txt
a4.sources.r4.filegroups.f2 = /opt/module/flume/files/file2.txt

# Describe the sink
a4.sinks.k4.type = hdfs
a4.sinks.k4.hdfs.path = hdfs://master:9000/flume/%Y%m%d/%H
#上传文件的前缀
a4.sinks.k4.hdfs.filePrefix = upload- 
#是否按照时间滚动文件夹
a4.sinks.k4.hdfs.round = true
#多少时间单位创建一个新的文件夹
a4.sinks.k4.hdfs.roundValue = 1
#重新定义时间单位
a4.sinks.k4.hdfs.roundUnit = hour
#是否使用本地时间戳
a4.sinks.k4.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a4.sinks.k4.hdfs.batchSize = 10
#设置文件类型，可支持压缩
a4.sinks.k4.hdfs.fileType = DataStream
#多久生成一个新的文件
a4.sinks.k4.hdfs.rollInterval = 60
#设置每个文件的滚动大小大概是 128M
a4.sinks.k4.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a4.sinks.k4.hdfs.rollCount = 0

# Use a channel which buffers events in memory
a4.channels.c4.type = memory
a4.channels.c4.capacity = 1000
a4.channels.c4.transactionCapacity = 100

# Bind the source and sink to the channel
a4.sources.r4.channels = c4
a4.sinks.k4.channel = c4

```

**启动监控文件夹命令**

```shell
bin/flume-ng agent -c conf/ -f job/flume-taildir-hdfs.conf -n a4
```

---



## 复制和多路复用

### 需求

  使用 Flume-1 监控文件变动，Flume-1 将文件变动内容传递给 Flume-2，Flume-2 负责存储到 HDFS。同时 Flume-1 将变动内容传递给 Flume-3，Flume-3 负责输出到 Local FileSystem。

### 分析

flume-1 监控文件,将数据通过不同端口发送出去,由flume-2和flume-3 分别监控端口,拉取需要的数据

### 实现流程

- 准备工作

在 /opt/module/flume/job 目录下创建 group1 文件夹，在 /opt/module/datas/ 目录下创建 flume3 文件夹。

- 创建 flume1.conf

配置 1 个接收日志文件的 Source 和 两个 Channel、两个 Sink，分别输送给 flume2，flume3。

```shell
# Name the components on this agent
a1.sources = r1
a1.sinks = k1 k2
a1.channels = c1 c2

# 将数据流复制给所有 channel
a1.sources.r1.selector.type = replicating

# Describe/configure the source
a1.sources.r1.type = TAILDIR
a1.sources.r1.positionFile = /opt/module/flume/postion/position1.json
a1.sources.r1.filegroups = f1
a1.sources.r1.filegroups.f1 = /hadoop/hive-2.3.6/logs/hive.log

# Describe the sink
# sink 端的 avro 是一个数据发送者
a1.sinks.k1.type = avro
a1.sinks.k1.hostname = slave1
a1.sinks.k1.port = 4141
a1.sinks.k2.type = avro
a1.sinks.k2.hostname = slave1
a1.sinks.k2.port = 4142

# Describe the channel
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100
a1.channels.c2.type = memory
a1.channels.c2.capacity = 1000
a1.channels.c2.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1 c2
a1.sinks.k1.channel = c1
a1.sinks.k2.channel = c2

```

**创建 flume2.conf**

配置上级 Flume 的 Source，输出是 HDFS 的 Sink

```shell
# Name the components on this agent
a2.sources = r1
a2.sinks = k1
a2.channels = c1

# Describe/configure the source
# source 端的 avro 是一个数据接收服务
a2.sources.r1.type = avro
a2.sources.r1.bind = slave1
a2.sources.r1.port = 4141

# Describe the sink
a2.sinks.k1.type = hdfs
a2.sinks.k1.hdfs.path = hdfs://master:9000/flume2/%Y%m%d/%H
#上传文件的前缀
a2.sinks.k1.hdfs.filePrefix = flume2- 
#是否按照时间滚动文件夹
a2.sinks.k1.hdfs.round = true
#多少时间单位创建一个新的文件夹
a2.sinks.k1.hdfs.roundValue = 1
#重新定义时间单位
a2.sinks.k1.hdfs.roundUnit = hour
#是否使用本地时间戳
a2.sinks.k1.hdfs.useLocalTimeStamp = true
#积攒多少个 Event 才 flush 到 HDFS 一次
a2.sinks.k1.hdfs.batchSize = 10
#设置文件类型，可支持压缩
a2.sinks.k1.hdfs.fileType = DataStream
#多久生成一个新的文件
a2.sinks.k1.hdfs.rollInterval = 600
#设置每个文件的滚动大小大概是 128M
a2.sinks.k1.hdfs.rollSize = 134217700
#文件的滚动与 Event 数量无关
a2.sinks.k1.hdfs.rollCount = 0

# Describe the channel
a2.channels.c1.type = memory
a2.channels.c1.capacity = 1000
a2.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a2.sources.r1.channels = c1
a2.sinks.k1.channel = c1

```

**创建 flume3.conf**

配置上级 Flume 输出的 Source ，输出是本地目录 Sink

```shell
# Name the components on this agent
a3.sources = r1
a3.sinks = k1
a3.channels = c2

# Describe/configure the source
a3.sources.r1.type = avro
a3.sources.r1.bind = slave1
a3.sources.r1.port = 4142

# Describe the sink
a3.sinks.k1.type = file_roll
a3.sinks.k1.sink.directory = /opt/module/datas/flume3

# Describe the channel
a3.channels.c2.type = memory
a3.channels.c2.capacity = 1000
a3.channels.c2.transactionCapacity = 100

# Bind the source and sink to the channel
a3.sources.r1.channels = c2
a3.sinks.k1.channel = c2

```

**执行配置文件**

```shell
bin/flume-ng agent -c conf -f job/gruop1/flume1.conf -n a1
```

```shell
bin/flume-ng agent -c conf -f job/gruop1/flume2.conf -n a2
```

```shell
bin/flume-ng agent -c conf -f job/gruop1/flume3.conf -n a3
```

---



## 负载均衡和故障转移

### 需求

使用 Flume1 监控一个端口，其中 Sink 组中 Sink 分别对接 Flume2 和 Flume3，采用 FailoverSinkProcessor 时实现故障转移，使用 LoadBalancingSinkProcessor 时实现负载均衡。

### 实现流程

**（一）故障转移**

理解: 对sinks分组,分配优先级和监听

1. **准备工作。**

    在 /opt/module/flume/job 目录下创建 group2 文件夹

2. **创建 flume1.conf **

	配置 1 个 netcat Source 和 1 个 channel 、1 个 Sink Group（2 个 Sink）,分别输送给 flume2 和 flume3。
	
	```shell
	# Name the components on this agent
	a1.sources = r1
	a1.channels = c1
	a1.sinkgroups = g1
	a1.sinks = k1 k2
	
	# Describe/configure the source
	a1.sources.r1.type = netcat
	a1.sources.r1.bind = localhost
	a1.sources.r1.port = 44444
	
	# Describe the sink
	a1.sinks.k1.type = avro
	a1.sinks.k1.hostname = slave1
	a1.sinks.k1.port = 4141
	a1.sinks.k2.type = avro
	a1.sinks.k2.hostname = slave1
	a1.sinks.k2.port = 4142
	
	# Sink Group	
	a1.sinkgroups.g1.processor.type = failover
	a1.sinkgroups.g1.processor.priority.k1 = 5
	a1.sinkgroups.g1.processor.priority.k2 = 10
	a1.sinkgroups.g1.processor.maxpenalty = 10000
	
	# Describe the channel
	a1.channels.c1.type = memory
	a1.channels.c1.capacity = 1000
	a1.channels.c1.transactionCapacity = 100
	
	# Bind the source and sink to the channel
	a1.sources.r1.channels = c1
	a1.sinkgroups.g1.sinks = k1 k2
	a1.sinks.k1.channel = c1
	a1.sinks.k2.channel = c1
	
	```
	
	**创建 flume2.conf**。
	
	配置上级 Flume 输出的 Source，输出是到本地控制台
	
	```shell
	# Name the components on this agent
	a2.sources = r1
	a2.sinks = k1
	a2.channels = c1
	
	# Describe/configure the source
	a2.sources.r1.type = avro
	a2.sources.r1.bind = slave1
	a2.sources.r1.port = 4141
	
	# Describe the sink
	a2.sinks.k1.type = logger
	
	# Describe the channel
	a2.channels.c1.type = memory
	a2.channels.c1.capacity = 1000
	a2.channels.c1.transactionCapacity = 100
	
	# Bind the source and sink to the channel
	a2.sources.r1.channels = c1
	a2.sinks.k1.channel = c1
	
	```
	
	

​	**创建 flume3.conf**

​	配置上级 Flume 输出的 Source，输出是到本地	控制台

```shell
# Name the components on this agent
a3.sources = r1
a3.sinks = k1
a3.channels = c1

# Describe/configure the source
a3.sources.r1.type = avro
a3.sources.r1.bind = slave1
a3.sources.r1.port = 4142

# Describe the sink
a3.sinks.k1.type = logger

# Describe the channel
a3.channels.c1.type = memory
a3.channels.c1.capacity = 1000
a3.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a3.sources.r1.channels = c1
a3.sinks.k1.channel = c1

```

**执行配置文件**

```shell
bin/flume-ng agent -c conf -f job/group2/flume1.conf -n a1
```

```shell
bin/flume-ng agent -c conf -f job/group2/flume2.conf -n a2 -Dflume.root.logger=INFO,console
```

```shell
bin/flume-ng agent -c conf -f job/group2/flume3.conf -n a3 -Dflume.root.logger=INFO,console
```



**（二）负载均衡**

理解:对sinks分组,开,选择为随机模式

和上面故障转移实现流程一样，只需更改 flume1.conf 中 Sink Group 配置，其余一模一样。

```shell
# Sink Group	
a1.sinkgroups.g1.sinks = k1 k2
a1.sinkgroups.g1.processor.type = load_balance
a1.sinkgroups.g1.processor.backoff = true
a1.sinkgroups.g1.processor.selector = random
```

---



