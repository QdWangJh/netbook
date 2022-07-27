## ZooKeeper

### 一、概念

1. 是什么?

分布式协调服务软件

2. 本质

分布式小文件存储系统

3. Zookeeper特性

**全局数据一致性**

==怎么能保障数据一致性?==

事务（**transaction**）：通俗理解 ==多个操作组成一个事务，要么一起成功，要么一起失败，不会存在中间的状态。如果中间失败了要进行回滚操作。==

zookeeper是一个标准的==主从架构==集群。

主角色 leader 从角色 follower 观察者角色 Observer

==事务性操作由主角色唯一调度和处理,从角色处理非事务性操作(查询),==

==主角色出现故障,从角色重新选举主角色.==



### 二、基本操作

1. 启动

```shell
/export/server/zookeeper/bin/zkServer.sh  start|stop|status

启用客户端连接
/path/zookeeper/bin/zkCli.sh -server ip

#如果不加-server 参数 默认去连接本机的zk服务 localhost:2181
#如果指定-server 参数 就去连接指定机器上的zk服务
#退出客户端端 ctrl+c
```

2. 创建节点

```shell
create [-s] [-e] path data acl

-s 或-e 分别指定节点特性，顺序或临时节点，若不指定，则表示持
久节点；acl 用来进行权限控制。

```

![image-20210814210230766](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210814210230766.png)

3. 读取节点

ls 命令和 get 命令，ls 命令可以列出 Zookeeper 指 定节点下的所有子节点，只能查看指定节点下的第一级的所有子节点；get 命令 可以获取 Zookeeper 指定节点的数据内容和属性信息。

```shell
 ls path [watch]
 get path [watch]
 ls2 path [watch]
 
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

4. 更新节点

```shell
set path data [version]
data 就是要更新的新内容，version 表示数据版本。
```

![image-20210814212342676](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210814212342676.png)



5. 删除节点

```shell
  [zk: node2(CONNECTED) 43] ls /itcast
  [aaa0000000000, bbbb0000000002, aaa0000000001]
  [zk: node2(CONNECTED) 44] delete /itcast/bbbb0000000002
  [zk: node2(CONNECTED) 45] delete /itcast               
Node not empty: /itcast
  [zk: node2(CONNECTED) 46] rmr /itcast  #递归删除
```



6. 限制节点  quota 



```shell
setquota -n|-b val path 对节点增加限制。 

n:表示子节点的最大个数 

b:表示数据值的最大长度 

val:子节点最大个数或数据值的最大长度 

path:节点路径

listquota path 列出指定节点的 quota

delquota [-n|-b] path 删除 quota
```



7. 其他命令

   history : 列出命令历史

![image-20210814213634941](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210814213634941.png)



redo：该命令可以重新执行指定命令编号的历史命令,命令编号可以通过 history 查看



### 三、节点类型

Znode 有两种，分别为临时节点和永久节点。 

节点的类型在创建时即被确定，并且不能改变。 

临时节点：该节点的生命周期依赖于创建它们的会话。一旦会话结束，临时 节点将被自动删除，当然可以也可以手动删除。临时节点不允许拥有子节点。

 永久节点：该节点的生命周期不依赖于会话，并且只有在客户端显示执行删 除操作的时候，他们才能被删除。

 Znode 还有一个序列化的特性，如果创建的时候指定的话，该 Znode 的名字 后面会自动追加一个不断增加的序列号。序列号对于此节点的父节点来说是唯一 的，这样便会记录每个子节点创建的先后顺序。它的格式为“%10d”(10 位数字， 没有数值的数位用 0 补充，例如“0000000001”)。



这样便会存在四种类型的 Znode 节点，分别对应： 

PERSISTENT：永久节点 

EPHEMERAL：临时节点 

PERSISTENT_SEQUENTIAL：永久节点、序列化 

EPHEMERAL_SEQUENTIAL：临时节点、序列化



### 四、节点属性

每个 znode 都包含了一系列的属性，通过命令 get，可以获得节点的属性。

![image-20210814214102303](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210814214102303.png)

dataVersion：数据版本号，每次对节点进行 set 操作，dataVersion 的值都 会增加 1（即使设置的是相同的数据），可有效避免了数据更新时出现的先后顺 序问题。

cversion ：子节点的版本号。当 znode 的子节点有变化时，cversion 的值 就会增加 1。

cZxid ：Znode 创建的事务 id。

mZxid ：Znode 被修改的事务 id，即每次对 znode 的修改都会更新 mZxid。

对于 zk 来说，每次的变化都会产生一个唯一的事务 id，zxid（ZooKeeper  Transaction Id）。通过 zxid，可以确定更新操作的先后顺序。例如，如果 zxid1 小于 zxid2，说明 zxid1 操作先于 zxid2 发生，zxid 对于整个 zk 都是唯一的， 即使操作的是不同的 znode。

ctime：节点创建时的时间戳.

mtime：节点最新一次更新发生时的时间戳.

ephemeralOwner:如果该节点为临时节点, ephemeralOwner 值表示与该节点 绑定的 session id. 如果不是, ephemeralOwner 值为 0.

在 client 和 server 通信之前,首先需要建立连接,该连接称为 session。连 接建立后,如果发生连接超时、授权失败,或者显式关闭连接,连接便处于 CLOSED 状态, 此时 session 结束。



### 五、监听机制

​	ZooKeeper 提供了分布式数据发布/订阅功能，一个典型的发布/订阅模型系 统定义了一种一对多的订阅关系，能让多个订阅者同时监听某一个主题对象，当 这个主题对象自身状态变化时，会通知所有订阅者，使他们能够做出相应的处理。 

ZooKeeper 中，引入了 Watcher 机制来实现这种分布式的通知功能。 ZooKeeper 允许客户端向服务端注册一个 Watcher 监听，当服务端的一些事件触 发了这个 Watcher，那么就会向指定客户端发送一个事件通知来实现分布式的通 知功能。

 触发事件种类很多，如：节点创建，节点删除，节点改变，子节点改变等。 总的来说可以概括 Watcher 为以下三个过程：客户端向服务端注册 Watcher、 服务端事件发生触发 Watcher、客户端回调 Watcher 得到触发事件情况



**Watch 机制特点 :**

**一次性触发** 

事件发生触发监听，一个 watcher event 就会被发送到设置监听的客户端， 这种效果是一次性的，后续再次发生同样的事件，不会再次触发。 

**事件封装**  

ZooKeeper 使用 WatchedEvent 对象来封装服务端事件并传递。 WatchedEvent 包含了每一个事件的三个基本属性： 通知状态（keeperState），事件类型（EventType）和节点路径（path） 

**event 异步发送** 

 watcher 的通知事件从服务端发送到客户端是异步的。 

**先注册再触发** 

Zookeeper 中的 watch 机制，必须客户端先去服务端注册监听，这样事件发 送才会触发监听，通知给客户端





**通知状态和事件类型**

![image-20210814220529890](C:\Users\root\AppData\Roaming\Typora\typora-user-images\image-20210814220529890.png)

其中连接状态事件(type=None, path=null)不需要客户端注册，客户端只要 有需要直接处理就行了。



监听实现需要几步？

```shell
#1、设置监听 

