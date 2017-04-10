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

echo "export JAVA_HOME=`readlink -f /usr/bin/javac | sed -e 's:/bin/javac::'`" >> ~/.bashrc
echo "export JAVA_HOME=`readlink -f /usr/bin/javac | sed -e 's:/bin/javac::'`" >> $install_prefix/hadoop/etc/hadoop/hadoop-env.sh
echo "export HADOOP_HOME='/usr/local/hadoop'" >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc

hadoop_home="$install_prefix/hadoop"
sudo cp $script_path/configs/* $hadoop_home/etc/hadoop/

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

sudo su
echo "ssh" > /etc/pdsh/rcmd_default
exit

pushd $hadoop_home
bin/hdfs namenode -format
popd

echo ""
echo "How to run a MapReduce job locally"
echo "  1. mv $hadoop_home"
echo "  2. sbin/start-dfs.sh"
echo "  3. bin/hdfs dfs -mkdir hdfs://localhost:9000/input"
echo "  5. bin/hdfs dfs -mkdir -p hdfs://localhost:9000/output/grep"
echo "  4. bin/hdfs dfs -put etc/hadoop/*.xml hdfs://localhost:9000/input"
echo "  6. bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-$version.jar grep hdfs://localhost:9000/input hdfs://localhost:9000/output 'dfs[a-z.]+'"
echo "  7. bin/hdfs dfs -cat output/*"
echo "  8. sbin/stop-dfs.sh"

echo ""
echo "How to run a MapReduce job on YARN in a pseudo-distoributed mode"
echo "  1. sbin/start-yarn.sh"
echo "  2. Run a MapReduce job"
echo "  3. sbin/stop-yarn.sh"

# echo `java -version 2>&1 /dev/null | grep --color=none -e 'version' | sed -e 's/^openjdk version "\(.*\)"$/\1/g'`

# sudo mkdir -p /fs/hadoop/tmp
# sudo chown pi:hadoop /fs/hadoop/tmp
# sudo chmod 750 /fs/hadoop/tmp

