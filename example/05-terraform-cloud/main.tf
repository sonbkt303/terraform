terraform {
  cloud {
    organization = "terraform_beginer"

    workspaces {
      name = "learn-terraform-init"
    }
  }
}

provider "aws" {
 region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  tags = {
    Name = "HelloWorld"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}