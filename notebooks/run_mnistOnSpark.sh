#!/bin/bash

#prepare data
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /data/mnist
$HADOOP_HOME/bin/hdfs dfs -put /usr/local/lib/python2.7/dist-packages/tensorspark/MNIST_data/* /data/mnist/

#start pyspark
$SPARK_HOME/bin/pyspark --master spark://${NAMENODE}:7077 --deploy-mode client