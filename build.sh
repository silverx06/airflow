#!/bin/sh

TAG=$1

SPARK_VERSION=2.3.0
HADOOP_VERSION=2.7.5

docker build \
       --build-arg="SPARK_VERSION=${SPARK_VERSION}" \
       --build-arg="HADOOP_VERSION=${HADOOP_VERSION}" \
       --no-cache=true \
       --tag ${TAG} \
       .
