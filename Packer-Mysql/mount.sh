#!/bin/bash
disk=/dev/nvme1n1
file=/mnt/data
#UUID=`sudo blkid | grep $disk | awk '{print $2}' | sed 's/"//g'`
message "格式化硬碟、放入FSTAB確保開機掛載"
sudo mkfs -t xfs $disk
sudo mkdir $file
sudo mount -t xfs $disk $file
sudo chmod 777 /etc/fstab
sudo cat << EOF >> /etc/fstab
$disk $file xfs defaults 0 0
EOF
sudo chmod 644 /etc/fstab

message "建立slowlog檔案、給予權限"
sudo touch /var/log/mysqld-slow.log
sudo chmod 777 /var/log/mysqld-slow.log