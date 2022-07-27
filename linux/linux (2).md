whoami      #显示当前用户
pwd           #显示当前在哪个文件夹下
date         	 #显示当前日期
bc     	#打开计算器   scale=number  小数点后保留几位  quite  退出
ls    	#显示当前目录下的文件
        -l    #显示详细信息
        -a   #显示以 . 开头的隐藏文件
        -s    #显示文件大小
        -d	#查看文件夹信息
clear	#清屏
如果选项为多个字母组成则需要使用 --
cat	#查看文档内容
cat  /etc/shells  #查看shell内容
默认的shell是bash 
按esc后按 . 可以快速的引用上一个命令的后半部分（目录、文件）
ctrl+a  光标跑到最前  ctrl+e光标跑到最后  ctrl+u删除光标前所有 ctrl+k删除光标后所有
history   #显示历史执行过的命令 
ctrl+r   #后面输入历史输入的单词出现历史命令
ctrl+左右键  #一整个单词跳转
ctrl+shirt+t  #打开终端
^命令^命令  #可以将上一条命令中的  命令 部分跟换后执行
ctrl+d   #关闭终端
ln  软连接==快捷方式 
bin   	#存放二进制文件/可执行文件
boot 	#可启动文件/内核
dev 	#存放设备控制文件
etc	#配置文件/服务
home	#用户家目录/用户文件
lib/lib64	#库文件（相当于windows里的dll'文件）
media	#默认挂载点
mnt	#手工挂载点
opt	#源码包
proc 	#运行文件
root	#root用户文件
run	#应用程序
sbin	#系统执行文件
sys	#硬件信息
tmp	#临时文件
uar	#日志、数据库
usr	#所有用户安装的软件都在 
cd	#如果只有cd则返回家目录下  cd~用户进入该用户的家目录下 cd-回到之前所在的目录下
df	#查看挂载信息
touch	#创建文件/如果已存在为更改文件时间
mkdir	#创建文件夹/如果已存在等于重命名功能
	-p   可以同时创建多级文件夹   。。。/。。。
rmdir	#删除文件夹需要为空文件夹
tree 	#查看目录树命令
	安装  rpm  -ivh /run/media/lduan/RHEL-7.。。。。\  ser..../Packages/tree。。。 ||镜像挂载路径
rm	#删除文件
              -rf   #强制删除文件+文件夹
如果文件名字中带有空格则空格处需加  \
cat	#查看文件内容
	-n    #显示行数
	-A    #每行末尾会显示$符号
cp	#复制文件  拷贝多个文件 /文件1  /文件2   目标目录/
	-rf  #将该目录下所有文件强制拷贝
ln   -s        #软连接
date  	#日期
hwclock	#硬件时间
获取帮助////
help	#知道命令是干嘛的，查看具体选项
man	#man<>章节查看的内容
whatis 	#看到一个未知命令，询问命令是干嘛的
pinfo
doc  ////
cal	#日历
>	#重定向    命令 > 文件   将命令执行结果放入文件中显示
	#如果文件已存在会清空之前的数据
 >>	#追加  如果文件中有内容则会在最后加入
	#只能重定向正确的结果
2>  2>>	#只能重定向错误的结果，不能重定向正确的结果，并非单指语法错误包括结果错误
&> &>>	#可以重定向所有的结果 
tr	#转换字符 tr  '原字符' '转换后的字符' 'a-z'  'A-Z'
<	#输入重定向   将文件输入到执行命令中   命令  < 文件
<<	#给文件添加内容   例子  cat >>文件名  <<END（结束关键字可自己定义）
|	#管道  执行完前面再执行后面
；	#两个同时执行
grep	#在一段内容中找到含有某个关键字的行   grep  关键字   文件
	-n显示行数
	^关键字  查找以这个关键字开头的行
	-i   忽略大小写
netstart	#查看运行中的信息
gedit	#打开记事本
 alias	#创建命令别名
file	#查看文件类型
vim	#  /关键字  进入末行模式（查找）a查找上一个  A查找下一个   关键字\c 忽略大小写
	set nu 显示行号
	vim  .vimrc  然后在文件中输入 set  nu  再编辑其他文件就会自动显示行号
	替换：_,_s/需要替换/替换后/g   _ _是数字表示第几行到第几行 g表示这一行所有   /可以用#代替  
	%s/old/new/g       m，n s/old/new/g  注：m和n是数字  $最后一行   .当前行 
	args  显示文件名
	！ls 文件  可以将文件内容考到这个文件里面编辑	
	命令模式中   x  是删除光标文字    
		dd  剪切
		y    复制
		p   黏贴
		u   撤销
		ctrl+r 前进
		r  替换  按一次r之后输入要替换的字母
		ctrl + v —往下移动光标（从第一行到最后一行— shift + i 输入内容（#）———-按两次esc可批		量注释  若取消 光标移到最后一行后按  x
		跳转行数   数字+G gg跳到第一行 GG跳到最后一行
		退出  ZZ	
		分屏  ctrl+w / sp
				////用户管理
 redhat系统下  用户信息存放在  /etc/passwd 用户信息	 一行一个用户
用户名：密码：uid用户编号：gid组号：注释信息：目录：shell
  /etc/shadow 密码信息   哈希函数加密
组信息   /etc/group
useradd	#创建用户
	-c  name  用户全称
	-d   家目录
	-s  shell目录  登录shell
	-G name  附属组  wheel 管理员组
	-g name  加入组
	-u number 指定uid
	-M  不创建家目录 如果创建时没有创建家目录 
    		后续加入 mkdir /home/名字    cd  -a /etc/skel/.[!.]* ~名字/   chown -R 用户名.用户名  ~名字/
userdel  -r   用户名  	#删除用户  并删除家目录

如果创建用户时没有创建密码则该用户处于锁定状态
passwd  用户名   #创建密码
usermod  	#更改用户设置信息
groupadd  #创建组
groupdel	#删除组
groups  用户名	#查看用户属于哪个组
gpasswd -a 用户名  组名  #将用户加入组
              -d	#将用户移除该组
change 	#设置更改密码的时间

文件信息
ls  
-	#普通文件
	d	#目录
	l	#软连接
	b	#设备文件，块文件
	c	#设备文件，字符型文件
	权限：r 读  w 写  x 可执行（目录可以cd进去）
	u用户	g组	o其他
	id  用户   	#查看用户id  组id
	chown	用户( . 组名)	文件	#更改文件所有者（组）
	-R    可以将目录（xx/）里面所有文件一起更改
	chgrp    组  文件	#只更改所有组

	u   +  r
	chomd  	g    -   w  文件名
	o    =  x

 	a

数字表示    r（4）w（2）x（1）
lsattr	#查看隐藏权限
chattr	#添加删除隐藏权限

ps	#查看资源管理器 进程
pstree	#查看进程树
jobs	#查看后台进程
bg  nub	#将后台第几个程序移到前台运行
ctrl+z	#将前台占中程序移到后台使用
kill   -9      %1	#杀死后台第一个程序
      强制 

服务管理

systemctl  start   xx      启动
	stop	   停止
	restart         重启
	reload
	status
	disable	  禁用 /开机不自动启动
sysytemctl  enabled   xx   开机启动
systemctl   list-units	#查看所有服务
	               --type   服务后缀   #查看该后缀名的所有服务
	--files		#查看服务启动类型

?	  
