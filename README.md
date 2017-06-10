# kubernetes-stuff
Useful kubernetes resources


## Scripts
open_port.sh

It applies different iptables rules to be able to access to containers from outside (through public IP). It works well if you have installed kubernetes on a single node.

For example, if the target port is 8080, your private container IP is 192.168.134.67, the private IP of your container host is 192.168.134.64, your public interface is eth0 and the private interface is tunl0, you can execute the following to access port 8080 on your container using the public IP:

> open_port.sh 8080 192.168.134.67 192.168.134.64 eth0 tunl0

After that, if you want to revert all the changes you can execute:

> close_port.sh 8080 192.168.134.67 192.168.134.64 eth0 tunl0

## secret.yaml
It creates a secret. The secret value has to be encoded on base64. For example:

echo -n "--argumentsRealm.passwd.jenkins=CHANGE_ME --argumentsRealm.roles.jenkins=admin" | base64

It gives two lines:

LS1hcmd1bWVudHNSZWFsbS5wYXNzd2QuamVua2lucz1DSEFOR0VfTUUgLS1hcmd1bWVudHNSZWFs
bS5yb2xlcy5qZW5raW5zPWFkbWlu

So we have to write all in one line:

LS1hcmd1bWVudHNSZWFsbS5wYXNzd2QuamVua2lucz1DSEFOR0VfTUUgLS1hcmd1bWVudHNSZWFsbS5yb2xlcy5qZW5raW5zPWFkbWlu
