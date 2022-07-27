# 概念:

## 为什么要学习java

- 使用最广泛,简单易学
- Java是一门强类型的语言
- Java有非常完善的异常处理机制
- Java提供了对于大数据的基础性支持

## 概述

-  Sun公司(Stanford University NetWork): 美国的斯坦福大学)在1995年推出的高级编程语言.

- Java之父: 詹姆斯·高斯林(James Gosling)

- Sun公司在2009年被甲骨文(Oracle)公司给收购了.

## 平台版本

- J2SE : 标准版 其他两个版本的基础 .在JDK1.5的时候正式更名为: JavaSE.

- J2ME: 小型版, 一般用来研发嵌入式程序. 已经被Android替代了. 在JDK1.5的时候正式更名为: JavaME.

- J2EE: 企业版, 一般开发企业级互联网程序. 在JDK1.5的时候正式更名为: JavaEE.

## 特点

- 开源
  - java源代码开放
- 跨平台
  - 用Java代码编写的程序, 可以在不同的操作系统上运行. 
  - 由JVM保证Java程序的跨平台性, 但是JVM本身并不能跨平台.
- 多态
- 多线程
- 面向对象

## 关键字&保留字

关键字:

被JAVA语言赋予了特殊含义的单词

特点: 全部小写,编辑器高亮显示

**保留字**:目前版本中还不是关键字的单词,但**有关键字的作用**,以后的版本中可能会升级成关键字

## 常量

指的是在程序的执行过程中, 其值不能发生改变的量.

### 分类

#### 自定义常量

- final
- static

#### 字面值常量

- 整数常量
- 小数常量
- 字符常量:   字符的意思是说只能有一个值, 而且要用单引号括起来
- 字符串常量     字符串常量值都要用双引号括起来
- 布尔常量
- 空常量 :  null

## 变量

•     在程序的执行过程中, 其值可以在某个范围内发生改变的量就叫变量. 

•     Java中要求一个变量每次只能保存一个数据，而且必须要明确保存数据的数据类型。

•     方式一: 声明变量并赋值. 

数据类型 变量名 = 初始值

•     方式二: 先声明, 后赋值.

 数据类型 变量名

变量名 = 初始值



–       **数据类型：**变量变化的范围就是数据类型

–       **变量名：**每个变量都有一个名字，方便存取。

–       **初始化值：**使用变量前，需要给变量赋值。



## 数据类型

Java是一种强类型语言, 针对于每一个数据都给出了明确的数据类型.

解释:

区分一门语言到底是强类型语言还是弱类型语言的依据是: 看这门语言对数据的数据类型划分是否精细.

如果精细, 则是强类型语言, 如果不精细, 则是弱类型语言. 

### 分类

#### 基本数据类型

四类八种:

- 整型: byte(-128,127)(1字节) ,short(2字节), int (4字节), long(8字节)
- 浮点型: fioat(4字节) , double(8字节)
- 字符型 char(65535)(2字节)
- 布尔型 boolean(1字节)

#### 引用数据类型

数组([ ]), 类(class), 接口, 

## 数据类型转换

byte、short、char-->int-->long-->float-->double

•     自动（隐式）类型转换

指的是**小类型转大类型，会自动提升为大类型，运算结果是大类型.**

**转换规则为:** 

1. 范围小的类型向范围大的类型提升，byte、short、char 运算时直接提升为int 。

2. boolean类型的数据只有true和false这两个, 所以boolean类型的数据不参与类型转换.

•     强制（显式）类型转换

指的是**手动将大类型转换成小类型，运算结果是小类型.**

数据类型 变量名 = （数据类型）要被转换的数据值；

## 数组

**用来同时存储多个同类型元素的容器的**, 那就是: **数组**. 

**格式**

- 动态初始化:我们给定长度, 由系统给出默认初始化值.
  - 数据类型[] 数组名 = new 数据类型[长度];
  - 数据类型 数组名[] = new 数据类型[长度];

- 静态初始化:我们给定初始化值, 由系统指定长度. 
  - 数据类型[] 数组名 = new 数据类型[]{元素1,元素2,元素3};
  - 数据类型[] 数组名 = {元素1,元素2};

**默认值**

1. int类型数组, 元素默认值是: 0

2. double类型的数组, 元素默认值是: 0.0

3. boolean类型的数组, 元素默认值是: false

4. String类型的数组, 元素默认值是: null

>  通过数组名.length的方式, 可以获取数组的长度.

数组内存状态:

![](C:\Users\root\AppData\Roaming\Typora\typora-user-images\数组内存.png)



## 数据结构

```
栈:      先进后出, 后进先出.    栈顶, 栈底.
队列:     先进先出, 后进后出.  队头, 队尾
数组:    查询和修改相对较快, 增删相对较慢.
链表:    查询和修改相对较慢, 增删相对较快.
```





# 基础:

## 注释:

单行注释

```java
// 单行注释
```

多行注释:

```java
/*
多行
多行
*/
```

文档注释(自定义函数注释):

```java
/** 
文档注释
文档注释
	*/
```

## 键盘录入

1. 导包. 包就是文件夹.

**注意**: 

a)     Scanner类是java.util包下的类, 使用之前必须要先导包.

b)     导包的语句是定义在类的上面的, 格式如下:

​		

```java
  import java.util.Scanner;
```



2. 创建Scanner类的对象, 格式为:

暂时先理解为固定格式, 也就是必须这么写.

```java
 Scanner sc = new Scanner(System.in);
```



3. 通过Scanner类的nextInt()方法接收用户录入的数据.

```java
int a = sc.nextInt();   //只接受整数 结束标记 /r/n

int b = sc.nextLine()  //接收字符串 结束标记 /r/n
```

Scanner的细节问题:
    **问题描述:**
        先用nextInt()接收整数, 再用nextLine()接收字符串, 发现字符串无法接收.
    **产生原因:**

   1. nextInt(), nextLine()两个方法结束标记都是 \r\n

   2. nextInt()方法只接收用户录入的整数, 不接收\r\n

   3. 它遗留下来的\r\n被nextLine()识别, 导致 nextLine()方法直接结束.
         **解决方案:**

            1. 重新new一个Scanner对象.

            2. 重新调用一次newLine()方法.

            3. 通过next()方法实现.

            4. 尽量先nextLine(), 然后nextInt()也能解决.

            5. 都用字符串接收, 然后把 字符串形式的整数转成对应的整数.    掌握, 实际开发做法.

                  ```java
                  int num = Integer.parseInt("123");
                  ```

                  



## 选择结构

### if

```java
if(){
}else if(){
} else{
    
}
```

### switch

```java
switch(表达式){
	case 值1:
		语句体1;
		break;
	case 值2:
		语句体2;
		break;
	default:  //表示所有都不匹配时执行
		语句体n;
        break;
}
		
```

####  case穿透

**概述**

在switch语句中，如果case的后面不写break，将出现**case穿透**现象，也就是不会在判断下一个case的值，直接向后运行，直到遇到break，或者整体switch结束。

## 循环结构

### for(一般用在知道循环次数)

```java
for(初始条件1;判断条件2;控制条件3){
	循环体4
}
```

