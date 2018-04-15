#!/bin/sh

airflow initdb
[ -f /airflow/default.json ] && airflow variables -j -i /airflow/default.json
airflow scheduler &
airflow webserver -p 80

$@
