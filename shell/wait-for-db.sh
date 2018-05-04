#!/bin/bash

set -e

function usage() {
  echo "Usage: wait-for-db.sh -t postgres -h <CONN_HOST> -u <CONN_USER> -ps <CONN_PASSWORD> -d <CONN_DB> -p <CONN_PORT>"
  echo "       wait-for-db.sh -t mysql -h <CONN_HOST> -u <CONN_USER> -ps <CONN_PASSWORD> -d <CONN_DB>"
  echo "       wait-for-db.sh -t redis -h <REDIS_CONN_HOST> -p <REDIS_CONN_PORT>"
  exit;
}

CMD=""
while [ $# -gt 0 ]
do
  if [ "${1}x" == "-tx" ]; then
    shift
    if [ -e ${1} ]; then
      CONN_TYPE="${1}"
    fi
  elif [ "${1}x" == "-px" ]; then
    shift
    if [ -e ${1} ]; then
      if [ "${CONN_TYPE}x" == "redisx" ]; then
        REDIS_CONN_PORT="${1}"
      else
        CONN_PORT="${1}"
      fi
    fi
  elif [ "${1}x" == "-hx" ]; then
    shift
    if [ -e ${1} ]; then
      if [ "${CONN_TYPE}x" == "redisx" ]; then
        REDIS_CONN_HOST="${1}"
      else
        CONN_HOST="${1}"
      fi
    fi
  elif [ "${1}x" == "-ux" ]; then
    shift
    if [ -e ${1} ]; then
      CONN_USER="${1}"
    fi
  elif [ "${1}x" == "-psx" ]; then
    shift
    if [ -e ${1} ]; then
      CONN_PASSWORD="${1}"
    fi
  elif [ "${1}x" == "-dx" ]; then
    shift
    if [ -e ${1} ]; then
      CONN_DB="${1}"
    fi
  else
    CMD=" ${CMD}"
  fi
  shift
done

cmd="$@"

if [ -e ${CONN_TYPE} ]; then
  usage
fi

DB_COMMAND="[ 0 -eq 0 ]"
if [ "${CONN_TYPE}x" == "postgresx" ]; then
  #psql -h db -U airflow -w airflow 
  export PGPASSWORD=${CONN_PASSWORD}
  DB_COMMAND="psql -h ${CONN_HOST} -U ${CONN_USER} -d ${CONN_DB} -p ${CONN_PORT} -l"
elif [ "${CONN_TYPE}x" == "mysqlx" ]; then 
  #mysql -h db -u airflow -pairflow airflow
  DB_COMMAND="mysql -h ${CONN_HOST} -u ${CONN_USER} -p${CONN_PASSWORD} ${CONN_DB} -e 'show databases;'"
elif [ "${CONN_TYPE}x" == "redisx" ]; then 
  #nc -v -w 172.17.0.4 -z 6379
  DB_COMMAND="nc -v -w ${REDIS_CONN_HOST} -p ${REDIS_CONN_PORT}"
fi

until ${DB_COMMAND}; do
  >&2 echo "${CONN_TYPE} is unavailable - sleeping"
  sleep 1
done

>&2 echo "${CONN_TYPE} is up - executing command"

exec $cmd
