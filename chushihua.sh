#!/bin/bash
[ "$1" == "-h" ] || [ "$1" == "--help" ]  &&  echo "usge: $(basename $0) 脚本使用方法.如果\$1是为空:
输编号"1"是关闭setenforce的功能 
"2"是关闭防火墙
"3"是永久关闭防火墙
"um"是配置本地源,
"net"是配置网络源.
"epel"是配置网络源 
"4" 是配置固定IP.
--------------------------------------
\$1是-h或者是--help就查看此脚本的用法.
\$2是更改网卡ip地址最后一位。
\$1 如果不是上述选项就是修改主机名.  
------------------------------------ "  &&  exit 
if [ -z "$1" ] 
then
read -p "请输入功能编号("1"是关闭setenforce的功能 
"2"是关闭防火墙
"3"是永久关闭防火墙
"um"是配置本地源,
"net"是配置网络源.
"epel"是配置网络源 
"4" 是配置固定IP.): " num
[ -d /etc/yum.repos.d/repodir ] ||  mkdir /etc/yum.repos.d/repodir 
[ -f /etc/yum.repos.d/Cen* ] && mv /etc/yum.repos.d/Cen* /etc/yum.repos.d/repodir 
case "$num" in
um)
if  `df -h|grep "/mnt$" &>/dev/null` 
then 	 
echo "[localdisk]     
name=local disk for centos7.3              
baseurl=file:///mnt    
enabled=1                              
gpgcheck=0 " > /etc/yum.repos.d/local.repo
yum makecache && yum repolist && exit
else
mount /dev/sr0 /mnt
echo "[localdisk]     
name=local disk for centos7.3              
baseurl=file:///mnt    
enabled=1                              
gpgcheck=0 " > /etc/yum.repos.d/local.repo
yum makecache && yum repolist && exit
fi
;;
net)
echo "[centos7]
name=centos-el7-tsinghua
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7" > /etc/yum.repos.d/qinghua.repo
yum makecache  && yum repolist && exit
;;
epel)
echo "[epel]
name=centos-epel
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/epel/RPM-GPG-KEY-EPEL-7" > /etc/yum.repos.d/epel.repo
yum makecache  && yum repolist && exit
;;
1)
 setenforce 0 &&  sed -i -r '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config && exit 
;;
2)
 systemctl stop firewalld && exit
;;
3)
 systemctl disable  firewalld && exit
;;
4)
	wangka=ens33
	echo "			
TYPE=Ethernet		
BOOTPROTO=none			
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=$wangka
DEVICE=$wangka
ONBOOT=yes
DNS1=114.114.114.114
" >/etc/sysconfig/network-scripts/ifcfg-$wangka
read -p "请输入IP: " p
read -p "请输入网关: " g
echo "IPADDR=$p" >>/etc/sysconfig/network-scripts/ifcfg-$wangka
echo "GATEWAY=$g" >>/etc/sysconfig/network-scripts/ifcfg-$wangka
ifdown $wangka;ifup $wangka
;;
esac
fi
if [ -n "$2" ]
then
	wangka=ens33
	sed -i -r "/IPADDR/s/.[0-9]+$/.$2/" /etc/sysconfig/network-scripts/ifcfg-$wangka 
	ifdown $wangka;ifup $wangka
elif [ -n "$1" ]
then
	hostname "$1" && echo "$1" > /etc/hostname
fi
