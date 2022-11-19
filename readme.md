# tusnami network security scanner, deployed on AWS, with jenkins "cron'ed" piplines

## this project uses google's tsunami network scanner with aws and jenkins to deploy, scan, identify and notify of any found vulnerabilities by the scanner.

#### by default, the scanner scans any vulnerabilities in any available instance's public ip's in the region. this can be changes in the tsunami_UD file in the terraform dir.for example, changing the aws ec2 describe-instances command to query "[PrivateIpAddress]" instead of "[PublicIpAddress]", or both!

### For Your Information:
#### the scanner's docker image compressed size is 871.94 MB, this is due to the extensible plugin system the scanner relies on, the scanner also requires computing power, (t2.micro instaces crashes due to memory cap), the script uses a t3.med instance but you are more then welcome to experiment with instance types
#### make sure to empty the report bucket before jenkins tries to destroy the infrastructure!

## pre-req:

1. working aws account with access key
2. jenkins machine with terraform and checkout from scm plugin


## step 1: create s3 bucket for terraform backend
### if you already own an s3 bucket configured for this purpose; skip to part 2

1. on the aws console, search for s3, and click create bucket and configure the following

<img width="948" alt="Capture" src="https://user-images.githubusercontent.com/110596448/202850053-9512fdf4-9438-4b02-b6d7-da1b2fddaac8.PNG">

<img width="602" alt="2" src="https://user-images.githubusercontent.com/110596448/202850063-dc2cdc84-d4d0-4197-86df-b0a0dec547f0.PNG">

<img width="538" alt="3" src="https://user-images.githubusercontent.com/110596448/202850066-c9cfc192-0582-4aad-83ab-3e36e845bed6.PNG">

<img width="546" alt="4" src="https://user-images.githubusercontent.com/110596448/202850069-bc69a95d-3546-4983-ac8b-3980effee5ca.PNG">

2. next click on the created bucket, and under permission tab, edit the bucket policy and enter the following:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<arn of the user that issued the access key>"
            },
            "Action": "s3:ListBucket",
            "Resource": "<arn of created bucket>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<arn of the user that issued the access key>"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "<arn of created bucket>/*"
        }
    ]
}

```
 
click save
  
 ## step 2: configure terraform block under backend.tf file with the corresponding values you have created earlier
   
  <img width="447" alt="terraform" src="https://user-images.githubusercontent.com/110596448/202850388-362f26ff-fcb3-4c47-8f11-d6ef31b8c1d2.PNG">
  
  
## step3: configure jenkins machine with aws crdentials and pipline.
 
 ### login to jeknins, under manage jenkins, manage credentials, system store, on the top right click add credentials and configure the following.
  
<img width="284" alt="jenkins1" src="https://user-images.githubusercontent.com/110596448/202850652-41208d0a-dff7-454c-a680-c6250830066d.PNG">
  
<img width="829" alt="jenkins2" src="https://user-images.githubusercontent.com/110596448/202850719-e2945bd2-ef62-4f40-a828-380265dbad47.PNG">
  
<img width="445" alt="jenkins3" src="https://user-images.githubusercontent.com/110596448/202850825-32aa5552-743e-416e-bfe6-1ddbbed4c413.PNG">

<img width="715" alt="jenkins4" src="https://user-images.githubusercontent.com/110596448/202850921-bcd7fdf6-aacd-482b-bbe5-540a2a7599c0.PNG">


### under dashboard, click create new item, and create a pipline job, copy and paste the file "jenkinsfile_apply" into the text box in the pipline configuration and click save

### repete previous step for the file "jenkinsfile_destroy"


# project architecture:


![architecture](https://user-images.githubusercontent.com/110596448/202863359-251f622a-5215-4346-86a1-a44dfb2db264.png)



