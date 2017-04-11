#!/bin/bash

version="3.0.3"

script_path=$(cd "$(dirname $0)"; pwd)

sudo addgroup hadoop
sudo adduser --ingroup hadoop "id -un"

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

echo "export JAVA_HOME='/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre'" >> ~/.bashrc
echo "export JAVA_HOME='/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre'" >> $install_prefix/hadoop/etc/hadoop/hadoop-env.sh
echo "export HADOOP_HOME='/usr/local/hadoop'" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\"$HADOOP_HOME/lib/native\""
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh-copy-id localhost

echo "ssh" > rcmd_default
sudo mv rcmd_default /etc/pdsh/

hadoop_home="$install_prefix/hadoop"
pushd $hadoop_home
bin/hdfs namenode -format
popd

echo ""
echo "How to run a MapReduce job locally"
echo "  1. cd $hadoop_home"
echo "  2. mkdir input"
echo "  3. cp etc/hadoop/*.xml input/"
echo "  4. hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$version.jar wordcount input output"

echo ""
echo "How to run a MapReduce job on YARN in a pseudo-distoributed mode"
echo "  1. cp $script_path/configs_for_pseudo/* $hadoop_home/etc/hadoop/"
echo "  2. hdfs namenode -format"
echo "  3. start-all.sh"
echo "  4. hdfs dfs -mkdir -p /user/`id -un`"
echo "  5. hdfs dfs -mkdir input"
echo "  6. hdfs dfs -put $hadoop_home/etc/hadoop/*.xml input/"
echo "  7. hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$version.jar grep input output 'dfs[a-z.]+'"
echo "  8. hdfs dfs -cat output/*"
echo "  9. stop-all.sh"

# echo `java -version 2>&1 /dev/null | grep --color=none -e 'version' | sed -e 's/^openjdk version "\(.*\)"$/\1/g'`

# sudo mkdir -p /fs/hadoop/tmp
# sudo chown pi:hadoop /fs/hadoop/tmp
# sudo chmod 750 /fs/hadoop/tmp

