# scanner vpc
resource "aws_vpc" "web_app_vpc" {
  cidr_block           = var.vpc_cidr_def
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "tsunami VPC"
  }
}

# creating internet gateway for the vpc
resource "aws_internet_gateway" "web_app_igw" {
  vpc_id = aws_vpc.web_app_vpc.id
}


# routing traffic to igw from vpc, and public subnets(implicit)
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.web_app_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_app_igw.id
}


# creating 2 public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.web_app_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.web_app_vpc.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}
