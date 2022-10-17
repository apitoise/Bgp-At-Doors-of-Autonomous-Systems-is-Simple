HOST_NB=$(echo $HOSTNAME | tr -dc '0-9')

if [ $HOST_NB = "1" ]
	then
		ETH_NB=1
	else
		ETH_NB=0
fi
ip addr add 20.1.1.$HOST_NB/24 eth$ETH_NB
