### 定时调度crontab

#### 语法

```shell

crontab [ -u user ] file
或
crontab [ -u user ] { -l | -r | -e }

说明：
crontab 是用来让使用者在固定时间或固定间隔执行程序之用，换句话说，也就是类似使用者的时程表。

-u user 是指设定指定 user 的crontab 文件，这个前提是你必须要有其权限(比如说是 root)才能够指定他人的crontab 文件。如果不使用 -u user 的话，就是表示设定自己的crontab 文件。

参数说明：
-e : 执行文字编辑器来设定crontab 文件，内定的文字编辑器是 VI，如果你想用别的文字编辑器，则请先设定 VISUAL 环境变数来指定使用那个文字编辑器(比如说 setenv VISUAL joe) 如果文件不存在会自动创建。
-r : 删除crontab 文件
-l : 列出crontab 文件
crontab -ir : 删除 crontab 文件前提醒用户
```

#### 使用:

```shell

crontab -e

0 5 * * * /root/bin/backup.sh

这将会在每天早上5点运行 /root/bin/backup.sh

crontab 文件的格式：

{minute} {hour} {day-of-month} {month} {day-of-week} {full-path-to-shell-script} 

o minute: 区间为 0 – 59 
o hour: 区间为0 – 23 
o day-of-month: 区间为0 – 31  月份中的第几天 
o month: 区间为1 – 12. 1 是1月. 12是12月. 
o Day-of-week: 区间为0 – 7. 周日可以是0或7. 周内第几天

特殊字符：
"*"代表所有的取值范围内的数字，如月份字段为*，则表示1到12个月；
"/"代表每一定时间间隔的意思，如分钟字段为*/10，表示每10分钟执行1次。
"-"代表从某个区间范围，是闭区间。如“2-5”表示“2,3,4,5”，小时字段中0-23/2表示在0~23点范围内每2个小时执行一次。
","分散的数字（不一定连续），如1,2,3,4,7,9。
注：由于各个地方每周第一天不一样，因此Sunday=0（第一天）或Sunday=7（最后1天）。
```

#### 示例:

```shell

Crontab 示例

1. 在 12:01 a.m 运行，即每天凌晨过一分钟。这是一个恰当的进行备份的时间，因为此时系统负载不大。

1 0 * * * /root/bin/backup.sh

2. 每个工作日(Mon – Fri) 11:59 p.m 都进行备份作业。

59 11 * * 1,2,3,4,5 /root/bin/backup.sh

下面例子与上面的例子效果一样：

59 11 * * 1-5 /root/bin/backup.sh

3. 每5分钟运行一次命令

*/5 * * * * /root/bin/check-status.sh

4. 每个月的第一天 1:10 p.m 运行

10 13 1 * * /root/bin/full-backup.sh

5. 每个工作日 11 p.m 运行。

0 23 * * 1-5 /root/bin/incremental-backup.sh

每一分钟执行一次command（因cron默认每1分钟扫描一次，因此全为*即可）

*    *    *    *    *  command
每小时的第3和第15分钟执行command

3,15   *    *    *    *  command
每天上午8-11点的第3和15分钟执行command：

3,15  8-11  *  *  *  command
每隔2天的上午8-11点的第3和15分钟执行command：

3,15  8-11  */2  *   *  command
每个星期一的上午8点到11点的第3和第15分钟执行command

3,15  8-11   *   *  1 command
每晚的21:30重启smb

30  21   *   *  *  /etc/init.d/smb restart
每月1、10、22日的4 : 45重启smb

45  4  1,10,22  *  *  /etc/init.d/smb restart
每周六、周日的1 : 10重启smb

10  1  *  *  6,0  /etc/init.d/smb restart
每天18 : 00至23 : 00之间每隔30分钟重启smb

0,30  18-23  *  *  *  /etc/init.d/smb restart
每一小时重启smb

*  */1  *  *  *  /etc/init.d/smb restart
晚上11点到早上7点之间，每隔一小时重启smb

*  23-7/1  *   *   *  /etc/init.d/smb restart
每月的4号与每周一到周三的11点重启smb

0  11  4  *  mon-wed  /etc/init.d/smb restart
每小时执行/etc/cron.hourly目录内的脚本

0  1   *   *   *     root run-parts /etc/cron.hourly
```

#### 注意

```shell
1.crontab有2种编辑方式：直接编辑/etc/crontab文件与crontab –e，其中/etc/crontab里的计划任务是系统中的计划任务，而用户的计划任务需要通过crontab –e来编辑；

2.每次编辑完某个用户的cron设置后，cron自动在/var/spool/cron下生成一个与此用户同名的文件，此用户的cron信息都记录在这个文件中，这个文件是不可以直接编辑的，只可以用crontab -e 来编辑。

3.crontab中的command尽量使用绝对路径，否则会经常因为路径错误导致任务无法执行。
4.新创建的cron job不会马上执行，至少要等2分钟才能执行，可从起cron来立即执行。
5.%在crontab文件中表示“换行”，因此假如脚本或命令含有%,需要使用\%来进行转义。
```

### 脚本无法执行

```shell
如果我们使用 crontab 来定时执行脚本，无法执行，但是如果直接通过命令（如：./test.sh)又可以正常执行，这主要是因为无法读取环境变量的原因。

解决方法：

1、所有命令需要写成绝对路径形式，如: /usr/local/bin/docker。

2、在 shell 脚本开头使用以下代码：

#!/bin/sh

. /etc/profile
. ~/.bash_profile
3、在 /etc/crontab 中添加环境变量，在可执行命令之前添加命令 . /etc/profile;/bin/sh，使得环境变量生效，例如：

20 03 * * * . /etc/profile;/bin/sh /var/www/runoob/test.sh
```

