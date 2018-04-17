#!/bin/bash

TARGET=webserver
PORT=""
INIT_FLG=0

while [ $# -gt 0 ]
do
  if [ "${1}x" == "-px" ]; then
    shift
    if [ -e ${1} ]; then
      PORT="-p ${1}"
    fi
  fi
  if [ "${1}x" == "-tx" ]; then
    shift
    if [ -e ${1} ]; then
      if ( [ "${1}x" == "webserverx" ] \
           || [ "${1}x" == "schedulerx" ] \
           || [ "${1}x" == "targetx" ] ) then
        TARGET=${1}
      fi
    fi
  fi
  if [ "${1}x" == "--initx" ]; then
    shift
    INIT_FLG=1
  fi
  shift
done

if ( [ "${TARGET}x" == "webserverx" ] || [ "${PORT}x" == "x" ] ) then
  PORT="-p 8080"
fi

[ ${INIT_FLG} -eq 1 ] && airflow initdb

[ -f /airflow/default.json ] && airflow variables -j -i /airflow/default.json

[ -f /airflow/db.conf ] && source /airflow/db.conf

[ -e ${CONN_ID} ] && [ -e ${CONN_TYPE} ] \
&& [ -e ${CONN_HOST} ] && [ -e ${CONN_PORT} ] \
&& [ -e ${CONN_USER} ] && [ -e ${CONN_PASSWORD} ] \
&& [ -e ${CONN_DB} ] \
&& airflow connections --conn_id ${CONN_ID} \
                       --conn_type ${CONN_TYPE} \
                       --conn_host ${CONN_HOST} \
                       --conn_login ${CONN_USER} \
                       --conn_password ${CONN_PASSWORD} \
                       --conn_schema ${CONN_DB} \
                       --conn_port ${CONN_PORT}

airflow ${TARGET} ${PORT}

$@
