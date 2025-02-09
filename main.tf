#Creating EC2 instance using data-source

data "aws_ami" "Amazonlnx" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "test" {
  ami                         = data.aws_ami.Amazonlnx.id
  availability_zone           = var.az
  instance_type               = var.ins_type
  key_name                    = var.key
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.myfirstvpc_subnet.id
  user_data                   = file("app.sh")
  vpc_security_group_ids      = [aws_security_group.devops.id]
  tags = {
    Name = "First-EC2"
  }
}


#Creating Elastic ip
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.test.id
  tags = {
    Name = "Elastic-IP_First_EC2"
  }
}


output "myfirstvpc" {
  value = aws_vpc.First_VPC.id
}


output "myip" {
  value = aws_instance.test.public_ip
}



#Provider block

provider "aws" {
  region = var.region

}


resource "aws_security_group" "devops" {
  name        = "my_sec_group"
  description = "Allow http, ssh   inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.First_VPC.id

  tags = {
    Name = "my_sec_group"
  }
}


resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.devops.id
}



resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.devops.id
}

resource "aws_security_group_rule" "https" {

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.devops.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.devops.id
}

#Terraform settings block

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


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

resource "aws_vpc" "First_VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.aws_vpc
  }
}



####Creating a subnet

resource "aws_subnet" "myfirstvpc_subnet" {
  vpc_id                  = aws_vpc.First_VPC.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = true
  #availability_zone = var.vpc_az

  tags = {
    Name = "myfirstvpc_subnet"
  }
}


###Creating a routable

resource "aws_route_table" "firstvpc_rt" {
  vpc_id = aws_vpc.First_VPC.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
}

#Subnet Association

resource "aws_route_table_association" "sub_associatiom" {
  subnet_id      = aws_subnet.myfirstvpc_subnet.id
  route_table_id = aws_route_table.firstvpc_rt.id
}

#Creating an Internet Gateway

resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.First_VPC.id

  tags = {
    Name = "myIgw"
  }
}
