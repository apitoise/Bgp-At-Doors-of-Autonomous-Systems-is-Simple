HOSTNB=$(echo $HOSTNAME | tr -dc '0-9')

#setup ip address
ip addr add 30.1.1.$HOSTNB/24 dev eth1

tail -f /dev/null
