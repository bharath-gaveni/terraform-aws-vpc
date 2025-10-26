resource "aws_vpc_peering_connection" "roboshop_default" {
    count = var.is_peering_required ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id#Acceptor
  vpc_id        = aws_vpc.main.id #requestor
  auto_accept   = true

  tags = merge(
    local.common_tags,
    var.vpc_tags,
{
    Name = "${local.common_name}-default"
}
  )

   accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}


resource "aws_route" "public_route_to_defaultVPC" {
   count = var.is_peering_required ? 1 : 0 # if there is no peering then what is use of setting of route to default VPC main route table 
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_default[count.index].id # need to access via list only(count->list)
}

resource "aws_route" "mainroutedefaultVPC_roboshopVPC" {
   count = var.is_peering_required ? 1 : 0 # if there is no peering then what is use of setting of route to default VPC main route table 
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_default[count.index].id
}