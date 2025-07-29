resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project_name}-rds-sg"
  description = "Security group for RDS instance"

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
  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres_db" {
  identifier = "${var.project_name}-postgres-db"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  engine = "postgres"
  engine_version = "14"
  db_name = "demo"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
  publicly_accessible = false
  multi_az = false
  tags = {
    Name = "${var.project_name}-postgres-db"
  }
}