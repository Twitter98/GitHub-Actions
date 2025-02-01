
#Variable for the VPC cidr

variable "cidr_block" {
  type    = string
  default = "192.168.0.0/16"

}

#Variable for VPC tags
variable "aws_vpc" {
  type    = string
  default = "First-VPC_V2.0.0"

}

#Variable for EC2

variable "ins_type" {
  type    = string
  default = "t2.micro"

}

variable "az" {
  type    = string
  default = "eu-west-1b"

}

variable "key" {
  type    = string
  default = "tesla1a"

}

#Variables for provider block

variable "region" {
  type    = string
  default = "eu-west-1"
}