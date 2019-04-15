#!/bin/bash

# Configure firewall
firewall-offline-cmd --add-port=9200/tcp
firewall-offline-cmd --add-port=5601/tcp
systemctl restart firewalld

# Install Java
yum install -y java

# Install Elasticsearch
yum install -y https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.0.0-x86_64.rpm

# Install Kibana
yum install -y https://artifacts.elastic.co/downloads/kibana/kibana-7.0.0-x86_64.rpm

# Install Logstash
yum install -y https://artifacts.elastic.co/downloads/logstash/logstash-7.0.0.rpm

# Enable and start services
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable kibana.service
systemctl start kibana.service
systemctl enable logstash.service
systemctl start logstash.service
