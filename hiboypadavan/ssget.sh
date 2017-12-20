#!/bin/sh
####### hiboy老毛子固件专用 #######
#安装、重装运行命令：wget --no-check-certificate https://raw.githubusercontent.com/nslook/padavanssidup/master/hiboypadavan/ssget.sh -O /tmp/ssget.sh;sh /tmp/ssget.sh install

abcj=$1
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`
if [ "1$abcj" = "1install" ]; then
	sed -i '/sleep/d' /etc/storage/post_wan_script.sh
	sed -i '/ssget/d' /etc/storage/post_wan_script.sh
	cat >> /etc/storage/post_wan_script.sh << EOF
	sleep 80
	sh /etc/storage/ssget.sh &
	EOF
	rm -f /etc/storage/ssget.sh
	cp /tmp/ssget.sh /etc/storage/ssget.sh
	#wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/hiboypadavan/ssget.sh -O /etc/storage/ssget.sh
	logger -t "【全自动SS获取脚本】" "全自动免费SS获取脚本（无人值守版）安装成功！"
	logger -t "【全自动SS获取脚本】" "停止运行命令：sh /etc/storage/ssget.sh stop"
	logger -t "【全自动SS获取脚本】" "卸载命令：sh /etc/storage/ssget.sh del"
 	logger -t "【全自动SS获取脚本】" "启动脚本（无人值守版）！"
 	sh /etc/storage/ssget.sh &
	rm -f /tmp/ssget*
	exit
fi

if [ "1$abcj" = "1del" ]; then
	nvram set abcss_run=0
	sed -i '/sleep/d' /etc/storage/post_wan_script.sh
	sed -i '/ssget/d' /etc/storage/post_wan_script.sh
	rm -f /etc/storage/ssget.sh
	rm -f /tmp/ssget*
	nvram set rt_ssnum_x=0
	logger -t "【全自动SS获取脚本】" "全自动免费SS获取脚本（无人值守版）已卸载！5分钟中内关闭后台运行脚本"
	exit
fi

if [ "1$abcj" = "1stop" ]; then
	nvram set abcss_run=0
	logger -t "【全自动SS获取脚本】" "脚本状态：5分钟中内关闭脚本"
	exit
fi

abcsssspower=`nvram get abcss_enable`
if [ "1$abcsssspower" = "11" ] && [ -f /tmp/abci ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：脚本已运行中，无需重复开启"
	rm -f /tmp/abci*
	exit
fi
nvram set abcss_enable=1
nvram set abcss_run=1
wget --no-check-certificate -q https://www.baidu.com -O /tmp/abci
abcc=aHR0cHM6Ly9nbG9iYWwuaXNoYWRvd3gubmV0Lw==

abc_start()
{
abca=0
abcb=1
rm -f /tmp/abci*
abcd=`echo "$abcc" | base64 -d`
wget --no-check-certificate -q $abcd -O /tmp/abci
if [ ! -f /tmp/abci ]; then
	wget --no-check-certificate -q https://www.baidu.com -O /tmp/abci
	sleep 60
	abc_keep
fi
nvram set rt_ssnum_x=0
sed -i '1,/<div class="hover-text">/d' /tmp/abci
while true
do
	abce=`sed -n '1p' /tmp/abci | cut -d '>' -f 3 | cut -d '<' -f 1`
	abcf=`sed -n '2p' /tmp/abci | cut -d '>' -f 3`
	abcg=`sed -n '4p' /tmp/abci | cut -d '>' -f 3`
	abch=`sed -n '6p' /tmp/abci | cut -d ':' -f 2 | cut -d '<' -f 1 | tr '[A-Z]' '[a-z]'`
	if [ "1$abce" = "1" ]; then
	break
	else
	sed -i '1,/<div class="hover-text">/d' /tmp/abci
	fi
	nvram set rt_ss_name_x$abca=$abcb	
	nvram set rt_ss_server_x$abca=$abce
	nvram set rt_ss_port_x$abca=$abcf
	nvram set rt_ss_method_x$abca=$abch
	nvram set rt_ss_password_x$abca=$abcg
	nvram set rt_ss_usage_x$abca=" -O origin -o plain"
	nvram set rt_ss_method_write_x_0$abca=
	let abca++
	let abcb++
	nvram set rt_ssnum_x=$abca
	if [ "1$abca" = "19" ]; then
	break
	fi
done
if [ "$abcj" -gt "0" ] && [ "$abcj" -lt "10" ]; then
	abcq=abcj
	let abcq--
	else
	abcq=`tr -cd 0-8 </dev/urandom | head -c 1`
fi
abck=`nvram get rt_ss_password_x$abcq`
abcl=`nvram get ss_key`
abcm=`nvram get rt_ss_server_x$abcq`
abcn=`nvram get ss_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	#logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	abc_keep
	else
	nvram set ss_server=`nvram get rt_ss_server_x$abcq`
	nvram set ss_server_port=`nvram get rt_ss_port_x$abcq`
	nvram set ss_key=`nvram get rt_ss_password_x$abcq`
	nvram set ss_method=`nvram get rt_ss_method_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
fi
sspower=`nvram get ss_enable`
if [ "1$sspower" = "10" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：当前SS还未启动！！！"
	abc_keep2
else
	/etc/storage/ez_buttons_script.sh cleanss &
	sleep 60
fi
abc_keep
}

abc_keep2()
{
while true
do
	sleep 30
	sspower=`nvram get ss_enable`
	if [ "1$sspower" = "10" ]; then
		sleep 1
	else
		break
	fi
done
sleep 60
abc_keep
}

abc_keep()
{
abco=0
while true
do
	abcsssspower=`nvram get abcss_run`
	if [ "1$abcsssspower" = "10" ]; then
		logger -t "【全自动SS获取脚本】" "脚本状态：关闭脚本"
		nvram set abcss_enable=0
		rm -f /tmp/abci*
		exit
	fi
	abcdd=0
	abcgg=0
	wget --no-check-certificate -q -T 10 "www.baidu.com" -O /dev/null;[ "$?" == "0" ] && abcdd=1
  sleep 1
	wget --no-check-certificate -q -T 10 "www.google.com.hk" -O /dev/null;[ "$?" == "0" ] && abcgg=1
	if [ "$abcdd" == "0" ] && [ "$abcgg" == "0" ]; then
		logger -t "【全自动SS获取脚本】" "网络瘫痪,请检查是否已联网"
		sleep 60
	fi
	
	if [ "$abcdd" == "0" ] && [ "$abcgg" == "1" ]; then
		sleep 60
	fi
	
	if [ "$abcdd" == "1" ] && [ "$abcgg" == "0" ]; then
		let abco++
		logger -t "【全自动SS获取脚本】" "SS服务器检测失败 $abco 次，失败 $abcp 次后重新获取"
		sleep 30
	fi
	
	if [ "$abcdd" == "1" ] && [ "$abcgg" == "1" ]; then
		#logger -t "【全自动SS获取脚本】" "网络全球通"
		abco=0
		sleep 300
	fi
	
	if [ "$abco" == "$abcp" ]; then
		abco=0
		break
	fi
done
abc_start
}

#默认参数5
abcp=5
logger -t "【全自动SS获取脚本】" "脚本状态：开启（自守护模式）"
rm -f /tmp/ssget*
abc_start
