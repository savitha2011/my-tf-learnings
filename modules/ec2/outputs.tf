
# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "aws_security_group_id" {
  value = aws_security_group.web_sg.id
}
