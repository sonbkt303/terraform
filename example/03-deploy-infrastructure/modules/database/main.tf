resource "random_password" "password" {
  length           = 16
  special          = false
  override_special = "_%@"
}

resource "aws_db_instance" "database" {
  allocated_storage      = 5
  engine                 = "postgres"
#   engine_version         = "14.1"
  instance_class         = "db.t3.micro"
  identifier             = "${var.project}-db-instance"
  db_name                = "series"
  username               = "series"
  password               = random_password.password.result
  db_subnet_group_name   = var.vpc.database_subnet_group
  vpc_security_group_ids = [var.sg.db]
  skip_final_snapshot    = true

  
}