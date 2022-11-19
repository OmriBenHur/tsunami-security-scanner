# tsunami scanner instance, type t3.med is required.
# you can remove "depends on" it's for demonstration purposes only. to allow time for the jupyter notebook instances to boot
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

# vulnerable jupyter notebook instances to be scanned and reported via the scanner
# this is for demonstration purposes only, it can be removed if you already have something to scan.

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