output "vpcID" {
  value = aws_vpc.main_vpc.id
}

output "subnetID" {
  value = aws_subnet.public_subnet.id
}

output "subnetID2" {
  value = aws_subnet.public_subnet2.id
}