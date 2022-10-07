#!/bin/sh

# Get host id
NUMBER=$(echo $HOSTNAME | tr -dc '0-9')

if [ $NUMBER = "1" ]
then
	LOCAL_ID=1
	REMOTE_ID=2
else
	LOCAL_ID=2
	REMOTE_ID=1
fi

# Set ip to eth1
ip addr add 30.1.1.$LOCAL_ID/24 dev eth0

# Set vxlan
ip link add vxlan10 type vxlan id 10 remote 30.1.1.$REMOTE_ID local 30.1.1.$LOCAL_ID dev eth0 dstport 4789
ip addr add 20.1.1.$LOCAL_ID/24 dev vxlan10

# Create bridge
ip link add br0 type bridge

# Set eth1 & vxlan as member of br0
ip link set eth1 master br0
ip link set vxlan10 master br0

# Up bridge & vxlan
ip link set br0 up
ip link set vxlan10 up
