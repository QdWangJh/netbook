### Flume -- 实时数据流采集工具

#### 概念

- 功能:
  - 实现分布式实时数据流的数据采集,可以将各种不同数据源的数据实时采集到各种目标地中
- 特点
  - 实时采集:只要数据一产生,就会立即被采集
  - 功能全面:大数据中常用的数据源和目标地flume都封装好了对应的接口,只要传递参数直接使用
  - 允许自定义开发:Java开发的软件,提供了自定义开发接口 
  - 开发相对简单
  - 可以实现分布式采集,本身不是分布式工具,可以实现分布式采集
- 应用场景
  -  **应用于实时文件,网络数据流采集** 
- Flume 组成结构
  - **Agent**: 一个Agent就是一个Flume程序,每个Agent都有自己的一个名字
    - 由 Source 、Channel、Sink 组成
  - **Source**:采集数据,监听要采集的数据源,一旦数据源发生变化,将最新的每一条数据采集成一个Event,将Event放入Channel
  - **Channel**:临时存储Source采集到的数据,将所有Event临时存放在Channel中
  - **Sink**:主动将Channel中的数据写入到目标地
  - **Event**:将每一条数据封装成一个Event对象在网络中传递
    - Event 组成: header+body
    - header:默认为空,可以存放一些Key,Value对
    - body:存储数据内容

#### 使用方法

```sql
-- 在Flume 安装路径下运行
flume-ng agent -c Flume配置文件目录 -f 指定运行的文件 -n 指定agent名称

-- 后台运行
nohup 命令 &
或
命令 >>/dev/null 2>&1 &  -- 错误信息(error,warring)会标记为2 将2重定向为1 

-- 将日志打印在命令行
命令 -Dflume.root.logger=INFO,console

-- 进程名称
Application

```



- 更改官方示例配置文件

```sql
-- 复制官方配置文件到开发目录
cp conf/flume-conf.properties.template  /path
```

- 开发配置文件

```shell
# The configuration file needs to define the sources,
# the channels and the sinks.
# Sources, channels and sinks are defined per a1,

# in this case called 'a1'

#define the agent  -- 自定义模块名称
a1.sources = s1
a1.channels = c1
a1.sinks = k1

#define the source  -- 定义数据源

a1.sources.s1.type = exec -- exec监听文件
a1.sources.s1.command = tail -f /export/server/hive-1.1.0-
cdh5.14.0/logs/hiveserver2.log  -- 监听文件的位置

#define the channel -- 定义数据池属性
a1.channels.c1.type = memory  --将数据缓存在内存中
a1.channels.c1.capacity = 10000 --缓存大小,指定Channel中最多存储多少条event

#define the sink  -- 定义清洗类型
a1.sinks.k1.type = logger

#bond  -- 指定数据池
a1.sources.s1.channels = c1  -- 指定拉取数据源的存储位置
a1.sinks.k1.channel = c1	-- 指定存放数据的数据源

```

##### Sources类型:

```shell
# exec 监听文件
a1.sources.s1.type = exec
a1.sources.s1.command = tail -f 文件位置  -- 增量监听

# spooldir 监听文件夹  
a1.sources.s1.type = spooldir
a1.sources.s1.spoolDir = 文件夹位置
1）监控文件夹内的文件被flume使用后不能进行修改。
2）文件名字不能重复，如果已经存在了xx.completed，不能在放入名字叫xx的文件。否则报错，停止。
3）被监控文件夹里的子文件夹不处理
# spooldir 比 exec 更加稳定 

# avro 监听avro端口
监听avro端口，接收外部avro客户端数据流。
a1.sources.s1.type= avro
a1.sources.s1.bind= IP 
a1.sources.s1.port= 端口

# netcat 监听端口数据

a1.sources.s1.type= netcat
a1.sources.s1.bind= localhost/IP
a1.sources.s1.port= 端口

# http 
通过Http获取event，可以是GET、POST方式，GET方式应该在测试时使用。一个HTTP Request被handler解析成若干个event，这组event在一个事务里。
如果handler抛异常，http状态是400；如果channel满了，http状态是503。

a1.sources.s1.type=http
a1.sources.s1.port= 端口

# syslog  读取syslog数据
读取syslog数据，它分为：Syslog TCP Source、Multiport Syslog TCP Source、Syslog UDP Source

a1.sources.s1.type = syslogtcp
a1.sources.s1.host = localhost / IP
a1.sources.s1.port = 端口
```

- TAILDIR 动态监听多个文件

```shell
# define the s1
a1.sources.s1.type = TAILDIR
#指定一个元数据记录文件
a1.sources.s1.positionFile = /export/server/flume-1.6.0-
cdh5.14.0-bin/position/taildir_position.json
#将所有需要监控的数据源变成一个组，这个组内有两个数据源
a1.sources.s1.filegroups = f1 f2
#指定了f1是谁：监控一个文件
a1.sources.s1.filegroups.f1 = /export/data/flume/bigdata01.txt
#指定f1采集到的数据的header中包含一个KV对
a1.sources.s1.headers.f1.headerKey1 = value1
#指定f2是谁：监控一个目录下的所有文件
a1.sources.s1.filegroups.f2 = /export/data/flume/bigdata/.*
#指定f2采集到的数据的header中包含一个KV对
a1.sources.s1.headers.f2.headerKey1 = value2
a1.sources.s1.fileHeader = true

```

##### Channel类型



```shell
mem 将数据缓存在内存中
特点：读写快、容量小、安全性较差
应用：小数据量的高性能的传输

a1.channels.c1.type = memory  --将数据缓存在内存中
a1.channels.c1.capacity = 10000 --缓存大小,指定Channel中最多存储多少条event

file 将数据缓存在文件中
特点：读写相对慢、容量大、安全性较高
应用：数据量大，读写性能要求不高的场景下

#指定缓存的数据存储在什么位置
a1.channels.c1.dataDirs = /export/datas/flume/filechannel/datadir
#指定检查点目录，用于记录数据的校验信息
a1.channels.c1.checkpointDir = /export/datas/flume/filechannel/chkdir

```

