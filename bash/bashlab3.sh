#!/bin/bash

#checking lxd on the hosting vm
which lxd >/dev/null

#installing lxd on the hosting vm
if [ $? -ne 0 ]; then
	echo "lxd is not installed. We're installing lxd now."
	sudo snap install lxd
	if [ $? -ne 0 ]; then
		echo "We're into a problem. Exiting now"
		exit 1
	fi
else
	echo "lxd already installed."
fi

#checking if lxdbr0 exists or not and creating lxdbr0 if it doesn't exist
ip link show lxdbr0 >/dev/null
if [ $? -ne 0 ];then
	echo "Creating lxdbr0 interface."
	lxd init --auto
else
	echo "lxdrb0 interface already exists."
fi

#Creating and launching a container running Ubuntu 22.04 server named COMP2101-S22
sudo lxc list | grep COMP2101-S22 >/dev/null
if [ $? -ne 0 ];then
	echo "Creating a new container."
	sudo lxc launch ubuntu:22.04 COMP2101-S22
else
	echo "Container exists. Now moving to next steps."
fi

#Updating the entry in /etc/hosts for hostname COMP2101-S22 with the container’s current IP address
currentipadd=$(sudo lxc list COMP2101-S22 -c n4 --format csv | cut -d',' -f2 | sed 's/(eth0)//')
if grep -q "COMP2101-S22" /etc/hosts; then
#For Existing IP Address
    existingipadd=$(grep "COMP2101-S22" /etc/hosts | awk '{print $1}')
    if [[ "$currentipadd" != "$existingipadd" ]]; then
        sudo sed -i "s/$existingipadd/$currentipadd/g" /etc/hosts
        echo "Entry updated with the current IP Address."
    else
        echo "Entry already exists with the current IP Address."
    fi
else
    sudo sh -c "echo $currentipadd COMP2101-S22 >> /etc/hosts"
    echo "Entry gets added in /etc/hosts with current IP Address."
fi

#Installing Apache2 in the container
if lxc exec COMP2101-S22 command -v apache2 >/dev/null 2>&1; then
	echo "Apache2 already installed."
else
	echo "Apache2 is installing."
  	lxc exec COMP2101-S22 -- sudo apt-get install -y apache2 > /dev/null
	echo "Apache is starting."
	lxc exec COMP2101-S22 -- systemctl start apache2
fi

#Retrieving the default web page from the container’s web service and also notifying the user of success or failure
sudo apt install curl >/dev/null
if curl http://COMP2101-S22 >/dev/null 2>&1; then
	echo "Retrieved the home page of the website without issue."
else
	echo "Retrieving the default web page is failed."
fi
