#!/bin/bash
ip_port=10.0.8.15:9200
user=elastic
passwd=sysadmin
args=$1

get_version () {
    # install jq if not exists
    rpm -qa |grep jq > /dev/null || yum install jq -y
    res=`curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/ | jq '.version.number'`
    echo "Current Elasticsearch Version Is $res ."
}

get_indexs() {
    curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/_cat/indices?v
}

get_spec_index() {
    curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/$args/_search?pretty
}

##验证Root
if [ `id -u` -ne 0 ];then
  echo -e "Current User is Not Root. Exit ..."
  exit
fi

if [ $# != 1 ];then
    echo -e ""
    echo -e "Usage:  sh $0 COMMAND"
    echo \
""" 
Common Commands:
  version	get elasticsearch version info.
  indexs	get all elasticsearch index.
  indexname	get spec elasticsearch index info.
"""
    exit 1
fi

case $1 in
	version)
		get_version
		;;
	indexs)
		get_indexs
		;;
	*)
		get_spec_index
		;;
esac
