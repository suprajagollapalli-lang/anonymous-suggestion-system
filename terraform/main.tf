provider "aws" {
  region = "ap-south-2"
}


data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


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


resource "aws_instance" "django_server" {
  ami           = data.aws_ami.amazon_linux.id   # ✅ AUTO AMI
  instance_type = "t3.micro"

  key_name = "django-key"

  vpc_security_group_ids = [aws_security_group.django_sg.id]

  tags = {
    Name = "Django-App-Server"
  }
}


output "public_ip" {
  value = aws_instance.django_server.public_ip
}
