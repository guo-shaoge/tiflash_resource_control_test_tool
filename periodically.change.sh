#!/bin/bash

sh ./periodically.sh &
sleep 1200 && pkill -f 'sh ./periodically.sh'
