# terraform-aws

This is a playground for learning AWS and Terraform tooling.

## Overview

### VPC module

The `vpc` module was inspired by a [similar initiative from the Terraform maintainers](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0).

The custom `vpc` module creates the following:

- VPC
- Internet gateway
- NAT gateways for AZ 1 and AZ 2
- Private subnet and public subnet for AZ 1 and AZ 2
- Route tables for private subnets
- Route table for public subnets
- Simple network ACL for all subnets
- Security groups for common EC2 use cases

**Note:** The VPC is currently configured to support exactly two
availability zones. This works fine for personal pet projects but this
may not be enough for enterprise use cases. Consider adding a Virtual Private
Gateway and additional subnets if needed.

## Usage

These Terraform artifacts ultimately publish their state to S3 using the storage backend configuration from `backend.ini`. An example `backend.ini.example` was created for people to create their own settings.

After populating the settings properly, then initialize the workspace:

    terraform init -backend-config=backend.ini

Then the Terraform resources can be deployed:

    terraform apply
