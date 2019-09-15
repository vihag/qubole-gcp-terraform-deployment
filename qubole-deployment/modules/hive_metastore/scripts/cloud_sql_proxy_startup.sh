#!/usr/bin/env bash

cd ~
mkdir cloudsql
mkdir cloudsqldir
cd cloudsq
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

cloud_sql_instance_name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/cloud_sql_instance -H "Metadata-Flavor: Google")

./cloud_sql_proxy -ip_address_types=PRIVATE -instances='+cloud_sql_instance_name+'=tcp:0.0.0.0:3306 &> /tmp/cloud_sql_proxy.log
