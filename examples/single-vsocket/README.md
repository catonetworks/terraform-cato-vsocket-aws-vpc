# Single vSocket AWS VPC Example

This example deploys one Cato vSocket in AWS, creates the AWS VPC resources, creates the AWS Socket site in the Cato Management Application, and registers the EC2 instance.

## Before You Run Terraform

1. In AWS, use a dedicated account or role with permissions to create VPCs, EC2 instances, network interfaces, security groups, route tables, EIPs, storage, IAM resources needed by your organization, and AWS Marketplace subscriptions.
2. In AWS Marketplace, search for `Cato Networks Virtual Socket`, open the result, click `View purchase options`, and subscribe.
3. In AWS, create or choose the EC2 key pair referenced by `key_pair` in `main.tf`.
4. In the Cato Management Application, create a service account with permissions to edit sites.
5. Create a service API key for that account and keep the key available for the `cato_token` Terraform variable.
6. Install the latest AWS CLI from the AWS documentation: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
7. Log in to the AWS account or role you will use for deployment:

```bash
aws sso login
```

## Run

Set the Cato values with environment variables or a local `.tfvars` file:

```bash
export TF_VAR_baseurl="https://api.catonetworks.com/api/v1/graphql2"
export TF_VAR_cato_token="your-cato-api-key"
export TF_VAR_account_id="your-cato-account-id"
```

Then run:

```bash
terraform init
terraform plan
terraform apply
```

The example leaves `vpc_id` and `internet_gateway_id` as `null`, so the module creates a new VPC and Internet Gateway. To deploy into existing AWS networking, set those inputs to existing resource IDs.

## Instance Type

The default example uses `c5.xlarge`. Choose one of the supported Cato vSocket instance types documented in the module README. Use `c5n.xlarge` for higher performance sites with bandwidth above 2 Gbps.
