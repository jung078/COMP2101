#!/bin/bash

Hostname=$(hostname)               #it will display hostname of a system
Operating_System_Name_and_Version=$(hostnamectl | grep -w Operating | awk '{print$3$4$5}') #(hostnamecctl) provides additional information of the host, (grep -w) command searches for the word that matches in a given set of files
IP_Address=$(ip route | grep default | awk '{print$3}')        #(ip route) command is used to find ip address used by computer
Root_FreeSpace=$(df -h / | awk 'NR==2 {print $4}') #(df -h) displays information about the disk space usage of the file systems that contain root directory in human readable format
							#(awk) is used to manipulate data, (NR==2) is a pattern that matches line where line number is equal to 2
cat << EOF

Report for my $Hostname
===================
FQDN: $Hostname
Operating System Name and Version:$Operating_System_Name_and_Version
IP Address:$IP_Address
Root FileSystem Free Space:$Root_FreeSpace
===================

EOF
