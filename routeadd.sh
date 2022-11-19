#!/bin/bash
##Date:         2018-12-04
##Author:       Browser
##Description:  intercept packets on assistant
##Version:      1.0

##验证Root
if [ `id -u` -eq 0 ];then
  echo -e "The Install is Root"
else
  echo -e "The Install is Not Root"
  exit
fi

# 定义函数
add_route () {
		route add -net 172.30.100.0 netmask 255.255.255.0 gw 192.168.201.34
	}

del_route () {
		route del -net 172.30.100.0 netmask 255.255.255.0 gw 192.168.201.34
	}

# 添加或删除路由表

case $1 in
	add)
		add_route
		echo "add route successful"
		;;
	del)
		del_route
		echo "del route successful"
		;;
	*)
		echo "Usage: $0 {add|del}"
		exit 1
		;;
esac

exit 0