•     死循环for(;;) { }

### while(一般用于循环次数不固定)

```
初始化条件1;
while(判断条件2){
循环体3
控制条件4

}
```

•    死循环 while(true){ }

循环跳转

•     break: 是用来终止循环的, 循环不再继续执行.

•     continue: 用来结束本次循环, 进行下一次循环的, 循环还会继续执行.

## 随机数

```java
Math.random(); //获取0.0 ~ 1.0 之间的数据,不包括1.0
例: 获取20-30之间的整数:  // 可将20
for(int i=0 ;i<10;i++){
	(int)(Math.random()*20+1);
}
* 10 后 int 强转类型可获取整数
+1 可取最后一位  30

```

# 方法( 函数)

将具有独立功能的代码块组织成为一个整体，使其成为具有特殊功能的代码集

### 格式:

```java
// 修饰符    返回值的类型
public static void name(参数类型 参数名1,参数类型 参数名2){
	方法体
	return 返回值
}
```

 格式解释

•     修饰符: 

•     返回值的数据类型: 用于限定返回值的数据类型的.

​        注意: 

1. 返回值的数据类型是int类型, 则说明该方法只能返回int类型的整数.

2. 如果方法没有具体的返回值, 则返回值的数据类型要用**void**来修饰.

•     方法名: 方便我们调用方法.

•     参数类型: 用于限定调用方法时传入的数据的数据类型.

​        例如: 参数类型是String类型, 说明我们调用方法时, 只能传入字符串.

•     参数名: 用于接收调用方法时传入的数据的变量. 

•     方法体: 完成特定功能的代码.

•     return 返回值: 用来结束方法的, 并把返回值返回给调用者. 

​        解释: 如果方法没有明确的返回值, 则return关键字可以省略不写. 

###  注意事项

1. 方法与方法之间是平级关系, 不能嵌套定义.

2. 方法必须先创建才可以使用, 该过程称为: 方法定义.

3. 方法自身不会直接运行, 而是需要我们手动调用方法后, 它才会执行, 该过程称为方法调用.

4. **方法的功能越单一越好**. 

5. 定义方法的时候写在参数列表中的参数, 都是: 形参. 

​        形参: 形容调用方法的时候, 需要传入什么类型的参数.

6. 调用方法的时候, 传入的具体的值(变量或者常量都可以), 叫实参. 

​        实参: 调用方法时, 实际参与运算的数据.

### 方法的好处:

​    提高代码的 复用性.

### 形参传值

1. 基本类型作为形参时, 传递的是数值, 所以形参的改变对实参没有任何影响.

2. 引用类型作为形参时, 传递的是地址值, 所以形参的改变直接影响实参.

### 方法重载

方法重载**简介**:
    概述:

- 同一个类中, 出现方法名相同, 但是参数列表不同(个数不同, 对应的数据类型不同.)的 两个或者以上的方法时, 称为方法重载.
- 方法重载与返回值的数据类型无关.
   应用场景:
- 用来解决功能相似或者相同, 但是方法名不能重名的问题.

```
定义时 用相同的方法名,()中的参数,数据类型,个数不同
使用时 直接使用,传入的实参符合定义中的任意一组条件即可
```



# 面向对象



####   类和对象详解

**类:** 是属性和行为的集合, 是一个抽象的概念, 看不见, 也摸不着.

**对象:** 是类的具体体现, 实现. 

**属性:** 也叫字段, 成员变量, 就是事物的描述信息(名词).

**行为:** 也叫成员方法, 指的就是事物能够做什么.

#### 类的定义格式

  简述

定义类其实就是**定义类的成员(成员变量和成员方法)**

•     成员变量:

1) 和以前定义变量是一样的, 只不过位置发生了改变, 写到**类中, **方法外

2) 而且成员变量还可以不用赋值, 因为它有默认值. 

•     成员方法: 

1) 和以前定义方法是一样的, 只不过把static关键字去掉.

##### 格式

```java
public class 类名 {
//成员变量, 私有化, 类似于Python中的 __
//构造方法, 空参, 全参, 类似于Python的魔法方法之 __init__(self)
//getXxx(), setXxx()方法, 用来获取或者设置对象的属性值的
//成员方法, 就是普通的函数
}
```

##### 使用类中成员的格式

```java
1.	创建该类的对象, 格式如下: 
 	类名 对象名 = new 类名();
2.	通过对象名.的形式, 调用类中的指定成员即可, 格式如下: 
 	//成员变量
 	对象名.成员变量
 	//成员方法
 	对象名.成员方法(参数列表中各数据类型对应的值...)
```



#### 封装:

​    概述:
​        封装就是隐藏对象的属性和实现细节, 仅对外提供一个公共的访问方式.

设置时

```java
public class 类名{
	private 数据类型 属性名   //1.设置私有属性 private 定义私有属性,调用需要 getXxx() 和 setXxx()方法
        
    //对外提供公共的访问方式.
    //赋值    
    public 返回值类型 set属性名{ // 2.设置方法中的私有属性限制
        this.属性名;    // 对属性做修改限制
    }
    //取值
    public 返回值类型 get属性名{	// 3.设置私有属性的返回值
    	return 属性;
    }
    //行为, 动词, 成员方法, 和以前定义方法一样, 先不写static.
    public 返回值类型  方法名 {
    }   
}
```

使用时    

```java
 //有main方法的类, 目前一般都是: 测试类.
public static void main(String[] args) {
	//1. 创建对象.
	类名 对象名 = new 类名();
	//2. 使用对象 / 注:成员变量都有默认值
	对象名.属性
    // 使用私有属性
        对象名.set私有属性() //给属性赋值
        对象名.get私有属性() //获取属性值
    // 调用类中方法
        对象名.方法名("实参")
```



 Q1: 怎么隐藏?
    A1: 可以通过 private 关键字实现, 被它修饰的内容只能在本类中直接访问.

​    Q2: 公共的访问方式是什么?
​    A2: 指的是 getXxx() 和 setXxx()方法.

Q3: 封装的好处是什么?
    A3: 提高代码的安全性(private保证), 提高代码的复用性(方法).

​    Q4: 封装的弊端是什么, 针对于private来讲?
​    A4: 代码的冗余度增加了.

​    Q5: 目前我们在setPrice()方法中是没有做到见名知意的, 只是传入了一个p, 那如何解决这个问题呢?
​    A5: 通过 this 关键字解决, 它是用来解决局部变量和成员变量重名问题的.
​        this关键字解释: 它表示当前对象的引用, 谁调用, 它就代表谁.



##### 构造方法  

idea中构造空参\全参的快捷键 alt+instert

概述:
    主要是用来创建对象的, 捎带着可以给对象的属性赋值.

​	**构造方法就是用来快速对对象的各个属性赋值的.** 

格式:

```java
public class 类名{
  	private 属性 // 属性全部私有
//空参构造  // 如果不写构造,系统会默认给添加一个空参
public 类名(){
    }

//全参构造   //全参构造 在调用时 不需要再调用 set 直接将实参传入 调用 get 即可
public 类名(形参) {
        this.形参 =    //给形参赋值
    }
}
```

