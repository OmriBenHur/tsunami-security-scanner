#!/bin/bash
# download and installing all dependencies
yum update -y
yum install docker -y
systemctl start docker
# sleep is required only for the jupyter notebook scanning if it is part of the terraform code, it is to provide the jupyter container time to set up and run
sleep 60
# exporting default region for aws to use in th next command
export AWS_DEFAULT_REGION=us-west-2
# exporting list of public ip's in the configured region to scan.
export ip=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text | sed -e 's/None//g')
# running the container with the list of public ips as an env variable
docker run -d --tty --env ip --name tsunami omribenhur/tsunami
# waiting for the container to exit (scanning, identification, and joining reports is finished.
while [ "`docker inspect -f  {{.State.Running}} tsunami`" != "false" ];
do
     sleep 2
     echo 'waiting'
done
# copying joined report from scanner container
docker cp tsunami:/scanner/joined-report.json .
# checking if report is present, if it is, upload it to a created s3 bucket and notify of the upload via sns(requires subscription)
if test -f joined-report.json
then

  aws s3api put-object --bucket security-reports131 --key joined-report --body joined-report.json

else
# if the joined report is not present(meaning scanning did not identify any vulnerabilities) echo all tests passed and upload to s3
  echo "all tests passed" > joined-report.json
  aws s3api put-object --bucket security-reports131 --key joined-report --body joined-report.json

fi




