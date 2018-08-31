terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

module "app" {
  source = "./app"
  region = "${var.region}"
  key_name = "${var.key_name}"
  public_subnets = "${data.terraform_remote_state.vpc.public_subnets}"
  private_subnets = "${data.terraform_remote_state.vpc.private_subnets}"
  security_groups = "${data.terraform_remote_state.vpc.security_groups}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags = "${local.common_tags}"
  db_name = "${var.db_name}"
  db_username = "${var.db_username}"
  db_password = "${var.db_password}"
  bastion_profile = "${var.bastion_profile}"
  app_profile = "${var.app_profile}"
}
