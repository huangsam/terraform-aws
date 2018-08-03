output "id" {
  description = "The ID of the VPC"
  value = "${aws_vpc.main.id}"
}

output "private_subnets" {
  description = "The private subnet IDs"
  value = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
}

output "public_subnets" {
  description = "The public subnet IDs"
  value = ["${aws_subnet.public_1.id}", "${aws_subnet.public_2.id}"]
}

output "security_groups" {
  description = "The security group IDs"
  value = {
    web = "${aws_security_group.web.id}"
    app = "${aws_security_group.app.id}"
    db = "${aws_security_group.db.id}"
    cache = "${aws_security_group.cache.id}"
    queue = "${aws_security_group.queue.id}"
  }
}
