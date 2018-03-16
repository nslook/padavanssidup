#!/bin/sh

ad_on()
{
sed -i '/123321/d' /etc/dnsmasq.conf
echo "addn-hosts=/tmp/123321/hosts" >> /etc/dnsmasq.conf
echo "conf-dir=/tmp/123321/conf" >> /etc/dnsmasq.conf
echo "conf-file=/tmp/123321/dnsfq" >> /etc/dnsmasq.conf
rm -rf /tmp/123321
mkdir -p /tmp/123321/conf
cd /tmp/123321
wget --no-check-certificate -q -O /tmp/123321/dnsfq https://raw.githubusercontent.com/sy618/hosts/master/dnsmasq/dnsfq
wget --no-check-certificate -q -O /tmp/123321/conf/ip.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/ip.conf
wget --no-check-certificate -q -O /tmp/123321/conf/union.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf
wget --no-check-certificate -q -O /tmp/123321/hosts https://raw.githubusercontent.com/vokins/yhosts/master/hosts
wget --no-check-certificate -q -O /tmp/123321/whitelist https://raw.githubusercontent.com/nslook/padavanssidup/master/adfq/whitelist
cat /tmp/123321/conf/union.conf | sed "/#/d" | sed "s/address\=\/.//g" | sed "s/\/0.0.0.0//g" | sed "/^$/d" > /tmp/123321/domain
cat /tmp/123321/whitelist >> /tmp/123321/domain;sed -i "/^$/d" /tmp/123321/domain
cat /tmp/123321/domain | while read line ;do sed -i "/$line/d" /tmp/123321/hosts;done
sed -i "/#/d" /tmp/123321/hosts
sed -i "s/0.0.0.0/127.0.0.1/g" /tmp/123321/hosts
sed -i "/^$/d" /tmp/123321/hosts
sed -i "s/0.0.0.0/127.0.0.1/g" /tmp/123321/conf/union.conf
/etc/init.d/dnsmasq restart > /dev/null 2>&1
}

ad_off()
{
sed -i '/123321/d' /etc/dnsmasq.conf
rm -rf /tmp/123321
/etc/init.d/dnsmasq restart > /dev/null 2>&1
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
	echo "127.0.0.1 $2" >> /tmp/123321/hosts
	;;
fq)
	echo "$2 $3" >> /tmp/123321/hosts
	;;
d)
	sed -i "/$2/d" /tmp/123321/hosts
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
