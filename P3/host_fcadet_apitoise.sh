HOSTNB=$(echo $HOSTNAME | tr -dc '0-9')

#setup ip address
ip addr add 20.1.1.$HOSTNB/24 dev eth0

tail -f /dev/null
