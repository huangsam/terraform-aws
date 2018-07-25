# terraform-aws

Apply Terraform to AWS provider

Learning how to use Terraform and AWS as I am developing a custom `vpc`
module that is similar to the following module:

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0

The custom `vpc` module creates the following:

- VPC
- Internet gateway
- NAT gateways for AZ 1 and AZ 2
- Private subnet and public subnet for AZ 1 and AZ 2
- Common security groups for most EC2 use cases
- Route tables for private subnets
- Route table for public subnets
- Simple network ACL for all subnets
