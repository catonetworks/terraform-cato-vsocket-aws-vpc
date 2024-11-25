# CATO VSOCKET AWS VPC Terraform module

Terraform module which creates a VPC, required subnets, elastic network interfaces, security groups, route tables, an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.

List of resources:
- aws_vpc
- aws_eip_association (mgmteip_assoc)
- aws_eip_association (waneip_assoc)
- aws_eip (mgmteip)
- aws_eip (waneip)
- aws_internet_gateway_attachment
- aws_internet_gateway
- aws_network_interface (laneni)
- aws_network_interface (mgmteni)
- aws_network_interface (waneni)
- aws_route_table_association (lan_subnet_route_table_association)
- aws_route_table_association (mgmt_subnet_route_table_association)
- aws_route_table_association (wan_subnet_route_table_association)
- aws_route_table (lanrt)
- aws_route_table (mgmtrt)
- aws_route_table (wanrt)
- aws_route (lan_route)
- aws_route (mgmt_route)
- aws_route (wan_route)
- aws_security_group (external_sg)
- aws_security_group (internal_sg)
- aws_subnet (lan_subnet)
- aws_subnet (mgmt_subnet)
- aws_subnet (wan_subnet)

## Usage

```hcl
module "vsocket-aws-vpc" {
  source                = "catonetworks/vsocket-aws-vpc/cato"
  token                 = "xxxxxxx"
  account_id            = "xxxxxxx"
  ingress_cidr_blocks   = ["0.0.0.0/0"]
  key_pair              = "your-keypair-name-here"
  vpc_range             = "10.1.0.0/16"
  subnet_range_mgmt     = "10.1.1.0/24"
  subnet_range_wan      = "10.1.2.0/24"
  subnet_range_lan      = "10.1.3.0/24"
  mgmt_eni_ip           = "10.1.1.5"
  wan_eni_ip            = "10.1.2.5"
  lan_eni_ip            = "10.1.3.5"
  site_name             = "Your-Cato-site-name-here"
  region                = "us-west-2"
  site_description      = "Your Cato site desc here"
  site_location = {
    city         = "San Diego"
    country_code = "US"
    state_code   = "US-CA" ## Optional - for countries with states
    timezone     = "America/Los_Angeles"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/tree/master/LICENSE) for full details.

