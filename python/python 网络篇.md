# python 网络篇



## 一、socket

## 使用方法

```python
import socket
#创建tcp的套接字(使用的网络协议IPv4,tcp协议)
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

#创建udp的套接字
s = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

#使用套接字收发数据,发送的内容需要是字节类型

#不使用时,关闭套接字
s.close()
```



### 使用udp发送数据

```python
####发送固定内容
import socket
#创建udp的套接字
s = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
#使用套接字收发数据,发送的内容需要是字节类型,可以在引号前加一个b"骗"过
s.sendto(b"发送的内容",("对方的ip",port端口号))

#不使用时,关闭套接字
s.close()
```

```python
####发送键盘输入内容
import socket
#创建一个udp的套接字
udp_socket = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
#从键盘获取数据
send_data = input("请输入要发送的数据:")
#用套接字收发数据,将接收到的数据转为utf-8的编码格式(字节类型)
udp_socket.sendto(send_data.encode("utf-8"),("ip地址",port端口号))
#关闭套接字
udp_socket.close()

```

 ### 接收数据

```python
from socket import *
#创建套接字
udp_socket = socket(AF_INET,SOCK_DGRAM)
#绑定本地的相关信息,如果一个网络程序不绑定,则系统会随机分配
local_addr = ('',8888)#IP地址和端口号,IP一般不用写,表示本机的任何一个ip
udp_socket.bind(local_addr)  # 绑定的数据为元组
#等待接收对方发送的数据
recv_data = udp_socket.recvfrom(1024)#1024表示本次接收的最大字节数
#将接收到的数据(元组)解包
recv_msg = recv_data[0]  # 存储接收的数据
send_addr = recv_data[1]  # 存储发送方的地址信息 
#显示接收到的数据//格式化接收到的数据
print(recv_data[0].decode('gbk')) // 
print("%s:%s"%(str(send_addr),recv_msg.decode("gbk")))

#关闭套接字
udp_socket.close()

```

