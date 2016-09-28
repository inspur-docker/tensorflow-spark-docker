#!/bin/bash

service ssh start

chmod 777 /tmp

rm /tmp/*.pid

#start docker-gen in master node
#if [ "${NAMENODE}" == "${HOSTNAME}" ]; then
if true ; then
  DOCKER_URI=${DOCKER_URI:-unix:///var/run/docker.sock}
  echo ''>/etc/hosts.new
  docker-gen  -endpoint $DOCKER_URI  -watch -notify "/shell/add-hosts.sh /etc/hosts.new" /etc/etc-hosts.tmpl /etc/hosts.new &
  sleep 3
fi

/shell/bootHDFS.sh

/shell/bootSPARK.sh

#start Tensorflow on master
if [ "${NAMENODE}" == "${HOSTNAME}" ]; then
    echo "starting TensorBoard...."
    python /usr/local/lib/python2.7/dist-packages/tensorflow/tensorboard/tensorboard.py --logdir=/notebooks/logs \
            > /var/logs/tensorboard.out 2>&1 &

    echo "starting jupyter...."
    nohup /run_jupyter.sh >/var/logs/jupyter.out 2>&1 &
fi

echo "All started."

if [[ $1 == "-d" ]]; then
  while [ 1 ]
  do
   if [ "${NAMENODE}" == "${HOSTNAME}" ]; then
    tail -f /var/logs/hadoop/hadoop-root-namenode-${HOSTNAME}.log
   else
    tail -f /var/logs/hadoop/hadoop-root-datanode-${HOSTNAME}.log
   fi
   sleep 5
  done
elif [[ $1 == "-bash" ]]; then
  /bin/bash
else
  sleep infinity
fi