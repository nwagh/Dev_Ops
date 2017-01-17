#! /bin/bash
set -vx

VERSALEX_CONTAINER=`docker ps -a|grep "harmony:latest"|awk '{print $1}'`
VLPROXY_CONTAINER=`docker ps -a|grep "vlproxy:latest"|awk '{print $1}'`
SERIAL=`docker exec -it $VERSALEX_CONTAINER ./Harmonyc -s "license" |grep "Serial Number"| awk '{print $4}'`

docker exec -it $VLPROXY_CONTAINER ./change_serial.sh $SERIAL
docker restart $VLPROXY_CONTAINER

docker exec -it $VERSALEX_CONTAINER ./bootstrap.sh
docker restart $VERSALEX_CONTAINER
