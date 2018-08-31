/**
 * Global settings
 *
 * Anything that is related to the AWS account and global
 * constructs such as regions and availability zones.
 */

variable "region" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "security_groups" {
  type = "map"
}

variable "vpc_id" {}

/**
 * EC2 settings
 *
 * Anything related directly to instance creation. One example is
 * the SSH key name that gets initialized for each EC2 instance.
 */

variable "key_name" {
  description = "Name of key used to control login access to EC2 instances"
}

variable "bastion_profile" {
  description = "Name of IAM role used for bastion instances"
}

variable "app_profile" {
  description = "Name of IAM role used for application instances"
}

/**
 * RDS settings
 *
 * Anything related directly to database creation. Examples include
 * database username and password.
 */

variable "db_name" {
  description = "Database to create when DB instance is created"
}

variable "db_username" {
  description = "Username of RDS user"
}

variable "db_password" {
  description = "Password of RDS user"
}

/**
 * AMI mappings
 *
 * A provider publishes the same AMI distribution to multiple
 * regions. As a result, the AMI has a different identifier in
 * each region. And it can actually change when the version of
 * the OS changes.
 *
 * One thing that we can consider is to build
 * our own custom AMI images. This can be done with Hashicorp
 * Packer or by snapshotting EC2 images. Will have to look into
 * this more in further detail.
 */

variable "ec2_amazon_amis" {
  description = "Amazon Linux 2018.03 AMI by region"
  type = "map"
  default = {
    us-west-1 = "ami-e0ba5c83"
    us-east-1 = "ami-b70554c8"
    eu-central-1 = "ami-7c4f7097"
  }
}
