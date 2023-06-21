LEAFNB=$(echo $HOSTNAME | tr -dc '0-9')

#create vxlan
ip link add name vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up

#bridge vxlan to eth0
ip link add br0 type bridge
ip link set dev br0 up
brctl addif br0 eth0
brctl addif br0 vxlan10

echo "!
!
frr version 8.4_git
frr defaults traditional
hostname $HOSTNAME
no ipv6 forwarding
!
######################
!
# INTERFACE TO SPINE
# (populated with OSPF in area 0)
!
interface eth1
 ip address 10.1.$LEAFNB.2/24
 ip ospf area 0
exit
!
######################
!
# LOOPBACK ADDRESS (lo)
# (populated with ospf in area 0)
!
interface lo
 ip address 1.1.1.$LEAFNB/32
 ip ospf area 0
exit
!
######################
!
# OSPF CONFIGRATION
!
router ospf
exit
!
######################
!
# BGP CONFIGURATION
# (AS 1 to 1 -> iBGP)
!
router bgp 1
 !
 # (Route Reflector configuration)
 !
 neighbor 1.1.1.4 remote-as 1
 neighbor 1.1.1.4 update-source lo
 !
 # (EVPN configuration for MAC and VNI support)
 !
 address-family l2vpn evpn
  neighbor 1.1.1.4 activate
  advertise-all-vni
 exit-address-family
exit
!
end" > /etc/frr/frr.conf

#start routing daemons
/usr/lib/frr/frrinit.sh start

tail -f /dev/null
