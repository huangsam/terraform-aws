#######################################
# Terraform variables
#######################################

### Global variables ###

region = "us-west-1"
project_name = "mvp"
environment = "production"
name_prefix = ""

### VPC variables ###

vpc_cidr = "10.0.0.0/16"
vpc_name = "vpc"
vpc_igw_name = "igw"

vpc_subnet_cidrs = {
  # AZ 1 - 0.0 thru 63.255
  public_1 = "10.0.0.0/20"
  private_1 = "10.0.16.0/20"

  # AZ 2 - 64.0 thru 127.255
  public_2 = "10.0.80.0/20"
  private_2 = "10.0.96.0/20"

  # AZ 3 - 128.0 thru 191.255
  # NOTE: Unused for simplicity

  # Mixed - 192.0 thru 255.255
  # NOTE: Unused for simplicity
}

vpc_subnet_names = [
  "sn-public-az-1", "sn-private-az-1",
  "sn-public-az-2", "sn-private-az-2",
]

vpc_nacl_names = [
  "nacl-simple",
]

vpc_rt_names = [
  "rt-web",
  "rt-nat-az-1",
  "rt-nat-az-2",
]

vpc_eip_names = [
  "eip-nat-az-1",
  "eip-nat-az-2",
]

vpc_nat_names = [
  "nat-az-1",
  "nat-az-2",
]

vpc_sg_names = [
  "sg-bastion",
  "sg-web",
  "sg-app",
  "sg-db",
  "sg-cache",
  "sg-queue",
]
