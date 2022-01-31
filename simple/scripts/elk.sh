#!/bin/bash

# Uploads SSH Public Key to authorized keys.
cp /home/opc/.ssh/authorized_keys /home/opc/.ssh/authorized_keys.bak
echo "${ssh_public_key}" >> /home/opc/.ssh/authorized_keys
chown -R opc /home/opc/.ssh/authorized_keys

# Configure firewall
firewall-offline-cmd --add-port=${ESDataPort}/tcp
firewall-offline-cmd --add-port=${KibanaPort}/tcp
systemctl restart firewalld

# Install Java
yum install -y java

if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
then
	# Install Elasticsearch
	yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-aarch64.rpm 
	# Install Kibana
	yum install -y ${kibana_download_url}-${kibana_download_version}-aarch64.rpm 
	# Install Logstash
	yum install -y ${logstash_download_url}-${logstash_download_version}-aarch64.rpm 
else
	# Install Elasticsearch
	yum install -y ${elasticsearch_download_url}-${elasticsearch_download_version}-x86_64.rpm  
	# Install Kibana
	yum install -y ${kibana_download_url}-${kibana_download_version}-x86_64.rpm 
	# Install Logstash
	yum install -y ${logstash_download_url}-${logstash_download_version}-x86_64.rpm
fi	

# Enable and start services
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
systemctl enable logstash.service
systemctl start logstash.service

