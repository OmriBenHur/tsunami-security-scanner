# tsunami scanner instance security group, allows ssh from everywhere. change the cidr block to your public ip to allow a more secure debugging env

resource "aws_security_group" "tsunami_sg" {
  name        = "tsunami_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description = "Allow HTTP Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    role = "Allow ssh Traffic"
  }
}

# jupyter notebook security group allows traffic to the instance from everywhere on port 8888 (jupyter container's default port) and port 22 for debugging
resource "aws_security_group" "vuln_sg" {
  name        = "vulnerability_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description = "Allow jupyter Traffic"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ssh Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    role = "Allow jupyter Traffic"
  }
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

# iam role for ec2 to allow upload of joined report to s3 bucket, and scanning for ec2 public ip addresses to scan
# this is required for the scanner container to function
resource "aws_iam_role" "ec2-s3" {
  name               = "ec2_s3"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  inline_policy {
    name = "ec2_s3-upload"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "ec2:DescribeInstances"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}

# creating iam instance profile from iam role to use in the creation of the scanner instance
resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "ec2_s3-upload"
  role = aws_iam_role.ec2-s3.name
}
