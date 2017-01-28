# Note: script template + ideas taken from RAINMAN on the unraid forums:
# https://lime-technology.com/forum/index.php?topic=52220
 
#Hard Disk Power On Hours
#
# Added -n standby to the check so smartctl is not spinning up my drives
#

### CONFIG ###
# all values required
INFLUX_HOST=''
PORT='8086'
DB=''
MEASUREMENT_HOURS='disk_power_on_hours'
MEASUREMENT_TEMPS='hd_temps'
MEASUREMENT_HOST=''
DISK_ARRAY=( sdc sdd sde sdf sdb )
DESCRIPTION=( parity disk1 disk2 disk3 cache )
### END CONIG ###


## disk power on hours
i=0
for DISK in "${DISK_ARRAY[@]}"
do
	smartctl -n standby -A /dev/${DISK} | grep -E "Power_On_Hours" | awk '{ print $10 }' | while read POWERONHOURS
	do
		curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT_HOURS,host=$MEASUREMENT_HOST,disk=${DESCRIPTION[$i]} value=${POWERONHOURS}"
	done
	((i++))
done

## disk temps
j=0
for DISK in "${DISK_ARRAY[@]}"
do
	smartctl -n standby -A /dev/${DISK} | grep -E "Temperature_Celsius" | awk '{ print $10 }' | while read DISKTEMP
	do
		curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$MEASUREMENT_TEMPS,host=$MEASUREMENT_HOST,disk=${DESCRIPTION[$j]} value=${DISKTEMP}"
	done
	((j++))
done
