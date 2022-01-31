#!/bin/bash

#This script applies for bitnami
read -p "Enter new post_max_size (the number entered will be in MBs) = " postmaxsize #ask the user to enter postmaxsize
read -p "Enter new upload_max_filesize (the number entered will be in MBs) = " uploadmaxsize #ask the user to enter new postmaxsize

#replace the value in the file
sudo sed -i "/post_max_size/c\post_max_size = ${postmaxsize}M" /opt/bitnami/php/etc/php.ini #replace the value of maxsize in the file
sudo sed -i "/upload_max_filesize/c\upload_max_filesize = ${uploadmaxsize}M" /opt/bitnami/php/etc/php.ini #replace the value of maxsize in the file


echo "We will now restart the services so that changes apply"
sudo /opt/bitnami/ctlscript.sh restart