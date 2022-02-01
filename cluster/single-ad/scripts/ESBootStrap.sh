#! /bin/bash 
echo "############################################################"
echo "Elasticsearch Master/Data Nodes bootstrap script starting..."
echo "############################################################"
echo "."
echo "=(0%)> Setting limits (/etc/security/limits.conf, /etc/sysctl.conf)"
echo "."
ulimit -n 65536
ulimit -u 4096
echo "elasticsearch  -  nofile  65536" >>/etc/security/limits.conf
echo "elasticsearch  -  nproc  4096" >>/etc/security/limits.conf
echo "vm.max_map_count=262144" >>/etc/sysctl.conf
echo "vm.swappiness=1" >>/etc/sysctl.conf
sysctl -p
memgb="$((`cat /proc/meminfo |grep MemTotal|awk '{print $2}'` /1024/1024/2))"
echo "=(100%)> Limits done."
echo "."

##Configures Data Nodes
DataNodeFunc()
{
echo "."
echo "=(0%)> iSCSI discovery and vg/lvcreate"  
echo "."
IQN=$(iscsiadm -m discovery -t st -p 169.254.2.2:3260 |awk '{print $2}')
iscsiadm -m node -o new -T $IQN -p 169.254.2.2:3260
iscsiadm -m node -o update -T $IQN -n node.startup -v automatic
iscsiadm -m node -T $IQN -p 169.254.2.2:3260 -l
pvcreate /dev/sdb
vgcreate vgdata /dev/sdb
lvcreate -l 100%VG -n lvdata vgdata
mkfs.ext4 /dev/vgdata/lvdata
mkdir /elasticsearch
echo "/dev/vgdata/lvdata  /elasticsearch  ext4  defaults,_netdev  0 0" >>/etc/fstab
mount -a 
echo "=(100%)> iSCSI discovery and vg/lvcreate done."
echo "."
echo "=(0%)> yum install java and elasticsearch"  
echo "."
yum install -y java 
if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
then
  yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-aarch64.rpm 
else
  yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-x86_64.rpm  
fi
echo "=(100%)> yum install java and elasticsearch done."  
echo "."
echo "=(0%)> elasticsearch setup (override.conf, user config, jvm.options)"  
echo "."
mkdir /etc/systemd/system/elasticsearch.service.d
echo "[Service]" >>/etc/systemd/system/elasticsearch.service.d/override.conf
echo "LimitMEMLOCK=infinity" >>/etc/systemd/system/elasticsearch.service.d/override.conf
mkdir /elasticsearch/data /elasticsearch/log
chown -R elasticsearch:elasticsearch  /elasticsearch
sed -i 's/\/var\/log\/elasticsearch/\/elasticsearch\/log/g' /etc/elasticsearch/jvm.options
sed -i 's/\/var\/lib\/elasticsearch/\/elasticsearch\/data/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/-Xms1g/-Xms'$memgb'g/' /etc/elasticsearch/jvm.options
echo "."
echo "=(100%)> elasticsearch setup (override.conf, user config, jvm.options) done."  
echo "."
echo "=(0%)> elasticsearch setup (elasticsearch.yml)"  
echo "."
sed -i 's/#MAX_LOCKED_MEMORY/MAX_LOCKED_MEMORY/' /etc/sysconfig/elasticsearch
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.original
echo "cluster.name: oci-es-cluster" >>/etc/elasticsearch/elasticsearch.yml
echo "node.name: $HOSTNAME" >>/etc/elasticsearch/elasticsearch.yml
local_ip=`ip addr show ens3 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/'`
echo "network.host: $local_ip" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.unicast.hosts: ["${esmasternode1_private_ip}","${esmasternode2_private_ip}","${esmasternode3_private_ip}","${esdatanode1_private_ip}","${esdatanode2_private_ip}","${esdatanode3_private_ip}"]" >>/etc/elasticsearch/elasticsearch.yml 
echo "path.data: /elasticsearch/data" >>/etc/elasticsearch/elasticsearch.yml
echo "path.logs: /elasticsearch/log" >>/etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: ["${esmasternode1_private_ip}","${esmasternode2_private_ip}","${esmasternode3_private_ip}"]" >>/etc/elasticsearch/elasticsearch.yml 
echo "cluster.routing.allocation.awareness.attributes: privad" >>/etc/elasticsearch/elasticsearch.yml
subnetID=`hostname -f | awk -F "." '{print $2}'`
echo "node.attr.privad: $subnetID" >>/etc/elasticsearch/elasticsearch.yml
echo "node.roles: [data]" >>/etc/elasticsearch/elasticsearch.yml
echo "bootstrap.memory_lock: true" >>/etc/elasticsearch/elasticsearch.yml
chmod 660 /etc/elasticsearch/elasticsearch.yml
chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
cat /etc/elasticsearch/elasticsearch.yml
echo "."
echo "=(100%)> elasticsearch setup (elasticsearch.yml) done."  
echo "."
echo "=(0%)> elasticsearch service setup and firewall-offline-cmd"  
echo "."
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
firewall-offline-cmd --add-port=${ESDataPort}/tcp
firewall-offline-cmd --add-port=${ESDataPort2}/tcp
systemctl restart firewalld
echo "."
echo "=(100%)> elasticsearch service setup and firewall-offline-cmd done."  
echo "."
}

