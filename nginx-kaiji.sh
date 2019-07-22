#!/bin/bash
nginxnum=`egrep "^ +listen" /usr/local/nginx/conf/nginx.conf|awk -F " +|;" '{print $3}'`
name=`netstat -tanpl|grep ngin[x]|awk -F " +|:|/" '{print $10}'|uniq`
nginx=/usr/sbin/nginx
file=/usr/local/nginx/logs/nginx.pid
case $1 in
stop)
    [ -e $file ] && $nginx -s $1 || echo "nginx already stop"
;;
start)
 if [ -e $file ] 
then
	echo "nginx in busy"
else
for i in  "$nginxnum"  #弱引把它当成一个整体，只循环一次
do
 if netstat -tanpl|egrep  "\<$i\>" 
then
 echo "port in busy"  
else
 $nginx && exit
fi
done
fi
;;
reload)
	[ ! -e $file ] && echo "nginx already stop" && $nginx
        [ -e $file ] &&  $nginx -s $1  ;;
restart)
    [ ! -e $file ] && echo "nginx already stop" && $nginx
    [ -e $file ] && $nginx -s stop && $nginx		;;
*)
esac
