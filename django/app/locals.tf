locals {
  all_subnets = "${concat(
    var.private_subnets,
    var.public_subnets
  )}"
}
