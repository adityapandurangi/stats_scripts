# Stats Scripts
Repo of scripts for collecting various stats for grafana dashboards. The individual scripts are described below.

## current_docker_containers.sh
This script lists the name and status of the docker containers running on the machine

Requires: docker, and ideally not needing to use 'sudo' to run docker commands

## disk_stats.sh
This script pulls the temperature info and power-on hours for each drive. The DISK_ARRAY variable specifies which disks you want the info for, while the DESCRIPTION is a human readable description for storing in the database. The location of each item im the above two arrays correspond to eachother. (so 'sdc' is 'parity', 'sdd' is 'disk1', and so on).

Requires: smartctl

## query_ups.sh
This script uses 'acpaccess' to pull ups info. The items_of_interest hash needs to be filled in with the info you want to specifically pull.

Requires: apcaccess
