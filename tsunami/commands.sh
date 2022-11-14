#!/bin/bash
mkdir records
apt update -y
apt install nmap -y
apt install ncrack -y
apt install curl -y
apt install git -y
apt install openjdk-11-jdk -y
bash -c "$(curl -sfL https://raw.githubusercontent.com/google/tsunami-security-scanner/master/quick_start.sh)"
