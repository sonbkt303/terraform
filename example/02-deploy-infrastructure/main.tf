locals {
  project_name = "terraform-series"
}

provider "aws" {
  region = "us-west-2"
}

module "nerworking" {
  source = "./modules/networking"
}
