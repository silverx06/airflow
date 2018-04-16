#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

#mysql -h db -u airflow -pairflow airflow
#psql -h db -U airflow -w airflow 
until PGPASSWORD=${POSTGRES_PASSWORD} psql -h "$host" -U "${POSTGRES_USER}" -d ${POSTGRES_DB} -p ${POSTGRES_PORT} -l; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "PostgreSQL is up - executing command"

exec $cmd
