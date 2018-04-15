FROM python:3.6.5-stretch

MAINTAINER silverx06 

ADD shell /usr/local/src/
ADD config /usr/local/src/
ADD libs /usr/local/src/

ENV HADOOP_HOME /opt/hadoop
ENV PATH ${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin
ENV AIRFLOW_HOME /airflow
ENV AIRFLOW_DAG ${AIRFLOW_HOME}/dags

ARG SPARK_VERSION
ARG HADOOP_VERSION
ONBUILD ARG THEUSER=afpuser
ONBUILD ARG THEGROUP=hadoop

ONBUILD ENV USER ${THEUSER}
ONBUILD ENV GROUP ${THEGROUP}
ONBUILD RUN groupadd -r "${GROUP}" && useradd -rmg "${GROUP}" "${USER}"
ONBUILD ENV POSTGRES_HOST=db
ONBUILD ENV POSTGRES_PORT=5432
ONBUILD ENV POSTGRES_USER=airflow
ONBUILD ENV POSTGRES_PASSWORD=airflow
ONBUILD ENV POSTGRES_DB=airflow

ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}
ENV PATH=$PATH:${SPARK_HOME}/bin
ENV PYTHONPATH=${SPARK_HOME}/python
ENV PYSPARK_SUBMIT_ARGS="--driver-memory 8g --py-files ${SPARK_HOME}/python/lib/pyspark.zip pyspark-shell"

RUN set -x && \ 
    echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y --force-yes vim-tiny libsasl2-dev libffi-dev gosu krb5-user libcups2 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -t jessie-backports --no-install-recommends -y openjdk-8-jre-headless && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r /usr/local/src/config/requirements.txt && \
    [ -f /usr/local/src/libs/*.whl ] && pip install --no-cache-dir /usr/local/src/libs/*.whl && \
    mkdir -p ${AIRFLOW_DAG} && \
    /bin/bash -x /usr/local/src/shell/install-hadoop.sh ${HADOOP_VERSION} ${SPARK_VERSION} ${SPARK_HOME} && \
    /bin/bash -x /usr/local/src/shell/initial.sh && \
    echo SPARK_HOME is ${SPARK_HOME} && \
    ls -al --g ${SPARK_HOME} && \
    ls -la /

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

VOLUME ${AIRFLOW_DAG}
VOLUME ${AIRFLOW_HOME}/logs

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]