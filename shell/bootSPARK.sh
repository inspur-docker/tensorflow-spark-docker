#!/bin/bash

if [ "${NAMENODE}" == "${HOSTNAME}" ]; then

  #run spark master on NAMENODE
  echo 'starting spark master....'
  $SPARK_HOME/sbin/start-master.sh
  #HADOOP_HOME/sbin/start-yarn.sh
  sleep 5
fi
if [ "${DATANODE}" ]; then
  #start spark slave
  echo 'starting spark slave....'
   $SPARK_HOME/sbin/start-slave.sh spark://${NAMENODE}:7077
fi
