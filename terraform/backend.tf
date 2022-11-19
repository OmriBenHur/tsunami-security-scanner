# s3 bucket to house terraform state file, to allow remote interaction with terraform from multiple sources
# replace the bucket,kms key id and region to the valid values that suit your environment
terraform {
  backend "s3" {
    bucket         = "obhterraformbackend1"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    kms_key_id = "arn:aws:kms:us-west-2:839906679515:key/c92805d9-eab1-455a-8da6-62220c8dba15"
  }
}

# provider conf. enter the region you're operating in
provider "aws" {
  region     = "us-west-2"
}