**建议：因为可能涉及到自类调用,所以建议永远给出无参构造方法。**

特点:

    1. 构造方法名必须和类名**完全一致, 包括大小写**.
    2. 构造方法没有返回值, 连void都不能写.
    3. 构造方法中可以有return.
    4. 构造方法可以重载.
    5. 如果我们不写构造方法, 系统会默认给一个空参构造, 如果我们写了, 系统就不给了.
    6. 创建对象的格式可以优化为:
        类名 对象名 = new 构造方法名(值1, 值2...);

##### 构造方法的注意事项

1.    如果我们没有给出构造方法, 系统将给出一个默认的**无参构造**供我们使用. 

2. 如果我们给出了构造方法, 系统将不再提供默认的构造方法给我们使用. 
   1.  这个时候, 如果我们还想使用无参构造, 就必须自己提供.
   2. **建议定义类时, 我们给出无参构造, 方便用户调用(实际开发都这么做的).**

#####   private关键字

- private是一个关键字, 也是访问权限修饰符的一种, 它可以用来修饰类的成员(成员变量和成员方法).
- 被private修饰的内容只能在本类中直接使用.

应用场景

-  在实际开发中, 成员变量基本上都是用private关键字来修饰的.
- 如果明确知道类中的某些内容不想被外界直接访问, 都可以通过private来修饰.

##### this关键字

- this代表本类当前对象的引用, 大白话翻译: 谁调用, this就代表谁.
- 用来解决局部变量和成员变量重名问题的.

##### Java中使用变量的规则

- Java中使用变量遵循就近原则, 局部有就使用, 没有就去本类的成员位置找,
  有就使用, 没有就去父类的成员位置找, 有就使用, 没有就报错.
- 这里不考虑父类的父类这种情况,因为会一直找下去, 直至找到Object类.

#### 继承

概述:
    实际开发中, 我们发现好多类中的部分内容是相似的或者相同的, 每次写很麻烦, 针对于这种情况, 我们可以把这些相同(相似)的内容抽取出来,然后单独的定义到一个类中, 然后让那多个类和这个类产生关系, 这个关系就叫继承, Java中, 继承用 **extends** 关键字表示.

##### 格式:

​        

```java
class A extends B {    //子承父业
        }
    叫法:
        类A: 子类, 派生类
        类B: 父类, 基类, 超类.
            
        // 空参调用父类构造方法
        //super();  子类所有构造方法的第一行, 默认都有一个super()访问父类的空参.
       public A (){
            super()
        }

		// 全参调用
		public A(形参){
            super(与父类相同的形参)
        // 调用非私有属性
            
```

​    **好处**:

        1. 提高代码的复用性.
        2. 提高代码的可维护性.
        3. 让类与类之间产生关系, 是多态的前提.
        弊端:
                类与类之间的耦合性太强了.
                开发原则: 高内聚, 低耦合.

   **承关系中成员的特点**:   记忆.
        成员变量:
            就近原则.
        构造方法:
            子空参访问父空参, 子全参访问父全参.
        成员方法:
            就近原则.

**细节**:

    1. 子类只能继承父类的**非私有成员(构造方法也不能继承).**
    2. 为什么会有方法重写?
        当子类需要沿袭父类的功能, 但是功能主体又有自己额外需求的时候, 就可以考虑使用方法重写.

方法重写解释:
    **子父类间, 子类出现和父类一模一样的方法叫方法重写.**
    **包含返回值的类型都必须一致.**

  总结

1. 子类中所有的构造方法默认都会访问父类的空参构造.

​        问: 为什么这样设计呢?

​        答: 用于子类对象访问父类数据前, 对父类数据进行初始化. 

​        即: 每一个构造方法的第一条语句默认都是: super()

2. 如果**父类没有空参构造, 我们可以通过super(参数)的形式访问父类的带参构造.**

​        解释: **但是这样做比较繁琐, 所以建议我们定义类时, 永远手动给出空参构造**. 







#### 多态

概述:
    多态指的是 同一个事物 在不同时刻表现出来的不同形态, 状态. 例如: 水(气体, 液体, 固体)
示例:
    Animal an = new Cat();  //猫是动物, 这个是多态.
    Cat c = new Cat();      //猫是猫, 这个不是多态.

##### 前提:

   1. 必须有继承或者实现关系.

   2. 必须父类(父接口)引用指向子类对象.

   3. 必须有方法重写, 不然多态无意义.

    多态中的成员方法特点:
      **成员变量: 编译看左, 运行看左.
      成员方法: 编译看左, 运行看右.**

  







**多态的好处:**
      父类型可以作为方法的形参类型, 这样可以接受其任意的子类对象.
      根据多态的成员方法调用规则"编译看左, 运行看右"传入什么对象, 就掉谁的方法.

**多态的弊端:**
      父类引用不能直接使用子类的特有成员.

 如何解决?
​ 向下转型.

​    Animal an = new Cat();     //向上转型
​    Cat c = (Cat)an;                  // 向下转型

**小Bug**

//下述代码会报: ClassCastException(类型转换异常)
 Animal an = new Cat();
 Cat c = (Cat)an;    //这样写不报错.
 **Dog** d = (**Dog**)an;      //这样写会报错.

##### 格式

```java
子类:
public class A extends B{
	@Override 
    public void 方法(){  // 方法名与父类需要重写的方法相同
    }
    public void 子类自有方法(){
    }
}

调用函数:
	public static void main(String[] args) {
        B  成员变量b = new A(); //向上转型
    // 使用子类特有成员
        A 成员变量a = (A) 成员变量b  // 向下转型
```

###  final关键字

**概述**

final是一个关键字, 表示最终的意思, 可以修饰类, 成员变量, 成员方法. 

•     修饰的类: 不能被继承, 但是可以继承其他的类. 

•     修饰的变量: 是一个常量, 只能被赋值一次. 

•     修饰的方法: 不能被子类重写. 

```java
格式
public final class 类名{ //不能被继承
    public final void 方法名() { //不能被子类重写.
        final int 变量 =  ; //只能被赋值一次.
    }
}
```

###  static关键字

static是一个关键字, 表示静态的意思, 可以修饰成**员变量, 成员方法**. 

**特点**

1. 随着类的加载而加载.

2. 优先于对象存在.

3. 被static修饰的内容, 能被该类下所有的对象共享.

​        解释: 这也是我们判断是否使用静态关键字的条件. 

4. 可以通过 **类名.** 的形式调用.

######  静态方法的访问特点及注意事项

•     访问特点

​        静态方法只能访问静态的成员变量和静态的成员方法.

​        简单记忆: 静态只能访问静态. 

•     注意事项

1. 在静态方法中, 是没有this, super关键字的. 

2. 因为静态的内容是随着类的加载而加载, 而this和super是随着对象的创建而存在. 

​        即: 先进内存的, 不能访问后进内存的. 





### 抽象类

抽象类解释:
    概述:
        有抽象方法的类一定是抽象类, 抽象用 abstract 修饰.
        抽象方法: 没有方法体的方法叫抽象方法.

```java
// 定义时
public abstract class 类名

{

abstract int 方法名(int x,int y);

}
// 调用时
public class A extend B{
    @Override   // 调用抽象类
    public int 方法名(int x,int y){
    重写抽象方法
    }
}
```

