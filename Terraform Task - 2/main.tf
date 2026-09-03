provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_security_group" "mumbai_sg" {
  provider = aws.mumbai
  name     = "nginx-mumbai-sg"

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

resource "aws_security_group" "virginia_sg" {
  provider = aws.virginia
  name     = "nginx-virginia-sg"

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

data "aws_ami" "mumbai_amazon_linux" {
  provider    = aws.mumbai
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "mumbai_server" {
  provider      = aws.mumbai
  ami           = data.aws_ami.mumbai_amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.mumbai_sg.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = {
    Name = "Mumbai-Nginx-Server"
  }
}

data "aws_ami" "virginia_amazon_linux" {
  provider    = aws.virginia
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "virginia_server" {
  provider      = aws.virginia
  ami           = data.aws_ami.virginia_amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.virginia_sg.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF

  tags = {
    Name = "Virginia-Nginx-Server"
  }
}
