# AWS Infrastructure & Employee API Project

This repository contains a multi-tier application setup that includes:

- **AWS Infrastructure Provisioning:**  
  Provisioned with Terraform (and supported by AWS CLI) to deploy:
  - A VPC (with public subnets, Internet Gateway, and Route Tables)
  - An S3 bucket with remote Terraform state management and CloudFront distribution
  - An RDS MySQL database with an "employee" table
  - The Terraform state is stored remotely in an S3 bucket (with DynamoDB for state locking)

- **Backend:**  
  A Node.js REST API built with Express and documented with Swagger.  
  It provides endpoints to get and post employee data.

- **Frontend:**  
  A simple HTML/CSS/JavaScript application that includes a form to add employees and a list view that interacts with the backend REST API.


