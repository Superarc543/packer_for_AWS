#!/bin/bash
URL=https://github.com/prometheus/mysqld_exporter/releases/download/v0.13.0/mysqld_exporter-0.13.0.linux-amd64.tar.gz
name=mysqld_exporter

message "開始下載安裝mysql_exporter"
sudo wget -P /tmp $URL
sudo tar -C /tmp/ -zxvf /tmp/mysqld_exporter-0.13.0.linux-amd64.tar.gz
sudo mkdir /etc/$name
sudo mv /tmp/mysqld_exporter-0.13.0.linux-amd64/* /etc/$name

message "建立mysql_exporter用-exporter_my.cnf"
sudo bash -c "cat > /etc/$name/my.cnf" << EOF
[client]
host=localhost
port=3306
user=prometheus
password=1qaz@WSX
EOF

message "創建mysql_exporter啟動"
sudo bash -c "cat > /etc/systemd/system/$name.service" <<\EOF
[Service]
ExecStart=/etc/mysqld_exporter/mysqld_exporter \
--collect.info_schema.processlist \
--config.my-cnf=/etc/mysqld_exporter/my.cnf

[Install]
WantedBy=multi-user.target

[Unit]
Description=mysqld_exporter
After=network.target
EOF
message "開機啟動MYSQLD_EXPORTER"
sudo systemctl daemon-reload && sudo systemctl enable $name