#!/bin/bash
##開/etc/rc.d/rc.local權限
sudo chmod 757 /etc/rc.d/rc.local
##關閉THPy
sudo cat << EOF >> /etc/rc.d/rc.local
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
EOF
## 改完後移除權限，只留執行權限
sudo chmod 755 /etc/rc.d/rc.local
##安裝Redis-Server源
sudo yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
##安裝Redis-Server 5.0.14版本
sudo yum --enablerepo=remi install redis-5.0.14 -y
sudo systemctl enable redis
##修改/etc/redis.conf參數
sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/1' /etc/redis.conf
sudo sed -i 's/tcp-backlog 511/tcp-backlog 10000/1' /etc/redis.conf
##SlowLog預設10ms(10000) 改為1ms紀錄(1000)
sudo sed -i 's/slowlog-log-slower-than 10000/slowlog-log-slower-than 1000/1' /etc/redis.conf
##SlowLog紀錄數量 預設128 改為512條
sudo sed -i 's/slowlog-max-len 128/slowlog-max-len 512/1' /etc/redis.conf
##下載安裝Redis-Exporter
sudo wget -P /tmp https://github.com/oliver006/redis_exporter/releases/download/v1.33.0/redis_exporter-v1.33.0.linux-amd64.tar.gz
sudo mkdir /etc/redis_exporter
sudo tar -C /tmp/ -zxvf /tmp/redis_exporter-v1.33.0.linux-amd64.tar.gz
sudo mv /tmp/redis_exporter-v1.33.0.linux-amd64/* /etc/redis_exporter
##Redis-Exporter加入服務
sudo chmod 757 /etc/systemd/system
sudo cat <<\EOF > /etc/systemd/system/redis_exporter.service
[Unit]
Description=Prometheus exporter for Redis metrics.
Documentation=Supports Redis 2.x, 3.x, 4.x, 5.x, and 6.x

[Service]
ExecStart=/etc/redis_exporter/redis_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 755 /etc/systemd/system
sudo systemctl daemon-reload && sudo systemctl enable redis_exporter






