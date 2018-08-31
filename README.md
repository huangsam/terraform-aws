# terraform-aws

This is a playground for learning AWS and Terraform tooling.

## Overview

This repository currently supports the following projects:

- `service` creates service constructs
- `network` creates VPC constructs

Running a Terraform deployments should trigger an action to publish state to S3. Please verify that the machine with Terraform has proper IAM credentials to perform list, get and put operations for S3.
