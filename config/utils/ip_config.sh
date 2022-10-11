#!/bin/sh

# Set up host's eth0 ip

NUMBER=$(echo $HOSTNAME | tr -dc '0-9')

if [ $NUMBER = "1" ]
then
	LOCAL_ID=1
else
	LOCAL_ID=2
fi

ip addr add 30.1.1.$LOCAL_ID/24 dev eth0
