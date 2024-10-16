#!/bin/bash

# Install nginx
yum update
yum install -y nginx

html_file=/usr/share/nginx/html/index.html
nginx_config_file=/etc/nginx/nginx.conf

echo "<h1>Hello World</h1>" > $html_file

# Create the nginx config
touch $nginx_config_file
# curl the public id to configure the server_name variable
instance_public_id=`curl http://checkip.amazonaws.com`
echo "events{
worker_connections 1024;
}
http{server {
    listen 80;
    server_name $instance_public_id;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }
}}" > $nginx_config_file

# Restart nginx
systemctl restart nginx