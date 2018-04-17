#!/bin/sh

rm -Rf /usr/local/lib/python3.6/site-packages/airflow/example_dags/
if [ -f /usr/local/src/conf/default.json ]; then
  cp -f /usr/local/src/conf/default.json /airflow/
fi
mv /usr/local/src/conf/airflow.cfg /airflow/
mv /usr/local/src/shell/entrypoint.sh /usr/local/bin/
if [ -f /usr/local/src/libs/*.whl ]; then
  pip install --no-cache-dir /usr/local/src/libs/*.whl
fi

icat <<__EOF__ > /airflow/db.conf
CONN_ID=${CONN_ID}
CONN_TYPE=${CONN_TYPE}
CONN_HOST=${CONN_HOST}
CONN_USER=${CONN_USER}
CONN_PASSWORD=${CONN_PASSWORD}
CONN_DB=${CONN_DB}
CONN_PORT=${CONN_PORT}
__EOF__

rm -Rf /usr/local/src/*
