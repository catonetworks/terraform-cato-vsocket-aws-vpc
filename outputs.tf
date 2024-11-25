## The following attributes are exported:
output "internet_gateway_id" { value = aws_internet_gateway.internet_gateway.id }
output "sg_internal" { value = aws_security_group.internal_sg.id }
output "sg_external" { value = aws_security_group.external_sg.id }
output "mgmt_subnet_id" { value = aws_subnet.mgmt_subnet.id }
output "wan_subnet_id" { value = aws_subnet.wan_subnet.id }
output "lan_subnet_id" { value = aws_subnet.lan_subnet.id }
output "mgmt_eni_id" { value = aws_network_interface.mgmteni.id }
output "wan_eni_id" { value = aws_network_interface.waneni.id }
output "lan_eni_id" { value = aws_network_interface.laneni.id }
output "internal_sg" { value = aws_security_group.internal_sg.id }
output "external_sg" { value = aws_security_group.external_sg.id }
output "mgmt_eip_id" { value = aws_eip.mgmteip.id }
output "wan_eip_id" { value = aws_eip.waneip.id }
output "vpc_id" { value = aws_vpc.cato-vpc.id }
output "socket_site_id" { value = module.vsocket-aws.socket_site_id }
output "socket_site_serial" { value = module.vsocket-aws.socket_site_serial }
