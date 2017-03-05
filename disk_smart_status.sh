#
# Hard Disk Power On Hours
#
# Added -n standby to the check so smartctl is not spinning up my drives

### CONFIG ###
# all fields required
INFLUX_HOST=''
PORT='8086'
DB=''
MEASUREMENT='hd_smart_status'
MEASUREMENT_HOST=''
DISK_ARRAY=( sdc sdd sde sdf sdb )
DESCRIPTION=( parity disk1 disk2 disk3 cache )
### END CONFIG ###

i=0
for DISK in "${DISK_ARRAY[@]}"
do
    smartctl -n standby -H /dev/${DISK} | grep -E "self-assessment" | awk '{ print $6 }' | while read SMARTSTATUS
    do
        if [ "$SMARTSTATUS" = "PASSED" ]; then
            value=1
        else
            value=2;
        fi

        curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT,host=$MEASUREMENT_HOST,disk=${DESCRIPTION[$i]} value=$value"
        #echo ${DESCRIPTION[$i]} $value
    done
    ((i++))
done
