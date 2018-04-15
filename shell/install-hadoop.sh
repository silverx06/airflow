#!/bin/sh

export HADOOP_VERSION=${1}
export SPARK_VERSION=${2}
export SPARK_HOME=${3}

curl -o /usr/local/src/hadoop-${HADOOP_VERSION}.tar.gz https://www.mirrorservice.org/sites/ftp.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
tar xfz /usr/local/src/hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ && \
rm -Rf /usr/local/src/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz && \
mv /opt/hadoop-${HADOOP_VERSION} /opt/hadoop 

curl -o /usr/local/src/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz https://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz && \
tar xfz /usr/local/src/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz -C /opt/ && \
rm -Rf /usr/local/src/hadoop-${HADOOP_VERSION}.tar.gz && \
mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3} ${SPARK_HOME}
