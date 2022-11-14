resource "aws_security_group" "tsunami_sg" {
  name        = "tsunami_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description     = "Allow HTTP Traffic"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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

resource "aws_security_group" "vuln_sg" {
  name        = "vulnerability_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description     = "Allow jupyter Traffic"
    from_port       = 8888
    to_port         = 8888
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow ssh Traffic"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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


# iam role for ec2 to allow the secrets manager : get secret value operation
# this is required for the web app container to function
resource "aws_iam_role" "describe_instances_role" {
  name               = "ec2_describe"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
}

# creating iam instance profile from iam role to use in the launch template
# to be used with ASG. (regular roles cannot attach to launch templates or instances)
resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "ec2_secrets_manager"
  role = aws_iam_role.describe_instances_role.name
}