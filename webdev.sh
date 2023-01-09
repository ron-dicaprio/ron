#!/bin/bash
nohup /data/adrive/aliyunpan webdav start -ip "172.17.67.137" -port 23077 -webdav_user "admin" -webdav_password "sysadmin" -webdav_mode "rw" -pan_drive "File" -pan_dir_path "/" >> nohup.out 2>&1 &
