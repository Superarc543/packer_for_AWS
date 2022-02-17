#!/bin/bash
##修改sshd_config
#sudo sed -i 's/#PermitRootLogin no/PermitRootLogin yes/1' /etc/ssh/sshd_config
#sudo sed -i '$aPermitRootLogin yes' /etc/ssh/sshd_config
#sudo sed -i 's/UsePAM yes/UsePAM no/1' /etc/ssh/sshd_config
##註解掉root ssh金鑰文件某段
#sudo sed -ri 's/^/#/;s/sleep 10"\s+/&\n/' /root/.ssh/authorized_keys
##重啟sshd服務
#sudo systemctl restart sshd.service
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
#sudo yum update -y
##安裝套件
sudo yum install -y nano && sudo yum install -y unzip && sudo yum install -y wget
##放入金鑰
sudo mkdir ~/.aws && sudo mv /tmp/credentials ~/.aws/
##Install Node_exporter
sudo wget -P /tmp https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
sudo tar -C /tmp/ -zxvf /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
sudo mkdir /etc/node_exporter
sudo mv /tmp/node_exporter-1.3.1.linux-amd64/* /etc/node_exporter
sudo chmod 757 /etc/systemd/system
sudo cat <<\EOF > /etc/systemd/system/node_exporter.service
[Service]
ExecStart=/etc/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target

[Unit]
Description=node_exporter
After=network.target
EOF
sudo chmod 755 /etc/systemd/system
sudo systemctl daemon-reload && sudo systemctl enable node_exporter