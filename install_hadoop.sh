#!/bin/bash


version="3.0.3"


sudo apt install openjdk-8-jdk

sudo addgroup hadoop
sudo adduser --ingroup hadoop pi

ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

cd ~
wget http://ftp.tsukuba.wide.ad.jp/software/apache/hadoop/common/hadoop-$version/hadoop-$version.tar.gz
sudo tar zxvf hadoop-$version.tar.gz -C /usr/local

cd /usr/local
sudo mv hadoop-$version hadoop
sudo chown -R pi:hadoop hadoop

echo "export JAVA_HOME=`readlink -f /usr/bin/javac | sed -e 's:/bin/javac::'`" >> ~/.bashrc
echo "export HADOOP_INSTALL='/usr/local/hadoop'" >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_INSTALL/bin' >> ~/.bashrc

sudo cp ~/works/configs/* /usr/local/hadoop/etc/hadoop/

sudo mkdir -p /fs/hadoop/tmp
sudo chown pi:hadoop /fs/hadoop/tmp
sudo chmod 750 /fs/hadoop/tmp

/usr/local/hadoop/bin/hadoop namenode -format

