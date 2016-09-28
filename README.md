# README
This project contains Tensorflow + HADOOP + SPARK + tensoronspark,
 to make it easy to get up and running with `TensorFlow on Spark` via Docker.

# build

    git clone https://github.com/inspur-insight/tensorspark
    docker build -t tensorspark .
or pull from docker-hub

    docker pull incloud/tensorspark
# deploy
## all-in-one deploy
start one container to start all components:

    docker run --hostname tensordemo --name tensordemo \
           -e "NAMENODE=tensordemo" -e "DATANODE=localhost" \
           -ti \
           -v /var/run/docker.sock:/var/run/docker.sock \
           incloud/tensorspark /shell/bootALL.sh -d

## cluster deploy
START MASTER:

    docker run --hostname tfmaster --name tfmaster \
       -e "NAMENODE=tfmaster" -e "DATANODE=localhost" \
       -ti  \
       -v /var/run/docker.sock:/var/run/docker.sock \
       incloud/tensorspark /shell/bootALL.sh -d
START slave1:

    docker run --hostname tfslave1 --name tfslave1 \
           -e "NAMENODE=tfmaster" -e "DATANODE=localhost" \
           -ti \
           -v /var/run/docker.sock:/var/run/docker.sock \
           incloud/tensorspark /shell/bootALL.sh -d
## cluster deploy with docker-compose
edit docker-compose.xml :

    version: '2'
    #docker-compose version 1.7.1
    services:
      tfmaster: #
          image: incloud/tensorspark
          hostname: tfmaster
          volumes:
              - /var/run/docker.sock:/var/run/docker.sock
          command: ["/shell/bootALL.sh","-d"]
          environment:
             - NAMENODE=tfmaster
          ports:
             - "50070:50070"
             - "8080:8080"
             - "8888:8888"
             - "6060:6060"
      tfslave1: #
          image: incloud/tensorspark
          hostname: tfslave1
          volumes:
              - /var/run/docker.sock:/var/run/docker.sock
          command: ["/shell/bootALL.sh","-d"]
          environment:
             - NAMENODE=tfmaster
start:

    docker-compose -p demo up -d

# run mnist example on spark

Enter the master container,E.g:

    docker exec -ti tfmaster bash

prepare hdfs data:

    $HADOOP_HOME/bin/hdfs dfs -mkdir -p /data/mnist
    $HADOOP_HOME/bin/hdfs dfs -put /usr/local/lib/python2.7/dist-packages/tensorspark/MNIST_data/* /data/mnist/

start pyspark shell:

    $SPARK_HOME/bin/pyspark --master spark://${NAMENODE}:7077 --deploy-mode client
run spark_mnist:

`
import tensorspark.example.spark_mnist as mnist
mnist.train(sc=sc, user='root', name='spark_mnist', server_host=os.getenv('NAMENODE'), server_port=10080,\
     sync_interval=100, batch_size=100, num_partition=2, num_epoch=2)
`


