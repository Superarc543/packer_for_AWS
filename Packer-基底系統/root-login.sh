#!/bin/bash
##關閉ipv6功能
sudo sed -i '$anet.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf
sudo sed -i '$anet.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf
##TCP監聽佇列增加
sudo sed -i '$anet.core.somaxconn = 10000' /etc/sysctl.conf
##TCP SYN隊列最大長度，可加大等待的網路連線數
sudo sed -i '$anet.ipv4.tcp_max_syn_backlog = 2048' /etc/sysctl.conf
##開啟TCP快速三向交斡
sudo sed -i '$anet.ipv4.tcp_fastopen = 3' /etc/sysctl.conf
##讓/etc/sysctl.conf生效
sudo sysctl -p
##關閉 內建防火牆
sudo systemctl stop firewalld.service && sudo systemctl disable firewalld.service
##更新
sudo yum update -y
##安裝套件
sudo yum install -y nano && sudo yum install -y unzip && sudo yum install -y wget
##放入金鑰
sudo mkdir ~/.aws && sudo mv /tmp/credentials ~/.aws/

sleep 3s

message "Install Node_exporter"
##Install Node_exporter
#sudo wget -P /tmp https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
sudo tar -C /tmp/ -zxvf /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
sudo mkdir /etc/node_exporter
sudo mv /tmp/node_exporter-1.3.1.linux-amd64/* /etc/node_exporter
sudo rm -rf /tmp/node_exporter-1.3.1.linux-amd64.tar.gz

message "建立node_exporter開機啟動服務"
sudo bash -c "cat > /etc/systemd/system/node_exporter.service" <<\EOF
[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always
RestartSec=30
StartLimitInterval=10

[Install]
WantedBy=multi-user.target

[Unit]
Description=node_exporter
After=network.target
EOF
##Systemd開機啟動
sudo systemctl daemon-reload && sudo systemctl enable node_exporter