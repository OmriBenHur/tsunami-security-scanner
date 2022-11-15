# provider conf, enter your access key and secret key here
provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
  token = ""
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