**抽象的方法没有方法体**。需要注意的是在抽象类中既可以有抽象方法，也可以有普通方法，注意抽象方法是没有方法体的（也就是方法后面是没有大括号的）。凡是**继承这个抽象类的实体子类，都必须要实现这个抽象方法**。

​    特点:
​        1. 抽象用 **abstract** 修饰.
​        2. 有抽象方法的类一定是抽象类, 反之则不一定.
​        3. 抽象类不能直接实例化.
​        4. 抽象类的子类:
​            如果是普通类: 必须重写父类中所有的抽象方法.
​            如果是抽象类: 可以不用重写.

​    成员特点:
​       专业版: 变量, 常量, 构造方法, 静态方法, 非静态方法, 抽象方法.
​       大白话版: 比普通类多一种抽象方法, 且还可以不写.

**思考:**  既然抽象类不能实例化, 那要构造方法有什么用?

**答:**  用于子类对象访问父类数据前, 对父类数据进行初始化. 

扩展: 假如部分的猫经过循环, 学会了 飞, 请问, 飞这个功能应该定义到哪里?
答案: 通过 接口 实现.

记忆:
    抽象类(亲爹): 定义整个继承体系的 **共性内容**.
    接口(干爹): 定义整个继承体系的 **扩展内容**.



### 接口

概述:
        比抽象类更加抽象, 里边有且**只能有抽象方法和常量**.
    特点:

        1. 接口用 **interface** 修饰.
        2. 类和接口之间是实现关系, 用 **implements** 修饰.
        3. 接口不能实例化.
        4. 接口的子类:
            如果是普通类: 必须重写父类中所有的抽象方法.
            如果是抽象类: 可以不用重写.

类和接口的关系:
    类与类:
        继承关系, 只能单继承, 不能多继承, 但是可以多层继承.
    类与接口:
        实现关系, 可以单实现, 也可以多实现, 还可以在继承一个类的同时实现多个接口.
    接口与接口:
        继承关系, 可以单继承, 也可以多继承.

```java
//定义接口类
public interface A{
	void B()// 普通类 必须重写
	// 抽象类可以不用重写
}
// 调用接口
public class C implements A {
	@Override
    public void B(){
    //重写接口的普通类
    }
}
```



# 可变参

```java
 概述:
     JDK1.5的特性, 表示参数个数可变, 多用于方法的 形参列表.
格式:
     数据类型... 变量名
使用场景:
     当某一个方法有多个同类型参数的时候, 且具体个数不明确的时候, 就可以考虑使用可变参.
本质:
     可变参数的本质就是一个: 数组.
细节:

        1. 可变参数表示参数的个数可变, 最少0个, 最多无数个.
        2. 一个方法的形参列表有且只能有1个可变参数, 并且可变参必须放到形参列表的最后.

     例:   
			public static int getSum(int... arr) {}
```







# 匿名内部类

```
概述:
    指的是没有名字的局部内部类.
格式:
    new 类名或者接口名() {
        //重写类中所有的抽象方法
    };
本质:
    专业版: 匿名内部类就是一个继承了类, 或者实现了接口的子类的匿名对象.
    大白话: 匿名内部类的本质是一个 子类对象.
使用场景:
    1. 当对成员方法仅调用一次的时候.
    2. 可以作为方法的实参进行传递.
    
 例
 接口:
 //猫类
public class Cat extends Animal{
    @Override
    public void eat() {
        System.out.println("猫吃鱼!");
    }
}

函数体
//方式2: 匿名对象, 即: 没有名字的对象.
        //new Cat()解释: 就是一个继承了Animal类的子类Cat类的对象, 子类名叫:Cat, 对象名叫: 不知道
        new Cat().eat();
        System.out.println("--------------------");

抽象方法
//自定义Animal类
public abstract class Animal {
    //抽象方法, 吃.
    public abstract void eat();
}
        
 //方式3: 匿名内部类, 本质就是一个 该类(该接口)的子类对象
        //匿名内部类解释: 就是一个继承了Animal类的子类对象, 子类名叫:不知道, 对象名叫: 不知道
        new Animal() {
            //重写类中所有的抽象方法
            @Override
            public void eat() {
                System.out.println("匿名内部类方式创建Animal的子类, 动物会吃!");
            }
        }.eat();

```

```
内部类简介:
    概述:
        类里边还有一个类, 里边那个叫内部类, 外边那个叫外部类.
    格式:
        详见类A
    分类:
        成员内部类:
           定义在成员位置的内部类, 一般是用来对类的功能做延伸的, 多用于底层源码.
        局部内部类:
           定义在局部位置的内部类, 我们用的最多的匿名内部类就是属于 局部内部类.
```







# Lambda

```java
格式:
    (形参列表) -> {
        方法体;
        return 具体的返回值;
    }
案例:
    1. 无参无返回值的方法, Lambda表达式写法.
    2. 有参无返回值的方法, Lambda表达式写法.
    3. 有参有返回值的方法, Lambda表达式写法.

省略模式:
    1. 参数类型可以省略, 但是如果有多个参数的情况下, 不能只省略一个.
    2. 如果只有一个参数的情况下, 则小括号可以省略.
    3. 如果方法体只有一句话, 则: return, {}, ; 都可以省略
```

```
细节:
    Lambda表达式只针对于 有其只能有1个抽象方法的接口有效.
```

使用:











# API

全称叫应用程序编程接口(Application Programming Interface), 本意指的是JDK提供的各种类和接口



### 使用步骤:

    1. 找到你要用的类或者接口.
    2. 看类所在的包, 如果是java.lang包下的类, 可以直接使用, 无需导包, 其它包下的类或者接口, 用之前都需要导包.
    3. 看下类的结构, 知道有哪些父类, 父接口, 子类.
    4. 大概看下类的说明, 别找错类了.
    5. **看下有无构造方法**.
        有: 说明该类的方法基本上都是非静态的, 需要创建对象, 然后通过 对象名. 的方式调用.
        无: 说明该类的方法基本上都是静态的, 通过 类名. 的方式调用.
    6. **调用指定的方法即可**.
        写 方法名();   注意大小写, 不要写错了.
        传参, 方法要什么, 就给什么.
        接收返回值, 方法给什么, 就用什么类型的变量来接收.
    例如: Scanner获取字符串.
        public String nextLine();    获取用户录入的字符串, 结束标记是: \r\n, 能获取整行数据.
        public String next();        获取用户录入的字符串, 结束标记是: \r\n, 但是只能获取空格以前的内容.

### Object类中的成员方法:

概述:
    它是所有类的父类, 所有的类都直接或者间接继承自Object类.

成员方法:

####    toString() 返回该对象的**字符串表示形式**

```java
public String toString()
```

​        返回该对象的**字符串表示形式**, 格式为: 全类名, @标记符, 该对象的哈希码的无符号十六进制形式组成.
​        无意义, 实际开发中, 子类都会重写该方法, 改为打印: 该对象的各个属性值.如何重写呢? 快捷键生成. alt+insert

