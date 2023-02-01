#!/bin/bash
echo "FQDN:$(hostname)"       #it will display the hostname of the system
echo "host information" 
hostnamectl                   #to provide additional information of the host
echo "IP Addresses:" 
hostname -I                   #to display the network address (IP address) of the host
df -h /                       #displays information about the disk space usage of the file systems that  contain root directory
