#
# Hard Disk Power On Hours
#
# Added -n standby to the check so smartctl is not spinning up my drives
#
#
# Set Vars
#
INFLUX_HOST=''
PORT='8086'
DB=''
MEASUREMENT_HOURS='disk_power_on_hours'
MEASUREMENT_TEMPS='hd_temps'
MEASUREMENT_HOST=''
DISK_ARRAY=( sdi sdd sdh sdc sdg )
DESCRIPTION=( disk1 disk2 disk3 disk4 disk5 )
HUMAN_READABLE_DESCRIPTION=( "Disk\ 1" "Disk\ 2" "Disk\ 3" "Disk\ 4" "Disk\ 5" )


## disk power on hours
post_url= 

i=0
for DISK in "${DISK_ARRAY[@]}"
do
    while read POWERONHOURS;
    do
        post_url=$post_url"$MEASUREMENT_HOURS,host=$MEASUREMENT_HOST,hr_host=${HUMAN_READABLE_DESCRIPTION[$i]},disk=${DESCRIPTION[$i]} value=${POWERONHOURS}"$'\n'
    done <<<$(smartctl -n standby -A /dev/${DISK} | grep -E "Power_On_Hours" | awk '{ print $10 }')
    ((i++))
done
curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$post_url"

## disk temps
post_url=
j=0
for DISK in "${DISK_ARRAY[@]}"
do
    while read DISKTEMP;
    do
        post_url=$post_url"$MEASUREMENT_TEMPS,host=$MEASUREMENT_HOST,hr_host=${HUMAN_READABLE_DESCRIPTION[$j]},disk=${DESCRIPTION[$j]} value=${DISKTEMP}"$'\n'
    done <<<$(smartctl -n standby -A /dev/${DISK} | grep -E "Temperature_Celsius" | awk '{ print $10 }')
    ((j++))
done
curl -s -i -XPOST "http://$INFLUX_HOST:$PORT/write?db=$DB" --data-binary "$post_url"

