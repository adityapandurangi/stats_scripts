#!/usr/bin/bash

## CONFIG ##
# all values required
INFLUX_HOST=''
PORT='8086'
DB='telegraf'
MEASUREMENT='docker_container_status'
MEASUREMENT_HOST=''
## END_CONFIG ##

# the awk skips the first line of output, which are the column headers
docker ps -a --format "table {{.Names}}\t{{.Status}}" | awk 'NR > 1' |
  while read i
  do
    container_name=$(awk '{print $1}' <<< "$i")
    container_status=$(awk '{print $2=="Up"?1:0}' <<< "$i")
    curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT,host=$MEASUREMENT_HOST,container=$container_name status=$container_status"
  done
