#!/bin/sh

BACKUP_BIN=/usr/local/mysql/bin/mysqlbinlog
LOCAL_BACKUP_DIR=/root/binlog
BACKUP_LOG=/root/binlog/backuplog
REMOTE_HOST=192.168.188.154
REMOTE_PORT=3306
REMOTE_USER=root
REMOTE_PASS=Gepoint
FIRST_BINLOG=bin.000001

#time to wait before reconnecting after failure
SLEEP_SECONDS=5

##create local_backup_dir if necessary
mkdir -p ${LOCAL_BACKUP_DIR}
cd ${LOCAL_BACKUP_DIR}

## 运行while循环，连接断开后等待指定时间，重新连接
while :
do
  if [ `ls -A "${LOCAL_BACKUP_DIR}" |wc -l` -eq 0 ];then
     LAST_FILE=${FIRST_BINLOG}
  else
     LAST_FILE=`ls -l ${LOCAL_BACKUP_DIR} | grep -v backuplog |tail -n 1 |awk '{print $9}'`
  fi
${BACKUP_BIN} --raw --read-from-remote-server --stop-never --host=${REMOTE_HOST} --port=${REMOTE_PORT} --user=${REMOTE_USER} --pa
ssword=${REMOTE_PASS} ${LAST_FILE}

echo "`date +"%Y/%m/%d %H:%M:%S"` mysqlbinlog停止，返回代码：$?" | tee -a ${BACKUP_LOG}
echo "${SLEEP_SECONDS}秒后再次连接并继续备份" | tee -a ${BACKUP_LOG}
sleep ${SLEEP_SECONDS}
done

#find ${LOCAL_BACKUP_DIR}  -mtime +60 -name "bin.*" -exec rm -rf {} \;

# supervisord.conf
#[program:binlog_backup]
#command=nohup sh /root/backup_binlog.sh