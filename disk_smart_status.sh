#
# Disk SMART Status
#
# Added -n standby to the check so smartctl is not spinning up my drives
#
#
# Set Vars
#
### CONFIG ###
INFLUX_HOST=''
PORT='8086'
DB=''
MEASUREMENT='hd_smart_status'
MEASUREMENT_HOST=''
DISK_ARRAY=( sdi sdd sdh sdc sdg )
DESCRIPTION=( disk1 disk2 disk3 disk4 disk5 )
HUMAN_READABLE_DESCRIPTION=( "Disk\ 1" "Disk\ 2" "Disk\ 3" "Disk\ 4" "Disk\ 5" )
### END CONFIG ###

## hd smart status
post_url=

i=0
for DISK in "${DISK_ARRAY[@]}"
do
    while read SMARTSTATUS;
    do
        if [ "$SMARTSTATUS" = "PASSED" ]; then
            value=1
        else
            value=2;
        fi

        post_url=$post_url"$MEASUREMENT,host=$MEASUREMENT_HOST,hr_host=${HUMAN_READABLE_DESCRIPTION[$i]},disk=${DESCRIPTION[$i]} value=$value"$'\n'
        #echo "$post_url"
    done <<<$(smartctl -n standby -H /dev/${DISK} | grep -E "self-assessment" | awk '{ print $6 }')
    ((i++))
done
curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$post_url"