```java
自己重写Object#toString()
    @Override
    public String toString() {
        return name + ", " + age; //重写成需要的字符串返回格式
    }
```

####     equals()比较两个对象是否相等

```java
public boolean equals(Object obj);
```

​        比较两个对象是否相等(即: 是否是同一个对象), 默认比较的是地址值, 无意义, 实际开发中子类都会重写该方法, 用来比较各个对象的属性值.

```java
@Override
public boolean equals(Object o) {
    //提高效率, 比较两个对象的地址值, 因为有可能要比较的对象是同一个对象,
    //s1.equals(s1)
    if (this == o) return true;

    //提高健壮性, 有可能要比较的两个对象不同同一个类型的对象.  getClass()返回此 Object 的运行时类。
    if (o == null || getClass() != o.getClass()) return false;


    //能走到这里, 说明肯定是: 同一个类的 不同的两个对象.
    //正常的逻辑, 向下转型, 然后依次比较各个属性值.
    Student student = (Student) o;
    if (age != student.age) return false;
    return name != null ? name.equals(student.name) : student.name == null;
}

使用比较
    boolean flag = s1.equals(s2);  //比较两个值是否相同
```

细节(记忆):
    1. 实际开发中, 我们认为, 如果**同一个类的多个对象, 只要属性值相同, 它们就是同一个对象**, 即:
        Student s1 = new Student("刘亦菲", 33);
        Student s2 = new Student("刘亦菲", 33);
       上述两个对象实际开发中, 我们也会认为它们是同一个对象.
    2. 输出语句直接打印对象, 默认调用了该对象的toString()方法.



### getClass()

java内部类 ,返回此Object 的运行时类。返回类型为Class

### String()

概述:
    它是java.lang包下的类, 可以直接使用, 无需导包, 它表示所有的字符串, 每一个字符串都是它的对象.
    

```java
	String s1 = new String("abc");
    String s2 = "abc";      //免new, 语法糖.
```

成员方法:

```java
    "s1".equals("s2")
这个是String重写了Object#equals()方法, 比较字符串的内容是否相同, 区分大小写.  //需要是String类型
    "s1".equalsIgnoreCase("s2")
这个是String独有的方法, 比较字符串的**内容是否相同, 不区分大小写.**//需要是String类型
```

 细节(记忆):

              1. ==的作用
                 比较基本类型: 比较的是 数值.        10 == 20    比较数值.
                 比较引用类型: 比较的是 地址值.      s1 == s2    比较地址值.
              2. String.equals()区分大小写, equalsIgnoreCase()忽略大小写.

### charAt()

从String获取char

```java
String hex="今天是周一！"；

 char a=hex.charAt(0); //通过下标从String中获取char 

在数组中，使用
    String.toCharArray()//返回值为char[]
 可以得到将包含整个String的char数组。这样我们就能够使用从0开始的位置索引来访问string中的任意位置的元素。
```



1. 我们应该明白char是基本的数据类型，而String是一个类，这是两者之间的本质区别
2. char表示字符，定义时使用单引号,只可以存储一个字符。
3. String表示字符串，定义时使用双引号，可以存储一个或多个字符。
  

### 将Char转为String

```java
String s = new String(new char[]{'c'});
   					相当于
char[] c = {'a', 'b', 'c'};
String s = new String(c);

其他方法:
String s = String.valueOf('c'); //效率最高的方法 
String s = String.valueOf(new char[]{'c'}); //将一个char数组转换成String String s = Character.toString('c'); // Character.toString(char)方法实际上直接返回String.valueOf(char) 
String s = new Character('c').toString(); 
String s = "" + 'c'; // 虽然这个方法很简单，但这是效率最低的方法 
// Java中的String Object的值实际上是不可变的，是一个final的变量。 
// 所以我们每次对String做出任何改变，都是初始化了一个全新的String Object并将原来的变量指向了这个新String。 
// 而Java对使用+运算符处理String相加进行了方法重载。 

// 字符串直接相加连接实际上调用了如下方法： 
// new StringBuilder().append("").append('c').toString(); 

```

### length()

返回字符串长度

```java
String.length()
```

### split(String regex)

切割字符串

```java
String s = "91 27 45 38 50"; //定义字符串
String[] arrStr = s.split(" "); //根据（）中的内容，将字符串切割为字符串数组
```

### substring(int start, int end)

截取字符串, 包左不包右.

```java
s.substring(0,10)
```

### replaceAll(String oldStr, String newStr)

替换字符串

```java
s.replaceAll("被替换的字符串","用来替换的字符串");
```







### StringBuilder

概述:
    它表示字符串缓冲区类, 内容是可变的.

**构造方法**

```java
//方式1: 空参.
        StringBuilder sb1 = new StringBuilder();
//public boolean append(Object obj);  添加元素, 返回自身.
        StringBuilder sb2 = sb1.append("abc");
//方式2: 带参, 本质: 把String -> StringBuilder对象.
        StringBuilder sb4 = new StringBuilder("我爱黑马!");
```

#### toString()

将StringBuilder转为String

```java
 //演示: String -> StringBuilder
        String s1 = "abc";
        StringBuilder sb1 = new StringBuilder(s1);
//StringBuilder -> String
        String str = sb1.toString();
```

```
问题: 为什么会有类型相互转换?
答案: 当某个类A想用类B的功能的, 我们可以尝试把类A对象转成 类B对象, 这样就可以调用类B的方法之后, 调用完毕之后, 再转回类A即可.
```



#### reverse()

反转字符串

```java
StringBuilder s = new StringBuilder("");
s.reverse()  //反转字符串,只能在StringBuilder中调用
```



# Arrays工具类

```
概述:
    它是用来操作数组的工具类, 里边定义了大量操作数组元素的方法, 例如: 排序, 转换字符串等.
```

### sort(int[] arr)

对数组排序 , 默认升序

```java
Arrays.sort(arr); //对 int类型的数组排序
```

### toString(数组对象)

把数组转成其对应的字符串表示形式, 例如: int[] arr = [1, 2, 3];  ->  "[1, 2, 3]"

```java
String s = Arrays.toString(arr);
```

```
工具类:
    1. 成员都是静态的.
    2. 构造方法私有化.
```



# 包装类

```
包装类简介:
    概述:
        所谓的包装类指的就是 基本类型对应的引用类型.
    对应关系:
        基本类型        对应的包装类(引用类型)
        byte                Byte
        short               Short
        char                Character
        int                 Integer
        long                Long
        float               Float
        double              Double
        boolean             Boolean
    学习包装类主要目的就是学习 String类型的数据 和 该包装类对应的基本类型之间如何转换, 例如:
        Integer 是用来把 "123" -> 123
        Double  是用来把 "10.3" -> 10.3
        Boolean 是用来把 "false" -> false
```



### Integer

整数包装类

构造方法

```java
//演示如何创建Integer对象.
        //public Integer(int i);          创建Integer对象, 封装: 整数.
        Integer i1 = new Integer(10);
        System.out.println("i1: " + i1);  // 10
//public Integer(String s); 创建Integer对象, 封装: 字符串, 必须是纯数字形式的字符串.
        Integer i2 = new Integer("123");
        System.out.println("i2: " + i2);  // 123

Integer.MIN_VALUE   //-2147483648  int类型的最小值
Integer.MAX_VALUE	//2147483647 int类型最大值
```



