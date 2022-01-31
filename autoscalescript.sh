#!/bin/bash
cpuvalue=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
if [ $cpuvalue -gt 59 ]; then
    sleep 10
    if [ $cpuvalue -gt 59]; then
        sleep 10
        if [$cpuvalue -gt 59]; then
        aws autoscaling execute-policy --policy-name "enter policy name" --auto-scaling-group-name "enter autoscalegroup" --metric-value ${cpu-value} --breach-threshold 65

