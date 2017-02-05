#!/usr/bin/bash

## CONFIG ##
# all values required
INFLUX_HOST=''
PORT='8086'
DB='telegraf'
MEASUREMENT='docker_container_status'
MEASUREMENT_HOST=''

# simple measurement of whether any containers are down.
MEASUREMENT_UP='docker_containers_running'
## END_CONFIG ##

all_containers_up=1

# the awk skips the first line of output, which are the column headers
OUTPUT="$(docker ps -a --format "table {{.Names}}\t{{.Status}}" | awk 'NR > 1')"
  while read i
  do
    container_name=$(awk '{print $1}' <<< "$i")
    container_status=$(awk '{print $2=="Up"?1:0}' <<< "$i")

    if [ $container_status -eq 0 ]; then
        all_containers_up=0
    fi

    curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT,host=$MEASUREMENT_HOST,container=$container_name status=$container_status"
  done <<< "$OUTPUT"

  curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT_UP,host=$MEASUREMENT_HOST status=$all_containers_up"
