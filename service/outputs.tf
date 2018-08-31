output "lb_host" {
  value = "${module.app.lb_host}"
}

output "bastion_host" {
  value = "${module.app.bastion_host}"
}
