#!/bin/bash -e

MYSQL_URL="https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm"
MYSQL_CHECKSUM=e2bd920ba15cd3d651c1547661c60c7c
MYSQL_REPO=mysql80-community-release-el7-5.noarch.rpm
MYSQL_PASSWORD=1qaz@WSX

function message {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    sudo echo -e "[${TIMESTAMP}] [mysql-8] ${1}"
}

message "MySQL 8 install script"

if [ -z "${MYSQL_PASSWORD}" ]; then
  message "ERROR: Require 'MYSQL_PASSWORD' to be set"
  exit 1
fi

message "MYSQL_URL=${MYSQL_URL}"
message "MYSQL_CHECKSUM=${MYSQL_CHECKSUM}"
message "MYSQL_REPO=${MYSQL_REPO}"
message "Started"

message "Checking for existing MySQL repo"
if [ ! -f "/tmp/${MYSQL_REPO}" ]
then
    message "下載 MySQL repo"
    sudo curl --silent --location --output "/tmp/${MYSQL_REPO}" "${MYSQL_URL}"

    message "確認 MySQL repo源"
    sudo echo "${MYSQL_CHECKSUM}  /tmp/${MYSQL_REPO}" > /tmp/mysql-checksum
    sudo md5sum --quiet --check /tmp/mysql-checksum
    sudo rm /tmp/mysql-checksum

    message "安裝 MySQL repo"
    sudo rpm -Uvh "/tmp/${MYSQL_REPO}"
    sudo rm "/tmp/${MYSQL_REPO}"
else
    message "MySQL repo exists, skipping download"
fi

message "安裝 MySQL server"
sudo yum install -y "mysql-community-server"

message "安裝 MySQL shell"
sudo yum install -y "mysql-shell"

message "加入開機啟動、啟動MYSQL服務"
sudo systemctl --quiet enable mysqld.service
sudo systemctl --quiet start mysqld.service

message "等待MYSQL啟動-60s"
sleep 60

message "更換MYSQL初始化密碼"
MYSQL_TMP_PASSWORD="$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{ print $13 }')"
sudo mysql \
    --connect-expired-password \
    --user=root \
    --password="${MYSQL_TMP_PASSWORD}" \
    --execute="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" \
    -e "CREATE USER 'prometheus'@'%' IDENTIFIED BY '1qaz@WSX';" \
    -e "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'prometheus'@'%';" \
    -e "set global validate_password.policy=0;" \
    -e "set global validate_password.length=0;" \
    -e "set global validate_password.special_char_count=0;"

message "停止MYSQL服務"
sudo systemctl --quiet stop mysqld.service

message "MYSQL安裝完成"