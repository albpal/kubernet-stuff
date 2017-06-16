#!/bin/bash

if [[ "$#" -ne 6 ]];then
	echo "Illegal number of parameters"
	echo "Usage: script.sh <PUBLIC_PORT> <CONTAINER_PORT> <POD_INTERNAL_IP> <PUBLIC_NODE_INTERNAL_IP> <PUBLIC_INTERFACE> <PRIVATE_INTERFACE>"
	exit 1
fi

PUBLIC_PORT=$1
CONTAINER_PORT=$2
POD_INTERNAL_IP=$3
PUBLIC_NODE_INTERNAL_IP=$4
PUBLIC_INTERFACE=$5
PRIVATE_INTERFACE=$6

echo "sudo iptables -D FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -p tcp --syn --dport $PUBLIC_PORT -m conntrack --ctstate NEW -j ACCEPT -m comment --comment \"Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT\""
sudo iptables -D FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -p tcp --syn --dport $PUBLIC_PORT -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT"

echo "sudo iptables -D FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment \"Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT\""
sudo iptables -D FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT"
echo "sudo iptables -D FORWARD -i $PRIVATE_INTERFACE -o $PUBLIC_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment \"Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT\""
sudo iptables -D FORWARD -i $PRIVATE_INTERFACE -o $PUBLIC_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT"

echo "sudo iptables -t nat -D PREROUTING -i $PUBLIC_INTERFACE -p tcp --dport $PUBLIC_PORT -m comment --comment \"Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT\" -j DNAT --to-destination $POD_INTERNAL_IP:$CONTAINER_PORT"	
sudo iptables -t nat -D PREROUTING -i $PUBLIC_INTERFACE -p tcp --dport $PUBLIC_PORT -m comment --comment "Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT" -j DNAT --to-destination "$POD_INTERNAL_IP:$CONTAINER_PORT"
echo "sudo iptables -t nat -D POSTROUTING -o $PRIVATE_INTERFACE -p tcp --dport $PUBLIC_PORT -m comment --comment \"Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT\" -d $POD_INTERNAL_IP -j SNAT --to-source $PUBLIC_NODE_INTERNAL_IP:$PUBLIC_PORT"
sudo iptables -t nat -D POSTROUTING -o $PRIVATE_INTERFACE -p tcp --dport $PUBLIC_PORT -m comment --comment "Open port from $PUBLIC_PORT to $POD_INTERNAL_IP:$CONTAINER_PORT" -d $POD_INTERNAL_IP -j SNAT --to-source "$PUBLIC_NODE_INTERNAL_IP:$PUBLIC_PORT"
