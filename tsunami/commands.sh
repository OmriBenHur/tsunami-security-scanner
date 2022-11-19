#!/bin/bash
# commands to run on the creation of the docker image( this is not required because the image is already built on hosted on my dockerhub account
mkdir records
chmod 777 scan.sh
chmod 777 activate.sh
apt update -y
apt install nmap -y
apt install ncrack -y
apt install curl -y
apt install git -y
apt install openjdk-11-jdk -y
bash -c "$(curl -sfL https://raw.githubusercontent.com/google/tsunami-security-scanner/master/quick_start.sh)"