# Lookup data from region and VPC
data "aws_availability_zones" "available" {
  state = "available"
}
