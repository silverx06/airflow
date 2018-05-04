#!/bin/sh

rm -Rf /usr/local/lib/python3.6/site-packages/airflow/example_dags/

if [ -f /usr/local/src/libs/*.whl ]; then
  pip install --no-cache-dir /usr/local/src/libs/*.whl
fi
if [ -f /usr/local/src/conf/*.json ]; then
  mv /usr/local/src/variables/*.json /usr/local/airflow/
fi

mv /usr/local/src/shell/wait-for-db.sh /airflow/
chmod 755 /airflow/wait-for-db.sh

mv /usr/local/src/conf/airflow.cfg /airflow/

mv /usr/local/src/shell/entrypoint.sh /
chmod 755 /entrypoint.sh
cat /entrypoint.sh


