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
