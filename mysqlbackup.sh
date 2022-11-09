#!/bin/bash
## Filename : mysql_backup.sh
## Date     : 2022-11-08
## Author   : caitao <caitao@css.com.cn>
## Desc     : 如果数据库大于50G,请不要使用此脚本

# 环境变量
source /etc/profile
# 设置系统打开文件数,解决高并发下too many open files的问题,只在当前shell有效.
ulimit -HSn 102400

# 定义备份路径
backup_path="/mysqlbackup"

# 定义需要备份的数据库,如pydev和test两个库
db_list="pydev test"
# 用户
MYSQL_USER="root"
# 密码
MYSQL_PASSWORD="@password"
# sockpath. docker下的路径
MySQL_Socket="/var/lib/mysql/mysql.sock"

# sql和log备份文件保留时长,暂定14天
reserve_day=14

# 检查备份目录是否存在,不存在就创建
if [[ ! -d ${backup_path} ]];then
	mkdir -p ${backup_path} 
fi

# 开始for循环
for db in $db_list;do
# 备份日志文件路径 日期没空格不需要引号
dumplog="${backup_path}/${db}_$(date +%Y%m%d%H%M%S).log"
# /mysqlbackup/pydev_20221108220739.log / or use $(date +"%F_%H-%M-%S").log

# 记录备份开始时间  有空格必须引号
startbackuptime=$(date +"%Y-%m-%d %H:%M:%S")
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${startbackuptime} start Backup ${db} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> ${dumplog}

# 开始执行备份
/usr/bin/mysqldump -u${MYSQL_USER} -p${MYSQL_PASSWORD} -S ${MySQL_Socket} --single-transaction --databases ${db} --log-error=${dumplog} > ${backup_path}/${db}_$(date +"%Y%m%d%H%M%S").sql

# 记录备份结束时间 有空格必须引号
endbackuptime=$(date +"%Y-%m-%d %H:%M:%S")
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${endbackuptime} end Backup ${db} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> ${dumplog}

# 结束for循环
done

# 定期删除sql备份文件及log日志,生产慎用
if [[ -d ${backup_path} ]];then
	find ${backup_path} -type f -mtime +${reserve_day} -name "*.sql" -exec rm -rf {} \;
    find ${backup_path} -type f -mtime +${reserve_day} -name "*.log" -exec rm -rf {} \;
fi


###  使用--single-transaction 通过在一个事务中导出所有表从而创建一个一致性的快照。
###  禁用--master-data=2参数，不执行 FLUSH TABLES WITH READ LOCK全局锁，防止锁表。
