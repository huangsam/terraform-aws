# terraform-aws

This is a playground for learning AWS and Terraform tooling.

## Overview

This repository currently supports the following projects:

- `django`
- `network`

Keep in mind that the base `main.tf` publishes state to S3. Please verify that the machine running Terraform has proper IAM credentials and the associated IAM user can perform list, get and put operations on the bucket.
