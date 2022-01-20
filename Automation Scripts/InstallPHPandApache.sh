#!/bin/bash
sudo apt-get update  #Get updates
sudo apt-get upgrade -y #install upgrades
yes | sudo add-apt-repository ppa:ondrej/php #get older versions of PHP
sudo apt-get update #update
sudo apt-get install php7.0 -y #install PHP 7.0
sudo apt-get install apache2 -y #install apache2
sudo systemctl enable apache2 #enable apache2
sudo apt-get install snmpd #install snmp on server
sudo sed -i '/127.0/c\agentaddress  udp:161' /etc/snmp/snmpd.conf #change the port of agentaddress
sudo bash -c "echo rocommunity gtro 10.31.0.11 >> /etc/snmp/snmpd.conf" #input the value of rocommunity on the file
sudo service snmpd restart #restart the SNMP service to refresh the data
SNMP_STATUS=$(sudo service snmp status | grep Active | cut -d ":" -f 2 | cut -d " " -f 2) #set variable SNMP that will use to print output
PHP_VERSION=$(php -v | cut -d " " -f 2 | cut -d "+" -f 1) #set variable PHP that will use to print output
APACHE_STATUS=$(sudo service apache2 status | grep Active | cut -d ":" -f 2 | cut -d " " -f 2) #set variable Apache that will use to print output
cat <<EOF
PHP version: $PHP_VERSION
Apache Status: $APACHE_STATUS
SNMP Status: $SNMP_STATUS
EOF