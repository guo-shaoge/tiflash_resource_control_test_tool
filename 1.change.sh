#!/bin/bash
sh ./1.sh &

sleep 900 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=100000;' && \
	sleep 900 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=1000000;' && \
	sleep 900 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=5000;' && \
    sleep 900 && pkill -f 'sh ./1.sh'
