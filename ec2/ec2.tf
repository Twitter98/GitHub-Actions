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
