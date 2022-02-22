#!/bin/bash
#sudo wget -P /tmp https://cdn.azul.com/zulu/bin/zulu11.52.13-ca-jdk11.0.13-linux_x64.tar.gz
sudo tar -zxvf /tmp/zulu11.52.13-ca-jdk11.0.13-linux_x64.tar.gz -C /tmp
sudo mkdir /opt/JDK11 && sudo chmod 755 /opt/JDK11
sudo mv /tmp/zulu11.52.13-ca-jdk11.0.13-linux_x64/* /opt/JDK11/
sudo rm -rf /tmp/zulu11.52.13-ca-jdk11.0.13-linux_x64.tar.gz
##加入環境變數
sudo sed -i '$a# Zulu JDK 11\nJAVA_HOME=/opt/JDK11\nCLASSPATH=$JAVA_HOME/lib/\nPATH=$PATH:$JAVA_HOME/bin/\nexport PATH JAVA_HOME CLASSPATH' /etc/profile
sudo sed -i '$a# Zulu JDK 11\nJAVA_HOME=/opt/JDK11\nCLASSPATH=$JAVA_HOME/lib/\nPATH=$PATH:$JAVA_HOME/bin/\nexport PATH JAVA_HOME CLASSPATH' /etc/bashrc