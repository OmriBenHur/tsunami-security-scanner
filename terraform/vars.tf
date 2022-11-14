# provider conf, enter your access key and secret key here
provider "aws" {
  region     = "us-west-2"
  access_key = "ASIATTZPWNMGXPYVAASI"
  secret_key = "KkMmri4A6eECtjHRbR+jVq88SpNKw7Gm8Fu3tgE6"
  token = "FwoGZXIvYXdzEPD//////////wEaDApxWVMmJjn66njT2iLGATzFZ91gZd0FfVOwAnQLHJdbHhu01Kir8HrRXFVEqYBFx2cn0Of0uepuWkWcmB9QkM9Dzs4oTDL5YG/H/PtcL3vHFN1/n8oult5U7qz4olN8s4mGo8NN/DpSeCbTekof62Y6OMiM5u/g5+hixjqrKatPX+pEvEvgCz4ubeYxeMfpq4TSFT6yhERwnmZ0VgJIlt6ZQQfnMGOxvZeeT1ymMth8JPiemKacLXSlLti0Upn5S0c3TcSEP3UDB1wEocrSktfUVCT9WCihrcmbBjIto2XdiLstboGekcL9yhVsTb+Ym5EfMdYG0OCWoilhWTUqWjQR2gtzn8EzEyow"
}

# data obj to return the latest available version of amazon linux AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# vpc CIDR range, this can be configured, subnets are created automatically
# from this CIDR range
variable "vpc_cidr_def" {
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}
# data obj to return a list of available AZ's in the configured region
data "aws_availability_zones" "available_zones" {
  state = "available"
}
#data obj to return assume role policy to be used in the role creation
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
