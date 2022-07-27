# 一:调用文件操作

```
encoding="UTF-8"(写入方式为utf-8)
open("file","w",encoding="UTF-8")
open()函数是Python的内置函数，负责打开文件，并且返回文件对象
		open()函数的第一个参数是要打开的文件名（文件名区分大小写）
		如果文件存在，返回文件对象
		如果文件不存在，会抛出异常
		open()函数的第二个参数，一般写打开文件方式
这里我们是要写文件，传入参数"w"即代表接下来的操作是要往文件里写内容的
这里我们是要读文件，传入参数"r"即代表接下来的操作是要读取文件中的内容	
```

访问方式:

​		

```
 'w'只写打开,指针在文件开头(覆盖原文),无则创建
 'r'只读打开,指针在文件开头,如果不存在则抛出异常
 'a'以追加打开,指针在文件末尾,无则创建
 'r+'读写方式打开,指针在文件开头,如果不存在则抛出异常
 'w+'读写打开,指针在文件开头(覆盖原文),无则创建
 'a+'读写打开,指针在文件末尾,无则创建
```

​		  

```
read(), write(), close() 三个方法都需要通过文件对象来调用
open()函数返回的文件对象里面有个read()方法可以完成读取文件中的内容的操作
read(num)可以从文件中读取数据
num表示要从文件中读取的数据的长度（单位是字节）
如果没有传入num，那么就表示读取文件中所有的数据
特点：读取整个文件，将文件内容放到一个字符串变量中。
劣势：如果文件非常大，尤其是大于内存时，无法使用read()方法。

readline()方法：可以一次读取一行内容
特点：从字面意思可以看出，该方法每次读出一行内容，所以，读取时占用内存小，比较适合大文件，该方法返回一个字符串对象。方法执行后，会把文件指针移动到下一行，准备再次读取。
缺点：比readlines()慢得多

readlines()方法
特点：读取整个文件所有行，保存在一个列表(list)变量中，每行作为一个元素。
缺点：读取大文件会比较占内存

open()函数默认以只读方式打开文件，并且返回文件对象
也就是说，刚刚我们写的小demo中，用open打开文件时，如果只是想读取文件内容的话，是可以省略"r"这个参数

open()函数返回的文件对象里面有个write()方法可以完成向文件写入数据的操作
close()方法负责关闭文件
如果忘记关闭文件，会造成系统资源消耗，而且会影响到后续对文件的访问
```



## 第一步：以“写入”的方式打开文件

f = open('whoami.txt', 'w')

## 第二步：循环往文件里面写入内容
for i in range(20):
    f.write('我是宇宙超级无敌美少女！\n')

## 第三步：关闭文件
f.close()


什么是文件指针？
文件指针 标记 从文件的哪个位置开始读取数据
第一次打开 文件时，通常 文件指针会指向文件的开始位置
当执行了 read() 方法后，文件指针 会移动到 读取内容的末尾
思考
如果执行了一次read()方法，读取了所有内容，那么再次调用read()方法，还能够获得到内容吗？
答案
不能
第一次读取之后，文件指针移动到了文件末尾，再次调用不会读取到任何内容

二with语句
	with语句:只要把打开文件写成"with … as …"语句的形式，不管程序是否正常运行都会关闭文件，不需要再单独写close()
	# 第一步：以“写入”的方式打开文件
	with open('whoami[with版].txt', 'w') as f:
		

```python
# 第二步：循环往文件里面写入内容
for i in range(20):
    f.write('我是宇宙超级无敌美少女！\n')
```

2. 上下文管理器
前面的代码中，带上“with … as …”后，就不用特意调用close()方法即可自动关闭文件，大大简化了文件操作的步骤。
这其实是因为with语句本质上实现了一个上下文管理器，其作用便是能让文件对象f会在完成自己的任务之后，自动执行自己的close方法。


3.批量复制
打开想要复制的源文件
with open("whoami.txt") as file_read:
    # 读取打开文件中的内容到内存，并保存到content变量中
​    content = file_read.read()
    # 批量复制100份whoami文件，因此重复100次写入动作
​    for i in range(100):
        # 将内存中读取到的内容原封不动写入目标文件，重复100次
​        with open("whoami[复制]{}.txt".format(i), "w") as temp_file:
​            temp_file.write(content)

三OS模块
	os模块是什么？
	os的全称即为operate system，也就是操作系统
	os模块是Python标准库中的一个用于访问操作系统功能的模块
	
```python
虽然不同的操作系统有不同的协议，但使用os模块中提供的接口，就可以很方便地实现跨平台访问
特别是os模块内的os.path 模块，使用频率非常高，主要包含了路径相关的方法：
os.path.exists(path)：如果路径 path 存在，返回 True；如果路径 path 不存在，返回 False。
os.path.isdir(path)：判断路径是否为目录
os.path.isfile(path)：判断路径是否为文件
os.path.join(path1[, path2[, ...]])：把目录和文件名合成一个路径
os.listdir(path):#遍历path下所有文件，包括子目录

详细手册参考官网：https://docs.python.org/zh-cn/3/library/os.html

os.getcwd()：它将返回当前Python程序运行所在的路径，并用字符串表示

os.path.join(第一个, 第二个, 第三个, ……)将路径进行拼接
例如想要表示路径："lesson"文件夹下的"class"文件夹
print(os.path.join("lesson", "class"))

rename()方法对目标文件进行重命名。

# 因为会用到os.listdir()，所以我们先导入os模块
import os

# 用字符串表示的绝对路径，告诉Python解释器你将要对哪个文件夹里的哪些文件进行批量重命名
path = "/Users/yourusername/Desktop/xtlz/昌平校区python44期/机器学习day05/01-视频/"

# os.listdir()会以列表的形式返回某个路径里面的所有文件的文件名
# 用变量file_name保存目标文件夹下的所有文件名
file_name = os.listdir(path)

# 查看file_name中保存的内容
print(file_name)

# 用for循环遍历os.listdir(path)返回的所有文件名
for file in file_name:
# 如果文件名是以"mp4"结尾的，我们就对其进行重命名
	if file[-3:] == "mp4":
		# 给原有文件名添加自己的大名
		# 例如，将"07-什么是线性回归.mp4"重命名为"07-什么是线性回归----MadeByXiaoTuLingZi.mp4"
		after = file[:-4] + "----MadeByXiaoTuLingZi"+".mp4"

		# 原有文件路径
		before_path = os.path.join(path, file)
		# 重名名后的文件路径
		after_path = os.path.join(path, after)

		# 进行重命名
		os.rename(before_path, after_path)
			
字符串中的replace()替换方法，将"----MadeByXiaoTuLingZi"替换为空字符串""，让重命名更简单，代码如下：
import os

path = "/Users/yourusername/Desktop/xtlz/昌平校区python44期/机器学习day05/01-视频/"
file_name = os.listdir(path)

# 想要删掉的部分
want_del = "----MadeByXiaoTuLingZi"

# 用for循环遍历os.listdir(path)返回的所有文件名
for file in file_name:
# 如果文件名中含有我们想要删掉的部分，就进行重命名
if "----MadeByXiaoTuLingZi" in file:
    # 删掉多余部分
    after = file.replace(want_del, "")
    # 重命名前的文件路径
    before_path = os.path.join(path, file)
    # 重命名后的文件路径
    after_path = os.path.join(path, after)
    # 进行重命名
    os.rename(before_path, after_path)

用os.walk()默认实现的就是递归遍历,可以获取到该目录子文件中的信息
import os

for dirpath, dirnames, files in os.walk('./'):
	print(f'发现文件夹：{dirpath}')
	print(files)
```