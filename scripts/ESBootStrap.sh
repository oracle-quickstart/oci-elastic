#! /bin/bash 
##ES Master/Data Nodes boot starp
esmasternode1=`host esmasternode1.privad1|awk '{print $4}'`
esmasternode2=`host esmasternode2.privad2|awk '{print $4}'`
esmasternode3=`host esmasternode3.privad3|awk '{print $4}'`
esdatanode1=`host esdatanode1.privad1|awk '{print $4}'`
esdatanode2=`host esdatanode2.privad1|awk '{print $4}'`
esdatanode3=`host esdatanode3.privad2|awk '{print $4}'`
esdatanode4=`host esdatanode4.privad2|awk '{print $4}'`
local_ip=`hostname -i`
subnetID=`hostname -f |cut -f2 -d"."`
ulimit -n 65536
ulimit -u 4096
echo "elasticsearch  -  nofile  65536" >>/etc/security/limits.conf
echo "elasticsearch  -  nproc  4096" >>/etc/security/limits.conf
echo "vm.max_map_count=262144" >>/etc/sysctl.conf
echo "vm.swappiness=1" >>/etc/sysctl.conf
sysctl -p
memgb="$((`cat /proc/meminfo |grep MemTotal|awk '{print $2}'` /1024/1024/2))"

##Configures Data Nodes
DataNodeFunc()
{
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
yum install -y java 
yum install -y https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.rpm
mkdir /etc/systemd/system/elasticsearch.service.d
echo "[Service]" >>/etc/systemd/system/elasticsearch.service.d/override.conf
echo "LimitMEMLOCK=infinity" >>/etc/systemd/system/elasticsearch.service.d/override.conf
mkdir /elasticsearch/data /elasticsearch/log
chown -R elasticsearch:elasticsearch  /elasticsearch
sed -i 's/\/var\/log\/elasticsearch/\/elasticsearch\/log/g' /etc/elasticsearch/jvm.options
sed -i 's/\/var\/lib\/elasticsearch/\/elasticsearch\/data/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/-Xms1g/-Xms'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/#MAX_LOCKED_MEMORY/MAX_LOCKED_MEMORY/' /etc/sysconfig/elasticsearch
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.original
echo "cluster.name: oci-es-cluster" >>/etc/elasticsearch/elasticsearch.yml
echo "node.name: ${HOSTNAME}" >>/etc/elasticsearch/elasticsearch.yml
echo "network.host: $local_ip" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.unicast.hosts: ["$esmasternode1","$esmasternode2","$esmasternode3","$esdatanode1","$esdatanode2","$esdatanode3","$esdatanode4"]" >>/etc/elasticsearch/elasticsearch.yml 
echo "path.data: /elasticsearch/data" >>/etc/elasticsearch/elasticsearch.yml
echo "path.logs: /elasticsearch/log" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 2" >>/etc/elasticsearch/elasticsearch.yml
echo "cluster.routing.allocation.awareness.attributes: privad" >>/etc/elasticsearch/elasticsearch.yml
echo "node.attr.privad: $subnetID" >>/etc/elasticsearch/elasticsearch.yml
echo "node.master: false" >>/etc/elasticsearch/elasticsearch.yml
echo "node.data: true" >>/etc/elasticsearch/elasticsearch.yml
echo "bootstrap.memory_lock: true" >>/etc/elasticsearch/elasticsearch.yml
chmod 660 /etc/elasticsearch/elasticsearch.yml
chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
firewall-offline-cmd --add-port=9200/tcp
firewall-offline-cmd --add-port=9300/tcp
systemctl restart firewalld
}

##Configure Master Nodes
MasterNodeFunc()
{
yum install -y java 
yum install -y https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.rpm
yum install -y https://artifacts.elastic.co/downloads/kibana/kibana-6.4.1-x86_64.rpm
mkdir /etc/systemd/system/elasticsearch.service.d
echo "[Service]" >>/etc/systemd/system/elasticsearch.service.d/override.conf
echo "LimitMEMLOCK=infinity" >>/etc/systemd/system/elasticsearch.service.d/override.conf
mkdir -p /elasticsearch/data /elasticsearch/log 
chown -R elasticsearch:elasticsearch  /elasticsearch
sed -i 's/\/var\/log\/elasticsearch/\/elasticsearch\/log/g' /etc/elasticsearch/jvm.options
sed -i 's/\/var\/lib\/elasticsearch/\/elasticsearch\/data/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/-Xms1g/-Xms'$memgb'g/' /etc/elasticsearch/jvm.options
sed -i 's/#MAX_LOCKED_MEMORY/MAX_LOCKED_MEMORY/' /etc/sysconfig/elasticsearch
mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.original
echo "cluster.name: oci-es-cluster" >>/etc/elasticsearch/elasticsearch.yml
echo "node.name: ${HOSTNAME}" >>/etc/elasticsearch/elasticsearch.yml
echo "network.host: $local_ip" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.unicast.hosts: ["$esmasternode1","$esmasternode2","$esmasternode3","$esdatanode1","$esdatanode2","$esdatanode3","$esdatanode4"]" >>/etc/elasticsearch/elasticsearch.yml
echo "path.data: /elasticsearch/data" >>/etc/elasticsearch/elasticsearch.yml
echo "path.logs: /elasticsearch/log" >>/etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 2" >>/etc/elasticsearch/elasticsearch.yml
echo "cluster.routing.allocation.awareness.attributes: privad" >>/etc/elasticsearch/elasticsearch.yml
echo "node.attr.privad: $subnetID" >>/etc/elasticsearch/elasticsearch.yml
echo "node.master: true" >>/etc/elasticsearch/elasticsearch.yml
echo "node.data: false" >>/etc/elasticsearch/elasticsearch.yml
echo "node.ingest: false" >>/etc/elasticsearch/elasticsearch.yml
echo "bootstrap.memory_lock: true" >>/etc/elasticsearch/elasticsearch.yml
mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.original 
echo "server.host: $local_ip" >>/etc/kibana/kibana.yml
echo "elasticsearch.url: "http://$local_ip:9200"" >>/etc/kibana/kibana.yml
chmod 660 /etc/elasticsearch/elasticsearch.yml
chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
firewall-offline-cmd --add-port=9200/tcp
firewall-offline-cmd --add-port=9300/tcp
firewall-offline-cmd --add-port=5601/tcp
systemctl restart firewalld
}

## Select the node as Master/Data and runs relevant function.
case ${HOSTNAME} in
     esmasternode1|esmasternode2|esmasternode3)
           echo "Running Master Node Function"
           MasterNodeFunc
           ;;
    esdatanode1|esdatanode2|esdatanode3|esdatanode4)
           echo "Running Data Node Function"
           DataNodeFunc
           ;;
       *)
esac
