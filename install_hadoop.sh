#!/bin/bash

version="3.0.3"

script_path=$(cd "$(dirname $0)"; pwd)

sudo addgroup hadoop
sudo adduser --ingroup hadoop "id -un"

ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

download_directory="$HOME/Downloads"
pushd $download_directory
wget http://ftp.tsukuba.wide.ad.jp/software/apache/hadoop/common/hadoop-$version/hadoop-$version.tar.gz
sudo tar zxvf hadoop-$version.tar.gz -C /usr/local
popd

install_prefix="/usr/local"
pushd $install_prefix
sudo mv hadoop-$version hadoop
sudo chown -R pi:hadoop hadoop
popd

echo "export JAVA_HOME=`readlink -f /usr/bin/javac | sed -e 's:/bin/javac::'`" >> ~/.bashrc
echo "export HADOOP_INSTALL='/usr/local/hadoop'" >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_INSTALL/bin' >> ~/.bashrc

sudo cp $script_path/configs/* $install_prefix/hadoop/etc/hadoop/

sudo mkdir -p /fs/hadoop/tmp
sudo chown pi:hadoop /fs/hadoop/tmp
sudo chmod 750 /fs/hadoop/tmp

$install_prefix/hadoop/bin/hadoop namenode -format

