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
