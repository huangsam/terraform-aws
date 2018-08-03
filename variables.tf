variable "region" {}

variable "name" {}

variable "cidr" {}

variable "tags" {
  type = "map"
}

variable "vpc_subnet_cidrs" {
  type = "map"
}
