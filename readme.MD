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