使用包装类相互转换字符类型

```java
int 和 String之间如何相互转换:
    int -> String:
        String s = "" + 10;

    String -> Int:
        int num = Integer.parseInt("123");

        Integer类中的方法解释:
            public static int parseInt(String s);  把字符串形式的整数转成其对应的int类型.

记忆(细节):
    1. 所有的包装类(除了Character)都有一个 parseXxx()方法, 用于把字符串数据转成该类型对应的基本类型的数据, 例如:
        int num = Integer.parseInt("123");
        double d = Double.parseInt("10.3");
        boolean flag = Boolean.parseBoolean("true");
    2. String 和 Character之间有特殊的转换方式.
```

###   自动拆装箱

把基本类型的数据封装成其对应的包装类型, 则称之为**装箱**.

```java
Integer i = new Integer(10);  //java se5 之前
```

把包装类型的对象拆解成其对应的基本类型, 则称之为**拆箱.**

**自动装箱:** 就是将基本数据类型自动转换成对应的包装类。

**自动拆箱**：就是将包装类自动转换成对应的基本数据类型

```java
Integer i =10;  //自动装箱
int b= i;     //自动拆箱
```



# Date类

java.util包下的类, 它表示日期类, 可以精确到毫秒, 里边大多数的方法已过时, 已经被Calendar替代了.

 

```java
构造方法:
        public Date();              表示当前时间.
        public Date(long time);     根据时间种子, 获取对应的Date对象, 种子一样, 时间对象也是固定的.

    成员方法:
        public void setTime(long time);      设置时间, 单位: 毫秒.
        Date d2 = new Date(1631180490798L);

        public long getTime();      获取时间, 单位: 毫秒.
	
     	Date d = new Date();
        System.out.println(d);      //Thu Sep 09 17:41:30 CST 2021
        System.out.println(d.getTime());  // 从时间原点1970/1/01 00:00:00, 到现在的时间, 总共有多少毫秒.       

            
            
   细节:

       1. 直接打印Date对象, 格式我们不习惯, 能不能换成我们习惯的格式.
          可以, SimpleDateFormat可以实现.
       2. 翻看API发现Date大多数方法已过时, 被Calendar替代了.
          Calendar: 日历类.
       3. 获取当前时间毫秒值.
          long time = System.currentTimeMillis();
```



### SimpleDateFormat**日期格式化类**

用来格式化和解析日期

格式化(日期 -> 文本), 即: Date -> String

```java
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String result = sdf.format(d);

----------
    2021/09/14 15:02:09
```

 解析(文本 -> 日期), 即: String -> Date

```java
解析, 模板必须和字符串模板一致.
 String s = "2021年09月09日 17:50:02";
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
        Date d2 = sdf2.parse(s);  //这里有异常, 我们先抛出即可.
-------------
    Thu Sep 09 17:50:02 CST 2021
```



### Calendar日历类

```
概述:
    它表示日历类, 是一个抽象类, 里边大多数的方法都是替代 Date类的功能的.
```



```java
成员常量:
    public static final int YEAR;
    public static final int MONTH;
    public static final int DATE;
    public static final int DAY_OF_MONTH;
    public static final int DAY_OF_YEAR;
成员方法:
    public static Calendar getInstance();  获取Calendar类的实例.
    public int get(int field);      根据指定的日历字段, 获取值.
    public int set(int year, int month, int day);  设置时间.
    public void add(int field, int amount);   设置指定字段的偏移量, 往前推3天, 往后推2个月..  //field 设置几就是第几次调用改变,amount则是 正数往后推,负数向前推 ,调用的语句是获取的年就是以年为单位推
```

使用方法

```java
Calendar c = Calendar.getInstance();
 //获取时间字段.
        System.out.println(c.get(Calendar.YEAR));   //2021
        System.out.println(c.get(Calendar.MONTH));  //8, Java中月份范围: 0 ~ 11
        System.out.println(c.get(Calendar.DATE));   //9
        System.out.println(c.get(Calendar.DAY_OF_MONTH));   //9
        System.out.println(c.get(Calendar.DAY_OF_YEAR));    //252
```







# 集合

```java
概述:
        就使用来同时存储 多个 同类型元素的容器, 其长度是 可变的.
    体系:
       Collection:    单列集合顶层接口
  创建:Collection<String> list = new ArrayList<>();
 
泛型:
    概述:
        指定某种具体的数据类型.
    格式:
        <数据类型>
    细节:
        1. 泛型是JDK1.5出来的, 必须是引用类型.
        2. 前后泛型必须一致, 或者后边的泛型可以省略不写(JDK1.7的特性: 菱形泛型 )
        3. 实际开发中, 泛型一般只结合集合一起使用.
        4. 泛型进阶, 泛型分为: 泛型类, 泛型方法, 泛型接口, 这些内容目前了解即可.
        5. 泛型一般用字母: T: type(类型), E: Element(元素), K: key(键), V: value(值) 表示.

细节:
    1. 集合的顶层都是接口(例如: Collection, List, Set, Map), IO流的顶层都是抽象类(InputStream, OutputStream, Reader, Writer)
    2. 集合如何限定里边存储元素的数据类型呢?
        通过 泛型 实现.
    3. 当我们接触一个新的继承体系, 建议采用"学顶层, 用底层的"的方式学习.
        顶层: 是整个继承体系的共性内容, 大家都有.
        底层: 才是具体的体现, 实现.
```

成员方法

```java
成员方法:
   public boolean add(E e) 添加元素.
   public boolean remove(Object obj) 从集合中移除指定的元素.
   public void clear() 清空集合对象
   public boolean contains(Object obj) 判断集合中是否包含指定的元素
   public boolean isEmpty() 判断集合是否为空
   public int size() 获取集合的长度, 即集合中元素的个数
```

## List 集合

```java
概述:
    它属于Collection体系, 是单列集合, 也叫序列, 列表, 元素特点是: 有索引, 可重复, 有序(元素的存取顺序一致).
        List<String> list = new ArrayList<>();
成员方法:
    public void add(int index, E element)
        解释: 在集合的指定位置(索引), 插入指定的元素, 索引越界会报IndexOutOfBoundsException异常.
    public E remove(int index)
        解释: 删除指定索引处的元素, 并返回被删除的元素, 索引越界会报IndexOutOfBoundsException异常.
    public E set(int index, E element)
        解释: 修改指定索引处的元素为指定的值, 并返回修改前的元素, 索引越界会报IndexOutOfBoundsException异常.
    public E get(int index)
        解释: 根据索引, 获取其对应的元素, 索引越界会报IndexOutOfBoundsException异常.
```



```java
List体系独有的遍历方式: get() + size(),   iterator list ->快捷键 itli
```

### 列表迭代器

它指的是ListIterator, 是Iterator接口的子接口, 它独属于List体系, 即: Collection, Set用不了.

```java
 成员方法:
创建:
public ListIterator<E> listIterator()	//根据List集合对象, 获取其对应的列表迭代器对象. 
    ListIterator<String> lit = list.listIterator();
 使用:  
 public booelan hasPrevious();       判断有没有上一个元素.
 public E previous();                如果有, 就获取上一个元素.
```

