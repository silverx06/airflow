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

airflow ${TARGET} ${PORT}

$@
