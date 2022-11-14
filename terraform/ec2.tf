resource "aws_instance" "tsunami" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.medium"
  security_groups = [aws_security_group.tsunami_sg.id]
  subnet_id = aws_subnet.public.id
  user_data = file("tsunami_UD.sh")
  tags {
    Name = "tsunami scanner"
  }
}

resource "aws_instance" "vuln" {
  count = 2
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.tsunami_sg.id]
  subnet_id = [for subnet in aws_subnet.public : subnet.id]
  user_data = file("jup_UD.sh")
  tags {
    Name = "jupyter notebook"
  }
}