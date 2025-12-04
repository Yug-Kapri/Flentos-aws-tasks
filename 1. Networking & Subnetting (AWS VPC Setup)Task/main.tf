provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "yug_kapri_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "yug-kapri_vpc" }
}

resource "aws_subnet" "yug_kapri_public1" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "yug-kapri_public_1" }
}

resource "aws_subnet" "yug_kapri_public2" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = { Name = "yug-kapri_public_2" }
}

resource "aws_subnet" "yug_kapri_private1" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  tags = { Name = "yug-kapri_private_1" }
}

resource "aws_subnet" "yug_kapri_private2" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = { Name = "yug-kapri_private_2" }
}

resource "aws_internet_gateway" "yug_kapri_igw" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  tags = { Name = "yug-kapri_igw" }
}

resource "aws_eip" "yug_kapri_nat_eip" {
  domain = "vpc"
  tags = { Name = "yug-kapri_nat_eip" }
}

resource "aws_nat_gateway" "yug_kapri_nat" {
  allocation_id = aws_eip.yug_kapri_nat_eip.id
  subnet_id = aws_subnet.yug_kapri_public1.id
  tags = { Name = "yug-kapri_nat_gw" }
}

resource "aws_route_table" "yug_kapri_public_rt" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yug_kapri_igw.id
  }
  tags = { Name = "yug-kapri_public_rt" }
}

resource "aws_route_table_association" "yug_kapri_pub1_assoc" {
  subnet_id = aws_subnet.yug_kapri_public1.id
  route_table_id = aws_route_table.yug_kapri_public_rt.id
}

resource "aws_route_table_association" "yug_kapri_pub2_assoc" {
  subnet_id = aws_subnet.yug_kapri_public2.id
  route_table_id = aws_route_table.yug_kapri_public_rt.id
}

resource "aws_route_table" "yug_kapri_private_rt" {
  vpc_id = aws_vpc.yug_kapri_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.yug_kapri_nat.id
  }
  tags = { Name = "yug-kapri_private_rt" }
}

resource "aws_route_table_association" "yug_kapri_priv1_assoc" {
  subnet_id = aws_subnet.yug_kapri_private1.id
  route_table_id = aws_route_table.yug_kapri_private_rt.id
}

resource "aws_route_table_association" "yug_kapri_priv2_assoc" {
  subnet_id = aws_subnet.yug_kapri_private2.id
  route_table_id = aws_route_table.yug_kapri_private_rt.id
}
