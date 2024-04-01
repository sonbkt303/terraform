variable "application_name" {
  default = "07-backend-state"
}

variable "project_name" {
  default = "users"
}

variable "enviroment" {
  default = "dev"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "dev-applications-backend-state-1"
    # key = "${var.application_name}-${var.project_name}-${var.enviroment}"
    key = "07-backend-state-users-dev"
    region = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}

resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user"
}
