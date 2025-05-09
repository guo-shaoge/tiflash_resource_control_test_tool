#!/bin/bash

sh ./high.sh &

# rgs1/rgs2/rgs3 all 1.4M RU_PER_SEC non-busrtable
# rgs1/rgs2/rgs3 all lower RU_PERSEC
# rgs1 burstable
# rgs2 burstable
# rgs1 non burstable
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 RU_PER_SEC=50000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 RU_PER_SEC=100000;' && \
    mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs3 RU_PER_SEC=150000;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 BURSTABLE = true;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs2 BURSTABLE = true;' && \
sleep 600 && mysql -h tidb-1-peer -P 4000 -Dtest -u root -e 'alter resource group rgs1 BURSTABLE = false;' && \
sleep 600 && pkill -f 'sh ./high.sh'

