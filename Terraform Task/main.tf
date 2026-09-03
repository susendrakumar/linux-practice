provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
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

data "aws_ami" "virginia_amazon_linux" {
  provider    = aws.virginia
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

  tags = {
    Name = "Mumbai-Linux-Server"
  }
}

resource "aws_instance" "virginia_server" {
  provider      = aws.virginia
  ami           = data.aws_ami.virginia_amazon_linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Virginia-Linux-Server"
  }
}
