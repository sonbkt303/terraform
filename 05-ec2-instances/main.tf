variable "aws_key_pair" {
  default = "~/.ssh/aws/aws_keys/evn0031_ec2.pem"
}

provider "aws" {}

// HTTP Server -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = "vpc-aabcfbd0"

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

resource "aws_instance" "http_server" {
  ami                    = "ami-0277155c3f0ab2930"
  key_name               = "evn0031_ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-91487fcd"

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