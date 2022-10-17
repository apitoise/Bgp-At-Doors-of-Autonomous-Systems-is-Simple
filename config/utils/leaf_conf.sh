#!/bin/sh

HOST_NB=$(echo $HOSTNAME | tr -dc '0-9')

if [ $HOST_NB = "2" ]
	then
		BRIDGE_ETH=1
		ETH_NB=0
		ETH_IP=2
		LO_IP=2
	elif [ $HOST_NB = "3" ]
		then
			BRIDGE_ETH=0
			ETH_NB=1
			ETH_IP=6
			LO_IP=3
	elif [ $HOST_NB = "4" ]
		then
			BRIDGE_ETH=0
			ETH_NB=2
			ETH_IP=10
			LO_IP=4
	else
		echo ERROR
		exit
fi

ip link add br0 type bridge
ip link set dev br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up
brctl addif br0 vxlan10
brctl addif br0 eth$BRIDGE_ETH

vtysh << script

config t
hostname $HOSTNAME
no ipv6 forwarding
!
interface eth$ETH_NB
 ip address 10.1.1.$ETH_IP/30
 ip ospf area 0
!
interface lo
 ip address 1.1.1.$LO_IP/32
 ip ospf area 0
!
router bgp 1
 neighbor 1.1.1.1 remote-as 1
 neighbor 1.1.1.1 update-source lo
 !
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
  advertise-all-vni
 exit-address-family
 !
 router ospf
 !

script
