#!/bin/bash
yum -y install expect &>/dev/null
read -p "请输入ssh-copy-id的IP: " num
/usr/bin/expect<<EOF
set timeout 300
spawn ssh-keygen
expect "Enter file in which to save the key (/root/.ssh/id_rsa):"
send "\n"
expect "Enter passphrase (empty for no passphrase):"
send "\n"
expect "Enter same passphrase again:"
send "\n"
spawn  ssh-copy-id $num
expect {
    "yes/no" { send "yes\n"; exp_continue}     
    "root@$num's password:" { send "1\n"}
}

expect eof
EOF
yum -y install rsync &>dev/null
ssh $num "yum -y install rsync" &>/dev/null
yum install -y inotify-tools-3.14-8.el7.x86_64.rpm &>/dev/null
mulu=/www/wordpress/
inotifywait -mrq -e modify,delete,create,attrib,move  --format '%T %w%f' --timefmt '%F %T' $mulu |while read line;do  rsync -azHAX --delete $mulu  $num:$mulu ; done &

