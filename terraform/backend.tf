# s3 bucket to house terraform state file, to allow remote interaction with terraform from multiple sources
# replace the bucket,kms key id and region to the valid values that suit your environment
terraform {
  backend "s3" {
    bucket         = "<your created bucket name>"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    kms_key_id = "<kms key arn attached to the s3 bucket>"
  }
}

# provider conf. enter the region you're operating in
provider "aws" {
  region     = "us-west-2"
}
