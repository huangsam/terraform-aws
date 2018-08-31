output "lb_host" {
  description = "Load balancer hostname"
  value = "${aws_lb.app.dns_name}"
}

output "bastion_host" {
  description = "Bastion hostname"
  value = "${aws_instance.bastion.public_dns}"
}
