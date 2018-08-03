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

First get the settings placed in the working directory:

    make config

After populating the settings properly, go ahead and initialize the workspace:

    make apply

After you verify that it works, feel free to remove the resources:

    make destroy

### Side notes

These Terraform artifacts ultimately publish their state to S3 using the storage backend configuration from `backend.ini`.

Please ensure that `~/.aws` has the proper credentials if you plan to leave out the `access_key` and `secret_key` parameters. Also ensure that your user is authorized to perform list, get and put operations on the S3 bucket of your choice.
