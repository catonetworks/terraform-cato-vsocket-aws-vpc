variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "baseurl" {
  description = "Cato API base URL"
  type        = string
}

variable "cato_token" {
  description = "Cato API key for a service account with permissions to edit sites"
  type        = string
  sensitive   = true
}

variable "account_id" {
  description = "Cato account ID"
  type        = string
}

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.98.00"
    }
    cato = {
      source  = "catonetworks/cato"
      version = ">= 0.0.73"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.cato_token
  account_id = var.account_id
}

module "vsocket-aws-vpc" {
  source  = "catonetworks/vsocket-aws-vpc/cato"
  version = ">= 0.0.10"

  # Leave both null to create a new VPC and Internet Gateway.
  # If you provide internet_gateway_id, you must also provide vpc_id.
  vpc_id              = null
  internet_gateway_id = null

  ingress_cidr_blocks = ["0.0.0.0/0"]
  instance_type       = "c5.xlarge"
  key_pair            = "CatoKeyPair"

  vpc_network_range = "10.1.0.0/16"
  subnet_range_mgmt = "10.1.1.0/24"
  subnet_range_wan  = "10.1.2.0/24"
  subnet_range_lan  = "10.1.3.0/24"
  mgmt_eni_ip       = "10.1.1.5"
  wan_eni_ip        = "10.1.2.5"
  lan_eni_ip        = "10.1.3.5"

  site_name        = "AWS_Violet"
  site_description = "AWS Lab"
  region           = var.region
  # site_location is derived from region unless explicitly provided.

  # Optional routed networks for additional subnets behind the vSocket site.
  # routed_networks = {
  #   "Peered-VPC-1" = {
  #     subnet = "10.100.1.0/24"
  #     # interface_index is omitted, so it defaults to "LAN1".
  #   }
  #   "Management-Subnet" = {
  #     subnet          = "10.100.2.0/25"
  #     interface_index = "LAN2"
  #   }
  # }

  tags = {
    Environment = "Production"
    Owner       = "Operations Team"
  }
}
