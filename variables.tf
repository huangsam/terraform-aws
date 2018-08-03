/*
 * Base variables
 *
 * The variables that are used in the base main.tf.
 * Whatever is used here is global to all modules,
 * providers and resources here.
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

/*
 * EC2 AMI mappings
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

variable "amazon_amis" {
  description = "Amazon Linux 2018.03 AMI by region"
  type = "map"
  default = {
    us-west-1 = "ami-824c4ee2"
    us-east-1 = "ami-97785bed"
    eu-central-1 = "ami-5652ce39"
  }
}
