output "myfirstvpc" {
value = aws_vpc.First_VPC.id
}


output "myip" {
value = aws_instance.test.public_ip
}


