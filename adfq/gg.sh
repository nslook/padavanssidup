#!/bin/sh

ad_on()
{
sed -i '/123321/d' /etc/dnsmasq.conf
echo "addn-hosts=/etc/123321/hosts" >> /etc/dnsmasq.conf
killall dnsmasq
sleep 1
/etc/init.d/dnsmasq restart > /dev/null 2>&1
#return
}

ad_off()
{
sed -i '/123321/d' /etc/dnsmasq.conf
killall dnsmasq
sleep 1
/etc/init.d/dnsmasq restart > /dev/null 2>&1
#return
}

abcj=$1
abcj=`echo $abcj | tr '[A-Z]' '[a-z]'`
case $abcj in

on)
	ad_on
	;;
off)
	ad_off
	;;
ad)
	echo "127.0.0.1 $2" >> /etc/123321/hosts
	;;
fq)
	echo "$2 $3" >> /etc/123321/hosts
	;;
d)
	sed -i "/$2/d" /etc/123321/hosts
	;;
*)
	#ad_on
	echo " "
	echo "[on]             start: sh gg.sh on"
	echo "[off]             stop: sh gg.sh off"
	echo "[ad]    Add ad address: sh gg.sh ad xx.xx.com"
	echo "[fq]    Add qf address: sh gg.sh fq 255.123.123.123 xx.xx.com"
	echo "[d]  del ad/qf address: sh gg.sh d xx.xx.com"
	echo " "
	;;
esac



#sh /etc/123321/gg.sh
#sh /etc/123321/gg.sh stop
#sed -i '/del.com/d' /etc/123321/hosts
#echo "127.0.0.1 www.xx.com" >> /etc/123321/hosts
