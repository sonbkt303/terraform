# provider "aws" {
#   region = "us-west-2"
# }


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr
  # azs     = data.aws_availability_zones.available.names
  #  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  azs = ["us-west-2a", "us-west-2b", "us-west-2c"]

  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  # name = "terraform-series"
  # cidr = "10.0.0.0/16"
  # azs  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  # private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  # database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

}

module "alb_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "web_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 80
      security_groups = [module.alb_sg.security_group.id]
    }
  ]
}

module "db_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 5432
      security_groups = [module.web_sg.security_group.id]
    }
  ]
}
