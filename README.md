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

Please ensure that `~/.aws` has the proper credentials if you plan to leave out the `access_key` and `secret_key` parameters. Also ensure that your user is authorized to perform list, get and put operations on the S3 bucket of your choice.
