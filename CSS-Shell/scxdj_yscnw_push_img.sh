#!/bin/bash
# Verify Parameter 
if [ $# != 3 ];then
    echo "Usage: Input parameter, Example: sh $0 docker pull @cpack_images"
    exit 1
fi

#  Verify Current User
if [ `id -u` -eq 0 ];then
    echo -e "Current User is Root"
else
    echo -e "Current User is Not Root. Exit..."
    exit
fi

if [[ $3 =~ docker.cpack.scsta.com/(.*)/docker-(.*)/(.*):(.*)-([0-9]{8})-([0-9]{6}) ]];then
    echo -e "Parameter Matched, Start Shell..."
else
    echo -e " $3 Match Error, Exit... "
    exit 1
fi

app_version=${3##*/}

TCE_image="ccr.xc01.cloud.scsw.tax/tsf_100004603242/$app_version"

docker login -u admin -p @password docker.cpack.scsta.com
docker pull $3
if [ $? -ne 0 ]; then
    echo "pull image failed"
    exit 1
else
    docker tag $3 $TCE_image

docker login -u 100004603242 -p @password ccr.xc01.cloud.scsw.tax 
if [ $? -ne 0 ]; then
    echo "login error!"
    exit 1
else
    echo "login successed!"
    
docker push $TCE_image
if [ $? -ne 0 ]; then
    echo "push images error!"
    exit 1
else
    echo "push images successed!"

docker rmi $TCE_image
docker rmi $3
