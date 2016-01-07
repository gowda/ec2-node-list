#!/bin/bash

function __init {
    # use GNU sed on OSX, change to 'sed' on GNU/Linux
    export SED='gsed'

    # EC2 command for fetching regions
    export DESCRIBE_REGIONS='ec2-describe-regions'

    # EC2 command for fetching instance description
    export DESCRIBE_INSTANCES='ec2-describe-instances'

    # filters for DESCRIBE_INSTANCES command
    export FILTERS='--filter instance-state-name="running"'

    export INSTANCES_CMD="$DESCRIBE_INSTANCES $FILTERS"
}

function get_regions {
    eval $DESCRIBE_REGIONS | cut -f 2,3 | $SED 's/[[:space:]]/,/g'
}

function get_instance_ids {
    eval $INSTANCES_CMD --hide-tags | grep -i instance | cut -f 2
}

function get_hostname {
    id=$1
    eval $INSTANCES_CMD --hide-tags ${id} | grep -vi tag | grep -i instance | cut -f4
}

function get_name {
    id=$1
    eval $INSTANCES_CMD ${id} | grep -i tag | grep -i name | cut -f5
}

function nodes {
    for region in $(get_regions); do	
	region_name=$(echo $region | $SED 's/\([^,]*\),\([^,]*\)/\1/g');
	region_url=$(echo $region | $SED 's/\([^,]*\),\([^,]*\)/\2/g');
	EC2_URL="https://${region_url}";
	INSTANCE_IDS=($(get_instance_ids))
	for id in ${INSTANCE_IDS[@]}; do
	    HOSTNAME=$(get_hostname ${id})
	    NAME=$(get_name ${id})
	    echo "${NAME},${region_name},${HOSTNAME}"
	done
    done
}

function is_alive {
    node=$1
    ping -c 5 $node &> /dev/null
    if [[ "$?" -eq "0" ]]; then
	echo "yes"
    else
	echo "no"
    fi
}

function __main {
    for line in $(nodes); do
	status=$(is_alive $(echo $line | cut -d',' -f 3));
	echo "${line},${status}";
    done
}

__init && __main
