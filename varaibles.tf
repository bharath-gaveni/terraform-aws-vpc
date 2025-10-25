variable "vpc_cidr" {
    type = string
}

variable "project_name" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "ig_tags" {
    type = map
    default = {}
}

variable "public_subnets_cidrs" {
    type = list
}

variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnets_cidrs" {
    type = list
}

variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnets_cidrs" {
    type = list
}

variable "database_subnet_tags" {
    type = map
    default = {}
}

variable "public_route_table_tags" {
    type = map
    default = {}
}

variable "private_route_table_tags" {
    type = map
    default = {}
}

variable "database_route_table_tags" {
    type = map
    default = {}
}

variable "nat_eip_tags" {
    type = map
    default = {}
}

variable "nat_tags" {
    type = map
    default = {}
}