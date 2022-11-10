#!/bin/bash
## Filename : mysql_backup_function.sh
## Date     : 2022-11-10
## Author   : caitao <caitao@css.com.cn>
## Desc     : 小型mysql数据库备份脚本

# 环境变量
source /etc/profile
# 设置系统打开文件数,解决高并发下too many open files的问题,在当前shell有效.
ulimit -HSn 102400

# 定义备份路径
backup_path="/mysqlbackup"
# 定义需要备份的数据库,如pydev和test两个库
db_list="pydev test"
# 用户
MYSQL_USER="root"
# 密码
MYSQL_PASSWORD="@Caitao628422"
# sockpath. docker下的路径
MySQL_Socket="/var/lib/mysql/mysql.sock"

# 备份mysql数据库
function mysql_backup() {
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
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $(date +"%Y-%m-%d %H:%M:%S") start Backup ${db} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> ${dumplog}
    # 开始执行备份
    /usr/bin/mysqldump -u${MYSQL_USER} -p${MYSQL_PASSWORD} -S ${MySQL_Socket} --single-transaction --databases ${db} --log-error=${dumplog} > ${backup_path}/${db}_$(date +%Y%m%d%H%M%S).sql
    # 记录备份结束时间 有空格必须引号
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $(date +"%Y-%m-%d %H:%M:%S") end Backup ${db} <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> ${dumplog}
    # 结束for循环
    done
}

# 定期删除sql备份文件及log日志,生产慎用
function clean_backup_files() {
    if [[ -d ${backup_path} ]];then
        find ${backup_path} -type f -mtime +${reserve_day} -name "*.sql" -exec rm -rf {} \;
        find ${backup_path} -type f -mtime +${reserve_day} -name "*.log" -exec rm -rf {} \;
    fi

}

# 执行备份
mysql_backup
# 清理文件
clean_backup_files