#!/bin/bash
#Created and edited by Andreas Ttofi
############################################################
###########CREATE THE AMI BASED ON THE TIME#################
############################################################
#First we need to print only the name of the instance:
eccinstancename=$(aws ec2 describe-instances --instance-ids=<INSERT Instance ID> | grep -A 1 '"Key": "Name",' | grep Value | cut -d ":" -f 2 | cut -d '"' -f 2)
#Then we need to import the timestamp for the created AMI
dateami=$(date | cut -d " " -f 2,3 | sed 's/ //g')
#tod= time of day. Distinguish if the time is morning or night
tod=$(date +'%R' | cut -d ":" -f 1)
if [ $tod -ge 12 ]; then
    tod="night"
else
    tod="morning"
fi
#echo "${eccinstancename}-${dateami}-${tod}"
echo "AMI is being created"
#Then we need to input the variable above in the ec2 create image command and create the AMI
aws ec2 create-image --instance-id <INSERT Instance ID> --name "${eccinstancename}-${dateami}-${tod}" --description "${eccinstancename}-${dateami}-${tod}" --no-reboot > config.json
############################################################
###############UPDATE LAUNCH TEMPLATE VERSION###############
############################################################
#currentversion=$(aws ec2 describe-launch-template-versions --launch-template-id lt-0fb1103bf65eda848 | grep VersionNumber | head -1 | cut -d ":" -f 2 | sed 's/,//g')
#Wait for 10 minutes for the creation of the AMI -> a loop can be created to check if the AMI is created to create a new template version
sleep 10m
echo "Wait for the completion of the AMI"
#Update the version of the AMI
aws ec2 create-launch-template-version --launch-template-id <INSERT Launch Template ID>  --version-description "${eccinstancename}-${dateami}-${tod}" --source-version 1 --launch-template-data file://config.json
rm /home/ubuntu/config.json
############################################################
##################DELETE AMI BASED ON TIME##################
############################################################
#Create a variable for the previous for the DATE and TIME 2 days before the AMI creation
previousamitime=$(date +'%R' | cut -d ":" -f 1)
previousamidate=$(date --date "2 days ago" | cut -d " " -f 2,3 | sed 's/ //g')
#Get the AMI name that we are going to delete
aminame=$(aws ec2 describe-instances --instance-ids= <INSERT Instance ID> | grep -A 1 '"Key": "Name",' | grep Value | cut -d ":" -f 2 | cut -d '"' -f 2)
#Distinguish if we are going to delete the morning or the night AMI
if [ $previousamitime -ge 12 ]; then
    previousamitime="night"
else
    previousamitime="morning"
fi
#Get the image ID that we are going to delete.
amitobedeleted=$(aws ec2 describe-images --region ap-northeast-1 --owner <INSERT OWNER ID> | grep -B 1 '"ImageLocation":' | grep -B 1 "${aminame}-${previousamidate}-${previousamitime}" | cut -d ":" -f 2 | cut -d "," -f 1 | head -1 | sed 's/"//g' | sed 's/ //g')
#Deregister the AMI
aws ec2 deregister-image --image-id $amitobedeleted