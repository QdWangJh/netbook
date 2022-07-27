# 简介

> - Pandas是一个强大的分析结构化数据的工具集
>   - 它的使用基础是Numpy（提供高性能的矩阵运算）
>   - 用于数据挖掘和数据分析，同时也提供数据清洗功能
> - Series
>   - 它是一种类似于一维数组的对象
>   - 是由一组数据(各种NumPy数据类型)以及一组与之相关的数据标签(即索引)组成
>   - 仅由一组数据也可产生简单的Series对象
>   - 用来处理单列数据
> - DataFrame
>   - DataFrame是Pandas中的一个表格型的数据结构
>   - 包含有一组有序的列，每列可以是不同的值类型(数值、字符串、布尔型等)
>   - DataFrame即有行标签(行索引)也有列标签(列索引)，可以被看做是由Series组成的字典
>   - 用来处理结构化数据（SQL数据表，Excel表格）
>   - 可以简单理解为一张数据表(带有行标签和列标签)

# 基本使用



 ## 一 加载数据

### CSV和TSV

>  csv文件每一列的列元素之间以逗号进行分割，tsv文件每一行的列元素之间以\t进行分割。

- 先导入 pandas 包

```python
import pandas as pd
```

- 加载数据

```python
# csv文件
pd.read_csv('path\file_name')

# tsv文件
pd.read_csv('path\name',sep='\t')
```

## 二 数据提取

### DataFrame 的行列标签

```python
# 获取DataFrame的行标签
file_name.index

# 获取DataFrame的列标签
file_name.columns

#设置 DataFrame 的行标签
#DataFrame 设置行标签时,不会改变原有数据,而是返回数据副本
file_name.set_indext('label_name')
```

### loc函数获取指定行列的数据

```python
# 基本格式 语法 根据行标签和列标签获取对应行的对应列的数据，结果为：DataFrame
df.loc[[行标签1,...],[列标签1,..]]

# 根据行标签获取对应行的所有列的数据 结果为：DataFrame
df.loc[[行标签1,...]]

# 根据列标签获取所有行的对应列的数据 结果为：DataFrame
df.loc[:,[列标签1,...]]

# 1）如果结果只有一行，结果为：Series
# 2）如果结果有多行，结果为：DataFrame
df.loc[行标签]

# 无论结果是一行还是多行，结果为DataFrame
df.loc[[行标签]]

# 1）如果结果只有一列，结果为：Series，行标签作为 Series 的索引标签
# 2）如果结果有多列，结果为：DataFrame
df.loc[[行标签],列标签]

# 1）如果结果只有一行，结果为：Series，列标签作为 Series 的索引标签
# 2）如果结果有多行，结果为DataFrame
df.loc[行标签,[列表签]]

# 1）如果结果只有一行一列，结果为单个值
# 2）如果结果有多行一列，结果为：Series，行标签作为 Series 的索引标签
# 3）如果结果有一行多列，结果为：Series，列标签作为 Series 的索引标签
# 4）如果结果有多行多列，结果为：DataFrame
df.loc[行标签,列标签]
```

### iloc函数获取指定行列的数据

```python
# iloc 和 loc 使用方法类似,传入的值为位置下标
df.iloc[[行位置1, ...], [列位置1, ...]]
```

###  loc和iloc的切片操作

```python
# 根据行列标签范围获取对应行的对应列的数据,包括起始行列标签和结束行列标签
df.loc[起始位置行标签:结束行标签,起始列标签:结束列标签]

# 根据行列标签位置获取对应的数据,包含起始行列位置,但不包含结束行列位置
df.iloc[起始行位置:结束行位置,起始列位置:结束列位置]
```

###  []语法,获取指定行列的数据

```python
# 根据列标签获取所有行对应的列的数据,结果为 DataFrame
df[['列标签1','列标签2',....]]

# 根据列标签获取所有行对应列的数据
# 1）如果结果只有一列，结果为：Series，行标签作为 Series 的索引标签
# 2）如果结果有多列，结果为：DataFrame
df['列标签']

# 根据列标签获取所有行对应列的数据,结果为DataFrame
df[['列标签']]

# 根据指定范围获取对应行的所有列的数据,不包括结束行位置
df[起始行位置:结束行位置:步长]
```

## 三 Series和DataFrame

### Series常用操作

```python
# 查看 Series 数据的形状
s.shape

# 查看 Series 数据的个数
s.size

# 查看 Series 数据的行标签
s.index

# 获取 Series 数据的元素值
s.values

# 获取 Series 数据的行标签,和 s.index 效果相同
s.keys()

# 根据行标签获取 Series 中的某个元素数据
s.loc[行标签]

# 根据行位置获取 Series 中的某个元素数据
s.iloc[行标签]

# 查看 Series 数据元素的类型
s.dtypes
```

#### 常用统计方法

```python
# 平均值
s.mean()

# 最大值
s.max()

# 最小值
s.min()

# 标准差 标准差定义是总体各单位标准值与其平均数离差平方的算术平均数的平方根。它反映组内个体间的离散程度
s.std()

# 计算不同元素的个数
s.value_counts()

# 计算非空元素的个数
s.count

# 显示 Series 数据中元素的各种统计值
s.describe()
```



**Series方法(备查)**：

