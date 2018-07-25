provider "aws" {
  region = "${var.region}"
}

module "my_vpc" {
  source = "./vpc"
  region = "${var.region}"
  project_name = "mvp"
  environment = "production"
  owner_name = "samhuang"
  name_prefix = ""
  vpc_subnet_cidrs = "${var.vpc_subnet_cidrs}"
}
