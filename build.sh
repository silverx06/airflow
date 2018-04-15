#!/bin/sh

SPARK_VERSION=2.3.0
HADOOP_VERSION=2.7.5

docker build \
       --build-arg="SPARK_VERSION=${SPARK_VERSION}" \
       --build-arg="HADOOP_VERSION=${HADOOP_VERSION}" 
       --tag="silverx06/airflow-hadoop" \
       .