细节:
    1. 进行逆向遍历之前, 必须进行一次正向遍历.
    2. 正向遍历和逆向遍历必须使用同一个(列表)迭代器.

#### 并发修改异常.

```java
问题描述:
    当我们用普通迭代器遍历集合的同时, 又往集合中添加元素, 就会报并发修改异常. 
    注意这个仅仅是并发修改异常的产生原因之一, 其它情况也可能会出现这个问题, 会解决就行.
产生原因:
    当我们根据 list.iterator()获取普通迭代器对象的时候, 底层会有一个变量记录住此时集合中
    元素的个数, 当集合中实际的元素个数 大于该值的时候, 就会报 并发修改异常.
解决方案:
    方式1: 列表迭代器.
        必须使用列表迭代器自身的添加元素的方法,
    方式2: 普通for循环, 即: get() + size()
        在集合元素最后添加.
    方式3: CopyOnWriteArrayList集合.
    CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
        在集合元素最后添加.
```

例:

```java
遍历集合, 添加元素.
//会产生并发修改异常.
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    判断是否有world, 如果就就加入一个 python
    String s = it.next();
    if ("world".equals(s))
        //删除元素, 不会出现并发修改异常.
        it.remove();
        //添加元素, 报并发修改异常.
        list.add("python");
}
```



### List集合的遍历方式:

```java
 List集合的遍历方式:
        1. 增强for
本质:
     增强for的本质是普通迭代器, 所以使用增强for遍历集合的同时又往集合中添加元素, 也会报 并发修改异常.
         for(数据类型 变量名 : 要遍历的集合或者数组) {
                逻辑代码;
            }
 
        2. 列表迭代器.
        3. 普通for循环.
        4. 普通迭代器.
 */
public class Demo08 {
    public static void main(String[] args) {
        //1. 创建集合对象.
        List<String> list = new ArrayList<>();
        //2. 创建元素对象.
        //3. 把元素对象添加到集合中.
        list.add("hello");
        list.add("world");
        list.add("java");
        //4. 遍历集合.
        //方式1: 普通迭代器
        Iterator<String> it = list.iterator();
        while (it.hasNext()) {
            String s = it.next();
            System.out.println(s);
        }
        System.out.println("---------------------");

        //方式2: 列表迭代器
        ListIterator<String> lit = list.listIterator();
        while (lit.hasNext()) {
            String s = lit.next();
            System.out.println(s);
        }
        System.out.println("---------------------");

        //方式3: 普通for循环
        for (int i = 0; i < list.size(); i++) {
            String s = list.get(i);
            System.out.println(s);
        }
        System.out.println("---------------------");

        //方式4: 增强for
        for (String s : list) {
            System.out.println(s);
        }
    }
```



## set单列集合

```
概述:
    它属于Collection体系, 是单列集合, 元素特点是: 元素无索引, 无序, 唯一.
常用子类:
    HashSet: 底层数据结构采用哈希表(数组 + 链表).
    TreeSet: 底层数据结构采用二叉树, 可以对元素实现自定义排序.
遍历方式:
    1. 增强for.
    2. 普通迭代器.
```



## Map双列集合(字典)

```java
它是双列集合的顶层接口, 键具有唯一性, 值可以重复, 数据结构只针对于键有效.
成员方法:
V put(K key,V value)	   添加元素, 如果键是第一次添加, 就返回null, 如果键是重复添加, 就用新值覆盖旧值,并返回覆盖前的旧值.
V remove(Object key)	        根据键删除键值对元素
void clear()	                移除所有的键值对元素
boolean containsKey(Object key)	判断集合是否包含指定的键
boolean containsValue(Object value)	    判断集合是否包含指定的值
boolean isEmpty()	         判断集合是否为空
int size()	                 集合的长度，也就是集合中键值对的个数
    
public V get(K key);            根据键获取其对应的值.
    .get(key)
public Collection<V> values();  获取所有值的集合.\
    Collection<String> values = hm.values();
public Set<K> keySet();         获取所有键的集合.
    Set<String> keys = hm.keySet();
 
```

#### Map集合的遍历方式.

```java
 根据键找值, 即: 根据丈夫找妻子.
    1. 获取所有键的集合.       Map#keySet()
    2. 遍历, 获取到每一个键.   增强for, 普通迭代器.
    3. 根据键获取其对应的值.    Map#get()
 //实际开发写法   
 for (String key : map.keySet())
        System.out.println(key + " = " + hm.get(key));
```



## Collections工具类



```java
概述:
     它是用来操作集合(包括单列和双列)的工具类, 里边定义了大量针对于集合操作的常用方法.
成员方法:
public static void sort(List list)	将指定的列表按升序排序
public static void reverse(List<?> list)	反转指定列表中元素的顺序
public static void shuffle(List<?> list)	使用默认的随机源随机排列指定的列表

         //Collections.sort(list);     //默认升序
        //Collections.reverse(list);  //反转元素
        //Collections.shuffle(list);    //随机置换, 相当于洗牌.

```





# I/O流

```java
概述:
        指的是Input(输入) / Output(输出), 也叫输入/输出流, 就是用来实现文件传输的.
    应用场景:
        1. 文件上传.
        2. 文件下载.
    分类:
        按照流向分:
            输入流: 就是用来 读取 数据的.
            输出流: 就是用来 写   数据的.
        按照操作分:
            字节流:
                特点:
                   以字节为单位拷贝数据, 能操作任意类型的文件, 也叫万能流.
                分类:
                    字节输入流:   以字节为单位读取数据, 顶层抽象类: InputStream
                        FileInputStream:   基本的字节输入流.
                        BufferedInputStream: 高效的字节输入流.
                    字节输出流:   以字节为单位写数据, 顶层抽象类: OutputStream
                        FileOutputStream:     基本的字节输出流.
                        BufferedOutputStream: 高效的字节输出流.
            字符流:
                特点:
                   以字符为单位拷贝数据, 只能操作纯文本文件.
                   纯文本文件解释: 一个文件能用微软自带的记事本打开, 且里边的内容你也能看懂, 就是纯文本文件.
                分类:
                    字符输入流:   以字符为单位读取数据, 顶层抽象类: Reader
                        FileReader:   基本的字符输入流.
                        BufferedReader: 高效的字符输入流.
                    字符输出流:   以字符为单位写数据, 顶层抽象类: Writer
                        FileWriter:     基本的字符输出流.
                        BufferedWriter: 高效的字符输出流.
记忆:
    1. 实际开发中, 优先使用字符流, 字符流搞不定再考虑使用字节流.
    2. 如果目的地文件不存在, 程序会自动创建(前提: 该文件的父目录必须存在)
    3. 只要出现乱码问题, 原因只有一个: 编解码不一致.
    4. 如果一个类的对象想实现序列化或者反序列化操作, 则该类必须实现 Serializable接口.
```

