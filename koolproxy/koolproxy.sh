#!/bin/sh
#制作该脚本初衷，由于openwrt的luci是定制的，koolproxy官方luci不兼容，
#简单粗暴运行koolproxy全局代理（内存运行模式，不伤闪存）（mipsel版）

# 调试脚本(没问题可进行注释)
#set -x

kp_init()
{
if [ ! -f /tmp/koolproxy/koolproxy ]; then  
	rm -rf /tmp/koolproxy
	mkdir -p /tmp/koolproxy/data
	#下载二进制
	wget --no-check-certificate -q -O /tmp/koolproxy/koolproxy https://raw.githubusercontent.com/nslook/padavanssidup/master/toolbin/koolproxy
	chmod +x /tmp/koolproxy/koolproxy
	#下载规则
	#wget --no-check-certificate -q -O /tmp/koolproxy/data/rules/koolproxy.txt https://kprule.com/koolproxy.txt
	#wget --no-check-certificate -q -O /tmp/koolproxy/data/rules/kp.dat https://kprule.com/kp.dat
	#wget --no-check-certificate -q -O /tmp/koolproxy/data/user.txt https://kprule.com/user.txt
fi

if [ ! -f /tmp/koolproxy/koolproxy ]; then 
	#下载失败，自动退出
	exit
fi
}

kp_updata()
{
[ ! -n "$(ps|grep '/tmp/koolproxy/koolproxy'|grep -v 'grep')" ] && exit
if [ -f /tmp/koolproxy/data ]; then  
	kill -9 $(ps|grep '/tmp/koolproxy/koolproxy'|grep -v 'grep'|awk '{print$1}') 2>/dev/null
	#更新规则
	wget --no-check-certificate -q -O /tmp/koolproxy/data/rules/koolproxy.txt https://kprule.com/koolproxy.txt
	wget --no-check-certificate -q -O /tmp/koolproxy/data/rules/kp.dat https://kprule.com/kp.dat
	#wget --no-check-certificate -q -O /tmp/koolproxy/data/user.txt https://kprule.com/user.txt
	#运行koolproxy二进制文件
	kp_run
else
	exit
fi
}

kp_run()
{
/tmp/koolproxy/koolproxy -d
}

kp_start()
{
[ -n "$(ps|grep '/tmp/koolproxy/koolproxy'|grep -v 'grep')" ] && exit
rm -rf /tmp/koolproxy/data
mkdir -p /tmp/koolproxy/data
#运行koolproxy二进制文件
kp_run
####################已下规则怎么设置，求大神修改，谢谢######################
LOCAL_PORT=3000
#防止重复添加规则
iptables -t nat -C PREROUTING -j KOOLPROXY 2>/dev/null && [ $? -eq 0 ] && return 2
#创建所需的ipset
#IPSET_ADB="adblock"
#ipset -! create $IPSET_ADB iphash && ipset -! add $IPSET_ADB 110.110.110.110
#生成代理规则
iptables -t nat -N KOOLPROXY
#  忽略特殊IP段
iptables -t nat -A KOOLPROXY -d 0.0.0.0/8 -j RETURN
iptables -t nat -A KOOLPROXY -d 10.0.0.0/8 -j RETURN
iptables -t nat -A KOOLPROXY -d 127.0.0.0/8 -j RETURN
iptables -t nat -A KOOLPROXY -d 169.254.0.0/16 -j RETURN
iptables -t nat -A KOOLPROXY -d 172.16.0.0/12 -j RETURN
iptables -t nat -A KOOLPROXY -d 192.168.0.0/16 -j RETURN
iptables -t nat -A KOOLPROXY -d 224.0.0.0/4 -j RETURN
iptables -t nat -A KOOLPROXY -d 240.0.0.0/4 -j RETURN
#获取默认规则行号
#BL_INDEX=`iptables -t nat -L PREROUTING|tail -n +3|sed -n -e '/^BLACKLIST/='`
#[ -n "$BL_INDEX" ] && let RULE_INDEX=$BL_INDEX+1
#确保添加到默认规则之前
#iptables -t nat -I PREROUTING $RULE_INDEX -j KOOLPROXY
iptables -t nat -I PREROUTING -j KOOLPROXY

#  生成对应CHAIN
iptables -t nat -N KOOLPROXY_GLO
iptables -t nat -A KOOLPROXY_GLO -p tcp --dport 80 -j REDIRECT --to $LOCAL_PORT
#加载默认代理模式
iptables -t nat -A KOOLPROXY -j KOOLPROXY_GLO
####################已上规则怎么设置，求大神修改，谢谢######################
}

kp_stop()
{
iptables -t nat -D PREROUTING -j KOOLPROXY 2>/dev/null
iptables -t nat -F KOOLPROXY 2>/dev/null && iptables -t nat -X KOOLPROXY 2>/dev/null
iptables -t nat -F KOOLPROXY_GLO 2>/dev/null && iptables -t nat -X KOOLPROXY_GLO 2>/dev/null

kill -9 $(ps|grep '/tmp/koolproxy/koolproxy'|grep -v 'grep'|awk '{print$1}') 2>/dev/null

}

abcj=$1
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`
case $abcj in

on)
	kp_init
	#kp_stop
	kp_start
	;;
off)
	kp_stop
	;;
up)
	kp_updata
	;;
del)
	kp_stop
	rm -rf /tmp/koolproxy
	;;
*)
	echo "on off up del"
	;;
esac
