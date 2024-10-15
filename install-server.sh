#!/bin/bash

# Install nginx
apt update
apt install -y nginx

html_file=/var/www/hello/index.html
nginx_config_file=/etc/nginx/sites-available/hello

# Create the static html file
mkdir /var/www/hello/
touch $html_file

system_info=`cat /etc/os-release`
echo "<h1>Hello World</h1>
<b>System information:</b>
<p>$system_info</p>" > $html_file

# Create the nginx config
touch $nginx_config_file
# curl the public id to configure the server_name variable
instance_public_id=`curl http://checkip.amazonaws.com`
echo "server {
    listen 80;

    server_name $instance_public_id;

    root /var/www/hello;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" > $nginx_config_file
ln -s $nginx_config_file /etc/nginx/sites-enabled/

# Restart nginx
systemctl restart nginx