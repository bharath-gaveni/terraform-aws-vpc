# Terraform AWS VPC

This module created the following resources
* VPC
* IGW attached to VPC
* 2 public subnets one in us-east-1 and another in us-east-1b Availability Zones
* 2 private subnets one in us-east-1 and another in us-east-1b Availability Zones
* 2 database subnets one in us-east-1 and another in us-east-1b Availability Zones
* 1 public Route table
* 1 private Route table
* 1 database Route table
* 1 public Route (which has IGW access,0.0.0./0) to public Route table
* Elastic IP
* NAT Gateway
* created NAT Gateway in public subnet in us-east-1 Availability Zone
* 1 private Route (which has NAT access,0.0.0./0) to private Route table
* 1 database Route (which has NAT access,0.0.0./0) to database Route table
* Route table association with respective subnets
* VPC peering with default VPC
* created public Route in public Route table of Created VPC to default VPC (default VPC cidr, peering connection)
* created Route in Default Main Route table to created VPC (created VPC cidr, peering connection)

# inputs

* vpc_cidr (required) user must supply the CIDR to VPC
* project_name (required) user must supply the project_name to VPC
* environment (required) user must supply the environment to VPC
* public_subnets_cidrs (required) user must supply the public_subnets_cidrs to VPC
* private_subnets_cidrs (required) user must supply the private_subnets_cidrs to VPC
* database_subnets_cidrs (required) user must supply the database_subnets_cidrs to VPC

# outputs

* vpc_id  - VPC id is created
* public_subnet_ids  - public subnet ids are created
* private  - private subnet ids are created
* database  - database subnet ids are created

