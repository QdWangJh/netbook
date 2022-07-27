 

### JDBC核心类和接口

DriverManager : 用于注册驱动

Connection : 表示与数据库创建的连接

Statement/PrepareStatement : 操作数据库语句的对象

ResultSet : 结果集或者一张表



### 执行流程

- 注册驱动

DriverManager.registerDriver(驱动);

- 建立与数据库服务器的连接

DriverManager.getConnection(ip,端口,数据库,用户名,密码);

- 将sql指令发送给服务器执行

Statement/PrepareStatement executeUpdate() / executeQuery()

- 处理服务器返回的结果

1.返回行数rows

2.返回一张表(结果集) ResultSet

- 释放资源

close();