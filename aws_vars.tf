/*
 * Global settings
 *
 * Anything that is related to the AWS account and global
 * constructs such as regions and availability zones.
 */

variable "region" {
  description = "Name of the AWS region to set up a network within"
}

variable "owner_name" {
  description = "Name of primary owner on AWS"
}

variable "project_name" {
  description = "Name of project these resources fall under"
}

variable "environment" {
  description = "Name of the environment lifecycle"
}

variable "name_prefix" {
  description = "Name of prefix applied to resource names"
}

/*
 * VPC settings
 *
 * Includes the name and CIDR notation of various resources
 * such as internet gateways, subnets, network ACLs.
 */

variable "vpc_name" {
  description = "Name tag for the VPC itself"
}

variable "vpc_igw_name" {
  description = "Name tag for the VPC internet gateway"
}

variable "vpc_cidr" {
  description = "CIDR mapping for VPC"
}

variable "vpc_subnet_cidrs" {
  description = "CIDR notation for each VPC subnet"
  type = "map"
}

variable "vpc_subnet_names" {
  description = "List of name tags for each VPC subnet"
  type = "list"
}

variable "vpc_rt_names" {
  description = "List of name tags for each VPC route table"
  type = "list"
}

variable "vpc_eip_names" {
  description = "List of name tags for each VPC elastic IP"
  type = "list"
}

variable "vpc_nat_names" {
  description = "List of name tags for each VPC NAT gateway"
  type = "list"
}

variable "vpc_nacl_names" {
  description = "List of name tags for each VPC network ACL"
  type = "list"
}

variable "vpc_sg_names" {
  description = "List of name tags for each VPC security group"
  type = "list"
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

variable "amazon_ami_regions" {
  description = "Amazon Linux 2018.03 AMI by region"
  type = "map"
  default = {
    us_west_1 = "ami-824c4ee2"
    us_east_1 = "ami-97785bed"
    eu_central_1 = "ami-5652ce39"
  }
}

variable "debian_ami_regions" {
  description = "Debian 9 AMI by region"
  type = "map"
  default = {
    us_west_1 = "ami-a126c2c2"
    us_east_1 = "ami-8c9bdaf3"
    eu_central_1 = "ami-9025167b"
  }
}

variable "centos_ami_regions" {
  description = "CentOS 7 AMI by region"
  type = "map"
  default = {
    us_west_1 = "ami-4826c22b"
    us_east_1 = "ami-9887c6e7"
    eu_central_1 = "ami-dd3c0f36"
  }
}

variable "ubuntu_ami_regions" {
  description = "Ubuntu 18.04 LTS AMI by region"
  type = "map"
  default = {
    us_west_1 = "ami-d7b355b4"
    us_east_1 = "ami-5cc39523"
    eu_central_1 = "ami-3c635cd7"
  }
}
