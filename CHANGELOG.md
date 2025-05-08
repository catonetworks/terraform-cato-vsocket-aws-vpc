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
### Features
- Disassociated native_network_range from vpc_cidr_range to enable VPC_CIDR to be different from Native_network_range