locals {
  common_tags={
    Project = var.project_name
    Environment = var.environment
    Terraform = "true"
  }
  common_name = "${var.project_name}-${var.environment}" #roboshop-dev
  az_name = slice(data.aws_availability_zones.available.names,0,2) #us-east-1a,us-east-1b
}