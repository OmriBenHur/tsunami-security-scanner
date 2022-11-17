# provider conf, enter your access key and secret key here
provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

variable "email_address" {
  description = "email address for sns subscription"
  default     = ""
}

# vpc CIDR range, this can be configured, subnets are created automatically
# from this CIDR range
variable "vpc_cidr_def" {
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}

variable "key_name" {
  description = "ssh key name for ec2"
  default     = ""
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


# data obj to return a list of available AZ's in the configured region
data "aws_availability_zones" "available_zones" {
  state = "available"
}


