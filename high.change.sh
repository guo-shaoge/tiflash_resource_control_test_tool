#!/bin/bash

sh ./high.sh &

# rgs1/rgs2/rgs3 1.4M
# rgs1 1.4M, rgs2 2.8M, rgs3 5.6M
# rgs3 50K
# rgs2 70K
# rgs1 70K
# rgs1 5K, rgs2 10K, rgs3 15K
# rgs1/rgs2/rgs3 100K
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=50000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=1400000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=2800000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=5600000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=70000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=70000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=5000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=10000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=15000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=100000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=100000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=100000;' && \
sleep 600 && pkill -f 'sh ./high.sh'
