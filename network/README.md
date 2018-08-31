# Network project

The `vpc` module creates the following resources:

- VPC
- Internet gateway
- NAT gateways for AZ 1 and AZ 2
- Private subnet and public subnet for AZ 1 and AZ 2
- Route tables for private subnets
- Route table for public subnets
- Simple network ACL for all subnets
- Security groups for common EC2 use cases

## Usage

Import placeholder settings into the working directory:

    make config-us

You will be given the following files:

- `terraform.tfvars`
- `backend.ini`
- `data.tf`

These represent settings for inputs and state storage. Configure them and initialize the workspace:

    make init

From there you can run any Terraform commands. Here are some common ones:

    make plan
    make apply
    make destroy

All of these commands are simply aliases to `terraform` commands. [Click here](https://www.terraform.io/docs/commands/index.html) to learn more about available commands.
