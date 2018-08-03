output "vpc_id" {
  description = "The ID of the VPC"
  value = "${aws_vpc.main.id}"
}

output "vpc_private_sns" {
  description = "The private subnet IDs"
  value = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
}

output "vpc_public_sns" {
  description = "The public subnet IDs"
  value = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]
}
