#!/bin/bash
hostip=$1

# 验证root
if [ `id -u` -eq 0 ];then
  echo -e "The Install is Root"
else
  echo -e "The Install is Not Root"
  exit
fi


# 判断脚本后是否加了多个参数
if [ $# != 1 ];then
    echo "Usage: Input parameter, Example: sh $0 [hostip]"
    exit 1
fi

# echo 开始扫描信息
echo "start scan $1....."

# 初始化
init=`shodan init PcqQdivwaWRGASbd6JYcNXYh7vnb3EUD`
# 打印结果
echo `shodan host $1 \n`

echo `nmap -sS $1 \n`
