shell 获取mysql中的值赋值变量

```shell
select_sql="select max(UPDATE_TIME) from TB_XBT_ORIGINA_LOG_UP;"

db_data=`mysql -h 10.10.0.138 -P3306 -uhadoop -pRfx,1118Ys  xbtserial -Bse "${select_sql}"`

echo $db_data
```