#2、执行监听

#3、事件发生，触发监听 通知给设置监听的   回调callback
```



zk中监听实现步骤

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



==总结：zk的很多功能都是基于这个特殊文件系统而来的。==

- ==特殊1：znode有临时的特性。==
- ==特殊2：znode有序列化的特性。顺序==
- ==特殊3：zk有监听机制 可以满足客户端去监听zk的变化。==
- ==特殊4：在非序列化节点下，路径是唯一的。不能重名。==



### 六、 典型应用

- **数据发布与订阅**

  ​		数据发布/订阅系统即所谓的配置中心，也就是发布者将数据发布到 ZooKeeper 的一个节点上，提供订阅者进行数据订阅，从而实现动态更新数据的 目的，实现配置信息的**集中式管理和数据的动态更新**。

  ​		ZooKeeper 采用的是推拉相结合的方式：客户端向服务器注册自己需要关注 的节点，一旦该节点的数据发生改变，那么服务端就会向相应的客户端发送 Watcher 事件通知，客户端接收到消息通知后，需要主动到服务端获取最新的数 据。

  主要用到了：**监听机制**。

- **提供集群选举**

  ​		在分布式环境下，不管是主从架构集群，还是主备架构集群，要求在服务的 时候有且有一个正常的对外提供服务，我们称之为 master。

  ​		当 master 出现故障之后，需要重新选举出的新的 master。保证服务的连续 可用性。zookeeper 可以提供这样的功能服务。

  主要用到了：**znode 唯一性、临时节点短暂性、监听机制**。

- **分布式锁服务**

  - 排他锁

  ```
  排他锁（Exclusive Locks），又被称为写锁或独占锁，如果事务T1对数据对象O1加上排他锁，那么整个加锁期间，只允许事务T1对O1进行读取和更新操作，其他任何事务都不能进行读或写。
  ```

  - 共享锁

  ```
  共享锁（Shared Locks），又称读锁。如果事务T1对数据对象O1加上了共享锁，那么当前事务只能对O1进行读取操作，其他事务也只能对这个数据对象加共享锁，直到该数据对象上的所有共享锁都释放。
  ```

  

  ​		ZooKeeper 通过数据节点表示一个锁，例如/itcast/lock 节点就可以定义一 个锁，所有客户端都会调用 create()接口，试图在/itcast 下创建 lock 子节点， 但是 ZooKeeper 的强一致性会保证所有客户端最终只有一个客户创建成功。也就 可以认为获得了锁，其它线程 Watcher 监听子节点变化（等待释放锁，竞争获取 资源）。

  ​		此外也可以通过 znode 的序列化特性，给创建 znode 的客户端自动编号，从 而实现所谓的顺序锁的功能

