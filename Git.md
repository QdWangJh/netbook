### 本地测试路径
`E:\Git\master`

### 查看git版本
```shell
git --version
```

### 版本控制流程
- 进入目录
- 初始化
```shell
git init
```
- 管理
```shell
git status  -- 检测当前文件夹下文件的状态
git add file_name
git add .  -- 将没有管理的文件全部进行管理

```
- 个人信息配置: 用户名 邮箱 (一次)
```shell
git config --global user.name "name"
git config --global user.email "email@.com"
```

- 生成版本  -- 没有管理为红色,管理后为绿色
```shell
git commit -m '版本描述信息'  -- 生成为一个版本 将文件从暂存区上传到本地仓库
```
- 版本生成后,无需新建文件,直接在源文件修改,修改完成后再生成版本
- 查看历史版本
```shell
git log
get log --graph --以图形显示
get log --graph --pretty-format:"%h %s" --格式化输出
```
- 回滚
```shell
git reset --hard md5   -- git log 显示的commit的MD5值
```
- 撤回到回滚之前的状态
```shell
git reflog -- 查看历史的版本


git reset --hard 版本号   -- git relog 指定版本的hash值 例:f9b3a8c 

```
- 不常用更改版本命令
```shell
git checkout file_name -- 将工作区修改的文件退回到没有修改前的状态
git reset --soft 版本号 -- 从版本库回滚到缓存区
git reset HEAD  -- 将此次所有误 add 文件从暂存区退回到工作区
git reset HEAD file_name -- 将此次误 add 的文件退回到工作区
```

### git模型图
![](Pasted%20image%2020220726140841.png)

### 分支
- 查看目前所在分支
```shell
git branch
```
- 创建分支
```shell
git branch 分支名
```
- 切换分支
```shell
git checkout 分支名
```
- 合并分支(需先回到主分支)
```shell
git merge 分支名
```
- 删除分支
```shell
git branch -d 分支名
```
- 不同分支数据合并到主分区后,会有冲突被标记出来,解决完成后重新上传


### 将本地分支推送到GitHub
- 先在GitHub上创建仓库获取地址
- 在本地发版
- 建立连接 只需一遍,之后用别名
```shell
git remote add origin github地址  -- origin 连接的别名
```

- 第一次从Github上下载需先克隆
```shell
git clone github地址   -- 第一次克隆
```
- 将分支上传到GitHub
```shell
git push -u origin 分支名
```
- 从GitHub下载到本地
```shell
git pull origin 分支名 -- 更新下载
```
- 输入 github 的token
在github右上角头像处点 Settings ->Developer settings

- 查看连接
```shell
git remote -v
```
- 删除连接
```shell
git remote remove 远程仓库的别名
```

####  问题解决
```sell
# fatal: unable to access 'https://[github].com/XXX/':OpenSSL SSL_read: Connection was reset, errno 10054

解决方法
修改Git不使用[ssl]验证
git config --global http.sslVerify "false"

如果不行需删除账号后重新输入
删除需要去控制面板----凭据保管库里删除
```



### rebase
#### 合并版本
```shell
git rebase -i 版本号  -- 将当前版本与指定的版本进行合并
git rebase -i HEAD~3 -- 将当前版本与之前3个版本进行合并

执行后将提示文本修改
将需要被合并版本前的 pick 改为 s  -- s squash 被合并
修改后:wq保存第一个文件

```
- 修改第二个文件
![](Pasted%20image%2020220726162701.png)
![](Pasted%20image%2020220726162737.png)

- 注意 合并时不要合并已经 push 到仓库的记录 负责会混乱

#### 合并分支版本
- 进入需要被合并的分支
```shell
git checkout 次分支
```
- 合并分支
```shell
git rebase  主分支名 --需要合并到的分支名
git checkout 主分支名
git merge 次分支 
```

#### 合并分支冲突
- 合并分支产生冲突时,解决冲突,解决完成后,继续执行合并
```shell
git rebase --continue
```

### 结合Beyond Compare快速解决冲突
- 在git中配置 --local 只在当前项目有效
```shell
git config --local merge.tool bc4 --指定合并文件的名称(别名)
git config --local mergetool.path 'Beyond Compare/bcomp' --文件路径
git config --local mergetool.keepBackup false --是否保留原文件

```
- 应用
```shell
git mergetool  -- 打开软件解决冲突,完成后保存关闭
```
