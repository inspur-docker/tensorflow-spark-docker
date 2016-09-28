#!/bin/bash

export HADOOP_HOME=/opt/hadoop/
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/HOSTNAME/$NAMENODE/ /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml

export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH && ldconfig

if [ "${NAMENODE}" == "${HOSTNAME}" ]; then
  if [ ! -d /hdfs/name/current ]; then
    echo 'Format namenode.'
    $HADOOP_HOME/bin/hdfs namenode -format
  fi

  #run on NAMENODE
  echo 'starting hdfs....'
  $HADOOP_HOME/sbin/start-dfs.sh
  #HADOOP_HOME/sbin/start-yarn.sh
  sleep 5
fi
if [ "${DATANODE}" ]; then
  #start datanode
  echo 'starting datanode....'
  #$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
  export USER=root
  $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
fi
