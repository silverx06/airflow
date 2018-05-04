#!/bin/bash

TARGET=${1}

function check_redis() {
    /airflow/wait-for-db.sh -t redis
}

function check_db() {
    /airflow/wait-for-db.sh
}

case ${TARGET} in
  webserver)
    check_redis
    check_db
    airflow initdb &

    sleep 10
    for F in `ls -1 /airflow/variables/*.json 2>/dev/null`
    do
      airflow variables -j -i \${F};
    done 

    [ -e ${CONN_ID} ] && [ -e ${CONN_TYPE} ] \
      && [ -e ${CONN_HOST} ] && [ -e ${CONN_PORT} ] \
      && [ -e ${CONN_USER} ] && [ -e ${CONN_PASSWORD} ] \
      && [ -e ${CONN_DB} ] && sleep 10 \
      && airflow connections --conn_id ${CONN_ID} \
                             --conn_type ${CONN_TYPE} \
                             --conn_host ${CONN_HOST} \
                             --conn_login ${CONN_USER} \
                             --conn_password ${CONN_PASSWORD} \
                             --conn_schema ${CONN_DB} \
                             --conn_port ${CONN_PORT}

    airflow webserver
    ;;
  scheduler)
    check_redis
    airflow scheduler
    ;;
  worker)
    check_redis
    airflow worker
    ;;
  flower)
    check_redis
    airflow flower
    ;;
  standalone)
    check_redis
    check_db
    airflow initdb &
    for F in `ls -1 /airflow/variables/*.json 2>/dev/null`
    do
      airflow variables -j -i \${F};
    done 

    [ -e ${CONN_ID} ] && [ -e ${CONN_TYPE} ] \
      && [ -e ${CONN_HOST} ] && [ -e ${CONN_PORT} ] \
      && [ -e ${CONN_USER} ] && [ -e ${CONN_PASSWORD} ] \
      && [ -e ${CONN_DB} ] && sleep 10 \
      && airflow connections --conn_id ${CONN_ID} \
                             --conn_type ${CONN_TYPE} \
                             --conn_host ${CONN_HOST} \
                             --conn_login ${CONN_USER} \
                             --conn_password ${CONN_PASSWORD} \
                             --conn_schema ${CONN_DB} \
                             --conn_port ${CONN_PORT}
    airflow webserver &
    airflow scheduler &
    airflow worker &
    airflow flower
    ;;
esac 
