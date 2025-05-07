resource "aws_vpc" "cato-vpc" {
  count      = var.vpc_id == null ? 1 : 0
  cidr_block = var.native_network_range
  tags = merge(var.tags, {
    Name = "${var.site_name}-VPC"
  })
}

# Lookup data from region and VPC
data "aws_availability_zones" "available" {
  state = "available"
}

# Internet Gateway and Attachment
resource "aws_internet_gateway" "internet_gateway" {
  count = var.internet_gateway_id == null ? 1 : 0
  tags = {
    Name = "${var.site_name}-IGW"
  }
  vpc_id = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
}

# Subnets
resource "aws_subnet" "mgmt_subnet" {
  vpc_id            = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  cidr_block        = var.subnet_range_mgmt
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.tags, {
    Name = "${var.site_name}-MGMT-Subnet"
  })
}

resource "aws_subnet" "wan_subnet" {
  vpc_id            = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  cidr_block        = var.subnet_range_wan
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.tags, {
    Name = "${var.site_name}-WAN-Subnet"
  })
}

resource "aws_subnet" "lan_subnet" {
  vpc_id            = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  cidr_block        = var.subnet_range_lan
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.tags, {
    Name = "${var.site_name}-LAN-Subnet"
  })
}

# Internal and External Security Groups
resource "aws_security_group" "internal_sg" {
  name        = "${var.site_name}-Internal-SG"
  description = "CATO LAN Security Group - Allow all traffic Inbound"
  vpc_id      = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  ingress = [
    {
      description      = "Allow all traffic Inbound from Ingress CIDR Blocks"
      protocol         = -1
      from_port        = 0
      to_port          = 0
      cidr_blocks      = var.ingress_cidr_blocks
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "Allow all traffic Outbound"
      protocol         = -1
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = merge(var.tags, {
    name = "${var.site_name}-Internal-SG"
  })
}

resource "aws_security_group" "external_sg" {
  name        = "${var.site_name}-External-SG"
  description = "CATO WAN Security Group - Allow HTTPS In"
  vpc_id      = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  ingress = [
    {
      description      = "Allow HTTPS In"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = var.ingress_cidr_blocks
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow SSH In"
      protocol         = "tcp"
      from_port        = 22
      to_port          = 22
      cidr_blocks      = var.ingress_cidr_blocks
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "Allow all traffic Outbound"
      protocol         = -1
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = merge(var.tags, {
    name = "${var.site_name}-External-SG"
  })
}

# vSocket Network Interfaces
resource "aws_network_interface" "mgmteni" {
  source_dest_check = "true"
  subnet_id         = aws_subnet.mgmt_subnet.id
  private_ips       = [var.mgmt_eni_ip]
  security_groups   = [aws_security_group.external_sg.id]
  tags = merge(var.tags, {
    Name = "${var.site_name}-MGMT-INT"
  })
}

resource "aws_network_interface" "waneni" {
  source_dest_check = "true"
  subnet_id         = aws_subnet.wan_subnet.id
  private_ips       = [var.wan_eni_ip]
  security_groups   = [aws_security_group.external_sg.id]
  tags = merge(var.tags, {
    Name = "${var.site_name}-WAN-INT"
  })
}

resource "aws_network_interface" "laneni" {
  source_dest_check = "false"
  subnet_id         = aws_subnet.lan_subnet.id
  private_ips       = [var.lan_eni_ip]
  security_groups   = [aws_security_group.internal_sg.id]
  tags = merge(var.tags, {
    Name = "${var.site_name}-LAN-INT"
  })
}

# Elastic IP Addresses
resource "aws_eip" "waneip" {
  tags = merge(var.tags, {
    Name = "${var.site_name}-WAN-EIP"
  })
}

resource "aws_eip" "mgmteip" {
  tags = merge(var.tags, {
    Name = "${var.site_name}-MGMT-EIP"
  })
}

# Elastic IP Addresses Association - Required to properly destroy 
resource "aws_eip_association" "waneip_assoc" {
  network_interface_id = aws_network_interface.waneni.id
  allocation_id        = aws_eip.waneip.id
}

resource "aws_eip_association" "mgmteip_assoc" {
  network_interface_id = aws_network_interface.mgmteni.id
  allocation_id        = aws_eip.mgmteip.id
}

# Routing Tables
resource "aws_route_table" "wanrt" {
  vpc_id = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.site_name}-WAN-RT"
  })
}

resource "aws_route_table" "mgmtrt" {
  vpc_id = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.site_name}-MGMT-RT"
  })
}

resource "aws_route_table" "lanrt" {
  vpc_id = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.site_name}-LAN-RT"
  })
}

# Routes
resource "aws_route" "wan_route" {
  route_table_id         = aws_route_table.wanrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id == null ? aws_internet_gateway.internet_gateway[0].id : var.internet_gateway_id
}

resource "aws_route" "mgmt_route" {
  route_table_id         = aws_route_table.mgmtrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id == null ? aws_internet_gateway.internet_gateway[0].id : var.internet_gateway_id
}

resource "aws_route" "lan_route" {
  route_table_id         = aws_route_table.lanrt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.laneni.id
}

# Route Table Associations
resource "aws_route_table_association" "mgmt_subnet_route_table_association" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.mgmtrt.id
}

resource "aws_route_table_association" "wan_subnet_route_table_association" {
  subnet_id      = aws_subnet.wan_subnet.id
  route_table_id = aws_route_table.wanrt.id
}

resource "aws_route_table_association" "lan_subnet_route_table_association" {
  subnet_id      = aws_subnet.lan_subnet.id
  route_table_id = aws_route_table.lanrt.id
}

module "vsocket-aws" {
  source               = "catonetworks/vsocket-aws/cato"
  vpc_id               = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  key_pair             = var.key_pair
  native_network_range = var.native_network_range
  site_name            = var.site_name
  site_description     = var.site_description
  site_type            = var.site_type
  mgmt_eni_id          = aws_network_interface.mgmteni.id
  wan_eni_id           = aws_network_interface.waneni.id
  lan_eni_id           = aws_network_interface.laneni.id
  lan_local_ip         = var.lan_eni_ip
  site_location        = var.site_location
  tags                 = var.tags
}