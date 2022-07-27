### 求最大值:



```mysql
数据量 5318651(531w) 
所求数据不是索引
数据类型为 datetime 3001-01-01 00:00:00

max() < order by  desc limit1 < row_number

max() 1.967s
order by  desc  limit 1 3.198s
row_number() 14.734s
```

### 不等于  

```mysql
数据量 5318651(531w) 
所求数据不是索引
数据类型为 datetime 3001-01-01 00:00:00

单一条件:
单一条件下 差距不大

!= :2.635s / 2.418s / 2.405s /2.404s
<> :2.645s / 2.776s / 2.711s / 2.678s
not in : 2.559s / 2.773s / 2.670s

多条件(5个):
多条件下 not in 优于 != <>
		
!= : 3.317s / 3.436s / 3.398s
<> : 3.415s / 3.387s / 3.459s
not in : 2.495s / 2.768s / 2.532s

多条件,连续:
随着数据量的增加 not in 比 not between and 越来越慢
建议连续数据用 between and 毕竟写起来比较 省 力
> union all < 的方法会慢很多

多条件,连续(10个):
not in : 2.594s / 2.752s / 2.459s
not between and : 3.121s / 2.951s / 2.833s
> union all < : 6.118s / 5.078s / 6.693s

多条件,连续(60个):
not in : 3.472s / 3.065s / 3.366s
not between and :2.789s / 2.840s / 3.264s
> union all < : 4.964s / 6.826s / 5.951s
```

###  等于

```mysql
数据量 5318651(531w) 
所求数据不是索引
数据类型为 datetime 3001-01-01 00:00:00

单一条件:
单一条件相差不大
= : 1.992s / 2.003s / 1.932s
in : 1.907s / 1.933s / 1.934s

多条件(5个)非连续: 
in 快于 union all = ,不过一般情况下也没有人会用 union all = 吧
union all = :11.048s
in : 2.158s / 2.054s / 2.232s

多条件(60个)连续
当前条件下相差不大,但是省力上还是用 between and
in : 1.913s/ 1.877s / 2.064s
between and : 2.043s / 2.069s / 1.944s
```

