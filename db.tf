resource "random_password" "pg_password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "sonar_pg_db" {
  identifier           = var.database_identifer
  allocated_storage    = 20
  db_name              = var.database_name
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = var.database_username
  password             = random_password.pg_password.result
  skip_final_snapshot  = true
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