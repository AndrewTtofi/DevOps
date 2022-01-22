#!/bin/bash
if [ $(id -u) -eq 0 ]; then  #check if the user is using the script is root
	read -p "Enter username : " username #ask for the name of the user
	read -s -p "Enter password : " password #ask for the password of the user
	egrep "^$username" /etc/passwd >/dev/null   #search if the user exists
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password) #encrypt the password
		useradd -m -p "$pass" "$username"  #create the user
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"  #in case of failure
	fi
else
	echo "Only root may add a user to the system." 
	exit 2
fi
echo "$username  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers #add the user to the sudoers + do not require pass for sudo

 