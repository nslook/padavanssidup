#!/bin/sh
#此脚本为H大、灯大padavan固件专用
#wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/ssget.sh -O /tmp/ssget.sh;sh /tmp/ssget.sh install
####################已完成##################
#以下为脚本运行方式
# sh ssget.sh:只更新节点列表
# sh ssget.sh run:更新节点列表+自动完成设置（只更新一次）
# sh ssget.sh runing:更新节点列表+自动完成设置（后台守护模式、无人值守模式、撒手不管模式）俗称全自动
# sh ssget.sh stop:脚本停止运行（针对后台守护模式）
# sh ssget.sh install:安装脚本
# sh ssget.sh del:卸载脚本
# sh ssget.sh clean:脚本出现未知BUY使用
####################未完成##################
#已知BUG，灯大版无人值守模式，可能不更新（测试中）
#updata:脚本升级
#后期开发功：1、脚本自动升级，2、SS和SSR地址解析+自动设置，3、自定义免费SS资源收集+自动选优服+自动设置

abc_install()
{
sed -i '/sleep/d' /etc/storage/post_wan_script.sh
sed -i '/ssget/d' /etc/storage/post_wan_script.sh
cat >> /etc/storage/post_wan_script.sh << EOF
sleep 80
sh /etc/storage/ssget.sh run &
EOF
rm -f /etc/storage/ssget.sh
cp /tmp/ssget.sh /etc/storage/ssget.sh
#wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/ssget.sh -O /etc/storage/ssget.sh
logger -t "【全自动SS获取脚本】" "全自动免费SS获取脚本（无人值守版）安装成功！"
logger -t "【全自动SS获取脚本】" "运行命令：sh /etc/storage/ssget.sh"
logger -t "【全自动SS获取脚本】" "无人值守模式运行命令：sh /etc/storage/ssget.sh runing &"
logger -t "【全自动SS获取脚本】" "停止运行命令：sh /etc/storage/ssget.sh stop"
logger -t "【全自动SS获取脚本】" "卸载命令：sh /etc/storage/ssget.sh del"
echo "全自动免费SS获取脚本（无人值守版）安装成功！"
echo "运行命令：sh /etc/storage/ssget.sh"
echo "无人值守模式运行命令：sh /etc/storage/ssget.sh runing &"
echo "停止运行命令：sh /etc/storage/ssget.sh stop"
echo "卸载命令：sh /etc/storage/ssget.sh del"
logger -t "【全自动SS获取脚本】" "启动脚本（无人值守版）！"
sh /etc/storage/ssget.sh run &
rm -f /tmp/ssget*
#mtd_storage.sh save
exit
}

abc_del()
{
nvram set abcss_run=0
sed -i '/sleep/d' /etc/storage/post_wan_script.sh
sed -i '/ssget/d' /etc/storage/post_wan_script.sh
rm -f /etc/storage/ssget.sh
rm -f /tmp/ssget*
#nvram set rt_ssnum_x=0
logger -t "【全自动SS获取脚本】" "全自动免费SS获取脚本（无人值守版）已卸载！5分钟中内关闭后台运行脚本"
exit

}

abc_stop()
{
nvram set abcss_run=0
logger -t "【全自动SS获取脚本】" "脚本状态：5分钟中内关闭脚本"
exit
}

abc_clean()
{
nvram set abcss_enable=0
nvram set abcss_run=0
rm -f /tmp/abci*
rm -f /tmp/ssget*
}

abc_run()
{
abc_get_x=0
abc_set_x=0
abc_get
if [ "1$abc_get_x" = "11" ]; then
	abc_set
fi
if [ "1$abc_set_x" = "11" ]; then
	abc_restart
fi
abc_clean
}

abc_runing()
{
while true
do
	abc_get_x=0
	abc_set_x=0
	abc_get
	if [ "1$abc_get_x" = "11" ]; then
		abc_set
	fi
	abc_restart
	abc_keep
done
}

