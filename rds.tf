
# --------------------------------- Private Subnet Group for RDS ---------------------------------

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rodrigopatelli-db-subnet-group"  // Unique name for the DB subnet group
  subnet_ids = module.vpc.private_subnets  // List of subnet IDs to include in the DB subnet group

  tags = {
    Name = "rodrigopatelli-db-subnet-group"  // Tags to assign to the DB subnet group for identification
  }
}

# --------------------------------- RDS Instance ---------------------------------

resource "aws_db_instance" "rds_instance" {
  identifier              = "rodrigopatelli-rds-instance"  // Unique identifier for the RDS instance
  db_name                 = var.db_name  // Name of the database
  allocated_storage       = 25  // Amount of storage allocated for the RDS instance in GB
  storage_type            = "gp2"  // Type of storage used for the RDS instance
  engine                  = "mysql"  // Database engine used (in this case, MySQL)
  engine_version          = "8.0.33"  // Version of the database engine
  instance_class          = "db.t2.micro"  // Instance type for the RDS instance
  username                = var.db_username  // Username for accessing the database
  password                = var.db_password  // Password for accessing the database
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name  // Name of the DB subnet group to associate with the RDS instance
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]  // List of security group IDs to associate with the RDS instance
  backup_retention_period = 7  // Number of days to retain automated backups
  backup_window           = "03:00-04:00"  // Time window for automated backups
  maintenance_window      = "Mon:00:00-Mon:03:00"  // Time window for maintenance operations
  multi_az                = true  // Enable multi-AZ deployment for high availability
  publicly_accessible     = false  // Set to false to restrict public access to the RDS instance
  skip_final_snapshot     = true  // Skip taking a final snapshot when deleting the RDS instance

  tags = {
    Name = "rodrigopatelli-rds-instance"  // Tags to assign to the RDS instance for identification
  }
}
