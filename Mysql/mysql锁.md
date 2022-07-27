### 分类

- 从对数据操作的粒度分

    - 表锁

        操作时,会锁定整个表

        - 特点

            偏向MyISAM引擎,开销小,加锁快,不会出现死锁,锁定粒度打,发生锁冲突的概率最高,并发度最低

    - 行锁

        操作时.锁定当前行

        - 特点

        偏向InnoDB引擎,开销大,加锁慢,会出现死锁,锁定粒度最小,大声锁冲突的概率最低,并发度最高

- 从对数据操作的类型分

    - 读锁(共享锁)

        针对同一份数据,多个读操作可以同时进行而不会互相影响

    - 写锁(排他锁)

        当前操作没有完成之前,会阻断其它写锁和读锁

### 引擎支持的锁

- MyISAM 

支持表级锁,不支持行级锁

- InnoDB

支持表级锁,支持行级锁

对于UPDATE,DELETE和INSERT语句,InnoDB会自动给涉及数据集加排他锁

对于普通SELECT语句,InnoDB不会加任何锁



### 操作

select时增加锁

```mysql
共享锁: select * from table_name where ... LOCK IN SHARE MODE

排他锁: select * from table_name where ... FOR UPDATE
```

