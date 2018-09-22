#!/bin/sh
#H大老毛子固件专用
#wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/enshanssget.sh -O /tmp/ssget.sh;sh /tmp/ssget.sh d &

abc_get()
{
#下载网页源代码
#curl --cacert /etc/storage/cacert.pem --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11" -o /tmp/sstmpweb http://www.right.com.cn/forum/thread-318036-1-1.html
wget --no-check-certificate http://www.right.com.cn/forum/thread-318036-1-1.html -O /tmp/sstmpweb
if [ ! -f /tmp/sstmpweb ]; then
	exit
fi
#筛选整理源代码
#sed -i '1,/<tbody>/d' /tmp/sstmpweb
#sed -i '/<\/tbody>/,$d' /tmp/sstmpweb

sszy_zy=$(grep 'S-S R:\/\/' /tmp/sstmpweb | awk 'BEGIN{FS="R:\/\/|\">SS<"}{print $2}' | cut -d '<' -f 1)
sszy_tmpkey=`expr $(echo "$sszy_zy" | awk -F '' '{print NF}') % 4`
case "$sszy_tmpkey" in
"1")
	sszy_zy=`echo "$sszy_zy===" | base64 -d`
	;;
"2")
	sszy_zy=`echo "$sszy_zy==" | base64 -d`
	;;
"3")
	sszy_zy=`echo "$sszy_zy=" | base64 -d`
	;;
"0")
	sszy_zy=`echo "$sszy_zy" | base64 -d`
	;;
esac
sszy_server=`echo "$sszy_zy" | cut -d ':' -f 1`
sszy_server_port=`echo "$sszy_zy" | cut -d ':' -f 2 | cut -d ':' -f 1`
sszy_key=`echo "$sszy_zy" | cut -d ':' -f 6 | cut -d '/' -f 1`
sszy_method=`echo "$sszy_zy" | cut -d ':' -f 4 | cut -d ':' -f 1`
sszy_ssr_type_protocol=`echo "$sszy_zy" | cut -d ':' -f 3 | cut -d ':' -f 1`
sszy_ssr_type_protocol_custom=`echo "$sszy_zy" | cut -d '=' -f 3 | cut -d '&' -f 1`
sszy_ssr_type_obfs=`echo "$sszy_zy" | cut -d ':' -f 5 | cut -d ':' -f 1`

sszy_tmpkey=`expr $(echo "$sszy_key" | awk -F '' '{print NF}') % 4`
case "$sszy_tmpkey" in
"1")
	sszy_key=`echo "$sszy_key===" | base64 -d`
	;;
"2")
	sszy_key=`echo "$sszy_key==" | base64 -d`
	;;
"3")
	sszy_key=`echo "$sszy_key=" | base64 -d`
	;;
"0")
	sszy_key=`echo "$sszy_key" | base64 -d`
	;;
esac

sszy_ssr_tmpprotoparam=`expr $(echo "$sszy_ssr_type_protocol_custom" | awk -F '' '{print NF}') % 4`
case "$sszy_ssr_tmpprotoparam" in
"1")
	sszy_ssr_type_protocol_custom=`echo "$sszy_ssr_type_protocol_custom===" | base64 -d`
	;;
"2")
	sszy_ssr_type_protocol_custom=`echo "$sszy_ssr_type_protocol_custom==" | base64 -d`
	;;
"3")
	sszy_ssr_type_protocol_custom=`echo "$sszy_ssr_type_protocol_custom=" | base64 -d`
	;;
"0")
	sszy_ssr_type_protocol_custom=`echo "$sszy_ssr_type_protocol_custom" | base64 -d`
	;;
esac

abcw=`ping $sszy_server -c 1 -w 1 -q`
sszy_time=`echo $abcw | awk -F '/' '{print $4}'| awk -F '.' '{print $1}'`
sszy_server=`echo $abcw | awk -F '(' '{print $2}'| awk -F ')' '{print $1}'`

echo "延迟时间：$sszy_time ms 服务器：$sszy_server 端口：$sszy_server_port 密码：$sszy_key 加密方式：$sszy_method 协议插件：$sszy_ssr_type_protocol 协议参数：$sszy_ssr_type_protocol_custom 混淆插件：$sszy_ssr_type_obfs"
logger -t "【aotuSS】" "PING：$sszy_time ms 服务器：$sszy_server 正常"

}

abc_set()
{
abcna=`nvram get ss_server`
abcnb=`nvram get ss_server_port`
abcnc=`nvram get ss_method`
abcnd=`nvram get ss_key`
abcne=`nvram get ssr_type_protocol`
abcnf=`nvram get ssr_type_protocol_custom`
abcng=`nvram get ssr_type_obfs`
abc_set_x=0
if [ "1$abcna" = "1$sszy_server" ] && [ "1$abcnb" = "1$sszy_server_port" ] && [ "1$abcnc" = "1$sszy_method" ] && [ "1$abcnd" = "1$sszy_key" ] && [ "1$abcne" = "1$sszy_ssr_type_protocol" ] && [ "1$abcnf" = "1$sszy_ssr_type_protocol_custom" ] && [ "1$abcng" = "1$sszy_ssr_type_obfs" ]; then
	logger -t "【aotuSS】" "脚本状态：SS服务器、密码未变更"
	exit
else
	nvram set ss_server=$sszy_server
	nvram set ss_server_port=$sszy_server_port
	nvram set ss_method=$sszy_method
	nvram set ss_key=$sszy_key
	nvram set ssr_type_protocol=$sszy_ssr_type_protocol
	nvram set ssr_type_protocol_custom=$sszy_ssr_type_protocol_custom
	nvram set ssr_type_obfs=$sszy_ssr_type_obfs
	#nvram commit
	logger -t "【aotuSS】" "脚本状态：正常更新SS服务器、端口、密码！！！"
	abc_set_x=1
fi

sspower=`nvram get ss_enable`
if [ "1$sspower" = "11" ] && [ "1$abc_set_x" = "11" ]; then
	#取消注释# SS重启模式，否则快速切换模式
	#nvram set ss_status=0
	sh /etc/storage/script/Sh15_ss.sh &
else
	logger -t "【aotuSS】" "脚本状态：无须更新！！！！！！"
	exit
fi
}


#SS开关：1开、0关
nvram set ss_enable=1
#SS模式开关：1为SSR模式、0为SS模式
nvram set ss_type=1

sspower=`nvram get ss_enable`
if [ "1$sspower" = "11" ]; then
	sleep 1
else
	logger -t "【aotuSS】" "脚本状态：当前SS未启动！！！！！！"
	exit
fi

abcj=$1
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`
case $abcj in
d)
	logger -t "【aotuSS】" "更新节点+自动设置"
	abc_get
	abc_set
	;;
*)
	abc_get
	;;
esac
