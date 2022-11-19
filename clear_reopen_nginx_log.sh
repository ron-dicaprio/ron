#!/bin/bash

HISTORY_DAY=$1

if [[ ${HISTORY_DAY} == "" ]];then
	HISTORY_DAY=180
fi

RM="/usr/bin/rm"
if [[ -f /usr/bin/sys_rm ]];then
    RM="/usr/bin/sys_rm"
fi

DOCKER=/usr/bin/docker

NGX_PIDS="-1"
NGX_CONTAINER_UUIDS=-1
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

TIME=$(date +%H_%M_%S)

LOG_BASE_PATH="/var/DockerVolumes/log"

ACCESS_DATE_LOG="access_${YEAR}${MONTH}${DAY}_${TIME}.log"
ACCESS_DATE_LOG_TAR_GZ="access_${YEAR}${MONTH}${DAY}_${TIME}.log.tar.gz"

ERROR_DATE_LOG="error_${YEAR}${MONTH}${DAY}_${TIME}.log"
ERROR_DATE_LOG_TAR_GZ="error_${YEAR}${MONTH}${DAY}_${TIME}.log.tar.gz"

function get_ngx_info()
{
    NGX_CONTAINER_UUIDS=$(${DOCKER} ps  | grep "epoint.*.nginx" | awk '{print $NF}')

    if [[ ${NGX_CONTAINER_UUIDS} != "" ]];then
        NGX_PIDS=$(ps -ef | grep "nginx: master" | grep -v grep | awk '{if($3 != 1) print $2}')            
    fi
}

function mv_history_log()
{
    for cntr_uuid in ${NGX_CONTAINER_UUIDS}
    do
		# mv history log
        LOG_PATH=$(find /var/DockerVolumes/log/ -maxdepth 5 -name "${cntr_uuid}" | grep -v "log/${cntr_uuid}")
		
		mv ${LOG_PATH}/access.log ${LOG_PATH}/${ACCESS_DATE_LOG}
		mv ${LOG_PATH}/error.log ${LOG_PATH}/${ERROR_DATE_LOG}
    done
}

function archive_clear_history_log()
{
    for cntr_uuid in ${NGX_CONTAINER_UUIDS}
    do
        LOG_PATH=$(find /var/DockerVolumes/log/ -maxdepth 5 -name "${cntr_uuid}" | grep -v "log/${cntr_uuid}")
        
		# archive and compress  history log
		tar -zcvf ${LOG_PATH}/${ACCESS_DATE_LOG_TAR_GZ} ${LOG_PATH}/${ACCESS_DATE_LOG}
		sha256sum ${LOG_PATH}/${ACCESS_DATE_LOG_TAR_GZ} > ${LOG_PATH}/${ACCESS_DATE_LOG_TAR_GZ}.sha256sum
		tar -zcvf ${LOG_PATH}/${ERROR_DATE_LOG_TAR_GZ} ${LOG_PATH}/${ERROR_DATE_LOG}
		sha256sum ${LOG_PATH}/${ERROR_DATE_LOG_TAR_GZ} > ${LOG_PATH}/${ERROR_DATE_LOG_TAR_GZ}.sha256sum
		
		# delete history log before 30 days
		find ${LOG_PATH} -mtime +7 -type f -name "*.log"  -exec ${RM} -rf  "{}" \;
		find ${LOG_PATH} -mtime +${HISTORY_DAY} -type f -name "*.tar.gz"  -exec ${RM} -rf  "{}" \;
		find ${LOG_PATH} -mtime +${HISTORY_DAY} -type f -name "*.sha256sum"  -exec ${RM} -rf  "{}" \;
	done
}

function reopen_ngx_log()
{
    for ngx_pid in ${NGX_PIDS}
    do
        kill -s USR1 ${ngx_pid}
    done
}


#-----------main-----------

get_ngx_info

if [[ ${NGX_PIDS} != "-1" ]];then
    mv_history_log
    reopen_ngx_log
	archive_clear_history_log
fi

