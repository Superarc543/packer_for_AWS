#!/bin/bash
URL=https://github.com/prometheus/prometheus/releases/download/v2.33.0-rc.1/prometheus-2.33.0-rc.1.linux-amd64.tar.gz
NAME=prometheus
TAR=`sudo find /tmp -name "prometheus-*" -print`
UNGZ=`sudo find /tmp -type d -name "prometheus-*" | grep -v .tar.gz`

sudo wget -P /tmp $URL
sudo tar -C /tmp/ -zxvf $TAR
sudo mkdir /etc/$NAME
sudo mv $UNGZ /etc/$NAME
