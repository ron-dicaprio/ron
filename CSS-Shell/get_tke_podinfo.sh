#!/bin/bash
## Filename : get_tke1_podinfo.sh
## Date     : 2022-11-25
## Verison  : v1.0
## Desc     : 监控CPU和节点个数,内存为pod的使用率(非JVM)
## note     : unix下用vim保存一下.    :set ff=unix


# check app list . sum 15
tke1_detail=" \
    scsj-sdsgjsjgywfcz-ctrl-jd \
    scsj-ztxxbg-ctrl-jd \
    scsj-ztzx-ctrl-jd \
    scsj-zhsffw-ctrl-jd \
    scsj-zhssjg-ctrl-jd \
    scsj-zhxxbg-ctrl-jd \
    scsj-dksq-ctrl-jd \
    scsj-cxssb-ctrl-jd \
    scsj-mh-ctrl-jd \
    scsj-sdgjjgcz-front-jd-web \
    scsj-ztxxbg-front-jd-web \
    scsj-ztzx-front-jd-web \
    scsj-zhxxbg-front-jd-web \
    scsj-dksq-front-jd-web \
    scsj-mh-front-jd-web \
    "

tke2_detail="scsj-ggsfsbyy-service \
    scsj-j3cx-service \
    scsj-jcsb-service \
    scsj-j3dl-service \
    scsj-fsgjssb-service \
    scsj-lzsfjssb-service \
    scsj-lzsfjssbyy-service \
    scsj-mh-service-jd \
    scsj-mh-service \
    scsj-nsrxx-service \
    scsj-qysdssb-service \
    scsj-sqsp-service \
    scsj-sdsgjsjg-service \
    scsj-sdsxgxxbg-service \
    scsj-ztxxbg-service \
    scsj-ztzx-service \
    scsj-zhsffw-service \
    scsj-zhsffwyy-service \
    zhssjg-service \
    scsj-zhxxbg-service \
    scsj-zhxxbgyy-service \
    scsj-cxssb-service \
    scsj-cwcl-service \
    scsj-dksq-service \
    scsj-skzs-service \
    scsj-wfcz-service \
    scsj-wfwwg-service \
    scsj-xxzxnsrd-service \
    "

tke3_detail="scsj-cxssb-ctrl-nsrd \
    scsj-dksq-ctrl-nsrd \
    scsj-dzzl-ctrl-nsrd \
    scsj-ggsfsb-ctrl-nsrd \
    scsj-lzsfjssb-ctrl-nsrd \
    scsj-mh-ctrl-nsrd \
    scsj-skzs-ctrl-nsrd \
    scsj-swws-ctrl-nsrd \
    scsj-sdsfsgjssb-ctrl-nsrd \
    scsj-sdsgjsjgywfcz-ctrl-nsrd \
    scsj-sdsxgxxbg-ctrl-nsrd \
    scsj-ztxxbg-ctrl-nsrd \
    scsj-ztzx-ctrl-nsrd \
    scsj-zhsffw-ctrl-nsrd \
    zhssjg-ctrl-nsrd \
    scsj-zhxxbg-ctrl-nsrd \
    scsj-xxzx-ctrl-nsrd \
    scsj-cxssb-front-nsrd-web \
    scsj-dksq-front-nsrd-web \
    scsj-dksq-front-nsrd-web \
    scsj-ggsfsb-front-nsrd-web \
    scsj-lzsfjssb-front-nsrd-web \
    scsj-mh-front-nsrd-web \
    scsj-skzs-front-nsrd-web \
    scsj-swws-front-nsrd-web \
    scsj-sdfsgjsb-front-nsrd-web \
    scsj-sdgjjgcz-front-nsrd-web \
    scsj-sdsxgxxbg-front-nsrd-web \
    scsj-ztxxbg-front-nsrd-web \
    scsj-ztzx-front-nsrd-web \
    scsj-zhsffw-front-nsrd-web \
    zhssjg-front-nsrd-web \
    scsj-zhxxbg-front-nsrd-web \
    "

# touch getpodinfo.csv
echo '[*]************* shell starting *************[*]'
#echo '应用简称,pod运行状态,pod运行数量,service状态,pod异常数量,CPU利用率(%),内存使用率(%)' > getpodinfo.csv
echo 'app_name,pod_status,pod_running,service_status,pod_error,CPU_uaeage(%),mem_useage(%)' > getpodinfo.csv

for app in $tke1_detail;do
# get pod
Nums=`kubectl get pod -n sc-zr-xdzswj-nw1 | awk "NR>1"'{print $1}' | grep $app | wc -l`
echo $Nums

echo 'check '$app

# get fullname from getpodnames.txt . limit top 1.
toppodname=`kubectl get pod -n sc-zr-xdzswj-nw1 | awk "NR>1"'{print $1}' | grep $app | head -n 1`
# cpu_useage and mem_useage . 
cpu_useage=`kubectl top pod $toppodname -n sc-zr-xdzswj-nw1 --containers | grep -v 'agent' | awk 'gsub("m", "", $3) NR>1 {print $3/10}'`
#containe_name=`kubectl getpod $toppodname -o jsonpath="{.spec['containers'][*].name}" -n sc-zr-xdzswj-nw1 |sed -e 's/ /\n/' | grep -v 'agent'`
mem_useage=`kubectl top pod $toppodname -n sc-zr-xdzswj-nw1 --containers | grep -v 'agent' | awk 'gsub("Mi", "", $4) NR>1 {print $4/286.72}'`

# '应用简称,pod运行状态,pod运行数量,service状态,pod异常数量,CPU利用率(%),内存使用率(%)'
echo "$app,ok,$Nums,ok,0,$cpu_useage%,$mem_useage%" >> getpodinfo.csv

done

echo '[*]************* shell finished *************[*]'
