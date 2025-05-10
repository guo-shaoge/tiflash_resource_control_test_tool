#!/bin/bash

sleep 300 && sh ./high.change.sh && \
    sleep 300 && sh ./periodically.change.sh && \
    sleep 300 && sh ./burstable.change.sh && \
    sleep 300 && sh ./priority.change.sh
