#VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
    
  tags = merge(
    local.common_tags,
    var.vpc_tags,
{
    Name = local.common_name
}
  )
}

#IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.ig_tags,
{
    Name = local.common_name
}
  )
}

#Public-subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidrs[count.index]
  availability_zone = local.az_name[count.index] 
  map_public_ip_on_launch = true #Assign Public_iPs to all instances in this subnets because this has to become public subnet right..

  tags = merge(
    local.common_tags,
    var.public_subnet_tags,
{
    Name = "${local.common_name}-public-${local.az_name[count.index]}"
}
  )
}


#Private-subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_cidrs[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
    local.common_tags,
    var.private_subnet_tags,
{
    Name = "${local.common_name}-private-${local.az_name[count.index]}"
}
  )
}


#database-subnets
resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnets_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnets_cidrs[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
    local.common_tags,
    var.database_subnet_tags,
{
    Name = "${local.common_name}-database-${local.az_name[count.index]}"
}
  )
}

#Public_route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.public_route_table_tags,
{
    Name = "${local.common_name}-public"
}
  )
}


#Private_route_table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.private_route_table_tags,
{
    Name = "${local.common_name}-private"
}
  )
}

#database_route_table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.database_route_table_tags,
{
    Name = "${local.common_name}-database"
}
  )
}

#Public route will be added to public route table
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

#elastic ip used in NAT Gateway which is placed in public_subnet and public_subnet has public_route_table which has route with internet and IG access
resource "aws_eip" "EIP_NAT" {
  domain   = "vpc"
 tags = merge(
    local.common_tags,
    var.nat_eip_tags,
{
    Name = "${local.common_name}-nat_eip"
}
  )
}

#NAT Gateway which is placed in public_subnet and public_subnet has public_route_table which has route with internet and IG access
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.EIP_NAT.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    local.common_tags,
    var.nat_tags,
{
    Name = "${local.common_name}-nat"
}
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}


#Private route will be added to private route table (private egress through NAT)
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


#database route will be added to database route table (database egress through NAT)
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

#public_route_table association with public_subnet_ids
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

#private_route_table association with private_subnet_ids
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

#database_route_table association with database_subnet_ids
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets_cidrs)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}