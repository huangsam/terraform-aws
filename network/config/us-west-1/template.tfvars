region = "us-west-1"

name = "vpc"

cidr = "10.0.0.0/20"

tags = {
  Environment = "production"
  Project = "network"
}

vpc_subnet_cidrs = {
  public_1 = "10.0.0.0/24"
  public_2 = "10.0.1.0/24"
  private_1 = "10.0.8.0/24"
  private_2 = "10.0.9.0/24"
}
