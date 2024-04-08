locals {
  tags = {
    project = var.project
  }
}

# terraform {
#   backend "s3" {
#     bucket         = "terraform-series-s3-backend"
#     key            = "test-project"
#     region         = "us-west-2"
#     encrypt        = true
#     role_arn       = "arn:aws:iam::428208402376:role/HpiS3BackendRole"
#     dynamodb_table = "terraform-series-s3-backend"
#   }
# }

provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project}-s3-backend"

  resource_query {
    query = <<-JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "project",
            "Values": ["${var.project}"]
          }
        ]
      }
    JSON
  }
}

output "config" {
  value = {
    bucket         = aws_s3_bucket.s3_bucket.bucket
    region         = data.aws_region.current.name
    role_arn       = aws_iam_role.iam_role.arn
    dynamodb_table = aws_dynamodb_table.dynamodb_table.name
  }
}