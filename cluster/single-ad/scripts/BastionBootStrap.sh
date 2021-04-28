#! /bin/bash
## Enables Bastion Host as NAT instance for ES master/data nodes to update/install software from internet.
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
firewall-offline-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o ens3 -j MASQUERADE
firewall-offline-cmd --direct --add-rule ipv4 filter FORWARD 0 -i ens3 -j ACCEPT
sysctl -p
systemctl restart firewalld

# Uploads SSH Public Key to authorized keys.
cp /home/opc/.ssh/authorized_keys /home/opc/.ssh/authorized_keys.bak
echo "${ssh_public_key}" >> /home/opc/.ssh/authorized_keys
chown -R opc /home/opc/.ssh/authorized_keys