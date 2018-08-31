/**
 * Global settings
 *
 * Anything that is related to the AWS account and global
 * constructs such as regions and availability zones.
 */

variable "region" {}

variable "tags" {
  type = "map"
}

variable "key_name" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "bastion_profile" {}

variable "app_profile" {}
