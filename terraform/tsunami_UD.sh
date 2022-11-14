#!/bin/bash

yum update -y
yum install docker -y
systemctl start docker
export AWS_DEFAULT_REGION=us-west-2
ip=($(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text))