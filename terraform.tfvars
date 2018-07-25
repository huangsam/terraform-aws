region = "us-west-1"

vpc_cidr = "10.0.0.0/16"

vpc_subnet_cidrs = {
  public_1 = "10.0.0.0/20"
  private_1 = "10.0.16.0/20"
  public_2 = "10.0.64.0/20"
  private_2 = "10.0.80.0/20"
}
