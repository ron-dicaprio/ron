# 创建备份路径backup_path 
```sh
create or replace directory backup_path as '/usr/backup_path';

expdp EPOINTBID_HNJCJY/Epointadmin_HNJY@HNZK_orcl schemas=EPOINTBID_HNJCJY directory=BACKUP_PATH dumpfile=EPOINTBID_HNJCJY081115.dmp logfile=EPOINTBID_HNJCJY081115.log version=11.2.0.1.0

expdp EPOINTBID_PB7/11111@HNZK_orcl schemas=EPOINTBID_PB7 directory=BACKUP_PATH dumpfile=EPOINTBID_PB7_081115.dmp logfile=EPOINTBID_PB7_081115.log version=11.2.0.1.0

expdp EPOINTBID_PB7/11111@HNZK_orcl schemas=EPOINTBID_PB7 directory=BACKUP_PATH dumpfile=EPOINTBID_PB7_190321.dmp logfile=EPOINTBID_PB7_190321.log version=11.2.0.1.0

expdp hnoauser/111111@HNZK_orcl schemas=hnoauser directory=backup_path dumpfile=hnoauser.dmp logfile=hnoauser.log
```
```sh
create or replace directory backup_path as 'd:\backup_path'; expdp EPOINTBID_HNJCJY/Epointadmin_HNJY@HNZK_orcl schemas=EPOINTBID_HNJCJY directory=backup_path dumpfile=EPOINTBID_HNJCJY2018-9-3.dmp logfile=EPOINTBID_HNJCJY2018-9-3.log

expdp EPOINTBID_PB7/111111@HNZK_orcl schemas=EPOINTBID_PB7 directory=backup_path dumpfile=EPOINTBID_PB72018-9-3.dmp logfile=EPOINTBID_PB72018-9-3.log

impdp EPOINTBID_HNP/11111@HNZK_ORCL schemas=EPOINTBID_HNJCJY directory=backup_path dumpfile=EPOINTBID_HNJCJY.dmp logfile=EPOINTBID_HNJCJY.log remap_schema=EPOINTBID_HNJCJY:EPOINTBID_HNP remap_tablespace=EPOINTBID_HNJCJY:EPOINTBID_HNP table_exists_action=replace
```
# --如果导入导出两边版本不一致，比方说导入的版本要比导出的版本低，导出时需要指定版本号

expdp EPOINTBID_JXPFJ_PB6J/11111@orcl schemas=EPOINTBID_JXPFJ_PB6J directory=EPOINTBID_TP6J dumpfile=EPOINTBID_JXPFJ_PB6J_11g.dmp logfile=EPOINTBID_JXPFJ_PB6J_11g.log version=11.1.0.6.0

## 创建路径 
create or replace directory backup_path as 'd:\backup_path';

## 数据库导出 
expdp EPOINTBID_HNZK/11111@orcl schemas=EPOINTBID_HNZK directory=backup_path dumpfile=EPOINTBID_HNZKbak.dmp logfile=EPOINTBID_HNZKbak.log

## 创建表空间
create temporary tablespace EPOINTBID_PB7_HISTORY_TEMP tempfile 'D:\oracledata\orcl\EPOINTBID_PB7_HISTORY.dbf' size 128m autoextend on next 64m extent management local;

create tablespace EPOINTBID_PB7_HISTORY datafile 'D:\oracledata\orcl\EPOINTBID_PB7_HISTORY.dbf' size 256m autoextend on next 128m maxsize unlimited extent management local;

###创建用户 
create user EPOINTBID_PB7_HISTORY identified by 111111 default tablespace EPOINTBID_PB7_HISTORY temporary tablespace EPOINTBID_PB7_HISTORY_TEMP;

###授权 
grant connect,resource to EPOINTBID_PB7_HISTORY; grant create any view to EPOINTBID_PB7_HISTORY; grant read,write on directory backup_path to EPOINTBID_PB7_HISTORY; grant unlimited tablespace to EPOINTBID_PB7_HISTORY; grant create job to EPOINTBID_PB7_HISTORY;

###数据库导入 
impdp EPOINTBID_PB7_HISTORY/111111@HNZK_ORCL directory=backup_path dumpfile=EPOINTBID_PB7_190321.DMP logfile=EPOINTBID_PB7_190321.log schemas=EPOINTBID_PB7 table_exists_action=replace

