# terraform-aws

This is a playground for learning AWS and Terraform tooling.

## Overview

This repository currently supports the following modules:

- `vpc`
- `app` (TBD)

Keep in mind that the base `main.tf` publishes state to S3. Please verify that the machine running Terraform has proper IAM credentials and the associated IAM user can perform list, get and put operations on the bucket.

### VPC module

The `vpc` module creates the following resources:

- VPC
- Internet gateway
- NAT gateways for AZ 1 and AZ 2
- Private subnet and public subnet for AZ 1 and AZ 2
- Route tables for private subnets
- Route table for public subnets
- Simple network ACL for all subnets
- Security groups for common EC2 use cases

#### Side notes

[Click here](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0) to see a similar implementation from the Terraform maintainers. Here are some noteworthy differences concerning their module:

- Supports variable availability zones
- Does not create security groups out of the box
- Relies on the default network ACL

## Usage

Place placeholder settings into the working directory:

    make config

You will be given `terraform.tfvars` and `backend.ini` which represent settings for inputs and state storage. After configuring both files, go ahead and initialize the workspace:

    make init

From there you can run any Terraform commands. Here are some common ones:

    terraform plan
    terraform apply
    terraform destroy

[Click here](https://www.terraform.io/docs/commands/index.html) to learn more about the other commands that are available from the Terraform CLI.

### Side notes

These Terraform artifacts ultimately publish their state to S3 using the storage backend configuration from `backend.ini`.
