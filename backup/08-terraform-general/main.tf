variable "aws_key_pair" {
  default = "~/.aws/aws_keys/default-ec2.pem"
}


provider "aws" {
  region = "us-east-1"
}

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
  name   = "elb_sg"
  vpc_id = "vpc-aabcfbd0"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

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
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = "default_ec2"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  # subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]

  for_each = toset(data.aws_subnets.default_subnets.ids)


  # subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]
  subnet_id = each.value

  tags = {
    name : "http_server_${each.key}"
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
# variable "users" {
#   # default = ["ravs", "sats", "ranga", "tom", "jane"]

#   default = {
#     ravs: {
#       country: "Netherlands",
#     }
#     tom: {
#       country: "US"
#     },
#     jane: {
#       country: "India"
#     }
#     # "India"
#   }
# }

# variable "my_iam_user_prefix" {
#   type    = string
#   default = "my_iam_user"
# }

# variable "environment" {
#   default = "dev"
# }

# # plan - execute
# resource "aws_s3_bucket" "my_s3_bucket" {
#   bucket = "my-s3-bucket-coconut-bucket-0809"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }


#   force_destroy       = false
#   object_lock_enabled = false
# }

# resource "aws_iam_user" "my_iam_user" {
#   # count = length(var.names)
#   # name = "${var.environment}_${var.names[count.index]}"
#   # path = "/system/test/"
#   for_each = var.users
#   name = each.key
#   tags = {
#     country: each.value.country
#   }
# }



# STATE
# DESIRED - KNOWN - ACTUAL