Impdp EPOINTBID_PB7J_EMPTY/11111@orcl directory=BACKUP_PATH dumpfile=EPOINTBID_PB7J.DMP remap_schema=EPOINTBID_PB7J:EPOINTBID_PB7J_EMPTY remap_tablespace=EPOINTBID_PB7J:EPOINTBID_PB7J_EMPTY,EPOINTBID_PB6J:EPOINTBID_PB7J_EMPTY logfile=EPOINTBID_PB7J.log table_exists_action=replace

Impdp EPOINTWEB/Epointcd2019@orcl directory=BACKUP_PATH dumpfile=eweb.dmp remap_schema=epointwebbuilder5_1_cdggzy:epointweb remap_tablespace=epointwebbuilder5_1_cdggzy:epointweb logfile=eweb.log table_exists_action=replace

#better impdp EPOINTBID_PB7_HISTORY/111111@HNZK_ORCL directory=backup_path dumpfile=EPOINTBID_PB7_190321.DMP logfile=EPOINTBID_PB7_190321.log remap_tablespace=EPOINTBID_PB7:EPOINTBID_PB7_HISTORY remap_schema=EPOINTBID_PB7:EPOINTBID_PB7_HISTORY table_exists_action=replace include=table

alter user scott account unlock;

<--! 省政府云机房数据导入导出--> create or replace directory backup_path as '/usr/backup_path'; expdp EPOINTBID_HNJY/11111@EpointA compression=all schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY2017-12-7.dmp logfile=EPOINTBID_HNJY2017-12-7.log directory=BACKUP_PATH version=11.2.0.1.0

<--! Oracle RAC导入 --> create tablespace EPOINTBID_HNJY datafile '+DATA13' size 256m autoextend on next 128m maxsize unlimited extent management local;

create temporary tablespace EPOINTBID_HNJY tempfile '+DATA13' size 256m autoextend on next 128m maxsize unlimited extent management local;

create user EPOINTBID_HNJY identified by Epointadmin_HNJY default tablespace EPOINTBID_HNJY temporary tablespace EPOINTBID_HNJY_TEMP;

grant connect,resource to EPOINTBID_HNJY; grant create any view to EPOINTBID_HNJY; grant read,write on directory backup_path to EPOINTBID_HNJY; grant unlimited tablespace to EPOINTBID_HNJY; grant create job to EPOINTBID_HNJY; impdp system/pH62ad4o0B schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY.DMP logfile=imp_0914.log directory=BACKUP_PATH cluster=n parallel=4 exclude=statistics

SQL> conn system/cpgrx8oMEG@epointa Connected.

SQL> conn system/pH62ad4o0B@epointb Connected.

expdp EPOINTBID_PB7/11111 compression=all schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY0914.dmp logfile=hnjy_0914 directory=backup_path

impdp system/pH62ad4o0B schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY.DMP logfile=imp_0914.log directory=BACKUP_PATH cluster=n parallel=4 exclude=statistics

<--! 覆盖导入--> impdp system/cpgrx8oMEG@EpointA schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY.DMP logfile=EPOINTBID_HNJY.log directory=BACKUP_PATH cluster=n parallel=4 exclude=statistics table_exists_action=replace;

impdp system/pH62ad4o0B@EpointB schemas=EPOINTBID_PB7 dumpfile=EPOINTBID_PB7.DMP logfile=EPOINTBID_PB7.log directory=BACKUP_PATH cluster=n parallel=4 exclude=statistics

impdp system/cpgrx8oMEG schemas=EPOINTBID_HNJY dumpfile=EPOINTBID_HNJY.DMP logfile=EPOINTBID_HNJY.log directory=BACKUP_PATH cluster=n parallel=4 exclude=statistics table_exists_action=replace

#多个表空间 Impdp EPOINTBID_PB7J_EMPTY/11111@orcl directory=BACKUP_PATH dumpfile=EPOINTBID_PB7J.DMP remap_schema=EPOINTBID_PB7J:EPOINTBID_PB7J_EMPTY remap_tablespace=EPOINTBID_PB7J:EPOINTBID_PB7J_EMPTY,EPOINTBID_PB6J:EPOINTBID_PB7J_EMPTY logfile=EPOINTBID_PB7J.log table_exists_action=replace

#exp数据泵方式导出，imp远程导入 exp username/password file=XXX.dmp owner=XXX log=XXX.log imp OA9_2_FB/OA9_2_FB@10.63.255.5/epointcd file=D:\dump\OA9_2_FB.dmp log=D:\dump\OA9_2_FB.log fromuser=OA9_2_FB touser=OA9_2_FB grant dba to epointbid_jingjia; revoke dba from epointbid_jingjia;

oracle imp 导入可以使用 ignore=y 参数进行覆盖数据库，
