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
