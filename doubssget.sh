#!/bin/sh
#此脚本仅限于H大老毛子（padavan）固件
#wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/doubssget.sh -O /tmp/ssget.sh;sh /tmp/ssget.sh d &
abc_get()
{
#下载网页源代码
wget --no-check-certificate https://doub.io/sszhfx/ -O /tmp/sstmpweb
if [ ! -f /tmp/sstmpweb ]; then
	exit
fi
#筛选整理源代码
sed -i '1,/<tbody>/d' /tmp/sstmpweb
sed -i '/<\/tbody>/,$d' /tmp/sstmpweb
grep 'ss:' /tmp/sstmpweb > /tmp/sstmpwea
#删除干扰代码
cat /tmp/sstmpwea | awk 'BEGIN{FS="Yi5p|by9z"}{print $2}' > /tmp/sstmpwec
for abc in $(cat /tmp/sstmpwec)
do
sed -i "s/$abc//g" /tmp/sstmpwea
done
#提取SS://地址
cat /tmp/sstmpwea | awk 'BEGIN{FS="ss:\/\/|\">SS<"}{print $2}' | cut -d '"' -f 1 > /tmp/sstmpwed
#转译SS地址
abca=0
for sszy_zy in $(cat /tmp/sstmpwed)
do
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
sszy_server=`echo "$sszy_zy" | cut -d '@' -f 2 | cut -d ':' -f 1`
sszy_server_port=`echo "$sszy_zy" | cut -d ':' -f 3`
sszy_method=`echo "$sszy_zy" | cut -d ':' -f 1`
sszy_key=`echo "$sszy_zy" | cut -d ':' -f 2 | cut -d '@' -f 1`
sszy_time=`echo $(ping $sszy_server -c 1 -w 1 -q) | awk -F '/' '{print $4}'| awk -F '.' '{print $1}'`
echo "延时：$sszy_time 服务器：$sszy_server 端口：$sszy_server_port 密码：$sszy_key 加密方式：$sszy_method "
#保存SS列表
nvram set rt_ss_name_x$abca="$sszy_time"ms	
nvram set rt_ss_server_x$abca=$sszy_server
nvram set rt_ss_port_x$abca=$sszy_server_port
nvram set rt_ss_method_x$abca=$sszy_method
nvram set rt_ss_password_x$abca=$sszy_key
nvram set rt_ss_usage_x$abca=" -O origin -o plain"
nvram set rt_ss_method_write_x_0$abca=
let abca++
nvram set rt_ssnum_x=$abca
done
}



abc_ping()
{
if [ "1$abcq" = "1$abca" ]; then
	logger -t "【aotuSS】" "PING：服务器全瘫痪了"
	exit
fi

ping_password=`nvram get rt_ss_password_x$abcq`
if [ "1$ping_password" == "1" ]; then
	logger -t "【aotuSS】" "PING：服务器无密码，尝试切换服务器"
	let abcq++
	abc_ping
	return
fi

ping_server=`nvram get rt_ss_server_x$abcq`
abcu=0
ping -c 1 -w 1 $ping_server >/dev/null;[ "$?" == "0" ] && abcu=1
if [ "1$abcu" = "11" ]; then
	logger -t "【aotuSS】" "PING：服务器：$ping_server 正常"
else
	logger -t "【aotuSS】" "PING：服务器：$ping_server 无响应，尝试切换服务器"
	let abcq++
	abc_ping
fi
}


abc_seth()
{
abc_set_x=0
abck=`nvram get rt_ss_password_x$abcq`
abcl=`nvram get ss_key`
abcm=`nvram get rt_ss_server_x$abcq`
abcn=`nvram get ss_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	logger -t "【aotuSS】" "脚本状态：SS服务器、密码未变更"
	#abc_keep
	#return
	exit
else
	nvram set ss_server=`nvram get rt_ss_server_x$abcq`
	nvram set ss_server_port=`nvram get rt_ss_port_x$abcq`
	nvram set ss_key=`nvram get rt_ss_password_x$abcq`
	nvram set ss_method=`nvram get rt_ss_method_x$abcq`
	#nvram commit
	logger -t "【aotuSS】" "脚本状态：正常更新SS服务器、端口、密码！！！"
	abc_set_x=1
fi
}

abc_restarh()
{
sspower=`nvram get ss_enable`
if [ "1$sspower" = "11" ] && [ "1$abc_set_x" = "11" ]; then
	#取消注释# SS重启模式，否则快速切换模式
	#nvram set ss_status=0
	sh /etc/storage/script/Sh15_ss.sh &
else
	logger -t "【aotuSS】" "脚本状态：当前SS未启动！！！！！！"
	exit
fi
}

abc_set()
{
sspower=`nvram get ss_enable`
if [ "1$sspower" = "11" ]; then
	sleep 1
else
	logger -t "【aotuSS】" "脚本状态：当前SS未启动！！！！！！"
	exit
fi

abcq=$abct
if [ "$abcq" -gt "0" ] && [ "$abcq" -lt "$abca" ]; then
	let abcq--
else
	abcq=0
fi

abc_ping
abc_seth
abc_restarh
}

doubhost=$(grep 'doub.io' /etc/storage/dnsmasq/hosts)
if [ "1$doubhost" = "1" ]; then
	echo "添加doub hosts"
	echo "MTA0LjE2LjI0OC4xIGRvdWIuaW8=" | base64 -d >> /etc/storage/dnsmasq/hosts
	sleep 1
	restart_dhcpd
	sleep 3
fi
abcj=$1
abct=$2
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`
case $abcj in
d)
	logger -t "【aotuSS】" "更新节点列表+自动设置"
	abc_get
	abc_set
	;;
h)
	echo " *.sh [选项][参数]"
	echo "      [选项]  空  更新节点列表"
	echo "      [选项]  d   更新节点列表+自动设置"
	echo " *.sh [参数]  1-4 指定SS服务器"
	;;
*)
	logger -t "【aotuSS】" "更新节点列表"
	abc_get
	#abc_clean
	;;
esac
