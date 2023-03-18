#!/bin/bash
#  Verify ROOT
if [ `id -u` -eq 0 ];then
    echo "Current User Is Root"
else
    echo "Current User Is Not Root. Exit..."
    exit 1
fi
# get image version .
img_ver=`cat /home/sysadmin/img_ver.conf`

# build new img
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/cait/docker-tomcat:v$img_ver.0 -f /data/Dockerfile /data/

# docker registry login .
sudo docker login -u <username> -p <password> registry.cn-hangzhou.aliyuncs.com
# if login .
if [ $? -ne 0 ]; then
    echo "aliyun registry login error!"
    exit 1
else
    echo "aliyun registry login successed!"
fi
# push img to aliyum registry
sudo docker push registry.cn-hangzhou.aliyuncs.com/cait/docker-tomcat:v$img_ver.0
# verify if pushd
if [ $? -ne 0 ]; then
    echo "push img error!"
    exit 1
else
    echo "push img successed!"
fi
# delete img
sudo docker rmi registry.cn-hangzhou.aliyuncs.com/cait/docker-tomcat:v$img_ver.0
# update img next version
sudo echo $((img_ver+1))>/home/sysadmin/img_ver.conf
