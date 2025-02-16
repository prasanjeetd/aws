output "website_endpoint" {
  value       = aws_s3_bucket.website_bucket.website_endpoint
  description = "URL of the static website hosted on S3"
}

output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The CloudFront domain name (HTTPS enabled) for your static website"
}

output "rds_endpoint" {
  value       = aws_db_instance.employee_db.endpoint
  description = "The endpoint of the RDS instance"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = [aws_subnet.public1.id, aws_subnet.public2.id]
  description = "The IDs of the public subnets"
}
