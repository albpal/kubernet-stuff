# kubernet-stuff
Useful kubernetes resources


open_port.sh

It applies different iptables rules to be able to access to containers from outside (through public IP). It works well if you have installed kubernetes on a single node.

For example, if the target port is 8080, your private container IP is 192.168.134.67, the private IP of your container host is 192.168.134.64, your public interface is eth0 and the private interface is tunl0, you can execute the following to access port 8080 on your container using the public IP:

> open_port.sh 8080 192.168.134.67 192.168.134.64 eth0 tunl0

After that, if you want to revert all the changes you can execute:

> close_port.sh 8080 192.168.134.67 192.168.134.64 eth0 tunl0
