terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./vpc"
  vpc_name = "${var.name}"
  vpc_cidr = "${var.cidr}"
  vpc_subnet_cidrs = "${var.vpc_subnet_cidrs}"
  tags = "${local.common_tags}"
}
