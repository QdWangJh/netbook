select table_schema,table_name, (data_length/1024/1024) as data_mb , (index_length/1024/1024) as index_mb,
    ((data_length+index_length)/1024/1024) as all_mb, table_rows
    from information_schema.tables
    where table_schema not in ('mysql','sys','information_schema','performance_schema','test')
    and (data_length/1024/1024)>10    # 查找data大于10M的table信息
    order by table_schema,all_mb desc;