THIS=$(echo $HOSTNAME | tr -dc '0-9')
OTHER=$(if [ "$THIS" = "1" ]; then echo 2; else echo 1; fi;)
VXLAN_CONF=$(if [ "$1" = "multi" ]
	then echo group 239.1.1.1;
	else echo remote 10.1.1.$OTHER local 10.1.1.$THIS; fi)

#setup ip address 10.1.1.X on eth0
ip addr add 10.1.1.$THIS/24 dev eth0

#create vxlan between 10.1.1.X
ip link add name vxlan10 \
	type vxlan \
	id 10 \
	dev eth0 \
	$VXLAN_CONF \
	dstport 4789
ip link set dev vxlan10 up

#bridge vxlan to eth1 interface (connected to host)
ip link add br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10

#start routing daemons
/usr/lib/frr/frrinit.sh start

tail -f /dev/null
