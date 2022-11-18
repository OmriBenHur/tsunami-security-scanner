terraform {
  backend "s3" {
    bucket         = "obhterraformbackend1"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    kms_key_id = "arn:aws:kms:us-west-2:839906679515:key/c92805d9-eab1-455a-8da6-62220c8dba15"
  }
}

# provider conf, enter your access key and secret key here
provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}
