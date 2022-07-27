### MySQL权限系统的工作原理

```
1、对连接的用户进行身份验证，合法的用户通过认证并建立连接。不合法的用户拒绝连接.
2、对通过认证的合法用户赋予相应的权限，用户可以在这些权限范围内对数据库做相应的操作。
```

注意两点：

1、MySQL通过IP地址和用户名联合进行确认的，同样的一个用户名如果来自不同的IP地址，MySQL则视为不同的用户。

2、MySQL的权限在数据库启动的时候就载入内存了，当用户通过身份认证后，就在内存中进行相应权限的操作。

### 查看所有权限

```mysql
show privileges;
```

### 赋予权限

```mysql
通过root用户登录之后创建
grant all privileges on *.* to user@localhost identified by "password" 
GRANT -- 创建用户
@localhost -- 指定允许本地访问  @% 允许远程访问
```

### 刷新MySQL的系统权限相关表

```
flush privileges ;
```



### 权限分类

存储过程

```mysql
ALTER ROUTINE 编辑或删除存储过程

CREATE ROUTINE 建立存储过程

EXECUTE 运行存储过程
```



