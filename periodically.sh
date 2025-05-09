#!/bin/bash

sh ./init_rg.sh

# 数据库连接配置
MYSQL_CMD="mysql -h tidb-1-peer -u us1 -p1234 -D test -P 4000"
# cost 40K RU
# LOW_SQL="set tidb_isolation_read_engines = 'tiflash'; set @@tidb_enforce_mpp=1; explain analyze select count(1) from lineitem;"
# cost 127 RU
LOW_SQL="set tidb_isolation_read_engines = 'tiflash'; set @@tidb_enforce_mpp=1; explain analyze select count(1) from lineitem where l_orderkey < 1000000;"
# cost 300K RU
HIGH_SQL="set tidb_isolation_read_engines = 'tiflash'; set @@tidb_enforce_mpp=1; explain analyze select l_returnflag, l_linestatus, sum(l_quantity) as sum_qty, sum(l_extendedprice) as sum_base_price, sum(l_extendedprice * (1 - l_discount)) as sum_disc_price, sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge, avg(l_quantity) as avg_qty, avg(l_extendedprice) as avg_price, avg(l_discount) as avg_disc, count(*) as count_order from lineitem where l_shipdate <= date_sub('1998-12-01', interval 108 day) group by l_returnflag, l_linestatus order by l_returnflag, l_linestatus;"

# 低负载SQL（示例：简单查询）
low_load_sql() {
	for i in {1..5}; do
		one_low_load_sql &
		PID_LOW=$!
		echo "[INFO] 低负载任务已启动，PID: $PID_LOW"
		# 捕获退出信号
		trap "kill $PID_LOW; exit" SIGINT SIGTERM
	done
}
one_low_load_sql() {
    while true; do
        $MYSQL_CMD -e "$LOW_SQL" > /dev/null 2>&1
    done
}

# 高负载SQL（示例：复杂查询）
high_load_sql() {
    # 这里替换成你的高负载SQL语句
    # 示例：SELECT BENCHMARK(1000000,MD5('test'));
    $MYSQL_CMD -e "$HIGH_SQL"> /dev/null 2>&1
}

# # 启动低负载后台任务
low_load_sql &

# 主循环：每分钟触发高负载
while true; do
    sleep 300

    echo "[$(date +'%T')] 启动高负载查询..."

    # 启动20个并发查询（按需调整）
    for i in {1..20}; do
        high_load_sql &
    done
done
