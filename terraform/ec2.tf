resource "aws_instance" "tsunami" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t3.medium"
  security_groups      = [aws_security_group.tsunami_sg.id]
  subnet_id            = aws_subnet.public[1].id
  iam_instance_profile = aws_iam_instance_profile.ec2_role_profile.name
  user_data            = file("tsunami_UD.sh")
  key_name             = var.key_name
  depends_on           = [aws_instance.vuln]
  monitoring = "true"
  tags = {
    Name = "tsunami scanner"
  }
}

resource "aws_instance" "vuln" {
  count           = 2
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.vuln_sg.id]
  subnet_id       = aws_subnet.public[0].id
  user_data       = file("jup_UD.sh")
  key_name        = var.key_name

  tags = {
    Name = "jupyter notebook"
  }
}