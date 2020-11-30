#!/bin/bash

# Configure firewall
firewall-offline-cmd --add-port=${ESDataPort}/tcp
firewall-offline-cmd --add-port=${KibanaPort}/tcp
systemctl restart firewalld

# Install Java
yum install -y java

# Install Elasticsearch
yum install -y ${elasticsearch_download_url}

# Install Kibana
yum install -y ${kibana_download_url}

# Install Logstash
yum install -y ${logstash_download_url}

# Enable and start services
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
systemctl enable logstash.service
systemctl start logstash.service
