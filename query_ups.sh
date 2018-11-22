#!/usr/bin/bash
# if you'd like to see what measurements are available, use 'apcaccess status'

### CONFIG ###
# all values required
INFLUX_HOST=''
PORT='8086'
DB=''
MEASUREMENT='ups_data'
MEASUREMENT_HOST=''
### END_CONFIG ###

# Set which measurements you're interested in. The value itself isn't important, since
# we're being hacky and just checking for existence.
declare -A items_of_interest=(["LOADPCT"]=0 ["LINEV"]=1 ["TIMELEFT"]=1 ["BCHARGE"]=1)

# Associations of measurements to a human readable item
declare -A items_human_readable=(["LOADPCT"]="battload" ["LINEV"]="inputvoltage" ["TIMELEFT"]="runtime" ["BCHARGE"]="battcharge")
### END CONFIG ###
post_url=

while read i;
do
    measurement_name=$(awk '{print $1}' <<< "$i")

    if test "${items_of_interest[$measurement_name]}"
    then
        measurement_value=$(awk '{print $3}' <<< "$i")
        measurement_human_readable=${items_human_readable[$measurement_name]}

        post_url=$post_url"$MEASUREMENT,host=$MEASUREMENT_HOST,sensor=$measurement_human_readable value=$measurement_value"$'\n'
    fi
done <<<$(apcaccess status)

curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$post_url"
