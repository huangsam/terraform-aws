resource "aws_launch_configuration" "main" {
  name = "web_config"
  image_id = "${lookup(var.ec2_amazon_amis, var.region)}"
  instance_type = "t2.micro"
}
