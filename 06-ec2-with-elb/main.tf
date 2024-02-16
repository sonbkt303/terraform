
provider "aws" {}

// HTTP Server -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_default_vpc" "default" {

}

data "aws_subnets" "default_subnets" {
}

data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  //vpc_id = "vpc-c49ff1be"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_security_group" "elb_sg" {
  name = "elb_sg"
  # vpc_id = "vpc-aabcfbd0" // Remove hard code
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb" {
  name = "elb"
  subnets = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances = values(aws_instance.http_servers).*.id

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

resource "aws_instance" "http_servers" {
  # ami                  = "ami-0277155c3f0ab2930"
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "evn0031_ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  
  # subnet_id            = "subnet-91487fcd"
  for_each =  toset(data.aws_subnets.default_subnets.ids)


  # subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]
  subnet_id = each.value

  tags = {
    name: "http_server_${each.key}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                            // install httpd
      "sudo service httpd start",                                                                             // start
      "echo Say Hello from Mike - Virtual Server is at ${self.public_dns}| sudo tee /var/www/html/index.html" // copy a file

    ]
  }
}