variable "aws_key_pair" {
  default = "~/.aws/aws_keys/default-ec2.pem"
}



# resource "aws_default_vpc" "default" {

# }

# data "aws_subnets" "default_subnets" {
# }


# data "aws_ami" "aws-linux-2-latest" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*"]
#   }
# }

# resource "aws_security_group" "http_server_sg" {
#   name = "http_server_sg"
#   //vpc_id = "vpc-c49ff1be"
#   vpc_id = aws_default_vpc.default.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     name = "http_server_sg"
#   }
# }


# resource "aws_security_group" "elb_sg" {
#   name   = "elb_sg"
#   vpc_id = "vpc-aabcfbd0"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # ingress {
#   #   from_port   = 22
#   #   to_port     = 22
#   #   protocol    = "tcp"
#   #   cidr_blocks = ["0.0.0.0/0"]
#   # }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# resource "aws_elb" "elb" {
#   name = "elb"
#   subnets = data.aws_subnets.default_subnets.ids
#   security_groups = [aws_security_group.elb_sg.id]
#   instances = values(aws_instance.http_servers).*.id

#   listener {
#     instance_port = 80
#     instance_protocol = "http"
#     lb_port = 80
#     lb_protocol = "http"
#   }
# }



# resource "aws_instance" "http_servers" {
#   ami                    = "ami-0c101f26f147fa7fd"
#   instance_type          = "t2.micro"
#   key_name               = "default_ec2"
#   vpc_security_group_ids = [aws_security_group.http_server_sg.id]
#   # subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]

#   for_each = toset(data.aws_subnets.default_subnets.ids)


#   # subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]
#   subnet_id = each.value

#   tags = {
#     name : "http_server_${each.key}"
#   }


#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ec2-user"
#     private_key = file(var.aws_key_pair)
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "sudo yum install httpd -y",                                                                            // install httpd
#       "sudo service httpd start",                                                                             // start
#       "echo Say Hello from Mike - Virtual Server is at ${self.public_dns}| sudo tee /var/www/html/index.html" // copy a file
#     ]
#   }
# }

// S3 B


# STATE
# DESIRED - KNOWN - ACTUAL

# terraform {
#   backend "s3" {
#     bucket = "dev-applications-backend-state-1"
#     # key = "${var.application_name}-${var.project_name}-${var.enviroment}"
#     key = "07-backend-state-users-dev"
#     region = "us-east-1"
#     dynamodb_table = "dev_application_locks"
#     encrypt = true
#   }
# }

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "enterprise_backend_state" {
  bucket = "dev-applications-backend-state-1"
  lifecycle {
    prevent_destroy = false
  }
  force_destroy = true

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
}


resource "aws_dynamodb_table" "enterprise_backend_lock" {
  name = "dev_application_locks"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}



