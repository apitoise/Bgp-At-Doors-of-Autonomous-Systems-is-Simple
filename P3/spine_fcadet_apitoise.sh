echo "!
!
frr version 8.4_git
frr defaults traditional
hostname $HOSTNAME
no ipv6 forwarding
!
!
######################
!
# INTERFACES TO LEAFS
!
interface eth0
 ip address 10.1.1.1/24
exit
!
interface eth1
 ip address 10.1.2.1/24
exit
!
interface eth2
 ip address 10.1.3.1/24
exit
!
######################
!
# LOOPBACK ADDRESS
!
interface lo
 ip address 1.1.1.4/32
exit
!
######################
!
# OSPF CONFIGRATION
# (spread populated adresses in area 0)
!
router ospf
 network 0.0.0.0/0 area 0
exit
!
######################
!
# BGP CONFIGURATION
# (AS 1 to 1 -> iBGP)
!
router bgp 1
 !
 # (Peer group 'leafs' configuration)
 !
 neighbor leafs peer-group
 neighbor leafs remote-as 1
 neighbor leafs update-source lo
 bgp listen range 1.1.1.0/24 peer-group leafs
 !
 # (EVPN configuration for MAC and VNI support)
 !
 address-family l2vpn evpn
  neighbor leafs activate
  neighbor leafs route-reflector-client
 exit-address-family
exit
!
end" > /etc/frr/frr.conf

#start routing daemons
/usr/lib/frr/frrinit.sh start

tail -f /dev/null
