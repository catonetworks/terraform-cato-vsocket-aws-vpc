# Changelog

## 0.0.1 (2024-11-07)

### Features
- Initial commit with single socket instance with 3 NICs, creating full vpc

## 0.0.2 (2024-11-25)

### Features
- Adding socket_site_serial and socket_site_id to module outputs.

## 0.0.4 (2025-04-24)

### Features
- Extracting provider from module to be passed in


## 0.0.5 (2025-05-07)

### Features
- Made vpc and internet gateway resource optional

## 0.0.6 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.0.7 (2025-05-08)

### Features
- Adjusted Readme Example to Match Variable Name (vpc_range becomes native_network_range)
- Disassociated native_network_range from vpc_cidr_range to enable VPC_CIDR to be different from Native_network_range

## 0.0.8 (2025-05-09)

### Features
- Adjusted Outputs to accomodate license resource added in ver 0.0.6
- Added output for Socket Lan Route Table (lan_subnet_route_table_id) for use in upstream calls
- Removed Management Route Table - No Longer Needed 
- Updated Cato vSocket WAN Security Group to Remove Inbound Rules 
- Updated Cato vSocket WAN Security Group to Add Outbound Rules (udp/443, tcp/443, udp/53, tcp/53)

## 0.0.9
 - Added output to get Lan Subnet Availability Zone

## 0.0.10 (2025-06-27)

### Features 
- Added automatic lookup for site_location
- Added Routed_range handling 
- Updated Variables for site_location and routed_range
- Removed native_network variable as we are now inferring this value from `subnet_range_lan` 
- Version Locked Sub-Module call
- Updated Requirements for Provider and Terraform, adjusted versions file. 
