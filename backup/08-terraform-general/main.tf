provider "aws" {
  region = "us-east-1"
}


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
  ami = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name = "evn0031_ec2"
  vpc_security_group_ids=[aws_security_group.http_server_sg.id]
  subnet_id = "subnet-893203a7"
  
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

