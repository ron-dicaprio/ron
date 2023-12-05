#!/bin/bash
# windows下set ff=unix
ip_port=10.100.9.133:9200
user=elastic
passwd=sysadmin
methon=$1
args=$2

##  验证Root用户
# if [ `id -u` -eq 0 ];then
#   echo -e "\033[33m Current User is Root \033[0m"
# else
#   echo -e "\033[31m Current User is Not Root \033[0m"
#   exit
# fi

## 判断参数个数
if [ $# != 2 ];then
    echo -e "\033[32m Usage: Input parameter, Example: sh $0 [method] [functhon] \033[0m"
    echo -e "\033[32m sh $0 get index \033[0m"
    echo -e "\033[32m sh $0 del index_name \033[0m"
    exit 1
fi

## 查看版本号
version () {
	curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/
	}
## 全量索引
all_index () {
    curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/_cat/indices?v
}
## 获取索引中的数据
get_info () {
    curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/$args?pretty
}
## 删除索引中的数据
del_info () {
    curl -s -X DELETE -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/$args?pretty
}
## 
disk_info () {
    curl -s -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/_cat/allocation?v
}

## 判断method
if [ $1 = get ];then
    case $2 in
        version)
            version
            ;;
        index)
            all_index
            ;;
        disk)
            disk_info
            ;;
        *)
            get_info
            ;;
    esac
elif [ $1 = del ];then
    # todo list
    del_info
else
    echo -e "method $1 not supprot!"
fi

# get ES index, example: xwcjsjjs_service_jkfwqq
#curl -X GET -u $user:$passwd -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_jkfwqq


# get all ES index
#
#curl -X GET -u elastic:sysadmin -H "Content-Type:application/json" http://10.0.0.168:9200/_cat/indices?v


# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_jkfwqq -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_jk": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "xwuuid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "sessionid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },
# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "sfcg": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "gndm": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "qqbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "csbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "jkqqlj": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "fwqd": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "lrrq": {
#           "type": "date",
#           "index": "true"  
#       },
# "sfbs": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "yhlx": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "qyid": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "kxsfId": {
#         "type": "keyword",
#         "index": "true"  
#             }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_gnymdk -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_gn": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "xwuuid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "sessionid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },
# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "sfcg": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "gndm": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "qqbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "csbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "fwqd": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "lrrq": {
#           "type": "date",
#           "index": "true"  
#       },
# "sfbs": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "yhlx": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "qyid": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "kxsfId": {
#         "type": "keyword",
#         "index": "true"  
#             }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_khdxxcj -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_khdcj": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "fwqd": {
#         "type": "keyword",
#         "index": "true"  
#         },
# "llqlb": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "llqbb": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "llqua": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "xtxx": {
#         "type": "keyword",
#         "index": "true"  
#         },
# "yybbh": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "sbid": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "sbcs": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "sbxh": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_yhssccs -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_yhssccs1": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },

# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "sscnr": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "fwqd": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_ymjzsc -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_ymjzsc1": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "xwuuid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "sessionid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },
# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "sfcg": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "gndm": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "qqbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "jkqqlj": {
#         "type": "keyword",
#         "index": "true"  
#             },

# "csbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "fwqd": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_dkywgncs -d ' {
#      "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_dkywgncs1": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },
# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "gndm": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "dkwz": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "fwqd": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_appyhscaz -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_appyhscaz1": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "xwuuid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "sessionid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },

# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "csbz": {
#         "type": "keyword",
#         "index": "true"  
#             },
# "fwqd": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';
# curl -X PUT -u $user:$passwd  -H "Content-Type:application/json" http://$ip_port/xwcjsjjs_service_appbkrz -d ' {
#   "settings": {
#       "index": {
#           "number_of_shards": "1",
#           "number_of_replicas": "0",
#           "mapping.total_fields.limit":2000
#       }
#   },
#   "aliases": {
#       "xwcjsjjs_service_appbkrz1": {}
#   },
#   "mappings": {
#     "properties": {
#       "pk_flag": {
#         "type": "keyword"
#       },
# "sjcjkey": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "khdid": {
#         "type": "keyword",
#         "index": "true"  
#       },
# "kssj": {
#         "type": "date",
#         "index": "true"
#             },
# "jssj": {
#         "type": "date",
#         "index": "true"
#             },
# "duration": {
#         "type": "double",
#         "index": "true"   
#             },
# "nsrsbh": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "zdynr": {
#           "type": "keyword",
#           "index": "true"  
#       },
# "fwqd": {
#           "type": "keyword",
#           "index": "true"  
#       }
#     }
#   }
# }';

