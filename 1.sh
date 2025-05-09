#!/bin/bash

sh ./init_rg.sh

# 启动三个 mysql 连接, 并发跑高负载查询

# 数据库连接配置
MYSQL_CMD1="mysql -h tidb-1-peer -u us1 -p1234 -D test -P 4000"
MYSQL_CMD2="mysql -h tidb-1-peer -u us2 -p1234 -D test -P 4000"
MYSQL_CMD3="mysql -h tidb-1-peer -u us3 -p1234 -D test -P 4000"

# 高负载SQL（请确保SQL语句完整且正确）
HIGH_SQL="set tidb_isolation_read_engines = 'tiflash'; set @@tidb_enforce_mpp=1; explain analyze select l_returnflag, l_linestatus, sum(l_quantity) as sum_qty from lineitem group by l_returnflag, l_linestatus;"

# 持续高负载查询函数
high_load_sql1() {
    while true; do
        $MYSQL_CMD1 -e "$HIGH_SQL" > /dev/null 2>&1
        # 可选：添加短暂休眠以控制压力（如：sleep 0.1）
    done
}
high_load_sql2() {
    while true; do
        $MYSQL_CMD2 -e "$HIGH_SQL" > /dev/null 2>&1
        # 可选：添加短暂休眠以控制压力（如：sleep 0.1）
    done
}

high_load_sql3() {
    while true; do
        $MYSQL_CMD3 -e "$HIGH_SQL" > /dev/null 2>&1
        # 可选：添加短暂休眠以控制压力（如：sleep 0.1）
    done
}


echo "[$(date +'%T')] 启动三个高负载查询进程..."

# 启动三个并发进程，持续运行高负载查询
# high_load_sql1 &
# high_load_sql2 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &
high_load_sql3 &

# 等待所有后台进程（实际上会无限运行）
wait
