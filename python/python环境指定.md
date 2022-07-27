#  python运行的环境有多个时,不指定容易出错

## 指定方法

```
# 导入 os 包
import os
# 指定环境所在位置
os.environ['环境名称']='/path'
# 例:
os.environ['SPARK_HOME']='/export/server/spark'
```

