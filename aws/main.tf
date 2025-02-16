provider "aws" {
  region = var.aws_region
}

#############################
# S3 and CloudFront Section
#############################

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

locals {
  website_files = fileset("../frontend/public", "**/*")
}

resource "aws_s3_bucket_object" "website_objects" {
  for_each = { for file in local.website_files : file => file }
  
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = "../frontend/public/${each.value}"
  etag   = filemd5("../frontend/public/${each.value}")
  
  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg",
    jpeg = "image/jpeg",
    svg  = "image/svg+xml",
    ico  = "image/x-icon"
  },
    length(split(".", each.value)) > 1 ?
      lower(element(split(".", each.value), length(split(".", each.value)) - 1))
    : "",
    "application/octet-stream"
  )
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.website_endpoint
    origin_id   = "S3WebsiteOrigin"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 80
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    target_origin_id       = "S3WebsiteOrigin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    
    forwarded_values {
      query_string = false
      
      cookies {
        forward = "none"
      }
    }
  }
  
  price_class = "PriceClass_100"
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  tags = {
    Environment = "production"
  }
}

#############################
# VPC and RDS Section
#############################

# Create a new VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "main_vpc"
  }
}

# Attach an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main_igw"
  }
}

# Create two public subnets in different AZs
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_2"
  }
}

# Create a public route table and associate it with both subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public1_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Create a security group for RDS (allowing MySQL access)
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

# Create a DB Subnet Group using both public subnets (to meet the AZ requirement)
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

# Create the RDS MySQL instance
resource "aws_db_instance" "employee_db" {
  identifier             = var.db_instance_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = var.db_publicly_accessible
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  skip_final_snapshot    = true

  tags = {
    Name = var.db_instance_identifier
  }
}