| 方法            | 说明                                 |
| --------------- | ------------------------------------ |
| append          | 连接两个或多个Series                 |
| corr            | 计算与另一个Series的相关系数         |
| cov             | 计算与另一个Series的协方差           |
| describe        | 计算常见统计量                       |
| drop_duplicates | 返回去重之后的Series                 |
| equals          | 判断两个Series是否相同               |
| get_values      | 获取Series的值，作用与values属性相同 |
| hist            | 绘制直方图                           |
| isin            | Series中是否包含某些值               |
| min             | 返回最小值                           |
| max             | 返回最大值                           |
| mean            | 返回算术平均值                       |
| median          | 返回中位数                           |
| mode            | 返回众数                             |
| quantile        | 返回指定位置的分位数                 |
| replace         | 用指定值代替Series中的值             |
| sample          | 返回Series的随机采样值               |
| sort_values     | 对值进行排序                         |
| to_frame        | 把Series转换为DataFrame              |
| unique          | 去重返回数组                         |

#### bool 索引

Series 支持 bool 索引，可以从 Series 获取 bool 索引为 True 的位置对应的数据。



#### Series 运算

| 情况                         | 说明                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `Series 和 数值型数据运算`   | Series 中的每个元素和数值型数据逐一运算，返回新的 Series     |
| `Series 和 另一 Series 运算` | 两个 Series 中相同行标签的元素分别进行运算，若不存在相 同的行标签，计算后的结果为 NaN，最终返回新的 Series |



### DataFrame

#### 创建 DataFrame

1）可以使用字典来创建DataFrame

```python
peoples = pd.DataFrame({
    'Name': ['Smart', 'David'],
    'Occupation': ['Teacher', 'IT Engineer'],
    'Age': [18, 30]
})
peoples
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-50.png)



2）创建 DataFrame 的时候可以使用colums参数指定列的顺序，也可以使用 index 参数来指定行标签

```python
peoples = pd.DataFrame({
    'Occupation': ['Teacher', 'IT Engineer'],
    'Age': [18, 30]
}, columns=['Age', 'Occupation'], index=['Smart', 'David'])
peoples
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-51.png)



3）也可以使用嵌套列表创建 DataFrame，并使用 columns 参数指定列标签，使用 index 参数来指定行标签

```python
peoples = pd.DataFrame([
    ['Teacher', 18],
    ['IT Engineer', 30]
], columns=['Occupation', 'Age'], index=['Smart', 'David'])
peoples
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-52.png)

#### DataFrame 常用操作

| 属性或方法   | 说明                                     |
| ------------ | ---------------------------------------- |
| `df.shape`   | 查看 DataFrame 数据的形状                |
| `df.size`    | 查看 DataFrame 数据元素的总个数          |
| `df.ndim`    | 查看 DataFrame 数据的维度                |
| `len(df)`    | 获取 DataFrame 数据的行数                |
| `df.index`   | 获取 DataFrame 数据的行标签              |
| `df.columns` | 获取 DataFrame 数据的列标签              |
| `df.dtypes`  | 查看 DataFrame 每列数据元素的类型        |
| `df.info()`  | 查看 DataFrame 每列的结构                |
| `df.head(n)` | 获取 DataFrame 的前 n 行数据，n 默认为 5 |
| `df.tail(n)` | 获取 DataFrame 的后 n 行数据，n 默认为 5 |



#### 统计方法

| 方法           | 说明                                         |
| -------------- | -------------------------------------------- |
| `s.max()`      | 计算 DataFrame 数据中每列元素的最大值        |
| `s.min()`      | 计算 DataFrame 数据中每列元素的最小值        |
| `s.count()`    | 统计 DataFrame 数据中每列非空(NaN)元素的个数 |
| `s.describe()` | 显示 DataFrame 数据中每列元素的各种统计值    |

注意：describe 方法默认只显示数值型列的统计信息，可以通过 include 参数设置显示非数值型列的统计信息

```python
import numpy as np
scientists.describe(include = [np.object_])
```



#### DataFrame运算

| 情况                               | 说明                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| `DataFrame 和 数值型数据运算`      | DataFrame 中的每个元素和数值型数据逐一运算， 返回新的 DataFrame |
| `DataFrame 和 另一 DataFrame 运算` | 两个 DataFrame 中相同行标签和列标签的元素分 别进行运算，若不存在相同的行标签或列标签， 计算后的结果为 NaN，最终返回新的 DataFrame |



### Pandas与Python常用数据类型对照：

| Pandas类型 | Python类型 | 说明                           |
| ---------- | ---------- | ------------------------------ |
| object     | string     | 字符串类型                     |
| int64      | int        | 整形                           |
| float64    | float      | 浮点型                         |
| datetime64 | datetime   | 日期时间类型，python中需要加载 |



### bool索引

DataFrame 支持 bool 索引，可以从 DataFrame 获取 bool 索引为 True 的对应行的数据。

```python
book_values = [False, True, True, True, False, False, False, True]
scientists[book_values]
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-60.png)

### 行列标签操作

#### 加载数据后,指定某列数据作为行标签 .set_index()

> 加载数据文件时，如果不指定行标签，Pandas会自动加上从0开始的行标签；可以通过df.set_index('列名') 的方法重新将指定的列数据设置为行标签

```python
tist = pd,read_csv('./filename.csv')
tist
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-65.png)

```python
# 设置 Name 的标签作为行标签
tist_df = tist.set_index('Name')
```

![img](file:///C:/Users/root/Desktop/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E8%AF%BE%E7%A8%8B%E8%B5%84%E6%96%99/pandas%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E8%AE%B2%E4%B9%89/chapter02/images/chapter02-66.png)



#### 重置行标签. reset_index()

设置行标签之后，可以通过 `reset_index` 方法重置行标签：

```
# reset_index 返回的是一个新 DataFrame
```



#### 加载数据 时 ,指定某列数据作为行标签

>
>
>加载数据文件的时候，可以通过通过 index_col 参数，指定使用某一列数据作为行标签，index_col 参数可以指定列名或列位置

例: 加载数据时
