#!/bin/bash

IPADDR=$1
PORT=$2
COUNT=$3
DATE=$(date +%F_%H_%M_%s)

if [ $# != 3 ];then
    echo "Usage: Input parameter, Example: sh $0 [address] [port] [count]"
    exit 1
fi

n=1
while [ $n -le $COUNT ]
do
  nc -zv -w 2 $1 $2 >> $1_$2_$3_$DATE.log 2>&1
  let n++
done
