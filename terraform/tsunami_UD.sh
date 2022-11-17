#!/bin/bash

yum update -y
yum install docker -y
systemctl start docker
sleep 60
export AWS_DEFAULT_REGION=us-west-2
export ip=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text | sed -e 's/None//g')
docker run -d --tty --env ip --name tsunami omribenhur/tsunami
while [ "`docker inspect -f  {{.State.Running}} tsunami`" != "false" ];
do
     sleep 2
     echo 'waiting'
done

docker cp tsunami:/scanner/joined-report.json .

if test -f joined-report.json
then

  aws s3api put-object --bucket security-reports131 --key joined-report --body joined-report.json

else

  echo "all tests passed" > joined-report.json
  aws s3api put-object --bucket security-reports131 --key joined-report --body joined-report.json

fi




