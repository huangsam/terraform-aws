output "id" {
  description = "VPC ID"
  value = "${aws_vpc.main.id}"
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value = ["${aws_subnet.public_1.id}", "${aws_subnet.public_2.id}"]
}

output "security_groups" {
  description = "Security group IDs by role"
  value = {
    bastion = "${aws_security_group.bastion.id}"
    app = "${aws_security_group.app.id}"
    db = "${aws_security_group.db.id}"
    cache = "${aws_security_group.cache.id}"
    queue = "${aws_security_group.queue.id}"
  }
}
