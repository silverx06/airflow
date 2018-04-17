#!/bin/bash

set -e

#host="$1"
shift
cmd="$@"

DB_COMMAND="[ 0 -eq 0 ]"
if [ "${CONN_TYPE}x" == "postgresx" ]; then
  #psql -h db -U airflow -w airflow 
  export PGPASSWORD=${CONN_PASSWORD}
  DB_COMMAND="psql -h ${CONN_HOST} -U ${CONN_USER} -d ${CONN_DB} -p ${CONN_PORT} -l"
elif [ "${CONN_TYPE}x" == "mysqlx" ]; then 
  #mysql -h db -u airflow -pairflow airflow
  DB_COMMAND="mysql -h ${CONN_HOST} -u ${CONN_USER} -p${CONN_PASSWORD} ${CONN_DB} -e 'show databases;'"
fi

until ${DB_COMMAND}; do
  >&2 echo "${CONN_TYPE} is unavailable - sleeping"
  sleep 1
done

>&2 echo "${CONN_TYPE} is up - executing command"

exec $cmd
