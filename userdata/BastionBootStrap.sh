#! /bin/bash
## Enables Bastion Host as NAT instance for ES master/data nodes to update/install software from internet.
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo firewall-offline-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o ens3 -j MASQUERADE
sudo firewall-offline-cmd --direct --add-rule ipv4 filter FORWARD 0 -i ens3 -j ACCEPT
sudo sysctl -p
sudo systemctl restart firewalld
