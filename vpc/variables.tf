/*
 * Global settings
 *
 * Anything that is related to the AWS account and global
 * constructs such as regions and availability zones.
 */

variable "tags" {
  description = "Tag set applied to module resources"
  type = "map"
}

/*
 * VPC settings
 *
 * Includes the name and CIDR notation of various resources
 * such as internet gateways, subnets, network ACLs.
 */

variable "vpc_name" {
  description = "Name tag for the VPC itself"
  default = "vpc"
}

variable "vpc_igw_name" {
  description = "Name tag for the VPC internet gateway"
  default = "igw"
}

variable "vpc_cidr" {
  description = "CIDR mapping for VPC"
  default = "10.0.0.0/16"
}

variable "vpc_subnet_cidrs" {
  description = "CIDR notation for each VPC subnet"
  type = "map"
  default = {
    public_1 = "10.0.0.0/20"
    private_1 = "10.0.16.0/20"
    public_2 = "10.0.64.0/20"
    private_2 = "10.0.80.0/20"
  }
}

variable "vpc_subnet_names" {
  description = "Name tags for each VPC subnet"
  type = "map"
  default = {
    public_1 = "sn-public-az-1"
    private_1 = "sn-private-az-1"
    public_2 = "sn-public-az-2"
    private_2 = "sn-private-az-2"
  }
}

variable "vpc_nacl_names" {
  description = "Name tags for each VPC network ACL"
  default = {
    simple = "nacl-simple"
  }
}

variable "vpc_rt_names" {
  description = "Name tags for each VPC route table"
  type = "map"
  default = {
    web = "rt-web-az-all"
    nat_1 = "rt-nat-az-1"
    nat_2 = "rt-nat-az-2"
  }
}

variable "vpc_nat_names" {
  description = "Name tags for each VPC NAT gateway"
  type = "map"
  default = {
    nat_1 = "nat-az-1"
    nat_2 = "nat-az-2"
  }
}

variable "vpc_eip_names" {
  description = "Name tags for each VPC elastic IP"
  type = "map"
  default = {
    nat_1 = "eip-nat-az-1"
    nat_2 = "eip-nat-az-2"
  }
}

variable "vpc_sg_names" {
  description = "Name tags for each VPC security group"
  type = "map"
  default = {
    bastion = "sg-bastion"
    web = "sg-web"
    app = "sg-app"
    db = "sg-db"
    cache = "sg-cache"
    queue = "sg-queue"
  }
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

variable "ec2_amazon_ami" {
  description = "Amazon Linux 2018.03 AMI by region"
  type = "map"
  default = {
    us_west_1 = "ami-824c4ee2"
    us_east_1 = "ami-97785bed"
    eu_central_1 = "ami-5652ce39"
  }
}
