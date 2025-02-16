variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for the static website"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# For two public subnets in different AZs:
variable "public_subnet_cidr1" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az1" {
  description = "Availability Zone for the first public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Availability Zone for the second public subnet"
  type        = string
  default     = "us-east-1b"
}

variable "db_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "employee-db"
}

variable "db_engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_publicly_accessible" {
  description = "Should the RDS instance be publicly accessible?"
  type        = bool
  default     = true
}
