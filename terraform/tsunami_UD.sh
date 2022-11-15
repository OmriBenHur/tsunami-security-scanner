#!/bin/bash

yum update -y
yum install docker -y
systemctl start docker
export AWS_DEFAULT_REGION=us-west-2
export ip=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text)
docker run -d --tty --env ip --name tsunami omribenhur/tsunami