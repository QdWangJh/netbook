cat /etc/redhat-release  查看系统版本号
重启Linux系统主机并出现引导界面时，按下键盘上的e键进入内核编辑界面
在linux16参数这行的最后面追加“rd.break”参数，然后按下Ctrl + X组合键来运行修改过的内核程序
mount -o remount,rw /sysroot
chroot /sysroot
passwd
touch /.autorelabel
exit
reboot


常用的RPM软件包命令
安装软件的命令格式
rpm -ivh filename.rpm
升级软件的命令格式
rpm -Uvh filename.rpm
卸载软件的命令格式
rpm -e filename.rpm
查询软件描述信息的命令格式
rpm -qpi filename.rpm
列出软件文件信息的命令格式
rpm -qpl filename.rpm
查询文件属于哪个RPM的命令格式
rpm -qf filename


常见的Yum命令

命令
作用
yum repolist all
列出所有仓库
yum list all
列出仓库中所有软件包
yum info 软件包名称
查看软件包信息
yum install 软件包名称
安装软件包
yum reinstall 软件包名称
重新安装软件包
yum update 软件包名称
升级软件包
yum remove 软件包名称
移除软件包
yum clean all
清除所有仓库缓存
yum check-update
检查可更新的软件包
yum grouplist
查看系统中已经安装的软件包组
yum groupinstall 软件包组
安装指定的软件包组
yum groupremove 软件包组
移除指定的软件包组
yum groupinfo 软件包组
查询指定的软件包组信息

crt连接上传下载包安装
yum -y install lrzsz

which 文件名

搜索命令所在路径及别名

whereis 命令名

#搜索命令所在路径及帮助文档所在位置

选项：

 -b :只查找可执行文件位置

 -m:只查找帮助文件