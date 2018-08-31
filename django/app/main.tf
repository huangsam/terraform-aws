/**
 * AWS EC2 resources
 *
 * All the constructs necessary to deploy compute nodes
 * for hosting highly available services.
 *
 * Note that the autoscaling group uses private subnets
 * which means that its instances are not publicly accessible via
 * elastic IPs.
 *
 * The load balancer does not need to be configured to the
 * private subnets. Rather it needs to be registered with the public
 * subnets.
 *
 * Useful references:
 * https://aws.amazon.com/premiumsupport/knowledge-center/public-load-balancer-private-ec2/
 * https://stackoverflow.com/questions/22541895/amazon-elb-for-ec2-instances-in-private-subnet-in-vpc
 * https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
 */

resource "aws_lb" "app" {
  name = "ec2-alb-app"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${var.security_groups["app"]}"]
  subnets = ["${var.public_subnets}"]
}

resource "aws_lb_target_group" "http" {
  name = "ec2-alb-tg-http"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  health_check {
    path = "/api/"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200,204"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = "${aws_lb_target_group.http.arn}"
    type = "forward"
  }
}

resource "aws_launch_configuration" "app" {
  name_prefix = "ec2-lc-app-"
  image_id = "${lookup(var.ec2_amazon_amis, var.region)}"
  instance_type = "t2.medium"
  iam_instance_profile = "${var.app_profile}"
  key_name = "${var.key_name}"
  security_groups = ["${var.security_groups["app"]}"]
  user_data = "${base64encode(file("scripts/app.sh"))}"
  enable_monitoring = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name_prefix = "ec2-asg-app-"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.app.name}"
  vpc_zone_identifier = ["${var.private_subnets}"]
  target_group_arns = ["${aws_lb_target_group.http.arn}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "bastion" {
  ami = "${lookup(var.ec2_amazon_amis, var.region)}"
  instance_type = "t2.micro"
  iam_instance_profile = "${var.bastion_profile}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups["bastion"]}"]
  subnet_id = "${var.public_subnets[0]}"
  monitoring = true
  tags {
    Name = "ec2-bastion"
  }
}

/**
 * AWS RDS resources
 *
 * We plan to use the DB security group for this use case.
 * We'll be creating a DB subnet group that spans the two
 * public subnets in AZ 1 and AZ 2. We'll also create a DB subnet
 * group that spans the two private subnets in AZ 1 and AZ 2.
 *
 * We plan to create two RDS instances. One that spans the public
 * DB subnet group. And another one that spans the private DB subnet group.
 * The flavor of PostgreSQL will be 10.4
 *
 * NOTE: t2.* instances do not support encrypted data.
 */

resource "aws_db_subnet_group" "public" {
  name = "rds-sng-public"
  description = "RDS subnet group for public subnets"
  subnet_ids = ["${var.public_subnets}"]
  tags = "${var.tags}"
}

resource "aws_db_subnet_group" "private" {
  name = "rds-sng-private"
  description = "RDS subnet group for private subnets"
  subnet_ids = ["${var.private_subnets}"]
  tags = "${var.tags}"
}

resource "aws_db_instance" "main" {
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "10.4"
  instance_class = "db.m4.large"
  allocated_storage = 100
  db_subnet_group_name = "${aws_db_subnet_group.private.name}"
  vpc_security_group_ids = ["${var.security_groups["db"]}"]
  backup_retention_period = 7
  maintenance_window = "Mon:00:00-Mon:03:00"
  monitoring_interval = 0
  name = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  parameter_group_name = "default.postgres10"
  apply_immediately = true
  auto_minor_version_upgrade = true
  identifier = "rds-main-${var.region}"
  final_snapshot_identifier = "rds-main-${var.region}"
  skip_final_snapshot = false
  tags = "${var.tags}"
}