##Configure Master Nodes
MasterNodeFunc()
{
echo "."
echo "=(0%)> yum install java, elasticsearch and kibana"  
echo "."  
yum install -y java 
if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
then
  yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-aarch64.rpm 
  yum install -y ${kibana_download_url}-${kibana_download_version}-aarch64.rpm 
else
  yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-x86_64.rpm  
  yum install -y ${kibana_download_url}-${kibana_download_version}-x86_64.rpm 
fi
echo "=(100%)> yum install java, elasticsearch and kibana done."  
echo "."
echo "=(0%)> elasticsearch setup (override.conf, user config, jvm.options)"  
echo "."
mkdir /etc/systemd/system/elasticsearch.service.d
echo "[Service]" >>/etc/systemd/system/elasticsearch.service.d/override.conf
echo "LimitMEMLOCK=infinity" >>/etc/systemd/system/elasticsearch.service.d/override.conf
mkdir -p /elasticsearch/data /elasticsearch/log 
chown -R elasticsearch:elasticsearch  /elasticsearch
sed -i 's/\/var\/log\/elasticsearch/\/elasticsearch\/log/g' /etc/elasticsearch/jvm.options
sed -i 's/\/var\/lib\/elasticsearch/\/elasticsearch\/data/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/-Xms1g/-Xms'$memgb'g/' /etc/elasticsearch/jvm.options
echo "."
echo "=(100%)> elasticsearch setup (override.conf, user config, jvm.options) done."  
echo "."
echo "."
echo "=(0%)> elasticsearch setup (elasticsearch.yml)"  
echo "."
sed -i 's/#MAX_LOCKED_MEMORY/MAX_LOCKED_MEMORY/' /etc/sysconfig/elasticsearch
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.original
echo "cluster.name: oci-es-cluster" >>/etc/elasticsearch/elasticsearch.yml
echo "node.name: $HOSTNAME" >>/etc/elasticsearch/elasticsearch.yml
local_ip=`ip addr show ens3 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/'`
echo "network.host: $local_ip" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.unicast.hosts: ["${esmasternode1_private_ip}","${esmasternode2_private_ip}","${esmasternode3_private_ip}","${esdatanode1_private_ip}","${esdatanode2_private_ip}","${esdatanode3_private_ip}"]" >>/etc/elasticsearch/elasticsearch.yml 
echo "path.data: /elasticsearch/data" >>/etc/elasticsearch/elasticsearch.yml
echo "path.logs: /elasticsearch/log" >>/etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: ["${esmasternode1_private_ip}","${esmasternode2_private_ip}","${esmasternode3_private_ip}"]" >>/etc/elasticsearch/elasticsearch.yml 
echo "cluster.routing.allocation.awareness.attributes: privad" >>/etc/elasticsearch/elasticsearch.yml
subnetID=`hostname -f | awk -F "." '{print $2}'`
echo "node.attr.privad: $subnetID" >>/etc/elasticsearch/elasticsearch.yml
echo "node.roles: [master,data]" >>/etc/elasticsearch/elasticsearch.yml
echo "bootstrap.memory_lock: true" >>/etc/elasticsearch/elasticsearch.yml
mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.original 
local_ip=`ip addr show ens3 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/'`
echo "server.host: $local_ip" >>/etc/kibana/kibana.yml
echo "elasticsearch.hosts: ["http://$local_ip:${ESDataPort}"]" >>/etc/kibana/kibana.yml
cat /etc/kibana/kibana.yml
chmod 660 /etc/elasticsearch/elasticsearch.yml
chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
cat /etc/elasticsearch/elasticsearch.yml
echo "."
echo "=(100%)> elasticsearch setup (elasticsearch.yml) done."  
echo "."
echo "=(0%)> elasticsearch service setup and firewall-offline-cmd"  
echo "."
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
firewall-offline-cmd --add-port=${ESDataPort}/tcp
firewall-offline-cmd --add-port=${ESDataPort2}/tcp
firewall-offline-cmd --add-port=${KibanaPort}/tcp
systemctl restart firewalld
echo "."
echo "=(100%)> elasticsearch service setup and firewall-offline-cmd done."  
echo "."
}

## Select the node as Master/Data and runs relevant function.
case $HOSTNAME in
     esmasternode1|esmasternode2|esmasternode3)
           echo "Running Master Node Function"
           MasterNodeFunc
           ;;
    esdatanode1|esdatanode2|esdatanode3)
           echo "Running Data Node Function"
           DataNodeFunc
           ;;
       *)
esac

echo "#######################################################"
echo "Elasticsearch Master/Data Nodes bootstrap script done."
echo "#######################################################"

