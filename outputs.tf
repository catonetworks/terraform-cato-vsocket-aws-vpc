## The following attributes are exported:
output "internet_gateway_id" { value = var.internet_gateway_id == null ? aws_internet_gateway.internet_gateway[0].id : var.internet_gateway_id }
output "vpc_id" { value = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id }
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
output "socket_site_id" { value = module.vsocket-aws.socket_site_id }
output "socket_site_serial" { value = module.vsocket-aws.socket_site_serial }
output "vsocket_instance_id" { value = module.vsocket-aws.vsocket_instance_id }
output "vsocket_instance_public_ip" { value = module.vsocket-aws.vsocket_instance_public_ip }
output "vsocket_instance_ami" { value = module.vsocket-aws.vsocket_instance_ami }
output "cato_site_name" { value = module.vsocket-aws.cato_site_name }
output "native_network_range" { value = module.vsocket-aws.native_network_range }
output "local_ip" { value = module.vsocket-aws.local_ip }
output "cato_license_site" {
  value = var.license_id==null ? null : {
    id           = cato_license.license[0].id
    license_id   = cato_license.license[0].license_id
    license_info = cato_license.license[0].license_info
    site_id      = cato_license.license[0].site_id
  }
}