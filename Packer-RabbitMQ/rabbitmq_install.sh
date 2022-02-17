#!/bin/bash
sudo yum install -y curl
sudo curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
sudo yum install -y erlang
sudo rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey && sudo rpm --import https://packagecloud.io/gpg.key
sudo curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
sudo yum install -y rabbitmq-server-3.8.4-1.el7.noarch
sudo systemctl enable rabbitmq-server && sudo systemctl start rabbitmq-server
sleep 5s
sudo rabbitmq-plugins enable rabbitmq_management




