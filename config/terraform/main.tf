provider "aws" {
  region = "ap-south-2"
}

# ✅ Security Group
resource "aws_security_group" "django_sg" {
  name        = "django-sg"
  description = "Allow SSH, HTTP, Django"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

# ✅ EC2 Instance
resource "aws_instance" "django_server" {
  ami = "ami-0fd0ec892c8d13fc2"
  instance_type = "t2.micro"

  key_name = "django-key"   

  vpc_security_group_ids = [aws_security_group.django_sg.id]

  tags = {
    Name = "Django-App-Server"
  }
}

# ✅ Output IP
output "public_ip" {
  value = aws_instance.django_server.public_ip
}
