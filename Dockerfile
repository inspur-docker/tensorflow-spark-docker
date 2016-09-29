FROM tensorflow/tensorflow:0.10.0

#1.-------install JDK--HADOOP--SPARK
RUN cd /tmp && \
    curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" -k "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz" && \
    tar xf jdk-8u60-linux-x64.tar.gz -C /opt && rm -f jdk-8u60-linux-x64.tar.gz && \
    ln -s /opt/jdk* /opt/jdk

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /opt/jdk

#install HADOOP
RUN cd /tmp && curl -L -O -k "http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz" && \
    tar -xf hadoop-2.7.3.tar.gz -C /opt && rm -f hadoop-2.7.3.tar.gz && \
    ln -s /opt/hadoop* /opt/hadoop

ENV HADOOP_HOME /opt/hadoop

#install SPARK
RUN cd /tmp && curl -L -O -k "http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz" && \
     tar -xf spark-2.0.0-bin-hadoop2.7.tgz -C /opt && rm -f spark-2.0.0-bin-hadoop2.7.tgz && \
     ln -s /opt/spark* /opt/spark
ENV SPARK_HOME /opt/spark

# Add JDK,HADOOP and SPARK on PATH variable
ENV PATH ${PATH}:${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${SPARK_HOME}/bin

VOLUME ["/hdfs","/var/logs"]

#--------copy hadoop & spark config
COPY hadoop-conf/* /opt/hadoop/etc/hadoop/
COPY spark-conf/* /opt/spark/conf/

#2.----------- setup ssh client keys for root
RUN curl -o /etc/apt/sources.list http://mirrors.163.com/.help/sources.list.trusty

RUN apt-get update && apt-get install -y openssh-client openssh-server && \
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && chown root:root /root/.ssh/config

#3.-----------install docker-gen
RUN apt-get install -y dnsmasq && apt-get clean
ENV DOCKER_HOST unix:///var/run/docker.sock

RUN cd /tmp && curl -L -O -k "https://github.com/jwilder/docker-gen/releases/download/0.7.3/docker-gen-linux-amd64-0.7.3.tar.gz" && \
    tar xf docker-gen-linux-amd64-0.7.3.tar.gz -C /usr/local/bin && rm -f docker-gen-linux-amd64-0.7.3.tar.gz
COPY etc-hosts.tmpl /etc/etc-hosts.tmpl

COPY shell/* /shell/
RUN chmod +x /shell/*.sh

#4.-----------tensoronspark install
RUN pip install tensorspark requests
COPY notebooks/MNIST_data/ /notebooks/MNIST_data/

#-------enviroment
ENV NAMENODE localhost
ENV DATANODE localhost
LABEL dns.inspected="true"

#--------expose ports
EXPOSE 50070 50020 8020 8888 6060 7077 4040 8080 8081

CMD ["/shell/bootALL.sh"]