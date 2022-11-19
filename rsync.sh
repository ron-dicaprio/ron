#!/bin/bash

/usr/bin/rsync -auv  --delete  /data/backup   rsync:/opt/backup/
