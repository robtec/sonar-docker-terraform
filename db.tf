resource "aws_db_instance" "sonar_pg_db" {
  identifier           = "sonar-db" 
  allocated_storage    = 10
  db_name              = "sonar"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = "sonar"
  password             = random_password.pg_password.result
  parameter_group_name = aws_db_parameter_group.sonar.name
  skip_final_snapshot  = true
}

resource "aws_db_parameter_group" "sonar" {
  name   = "sonar"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "random_password" "pg_password" {
  length  = 32
  special = false
}

resource "aws_security_group" "public_pg_sg" {
  name = "Public PostgreSQL"
  description = "Allow PostgreSQL traffic"

  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}