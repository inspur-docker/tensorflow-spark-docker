
#!/usr/bin/env bash

# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options read in YARN client mode
#SPARK_EXECUTOR_INSTANCES="2" #Number of workers to start (Default: 2)
#SPARK_EXECUTOR_CORES="1" #Number of cores for the workers (Default: 1).
#SPARK_EXECUTOR_MEMORY="512m" #Memory per Worker (e.g. 1000M, 2G) (Default: 1G)
SPARK_DRIVER_MEMORY="1G" #Memory for Master (e.g. 1000M, 2G) (Default: 512 Mb)
#SPARK_YARN_APP_NAME="spark" #The name of your application (Default: Spark)
#SPARK_YARN_QUEUE="~@~Xdefault~@~Y" #The hadoop queue to use for allocation requests (Default: @~Xdefault~@~Y)
#SPARK_YARN_DIST_FILES="" #Comma separated list of files to be distributed with the job.
#SPARK_YARN_DIST_ARCHIVES="" #Comma separated list of archives to be distributed with the job.
SPARK_LOCAL_DIRS=/tmp/spark

#SPARK_DAEMON_MEMORY="1G"
#SPARK_WORKER_MEMORY="4G"
#SPARK_WORKER_CORES="2"
#SPARK_WORKER_WEBUI_PORT worker #web UI (default: 8081)
#SPARK_WORKER_INSTANCES

SPARK_MASTER_HOST=0.0.0.0

# Generic options for the daemons used in the standalone deploy mode

# Alternate conf dir. (Default: ${SPARK_HOME}/conf)
export SPARK_CONF_DIR=${SPARK_CONF_DIR:-/opt/spark/conf}

# Where log files are stored.(Default:${SPARK_HOME}/logs)
export SPARK_LOG_DIR=/var/logs/spark

# Where the pid file is stored. (Default: /tmp)
export SPARK_PID_DIR=/var/run/spark2

# A string representing this instance of spark.(Default: $USER)
SPARK_IDENT_STRING=$USER

# The scheduling priority for daemons. (Default: 0)
SPARK_NICENESS=0

export HADOOP_HOME=/opt/hadoop
export PATH=$HADOOP_HOME/bin:$PATH
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=/opt/hadoop/lib/native"
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

# The java implementation to use.
#export JAVA_HOME=/opt/jdk