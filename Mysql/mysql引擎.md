### 分类

- MyISAM: 5.5之前的默认版本,有较高的插入,查询速度,但是不支持事务(多个sql指定为一个事务)(最大支持256T)
    - 支持全文索引
    - 不支持哈希索引
    - 不支持集群索引
    - 不支持外键
- InnoDB: 事务型速记的首选,支持ACID事务,支持行级锁
    - 不支持全文索引
    - 支持外键
    - 支持集群索引

- Memory:有极高的插入,更新,查询效率,数据置于内存中,会占用和数据量成正比的内存空间,重启mysql数据会丢失
- Federated:将不同服务器联合起来,逻辑上组成一个完整的数据库,适合分布式应用(映射表)

### 查看mysql引擎

```sql
show engines
```



### 查看默认的存储引擎

```sql
show variables like '%default_storage_engine%';
```

### 查看某个表的引擎

```sql
show create table table_name
```

### 创建表时指定存储引擎

```sql
create table(...) engine = MyISAM;
```

### 修改表的引擎

```sql
alter table table_name engine = innodb
```

### 修改默认的存储引擎

- 关闭 mysql 服务
- 找到 mysql.ini文件
- 找到 default-storage-engine=INNODB 修改
- 启动mysql服务

