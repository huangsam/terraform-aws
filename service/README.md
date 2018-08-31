# Service project

The `app` module creates the following resources:

- Load balancer
- Target group
- Autoscaling group
- Launch configuration
- Bastion instance

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
