#!/bin/bash

if [[ "$#" -ne 5 ]];then
	echo "Illegal number of parameters"
	echo "Usage: script.sh <PORT> <POD_INTERNAL_IP> <PUBLIC_NODE_INTERNAL_IP> <PUBLIC_INTERFACE> <PRIVATE_INTERFACE>"
	exit 1
fi

PORT=$1
POD_INTERNAL_IP=$2
PUBLIC_NODE_INTERNAL_IP=$3
PUBLIC_INTERFACE=$4
PRIVATE_INTERFACE=$5

echo "sudo iptables -A FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -p tcp --syn --dport $PORT -m conntrack --ctstate NEW -j ACCEPT"
sudo iptables -A FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -p tcp --syn --dport $PORT -m conntrack --ctstate NEW -j ACCEPT

echo "sudo iptables -A FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
sudo iptables -A FORWARD -i $PUBLIC_INTERFACE -o $PRIVATE_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
echo "sudo iptables -A FORWARD -i $PRIVATE_INTERFACE -o $PUBLIC_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
sudo iptables -A FORWARD -i $PRIVATE_INTERFACE -o $PUBLIC_INTERFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "sudo iptables -t nat -I PREROUTING 1 -i $PUBLIC_INTERFACE -p tcp --dport $PORT -j DNAT --to-destination $POD_INTERNAL_IP"	
sudo iptables -t nat -I PREROUTING 1 -i $PUBLIC_INTERFACE -p tcp --dport $PORT -j DNAT --to-destination $POD_INTERNAL_IP
echo "sudo iptables -t nat -I POSTROUTING 1 -o $PRIVATE_INTERFACE -p tcp --dport $PORT -d $POD_INTERNAL_IP -j SNAT --to-source $PUBLIC_NODE_INTERNAL_IP"
sudo iptables -t nat -I POSTROUTING 1 -o $PRIVATE_INTERFACE -p tcp --dport $PORT -d $POD_INTERNAL_IP -j SNAT --to-source $PUBLIC_NODE_INTERNAL_IP
