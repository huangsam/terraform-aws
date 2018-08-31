output "vpc_id" {
  value = "${module.vpc.id}"
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "security_groups" {
  description = "Security group IDs by role"
  value = "${module.vpc.security_groups}"
}
