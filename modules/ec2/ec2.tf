# Create a Security Group allows port 80 HTTP
resource "aws_security_group" "web_sg" {
  vpc_id = var.vpcid
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WebSG"
  }
}
#Create security group with SSH group with port 20
resource "aws_security_group" "web_sg1" {
  vpc_id = var.vpcid
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WebSG1"
  }
}

# Create an EC2 Instance in Public Subnet
resource "aws_instance" "web_server" {
  ami                    = var.amiID
  instance_type          = "t2.micro"
  subnet_id              = var.subnetid
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World from $(hostname -f)" > /var/www/html/index.html
              EOF
}