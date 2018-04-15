#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

#mysql -h db -u airflow -pairflow airflow
#psql -h db -U airflow -w airflow 
until psql -h "$host" -u "$POSTGRESQL_USER" -w ${POSTGRESQL_PASSWORD} -d ${MYSQL_DATABASE} -l; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "PostgreSQL is up - executing command"

exec $cmd
