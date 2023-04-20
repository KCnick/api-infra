variable "aws_access_key"{
    type=string
    description="AWS access key"
   default =""
}

variable "aws_secret_key"{
    type=string
    description="AWS secret key"
    default =""
}

variable "aws_region"{
    type=string
    description="Region for AWS resources"
    default = "us-east-1"
}

variable "company"{
    type = string
    default = "rgs"
}

variable "project"{
    type = string
    default = "rgs-api"
}

variable "billing_code" {
  type= string
  default= "RSG-IT"
}

variable "vpc_cidr_block" {
  type = string
  default="10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type=bool
  default=true
}

variable "vpc_subnet1_cidr_block" {
  type = string
  default="10.0.0.0/24"
}

variable "map_public_ip_on_launch"{
    type = bool
    default = true
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}