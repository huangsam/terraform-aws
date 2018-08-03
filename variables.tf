/**
 * Global settings
 *
 * Anything that is related to the AWS account and global
 * constructs such as regions and availability zones.
 */

variable "region" {}

variable "name" {}

variable "cidr" {}

variable "tags" {
  type = "map"
}

variable "vpc_subnet_cidrs" {
  type = "map"
}
