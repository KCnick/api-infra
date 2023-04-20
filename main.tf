provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

data "aws_ssm_parameter" "ami"{
    name= "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet1" {
  cidr_block = var.vpc_subnet1_cidr_block
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_route_table" "rtb"{
    vpc_id = aws_vpc.vpc.id
    route  {
        cidr_block ="0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id =  aws_route_table.rtb.id 
}

resource "aws_security_group" "rsg_sg"{
    name = "rsg_sg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags=local.common_tags
}

resource "aws_instance" "rsg-api" {
  ami = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.rsg_sg.id]

  user_data = <<EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y dotnet-sdk-7.0
  sudo apt-get install -y aspnetcore-runtime-7.0
  EOF
  tags = local.common_tags
}