#!/bin/bash

sh ./high.sh &

# rgs1/rgs2/rgs3 all medium
# rgs3 with less RU_PER_SEC
# rgs3 high
# rgs1/rgs2 high
# rgs1/rgs2 low, rgs3 medium
sleep 30 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=50000;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 PRIORITY=HIGH;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 PRIORITY=HIGH;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 PRIORITY=HIGH;' && \
sleep 300 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 PRIORITY=LOW;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 PRIORITY=LOW;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 PRIORITY=MEDIUM;' && \
sleep 300 && pkill -f 'sh ./high.sh'
