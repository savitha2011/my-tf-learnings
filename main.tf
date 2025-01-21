resource "aws_instance" "web1" {
  ami                  = var.amiID
  instance_type        = var.instancesize
  iam_instance_profile = aws_iam_role.test_role.arn

  # Add tags
  tags = {
    Name = "MyEC2Instance"
  }
}

# step 1create Iam role to access s3 
resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
