terraform {
  required_providers {
    cato = {
      source  = "catonetworks/cato"
      version = ">= 0.0.30"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.98.00"
    }
  }
  required_version = ">= 1.5"
}
