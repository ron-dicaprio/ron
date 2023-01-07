#!/bin/bash
# 命名空间
nameSpace="sc-zr-xdzswj-nw1"
## 计数
i=0
## 网络区域
networkZone="业务专网区"
##
declare -A mapnw
mapnw["scsj-ggsfsbyy-service"]="公共税费申报应用微服务"
mapnw["scsj-j3cx-service"]="金三查询微服务"
mapnw["scsj-j3cxsbsj-service"]="金三查询申报数据微服务"
mapnw["scsj-j3cxsffw-service"]="金三查询税费服务微服务"
mapnw["scsj-jcsb-service"]="基础申报微服务"
mapnw["scsj-j3dl-service"]="金三代理微服务"
mapnw["scsj-fsgjssb-service"]="非税国际申报微服务"
mapnw["scsj-lzsfjssb-service"]="流转税申报微服务"
mapnw["scsj-lzsfjssbyy-service"]="流转税申报应用微服务"
mapnw["scsj-mh-service-jd"]="门户税务人端微服务"
mapnw["scsj-mh-service"]="门户微服务"
mapnw["scsj-nsrxx-service"]="纳税人信息微服务"
mapnw["scsj-qysdssb-service"]="企业所得税申报微服务"
mapnw["scsj-sqsp-service"]="申请审批微服务"
mapnw["scsj-sdsgjsjg-service"]="所得税国际税监管微服务"
mapnw["scsj-sdsxgxxbg-service"]="所得税相关信息报告微服务"
mapnw["scsj-ztxxbg-service"]="主体信息报告微服务"
mapnw["scsj-ztzx-service"]="征退中心微服务"
mapnw["scsj-zhsffw-service"]="综合税费服务微服务"
mapnw["scsj-zhsffwyy-service"]="综合税费服务应用微服务"
mapnw["scsj-zhssjg-service"]="综合税收监管微服务"
mapnw["scsj-zhxxbg-service"]="综合信息报告微服务"
mapnw["scsj-zhxxbgyy-service"]="综合信息报告应用微服务"
mapnw["scsj-cxssb-service"]="财行税申报微服务"
mapnw["scsj-cwcl-service"]="出错处理微服务"
mapnw["scsj-dksq-service"]="代开申请微服务"
mapnw["scsj-skzs-service"]="税款征收中心微服务"
mapnw["scsj-wfcz-service"]="违法处置微服务"
mapnw["scsj-wfwwg-service"]="微服务网关应用服务"
mapnw["scsj-xxzxnsrd-service"]="信息中税务人端微服务心"
mapnw["scsj-dzzl-front-jd-web"]="电子资料税务人端展示页面"
applist=(scsj-ggsfsbyy-service
scsj-j3cx-service
scsj-j3cxsbsj-service
scsj-j3cxsffw-service
scsj-jcsb-service
scsj-j3dl-service
scsj-fsgjssb-service
scsj-lzsfjssb-service
scsj-lzsfjssbyy-service
scsj-mh-service-jd
scsj-mh-service
scsj-nsrxx-service
scsj-qysdssb-service
scsj-sqsp-service
scsj-sdsgjsjg-service
scsj-sdsxgxxbg-service
scsj-ztxxbg-service
scsj-ztzx-service
scsj-zhsffw-service
scsj-zhsffwyy-service
scsj-zhssjg-service
scsj-zhxxbg-service
scsj-zhxxbgyy-service
scsj-cxssb-service
scsj-cwcl-service
scsj-dksq-service
scsj-skzs-service
scsj-wfcz-service
scsj-wfwwg-service
scsj-xxzxnsrd-service)
#scsj-dzzl-front-jd-web

echo -e "\033[31m ################################################################        开始应用巡检         ######################################################## \033[0m" 
echo -e "\033[36m 序号\t部署网络\t应用名称\t应用简称\tpod运行状态\tservice状态\tpod运行数量\tpod异常数量\tCPU利用率\t内存使用率 \033[0m" > monitor.csv
for app in ${applist[@]}
do
        # 按pod的CPU使用率从高到低排序，取第1个pod名字
        podName=`kubectl top pod -n $nameSpace |grep $app |sort -r -k 2 |head -n 1|awk '{print $1}'`
	    containerName=`kubectl get pod $podName -o jsonpath="{.spec['containers','initContainers'][*].name}" -n $nameSpace |sed -e 's/ /\n/'| grep -v agent`
        # 统计pod数量
        podNum=`kubectl get pod -n ${nameSpace} |grep $app |wc -l`
        # 检查pod是否有异常，只有一个状态不是Running，则输出异常
        podExceptionNum=`kubectl get pod -n ${nameSpace} |grep $app|grep -v Running|wc -l`
        if [ $podExceptionNum -eq 0 ];then
                podInfo="\033[42;37m 正常 \033[0m"
        else
                podInfo="\033[41;37m 异常 \033[0m"
        fi
        # 查看CPU使用
        podCpu=`kubectl top pod $podName -n $nameSpace |grep -v NAME|awk '{gsub("m","");print $2}'`
        # 查看内存使用
        
        case $app in
        	# 内存为16G的web pod
                scsj-dzzl-front-jd-web)
			podMem=`kubectl top pod $podName -n $nameSpace |grep -v NAME|awk '{gsub("Mi","");print $3}'`
                        podCpuInfo=`awk 'BEGIN{printf "%.1f%%\n",('${podCpu}')/10}'`
                        podMemInfo=`awk 'BEGIN{printf "%.1f%%\n",('${podMem}')/16384*100}'`
                        ;;
               # 内存为16G的app pod
		scsj-hcgl-service|scsj-j3cxsbsj-service|scsj-j3dl-service)
			podMem=`kubectl exec -it $podName -n $nameSpace -c $containerName -- tail -n 1 /data/tsf_apm/monitor/jvm-metrics/jmxtrans-agent.data |awk -F ',' '{print $12}'|awk -F ":" '{print $2}'`
			podCpuInfo=`awk 'BEGIN{printf "%.1f%%\n",('${podCpu}')/10}'`
			podmemInfo=`awk 'BEGIN{printf "%.1f%\n",('${podMem}')*100/16384/1024/1024}'`
			;;
		*)
			podMem=`kubectl exec -it $podName -n $nameSpace -c $containerName -- tail -n 1 /data/tsf_apm/monitor/jvm-metrics/jmxtrans-agent.data |awk -F ',' '{print $12}'|awk -F ":" '{print $2}'`
                        podCpuInfo=`awk 'BEGIN{printf "%.1f%%\n",('${podCpu}')/10}'`
                        podMemInfo=`awk 'BEGIN{printf "%.1f%\n",('${podMem}')*100/8192/1024/1024}'`
                        ;;
        esac
	i=$(($i+1))
	echo -e "$i\t${networkZone}\t${mapnw[$app]}\t${app}\t${podInfo}\t${podInfo}\t${podNum}\t${podExceptionNum}\t${podCpuInfo}\t${podMemInfo}" >> monitor.csv
done
echo -e "\033[35m #######################################################以下内容可直接复制到excel表格######################################################## \033[0m"
cat monitor.csv
echo -e "\033[35m #######################################################       格式化输出制表        ######################################################## \033[0m"
column -t monitor.csv
echo -e "\033[31m #######################################################      完成应用巡检         ######################################################## \033[0m"

