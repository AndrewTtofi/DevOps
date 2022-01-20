#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
yes | sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install php7.0 -y
sudo apt-get install apache2 -y
sudo systemctl enable apache2
PHP_VERSION=$(php -v | cut -d " " -f 2 | cut -d "+" -f 1)
APACHE_STATUS=$(sudo service apache2 status | grep Active | cut -d ":" -f 2 | cut -d " " -f 2)
cat <<EOF
PHP version: $PHP_VERSION
Apache Status: $APACHE_STATUS
EOF