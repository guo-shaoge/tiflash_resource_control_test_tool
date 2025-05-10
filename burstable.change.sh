#!/bin/bash

sh ./high.sh &

# rgs1/rgs2/rgs3 all 1.4M RU_PER_SEC non-busrtable
# rgs1/rgs2/rgs3 all lower RU_PER_SEC
# rgs1 burstable
# rgs2 burstable
# rgs1 non burstable
sleep 30 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=10000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=20000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=40000;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 BURSTABLE;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 BURSTABLE;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 BURSTABLE = OFF;' && \
sleep 300 && pkill -f 'sh ./high.sh'
