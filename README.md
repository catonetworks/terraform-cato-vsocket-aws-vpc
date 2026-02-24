# CATO VSOCKET AWS VPC Terraform module

Terraform module which creates a VPC, required subnets, elastic network interfaces, security groups, route tables, an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.

For the vpc_id and internet_gateway_id leave null to create new or add an id of the already created resources to use existing.

<details>
<summary>Example AWS VPC and Internet Gateway Resources</summary>

Create the AWS VPC and Internet Gateway resources using the following example, and create these resources first before running the module:

```hcl
resource "aws_vpc" "cato-vpc" {
  cidr_block = var.vpc_range
  tags = {
    Name = "${var.site_name}-VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "${var.site_name}-IGW"
  }
  vpc_id = aws_vpc.cato-vpc.id
}

terraform apply -target=aws_vpc.cato-vpc -target=aws_internet_gateway.internet_gateway
```

Reference the resources as input variables with the following syntax:
```hcl
  vpc_id           = aws_vpc.cato-vpc.id
  internetGateway  = aws_internet_gateway.internet_gateway.id 
```

</details>

## NOTE
- Site Location for Cato Socket is automatically inferred based on the region being deployed, however this can be overridden if necessary. 
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
// Initialize Providers
provider "aws" {
  region = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.cato_token
  account_id = var.account_id
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "baseurl" {}
variable "token" {}
variable "account_id" {}

// AWS VPC and Virtual Socket Module
module "vsocket-aws-vpc" {
  source                = "catonetworks/vsocket-aws-vpc/cato"
  version               = ">= 0.0.10"
  vpc_id                = null
  internet_gateway_id   = null 
  ingress_cidr_blocks   = ["0.0.0.0/0"]
  key_pair              = "your-keypair-name-here"
  vpc_network_range     = "10.1.0.0/16"
  subnet_range_mgmt     = "10.1.1.0/24"
  subnet_range_wan      = "10.1.2.0/24"
  subnet_range_lan      = "10.1.3.0/24"
  mgmt_eni_ip           = "10.1.1.5"
  wan_eni_ip            = "10.1.2.5"
  lan_eni_ip            = "10.1.3.5"
  site_name             = "Your-Cato-site-name-here"
  region                = var.region
  site_description      = "Your Cato site desc here"
  #site_location derived from region

  routed_networks = {
    "Peered-VNET-1" = {
      subnet = "10.100.1.0/24"
      # interface_index is omitted, so it will default to "LAN1".
    }
    "Management-Subnet" = {
      subnet          = "10.100.2.0/25"
      interface_index = "LAN2" # Overriding the default value.
    }
  }

  #Example Tags 
  tags = {
    Environment = "Production"
    Owner = "Operations Team"
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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.98.00 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | 0.0.57 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.98.00 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | 0.0.57 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vsocket-aws"></a> [vsocket-aws](#module\_vsocket-aws) | catonetworks/vsocket-aws/cato | >= 0.0.17 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.mgmteip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.waneip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.mgmteip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_eip_association.waneip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_network_interface.laneni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.mgmteni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.waneni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.lan_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.wan_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.lanrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.wanrt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.lan_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.mgmt_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.wan_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.external_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.lan_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.mgmt_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.wan_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.cato-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [cato_siteLocation.site_location](https://registry.terraform.io/providers/catonetworks/cato/0.0.57/docs/data-sources/siteLocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_sg_egress"></a> [external\_sg\_egress](#input\_external\_sg\_egress) | Egress rules for external security group | <pre>list(object({<br/>    description      = string<br/>    protocol         = string<br/>    from_port        = number<br/>    to_port          = number<br/>    cidr_blocks      = list(string)<br/>    ipv6_cidr_blocks = list(string)<br/>    prefix_list_ids  = list(string)<br/>    security_groups  = list(string)<br/>    self             = bool<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow HTTPS Outbound",<br/>    "from_port": 443,<br/>    "ipv6_cidr_blocks": [],<br/>    "prefix_list_ids": [],<br/>    "protocol": "tcp",<br/>    "security_groups": [],<br/>    "self": false,<br/>    "to_port": 443<br/>  },<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow DTLS Outbound",<br/>    "from_port": 443,<br/>    "ipv6_cidr_blocks": [],<br/>    "prefix_list_ids": [],<br/>    "protocol": "udp",<br/>    "security_groups": [],<br/>    "self": false,<br/>    "to_port": 443<br/>  },<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow DNS-UDP Outbound",<br/>    "from_port": 53,<br/>    "ipv6_cidr_blocks": [],<br/>    "prefix_list_ids": [],<br/>    "protocol": "udp",<br/>    "security_groups": [],<br/>    "self": false,<br/>    "to_port": 53<br/>  },<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow DNS-TCP Outbound",<br/>    "from_port": 53,<br/>    "ipv6_cidr_blocks": [],<br/>    "prefix_list_ids": [],<br/>    "protocol": "tcp",<br/>    "security_groups": [],<br/>    "self": false,<br/>    "to_port": 53<br/>  }<br/>]</pre> | no |
| <a name="input_external_sg_ingress"></a> [external\_sg\_ingress](#input\_external\_sg\_ingress) | Egress rules for external security group | <pre>list(object({<br/>    description      = string<br/>    protocol         = string<br/>    from_port        = number<br/>    to_port          = number<br/>    cidr_blocks      = list(string)<br/>    ipv6_cidr_blocks = list(string)<br/>    prefix_list_ids  = list(string)<br/>    security_groups  = list(string)<br/>    self             = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | Set CIDR to receive traffic from the specified IPv4 CIDR address ranges<br/>	For example x.x.x.x/32 to allow one specific IP address access, 0.0.0.0/0 to allow all IP addresses access, or another CIDR range<br/>    Best practice is to allow a few IPs as possible<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `list(any)` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the vSocket | `string` | `"c5.xlarge"` | no |
| <a name="input_internal_sg_egress"></a> [internal\_sg\_egress](#input\_internal\_sg\_egress) | Egress rules for internal security group | <pre>list(object({<br/>    description      = string<br/>    protocol         = string<br/>    from_port        = number<br/>    to_port          = number<br/>    cidr_blocks      = list(string)<br/>    ipv6_cidr_blocks = list(string)<br/>    prefix_list_ids  = list(string)<br/>    security_groups  = list(string)<br/>    self             = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_internal_sg_ingress"></a> [internal\_sg\_ingress](#input\_internal\_sg\_ingress) | Ingress rules for internal security group | <pre>list(object({<br/>    description      = string<br/>    protocol         = number<br/>    from_port        = number<br/>    to_port          = number<br/>    cidr_blocks      = list(string)<br/>    ipv6_cidr_blocks = list(string)<br/>    prefix_list_ids  = list(string)<br/>    security_groups  = list(string)<br/>    self             = bool<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow all traffic Outbound",<br/>    "from_port": 0,<br/>    "ipv6_cidr_blocks": [],<br/>    "prefix_list_ids": [],<br/>    "protocol": -1,<br/>    "security_groups": [],<br/>    "self": false,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_internet_gateway_id"></a> [internet\_gateway\_id](#input\_internet\_gateway\_id) | Specify an Internet Gateway ID to use. If not specified, a new Internet Gateway will be created. | `string` | `null` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Name of an existing Key Pair for AWS encryption | `string` | n/a | yes |
| <a name="input_lan_eni_ip"></a> [lan\_eni\_ip](#input\_lan\_eni\_ip) | Choose an IP Address within the LAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_mgmt_eni_ip"></a> [mgmt\_eni\_ip](#input\_mgmt\_eni\_ip) | Choose an IP Address within the Management Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_routed_networks"></a> [routed\_networks](#input\_routed\_networks) | A map of routed networks to be accessed behind the vSocket site.<br/>  The key is the network name. The value is an object with the following attributes:<br/>  - subnet (string, required): The CIDR range of the network.<br/>  - interface\_index (string, optional): The site interface the network is connected to. Defaults to "LAN1". | <pre>map(object({<br/>    subnet          = string<br/>    interface_index = optional(string, "LAN1")<br/>  }))</pre> | `{}` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the vsocket site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the AWS region dynamicaly. | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": null,<br/>  "country_code": null,<br/>  "state_code": null,<br/>  "timezone": null<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the vsocket site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_subnet_range_lan"></a> [subnet\_range\_lan](#input\_subnet\_range\_lan) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_mgmt"></a> [subnet\_range\_mgmt](#input\_subnet\_range\_mgmt) | Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_wan"></a> [subnet\_range\_wan](#input\_subnet\_range\_wan) | Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to AWS resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specify a VPC ID to use. If not specified, a new VPC will be created. | `string` | `null` | no |
| <a name="input_vpc_network_range"></a> [vpc\_network\_range](#input\_vpc\_network\_range) | Choose a unique range for your new vpc where the vSocket will live.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_wan_eni_ip"></a> [wan\_eni\_ip](#input\_wan\_eni\_ip) | Choose an IP Address within the Public/WAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license_site"></a> [cato\_license\_site](#output\_cato\_license\_site) | n/a |
| <a name="output_cato_site_name"></a> [cato\_site\_name](#output\_cato\_site\_name) | n/a |
| <a name="output_external_sg"></a> [external\_sg](#output\_external\_sg) | n/a |
| <a name="output_internal_sg"></a> [internal\_sg](#output\_internal\_sg) | n/a |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | # The following attributes are exported: |
| <a name="output_lan_eni_id"></a> [lan\_eni\_id](#output\_lan\_eni\_id) | n/a |
| <a name="output_lan_subnet_azid"></a> [lan\_subnet\_azid](#output\_lan\_subnet\_azid) | n/a |
| <a name="output_lan_subnet_id"></a> [lan\_subnet\_id](#output\_lan\_subnet\_id) | n/a |
| <a name="output_lan_subnet_route_table_id"></a> [lan\_subnet\_route\_table\_id](#output\_lan\_subnet\_route\_table\_id) | n/a |
| <a name="output_local_ip"></a> [local\_ip](#output\_local\_ip) | n/a |
| <a name="output_mgmt_eip_id"></a> [mgmt\_eip\_id](#output\_mgmt\_eip\_id) | n/a |
| <a name="output_mgmt_eni_id"></a> [mgmt\_eni\_id](#output\_mgmt\_eni\_id) | n/a |
| <a name="output_mgmt_subnet_id"></a> [mgmt\_subnet\_id](#output\_mgmt\_subnet\_id) | n/a |
| <a name="output_native_network_range"></a> [native\_network\_range](#output\_native\_network\_range) | n/a |
| <a name="output_sg_external"></a> [sg\_external](#output\_sg\_external) | n/a |
| <a name="output_sg_internal"></a> [sg\_internal](#output\_sg\_internal) | n/a |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | n/a |
| <a name="output_socket_site_id"></a> [socket\_site\_id](#output\_socket\_site\_id) | n/a |
| <a name="output_socket_site_serial"></a> [socket\_site\_serial](#output\_socket\_site\_serial) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vsocket_instance_ami"></a> [vsocket\_instance\_ami](#output\_vsocket\_instance\_ami) | n/a |
| <a name="output_vsocket_instance_id"></a> [vsocket\_instance\_id](#output\_vsocket\_instance\_id) | n/a |
| <a name="output_vsocket_instance_public_ip"></a> [vsocket\_instance\_public\_ip](#output\_vsocket\_instance\_public\_ip) | n/a |
| <a name="output_wan_eip_id"></a> [wan\_eip\_id](#output\_wan\_eip\_id) | n/a |
| <a name="output_wan_eni_id"></a> [wan\_eni\_id](#output\_wan\_eni\_id) | n/a |
| <a name="output_wan_subnet_id"></a> [wan\_subnet\_id](#output\_wan\_subnet\_id) | n/a |
<!-- END_TF_DOCS -->