abc_runyn()
{
abcsssspower=`nvram get abcss_run`
if [ "1$abcsssspower" = "10" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：关闭脚本"
	abc_clean
	exit
fi
}

abc_init()
{
abcsssspower=`nvram get abcss_enable`
if [ "1$abcsssspower" = "11" ] && [ -f /tmp/abci ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：脚本已运行中，无需重复开启"
	#rm -f /tmp/abci*
	exit
fi
exit
nvram set abcss_enable=1
wget --no-check-certificate -q https://www.baidu.com -O /tmp/abci
abcc=aHR0cHM6Ly9nbG9iYWwuaXNoYWRvd3gubmV0Lw==
#默认参数5
abcp=5
rm -f /tmp/ssget*
abchod=`nvram get ss_link_1`
if [ "1$abchod" = "1email.163.com" ]; then
	abcd=`echo "$abcc" | base64 -d`
	abcr=h
	else
	abc_initd
	abcr=d
fi
}

abc_initd()
{
ddycss=`nvram get google_fu_mode`
if [ "1$ddycss" = "10xDEADBEEF" ]; then
	sleep 1
else
	nvram set google_fu_mode=0xDEADBEEF
	#nvram commit
	sleep 10
fi
if [ ! -f /etc/storage/busybox ]; then
	wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/toolbin/busybox -O /etc/storage/busybox
	sleep 1
	chmod +x /etc/storage/busybox
fi
abcd=`echo "$abcc" | /etc/storage/busybox base64 -d`
}

abc_get()
{
abca=0
abcb=1
rm -f /tmp/abci*
#abcd=`echo "$abcc" | base64 -d`
wget --no-check-certificate -q $abcd -O /tmp/abci
if [ ! -f /tmp/abci ]; then
	wget --no-check-certificate -q https://www.baidu.com -O /tmp/abci
	#sleep 60
	return
	else
	abc_get_x=1
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
}

abc_set()
{
abcq=$abct
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

abc_seth()
{
abck=`nvram get rt_ss_password_x$abcq`
abcl=`nvram get ss_key`
abcm=`nvram get rt_ss_server_x$abcq`
abcn=`nvram get ss_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	#abc_keep
	return
else
	nvram set ss_server=`nvram get rt_ss_server_x$abcq`
	nvram set ss_server_port=`nvram get rt_ss_port_x$abcq`
	nvram set ss_key=`nvram get rt_ss_password_x$abcq`
	nvram set ss_method=`nvram get rt_ss_method_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi
}

abc_setd()
{
abck=`nvram get ss_node_password_x$abcq`
abcl=`nvram get dssgets_key`
abcm=`nvram get ss_node_server_addr_x$abcq`
abcn=`nvram get dssgets_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	#abc_keep
	return
	else
	nvram set shadowsocks_master_config=$abcq
	nvram set dssgets_server=`nvram get ss_node_server_addr_x$abcq`
	nvram set dssgets_key=`nvram get ss_node_password_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi
}

abc_restart()
{
if [ "1$abcr" = "1h" ]; then
	abc_restarh
fi
if [ "1$abcr" = "1d" ]; then
	abc_restard
fi
}

abc_restarh()
{
sspower=`nvram get ss_enable`
if [ "1$sspower" = "11" ] && [ "1$abc_set_x" = "11" ]; then
	/etc/storage/ez_buttons_script.sh cleanss &
	sleep 60
else
	logger -t "【全自动SS获取脚本】" "脚本状态：SS无需重启！！！！！！"
	abc_keeph
fi
}

abc_restard()
{
sspower=`nvram get shadowsocks_enable`
if [ "1$sspower" = "11" ] && [ "1$abc_set_x" = "11" ]; then
	restart_ss
	sleep 30
else
	logger -t "【全自动SS获取脚本】" "脚本状态：SS无需重启！！！！！！"
	abc_keepd
fi
}

abc_keeph()
{
while true
do
	abc_runyn
	sleep 30
	sspower=`nvram get ss_enable`
	if [ "1$sspower" = "11" ]; then
		break
	else
		sleep 1
	fi
done
sleep 60
#abc_keep
}

abc_keepd()
{
while true
do
	abc_runyn
	sleep 30
	sspower=`nvram get shadowsocks_enable`
	if [ "1$sspower" = "11" ]; then
		break
	else
		sleep 1
	fi
done
sleep 30
#abc_keep
}

abc_keep()
{
abco=0
while true
do
	abc_runyn
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
		logger -t "【全自动SS获取脚本】" "网络全球通"
		abco=0
		sleep 300
	fi
	if [ "$abco" == "$abcp" ]; then
		abco=0
		break
	fi
done
}

#########以下开发中##########

abc_ss_ssr_add()
{
abc_ss_ssr_add_x=0
sszy_1=$1
sszy_ssorssr=`echo "$sszy_1" | cut -d ':' -f 1`

if [ "p$sszy_ssorssr" = "pssr" ] && [ "1$abcr" = "1h" ]; then
	sszy_zy=`echo "$sszy_1" | cut -b 7-`
	sszy_tmpkey=`echo "$sszy_zy" | awk -F '' '{print NF}'`
	sszy_tmpkey=`expr $sszy_tmpkey % 4`
	if [ "p$sszy_tmpkey" = "p1" ]; then
		sszy_zy=`echo "$sszy_zy===" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p2" ]; then
		sszy_zy=`echo "$sszy_zy==" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p3" ]; then
		sszy_zy=`echo "$sszy_zy=" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p0" ]; then
		sszy_zy=`echo "$sszy_zy" | base64 -d`
	fi
	abce=`echo "$sszy_zy" | cut -d ':' -f 1`
	abcf=`echo "$sszy_zy" | cut -d ':' -f 2 | cut -d ':' -f 1`
	sszy_ssr_type_protocol=`echo "$sszy_zy" | cut -d ':' -f 3 | cut -d ':' -f 1`
	abch=`echo "$sszy_zy" | cut -d ':' -f 4 | cut -d ':' -f 1 | tr '[A-Z]' '[a-z]'`
	sszy_ssr_type_obfs=`echo "$sszy_zy" | cut -d ':' -f 5 | cut -d ':' -f 1`
	sszy_key=`echo "$sszy_zy" | cut -d ':' -f 6 | cut -d '/' -f 1`
	sszy_tmpkey=`echo "$sszy_key" | awk -F '' '{print NF}'`
	sszy_tmpkey=`expr $sszy_tmpkey % 4`
	if [ "p$sszy_tmpkey" = "p1" ]; then
		abcg=`echo "$sszy_key===" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p2" ]; then
		abcg=`echo "$sszy_key==" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p3" ]; then
		abcg=`echo "$sszy_key=" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p0" ]; then
		abcg=`echo "$sszy_key" | base64 -d`
	fi
	logger -t "【SSR://转译】" "服务器：$abce 端口：$abcf 密码：$abcg 加密方式：$abch 协议插件：$sszy_ssr_type_protocol 混淆插件：$sszy_ssr_type_obfs"
	echo "服务器：$abce 端口：$abcf 密码：$abcg 加密方式：$abch 协议插件：$sszy_ssr_type_protocol 混淆插件：$sszy_ssr_type_obfs"
	abc_ss_ssr_add_x=1
fi
if [ "p$sszy_ssorssr" = "pss" ]; then
	sszy_zy=`echo "$sszy_1" | cut -b 6-`
	sszy_tmpkey=`echo "$sszy_zy" | awk -F '' '{print NF}'`
	sszy_tmpkey=`expr $sszy_tmpkey % 4`
	if [ "p$sszy_tmpkey" = "p1" ] && [ "1$abcr" = "1h" ]; then
		sszy_zy=`echo "$sszy_zy===" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p2" ] && [ "1$abcr" = "1h" ]; then
		sszy_zy=`echo "$sszy_zy==" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p3" ] && [ "1$abcr" = "1h" ]; then
		sszy_zy=`echo "$sszy_zy=" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p0" ] && [ "1$abcr" = "1h" ]; then
		sszy_zy=`echo "$sszy_zy" | base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p1" ] && [ "1$abcr" = "1d" ]; then
		sszy_zy=`echo "$sszy_zy===" | /etc/storage/busybox base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p2" ] && [ "1$abcr" = "1d" ]; then
		sszy_zy=`echo "$sszy_zy==" | /etc/storage/busybox base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p3" ] && [ "1$abcr" = "1d" ]; then
		sszy_zy=`echo "$sszy_zy=" | /etc/storage/busybox base64 -d`
	fi
	if [ "p$sszy_tmpkey" = "p0" ] && [ "1$abcr" = "1d" ]; then
		sszy_zy=`echo "$sszy_zy" | /etc/storage/busybox base64 -d`
	fi
	abch=`echo "$sszy_zy" | cut -d ':' -f 1 | tr '[A-Z]' '[a-z]'`
	abcg=`echo "$sszy_zy" | cut -d ':' -f 2 | cut -d '@' -f 1`
	abce=`echo "$sszy_zy" | cut -d '@' -f 2 | cut -d ':' -f 1`
	abcf=`echo "$sszy_zy" | cut -d ':' -f 3`
	logger -t "【SS://转译】" "服务器：$abce 端口：$abcf 密码：$abcg 加密方式：$abch"
	echo "服务器：$abce 端口：$abcf 密码：$abcg 加密方式：$abch "
	abc_ss_ssr_add_x=1
fi

}



abc_setaddh()
{

if [ "1$abcr" = "1h" ]; then
	nvram set ss_server=$abce
	nvram set ss_server_port=$abcf
	nvram set ss_key=$abcg
	nvram set ss_method=$abch
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi
if [ "1$abcr" = "1d" ]; then
	abcaddd=10
	nvram set ss_node_name_x$abcaddd=ssadd	
	nvram set ss_node_server_addr_x$abcaddd=$abce
	nvram set ss_node_server_port_x$abcaddd=$abcf
	#nvram set ss_node_method_x$abcaddd=$abch
	nvram set ss_node_method_x$abcaddd=6
	nvram set ss_node_password_x$abcaddd=$abcg
	
	nvram set shadowsocks_master_config=$abcaddd
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi












abck=`nvram get rt_ss_password_x$abcq`
abcl=`nvram get ss_key`
abcm=`nvram get rt_ss_server_x$abcq`
abcn=`nvram get ss_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	#abc_keep
	return
else
	nvram set ss_server=`nvram get rt_ss_server_x$abcq`
	nvram set ss_server_port=`nvram get rt_ss_port_x$abcq`
	nvram set ss_key=`nvram get rt_ss_password_x$abcq`
	nvram set ss_method=`nvram get rt_ss_method_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi
}

abc_setaddd()
{
abck=`nvram get ss_node_password_x$abcq`
abcl=`nvram get dssgets_key`
abcm=`nvram get ss_node_server_addr_x$abcq`
abcn=`nvram get dssgets_server`
if [ "1$abck" = "1$abcl" ] && [ "1$abcm" = "1$abcn" ]; then
	logger -t "【全自动SS获取脚本】" "脚本状态：最新获取的服务器、密码未变更"
	#abc_keep
	return
	else
	nvram set shadowsocks_master_config=$abcq
	nvram set dssgets_server=`nvram get ss_node_server_addr_x$abcq`
	nvram set dssgets_key=`nvram get ss_node_password_x$abcq`
	#nvram commit
	logger -t "【全自动SS获取脚本】" "脚本状态：更新获取的服务器、端口、密码！！！"
	abc_set_x=1
fi
}





abc_sub () {

return

}

abcj=$1
abct=$2
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`

case $abcj in
install)
	abc_install
	;;
stop)
	abc_stop
	;;
del)
	abc_del
	;;
clean)
	abc_clean
	;;
runing)
	logger -t "【全自动SS获取脚本】" "更新节点列表+自动设置（全自动模式）"
	abc_init
	nvram set abcss_run=1
	abc_runing
	;;
run)
	nvram set abcss_run=0
	logger -t "【全自动SS获取脚本】" "更新节点列表+自动设置（半自动）"
	abc_init
	abc_run
	;;
*)
	nvram set abcss_run=0
	logger -t "【全自动SS获取脚本】" "更新节点列表"
	abc_init
	abc_get
	abc_clean
	;;
esac

