#!/bin/sh
#出脚本兼容H大、灯大padavan固件
#脚本运行命令+参数sh ssget.sh *
####################已完成##################
#*为空:只更新节点列表
#*为run:更新节点列表+自动完成设置（只更新一次）
#*为stop:脚本停止运行，针对后台守护模式
#*为del:卸载脚本
#*为clean:脚本出现未知BUY使用
####################未完成##################
#（开发中）*为runing:更新节点列表+自动完成设置（后台守护模式）俗称全自动
#（开发完善中）*为install:安装脚本表+自动完成设置（后台守护模式）
#后期开发功：1、安装，2、运行（后台守护模式），3、SS和SSR地址解析+自动设置，4、自定义免费SS资源收集+自动选优服+自动设置
abc_init () {
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
#默认参数5
abcp=5
rm -f /tmp/ssget*
ss_link_1=email.163.com
abchod=`nvram get ss_link_1`
if [ "1$abchod" = "1email.163.com" ]; then
	abcd=`echo "$abcc" | base64 -d`
	abcr=h
	else
	abc_ddinit
	abcr=d
fi
}

abc_ddinit () {
if [ ! -f /tmp/busybox ]; then
	wget --no-check-certificate https://raw.githubusercontent.com/nslook/padavanssidup/master/toolbin/busybox -O /tmp/busybox
	sleep 1
	chmod +x /tmp/busybox
fi
ddycss=`nvram get google_fu_mode`
if [ "1$ddycss" = "10xDEADBEEF" ]; then
	sleep 1
else
	nvram set google_fu_mode=0xDEADBEEF
	#nvram commit
	sleep 10
fi
abcd=`echo "$abcc" | /tmp/busybox base64 -d`
}

abc_get () {
abca=0
abcb=1
rm -f /tmp/abci*
#abcd=`echo "$abcc" | base64 -d`
wget --no-check-certificate -q $abcd -O /tmp/abci
if [ ! -f /tmp/abci ]; then
	wget --no-check-certificate -q https://www.baidu.com -O /tmp/abci
	return
fi
#nvram set rt_ssnum_x=0
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
	
	if [ "1$abcr" = "1h" ]; then
		#hiboy
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
	fi
	
	if [ "1$abcr" = "1d" ]; then
		#dengda
		nvram set ss_node_name_x$abca=$abcb	
		nvram set ss_node_server_addr_x$abca=$abce
		nvram set ss_node_server_port_x$abca=$abcf
		#nvram set ss_node_method_x$abca=$abch
		nvram set ss_node_method_x$abca=6
		nvram set ss_node_password_x$abca=$abcg
		let abca++
		let abcb++
		nvram set ss_node_num_x=$abca
	fi
	
	if [ "1$abca" = "19" ]; then
		break
	fi
done
#return
}

abc_set () {
if [ "$abcq" -gt "0" ] && [ "$abcq" -lt "10" ]; then
	let abcq--
else
	abcq=`tr -cd 0-8 </dev/urandom | head -c 1`
fi
if [ "1$abcr" = "1h" ]; then
	abc_seth
fi
if [ "1$abcr" = "1d" ]; then
	abc_setd
fi
}

abc_seth () {
abck=`nvram get rt_ss_password_x$abcq`
abcl=`nvram get ss_key`
abcm=`nvram get rt_ss_server_x$abcq`
abcn=`nvram get ss_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	#logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	return
else
	nvram set ss_server=`nvram get rt_ss_server_x$abcq`
	nvram set ss_server_port=`nvram get rt_ss_port_x$abcq`
	nvram set ss_key=`nvram get rt_ss_password_x$abcq`
	nvram set ss_method=`nvram get rt_ss_method_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
fi
}

abc_setd () {
abck=`nvram get ss_node_password_x$abcq`
abcl=`nvram get dssgets_key`
abcm=`nvram get ss_node_server_addr_x$abcq`
abcn=`nvram get dssgets_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	#logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
exit
	else
	nvram set shadowsocks_master_config=$abcq
	nvram set dssgets_server=`nvram get ss_node_server_addr_x$abcq`
	nvram set dssgets_key=`nvram get ss_node_password_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
fi
}

abc_restart () {
if [ "1$abcr" = "1h" ]; then
	abc_restarh
fi
if [ "1$abcr" = "1d" ]; then
	abc_restard
fi
}

abc_restarh () {
sspower=`nvram get ss_enable`
if [ "1$sspower" = "10" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：当前SS还未启动！！！"
	return
else
	/etc/storage/ez_buttons_script.sh cleanss &
	sleep 60
fi
}

abc_restard () {
sspower=`nvram get shadowsocks_enable`
if [ "1$sspower" = "10" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：当前SS还未启动！！！"
	return
else
	restart_ss
fi
}






abc_keep2()
{

}

abc_keep()
{

}

abc_install () {



}

abc_del () {

nvram set abcss_run=0
sed -i '/sleep/d' /etc/storage/post_wan_script.sh
sed -i '/ssget/d' /etc/storage/post_wan_script.sh
rm -f /etc/storage/ssget.sh
rm -f /tmp/ssget*
nvram set rt_ssnum_x=0
logger -t "【全自动SS获取脚本】" "全自动免费SS获取脚本（无人值守版）已卸载！5分钟中内关闭后台运行脚本"
exit

}

abc_stop () {

nvram set abcss_run=0
logger -t "【全自动SS获取脚本】" "脚本状态：5分钟中内关闭脚本"
exit

}

abc_main () {




}

abc_ssadd () {

return

}

abc_ssradd () {

return

}

abc_clean () {

nvram set abcss_enable=0
nvram set abcss_run=0
rm -f /tmp/abci*
rm -f /tmp/ssget*

}

abc_sub () {

return

}

abcj=$1
abcq=$2
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`

case $abcj in
#install)
#	abc_install
#	;;
stop)
	abc_stop
	;;
del)
	abc_del
	;;
	
clean)
	abc_clean
	;;
run)
	abc_init
	abc_get
	abc_set
	abc_restart
	abc_clean
	;;
*)
	abc_init
	abc_get
	abc_clean
	;;
esac