```java
//1. 创建输出流对象, 关联: 目的地文件.
FileOutputStream fos = new FileOutputStream("path"); //覆盖
FileOutputStream fos = new FileOutputStream("path", true); //追加
 //2. 往文件中写数据.
//方式1: 一次写一个字节.
fos.write(98);
//方式2: 一次写一个字节数组
//写入换行
fos.write("\r\n".getBytes());       //写入换行, 默认用的是: utf-8码表
byte[] bys = {65, 66, 67, 68, 69};      //ABCDE
    fos.write(bys);
//方式3: 一次写一个字节数组的一部分.
  byte[] bys = {65, 66, 67, 68, 69};      //BCD
  fos.write(bys, 1, 3);

//3. 关流, 释放资源.
   fos.close();

写一个1G的空文件
    public static void main(String[] args) throws IOException {
        //1. 创建输出流, 关联目的地文件.
        FileOutputStream fos = new FileOutputStream("d:/abc/房老师&鲁老师.avi");
        //2. 往文件中写数据.
        byte[] bys = new byte[1024];        //1024个字节 = 1KB

        //循环实现
        for (int i = 0; i < 1024 * 1024 * 1; i++) {
            fos.write(bys);
        }

        //3. 释放资源.
        fos.close();
    }
```

### 读取

```java
FileInputStream简介:
    概述:
        它表示基本的字节输入流, 即: 以字节为单位读取数据.
    构造方法:
        public FileInputStream(String path);   关联数据源文件, 如果文件不存在, 会报错.
    成员方法:
        public int read();
            一次读取一个字节, 并返回读取到的内容(例如: 'a' -> 97), 读不到返回-1
        public int read(byte[] bys);
            一次读取一个字节数组, 并将读取到的内容存储到字节数组中, 然后返回读取到的有效字节数(例如: 'a' -> 1), 读不到返回-1
        public void close();     释放资源
```

```java
/1. 创建输入流, 关联: 数据源文件.
 FileInputStream fis = new FileInputStream("day05_lambda&IO&Socket/data/1.txt");
```





# 反射



```java
 概述:
     指的就是在程序的运行期间, 通过类的字节码文件对象 来操作 类中成员(成员变量, 构造方法, 成员方法)的过程.

如何获取某个类的字节码文件对象?
         

方式1: 通过类的 class属性, 一般用于充当 锁对象.
Class<Student> clazz1 = Student.class;


方式2: 通过类的 getClass()方法实现, 一般用于判断两个对象是否是同一个类的对象.
         Student s = new Student();
        Class<? extends Student> clazz2 = s.getClass();
 

方式3: 通过反射的方式实现, 一般用于强制加载某个类的字节码文件进内存.
 Class<?> clazz3 = Class.forName("com.itheima.pojo.Student");


反射案例:
        1. 反射操作类中的构造方法.
        2. 反射操作类中的成员变量.
        3. 反射操作类中的成员方法.
        4. 动态代理, 即: 运行指定配置文件中指定类的指定方法, 目的是告诉大家, 为什么很多框架我们只要配置了配置文件信息, 就会有不同的效果.

反射步骤:
    1. 获取该类的字节码文件对象.
    2. 获取要操作的成员对象(构造器, 成员变量, 成员方法)
    3. 创建该类的实例.
    4. 操作指定的成员.
```

# 哈希值

```
概述:
    就是根据对象的各个属性算出来的一个数字.
特点:
    同一个对象哈希值肯定相同, 不同对象哈希值一般不同.
    
获取:
		.hashCode()
		
 同一个对象哈希值肯定相同, 不同对象哈希值一般不同.
            重地和通话,  儿女和农丰   //hash值相同
```



```
细节:
       1. 实际开发中, 我们认为如果同一个类的不同对象, 只要属性值相同, 那么它们就是同一个对象.
       2. Object#hashCode()方法, 可以获取对象的哈希值, 子类一般都会重写.

```





# 异常

```java
概述:
    Java中, 把所有的非正常情况统称为异常.
分类:
    顶层类: Throwable
        Error:      错误, 大多数和代码无关, 不需要你处理, 绝大多数你也处理不了.
            例如: 服务器宕机, 数据库崩溃.
        Exception:  这个才是我们常说的异常.
            运行时异常: 指的是 RuntimeException及其子类.
            编译期异常: 指的是 非RuntimeException及其子类.
编译期异常和运行时异常的区别是什么?
    编译期异常: 必须处理, 才能通过编译.
    运行时异常: 不处理, 也能通过编译, 但是运行报错.

JVM默认是如何处理异常的?
    1. 会把异常的类型, 原因, 位置打印到控制台上.
    2. 并终止程序的执行.

异常的处理方式:
    方式1: 声明抛出异常, throws
        大白话翻译: 告诉调用这里, 我这里有问题, 谁调用, 谁处理.
        处理之后, 程序终止运行, JVM默认用的就是这个.
            public static void show() throws Exception {}

    方式2: 捕获异常, 处理之后, 程序继续执行.
        try {
            可能出现问题的代码;
        } catch(Exception e) {
            e.printStackTrace();  //打印异常的类型, 位置, 原因
        } finally {
            释放资源的, 正常情况下, 里边的代码永远会执行.
        }
```



# 冒泡排序.

​    **冒泡排序原理:
​        相邻元素两两比较, 大的往后走, 这样第一轮比较完毕后, 最大值就在最大索引处.**

​    需求:
​        已知数组int[] arr = {25, 69, 80, 57, 13}, 请编写代码对齐进行升序排序.
​        即: 排序后结果为: arr = {13, 25, 57, 69, 80};

​    **核心点:**
​        1. 总共比较几轮?
​            arr.length - 1
​        2. 每轮比较多少次?
​            arr.length - 1 - i
​        3. 谁和谁比较?
​            arr[j] 和 arr[j+1]

​    灵魂三连问:
​        1. 外循环的-1是什么意思?
​            减少比较的总轮数, 节约资源, 提高效率.
​            
​        2. 内循环的-1是什么意思?
​            为了防止出现索引越界异常.
​            
​        3. 内循环的-i是什么意思?
​            减少每轮比较的总次数,节约资源, 提高效率.
​    
​        ```java
​    public class Demo04 {
​                          public static void main(String[] args) {
​                              //额外定义变量, 记录: 循环的总次数.
​                              int count = 0;
​        
                //1. 定义数组, 记录要排序的元素.
                int[] arr = {25, 69, 80, 57, 13};
        
                //2. 定义外循环, 控制: 比较的轮数.
                for (int i = 0; i < arr.length - 1; i++) {
                    //3. 定义内循环, 控制: 每轮比较的总次数.
                    for (int j = 0; j < arr.length - 1 - i; j++) {
        
                        //走到这里, 就是一次判断.
                        count++;
        
                        //4. 正常的比较, 如果前边的元素比后边的元素 大, 就交换位置.
                        if (arr[j] > arr[j + 1]) {
                            //交换变量.
                            int temp = arr[j];
                            arr[j] = arr[j + 1];
                            arr[j + 1] = temp;
                        }
                    }
                }
                //5. 打印结果.
                for (int i = 0; i < arr.length; i++) {
                    System.out.println(arr[i]);
                }
        
                System.out.println("循环总共执行了 " + count + " 次!");
            }
        }
        ```


​        
