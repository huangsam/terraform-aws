locals {
  common_tags = "${merge(
    var.tags,
    map(
      "Region", var.region
    )
  )}"
}
