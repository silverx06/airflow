#!/bin/sh

rm -Rf /usr/local/lib/python3.6/site-packages/airflow/example_dags/
mv /usr/local/src/config/airflow.cfg /airflow/
mv /usr/local/src/shell/entrypoint.sh /usr/local/bin/
[ -f /usr/local/src/config/default.json ] && cp /usr/local/src/config/default.json /airflow/

