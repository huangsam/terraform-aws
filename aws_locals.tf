locals {
  default_name_prefix = "${var.project_name}"
  name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
}

locals {
  common_tags = {
    Region = "${var.region}"
    Environment = "${var.environment}"
    Project = "${var.project_name}"
    Owner = "${var.owner_name}"
  }
}
