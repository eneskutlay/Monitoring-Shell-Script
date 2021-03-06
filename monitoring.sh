#!/bin/bash
printf	"#Architecture: "
uname -srvmo

printf	"#CPU physical: "
nproc --all

printf	"#vCPU: "
cat /proc/cpuinfo | grep processor | wc -l

printf	"#Memmory Usage: "
free -m | grep Mem | awk '{printf"%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100}'

printf "#Disk Usage: "
df -BM -a | grep /dev/mapper/ | awk '{sum+=$3}END{print sum}' | tr -d '\n'
printf "/"
df -BM -a | grep /dev/mapper/ | awk '{sum+=$4}END{print sum}' | tr -d '\n'
printf "MB ("
df -BM -a | grep /dev/mapper/ | awk '{sum1+=$3 ; sum2+=$4}END{printf "%d", sum1 / sum2 * 100}' | tr -d '\n'
printf "%%)\n"

printf	"#CPU load: "
top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%\n"), $1 + $3}'

printf	"#Last boot: "
who -b | sed -e 's/system boot//g' -e 's/^ *//g'

printf	"#LVM use: "
if [ "$(lsblk | grep lvm | wc -l)" -gt 0 ] ; then
	printf	"yes\n" ;
else
	printf	"no\n" ;
fi

printf	"#Connexions TCP: "
ss | grep -i tcp | wc -l | tr -d '\n'
printf	" ESTABLISHED\n"

printf	"#User log: "
who | wc -l

printf	"#Network: IP "
/sbin/ifconfig | grep broadcast | sed -e 's/inet//g' -e 's/netmask.*//g' -e 's/ //g' | tr -d '\n'

printf	" ("
/sbin/ifconfig | grep 'ether ' | sed -e 's/.*ether //g' -e 's/ .*//g' | tr -d '\n'
printf	")\n"

printf	"#Sudo: "
journalctl -q _COMM=sudo | grep COMMAND | wc -l | tr -d '\n'
printf	" cmd\n"
