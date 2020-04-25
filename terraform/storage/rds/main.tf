resource "aws_db_instance" "aws_db_instance" {
  identifier              = "rdscloudedinsight"
  allocated_storage       = 20
  max_allocated_storage   = 40
  storage_type            = "gp2"
  engine                  = var.rds_engine_type
  engine_version          = var.rds_engine_version
  instance_class          = "db.t2.micro"
  name                    = "wordpress"
  username                = var.username
  password                = var.password
  vpc_security_group_ids  = [var.rds_security_group]
  db_subnet_group_name    = aws_db_subnet_group.aws_db_subnet_group.name
  publicly_accessible     = false
  port                    = "3306"
  monitoring_interval     = 0
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = "main"
  subnet_ids = var.rds_subnet_group_ids

  tags = {
    Name = "My DB subnet group"
  }
}
