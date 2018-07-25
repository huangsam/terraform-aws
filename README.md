# terraform-aws

This is a playground for learning AWS and Terraform tooling.

## VPC module

The `vpc` module was inspired by a [similar initiative from the Terraform maintainers](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0).

The custom `vpc` module creates the following:

- VPC
- Internet gateway
- NAT gateways for AZ 1 and AZ 2
- Private subnet and public subnet for AZ 1 and AZ 2
- Common security groups for most EC2 use cases
- Route tables for private subnets
- Route table for public subnets
- Simple network ACL for all subnets
