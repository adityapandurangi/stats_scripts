# Stats Scripts
Repo of scripts for collecting various stats for grafana dashboards. The individual scripts are described below.

## current_docker_containers.sh
This script lists the name and status of the docker containers running on the machine

*Requires*: docker  
*Optional but ideal*: not needing to use 'sudo' to run docker commands (see http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)

## disk_stats.sh
This script pulls the temperature info and power-on hours for each drive. The DISK_ARRAY variable specifies which disks you want the info for, while the DESCRIPTION is a human readable description for storing in the database. The location of each item in the above two arrays correspond to each other. (so 'sdc' is 'parity', 'sdd' is 'disk1', and so on).

*Requires*: smartctl  
*Note*: script template + ideas taken from RAINMAN on the unraid forums: https://lime-technology.com/forum/index.php?topic=52220  
*Todo*: not call smartctl twice  

## query_ups.sh
This script uses 'apcaccess' to pull ups info. The items_of_interest hash needs to be filled in with the info you want to specifically pull.

*Requires*: apcaccess

## disk_smart_status.sh
This script pulls that smart status (passing or failure) for the desk. The DISK_ARRAY variable specifies which disks you want the info for, while the DESCRIPTION is a human readable description for storing in the database. The location of each item in the above two arrays correspond to each other. (so 'sdc' is 'parity', 'sdd' is 'disk1', and so on).

*Requires*: smartctl

## disk_smart_status.sh
This script is used for pulling sensor info, such as CPU temps and fan speeds. It's been tested on unRAID but not any other systems

*Requires* lm-sensors (I think)
