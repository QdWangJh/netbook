
-- 查看目录下文件大小  MB显示
hdfs dfs -du  目录 | awk -F ' '  '{printf "%.2f\t\t%s\n", $1/1024/1024,$3}'