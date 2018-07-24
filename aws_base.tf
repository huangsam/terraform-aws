/*
 * AWS VPC
 *
 * Everything revolves around this entity. Ideally the VPC
 * CIDR block does not have overlap with other VPC CIDR blocks
 * so that VPC peering is supported.
 */

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_name}"
    )
  )}"
}

/*
 * AWS Routing (Public)
 *
 * Spans internet gateways, route tables and their respective
 * associations to support internet accessibility for public
 * subnets.
 */

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_igw_name}"
    )
  )}"
}

resource "aws_route_table" "web" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_rt_names[0]}"
    )
  )}"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.web.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.web.id}"
}

/*
 * AWS Routing (Private)
 *
 * Spans NAT gateways, route tables and their respective
 * associations to support internet accessibility for private
 * subnets.
 *
 * NAT gateways take a considerable amount of time to spin up.
 * Perhaps they create an EC2 and assign it to an Elastic IP
 * under the hood. Please be patient as they are being
 * provisioned.
 *
 * Inspiration borrowed from the following link:
 * http://blog.kaliloudiaby.com/index.php/terraform-to-provision-vpc-on-aws-amazon-web-services/
 */

resource "aws_route_table" "private_1" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_rt_names[1]}"
    )
  )}"
}

resource "aws_eip" "nat_1" {
  vpc      = true
  depends_on = ["aws_internet_gateway.main"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_eip_names[0]}"
    )
  )}"
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = "${aws_eip.nat_1.id}"
  subnet_id = "${aws_subnet.public_1.id}"
  depends_on = ["aws_internet_gateway.main"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_nat_names[0]}"
    )
  )}"
}

resource "aws_route" "private_1" {
  route_table_id  = "${aws_route_table.private_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_1.id}"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.private_1.id}"
}

resource "aws_route_table" "private_2" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_rt_names[2]}"
    )
  )}"
}

resource "aws_eip" "nat_2" {
  vpc      = true
  depends_on = ["aws_internet_gateway.main"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_eip_names[1]}"
    )
  )}"
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = "${aws_eip.nat_2.id}"
  subnet_id = "${aws_subnet.public_2.id}"
  depends_on = ["aws_internet_gateway.main"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_nat_names[1]}"
    )
  )}"
}

resource "aws_route" "private_2" {
  route_table_id  = "${aws_route_table.private_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_2.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.private_2.id}"
}

/*
 * AWS Subnets
 *
 * A set of subnets that are being used for the VPC.
 * Currently we try to limit the subnets down to two
 * availability zones for simplicity sake.
 */

resource "aws_subnet" "public_1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_cidrs["public_1"]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_subnet_names[0]}"
    )
  )}"
}

resource "aws_subnet" "private_1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_cidrs["private_1"]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = false
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_subnet_names[1]}"
    )
  )}"
}

resource "aws_subnet" "public_2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_cidrs["public_2"]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_subnet_names[2]}"
    )
  )}"
}

resource "aws_subnet" "private_2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_cidrs["private_2"]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = false
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_subnet_names[3]}"
    )
  )}"
}

/*
 * AWS Network ACLs
 *
 * A set of egress and ingress rules for various subnets
 * to use. Currently a simple one has been configured to
 * allow all traffic in and out of the available subnets.
 */

resource "aws_network_acl" "simple" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = [
    "${aws_subnet.public_1.id}",
    "${aws_subnet.private_1.id}",
    "${aws_subnet.public_2.id}",
    "${aws_subnet.private_2.id}"
  ]
  ingress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress {
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_nacl_names[0]}"
    )
  )}"
}

/*
 * AWS Security Groups
 *
 * We have the following profiles:
 * - bastion
 * - web server (Nginx)
 * - applications (Django)
 * - databases (PostgreSQL)
 * - caches (Redis)
 * - queues (RabbitMQ)
 *
 * Inspiration borrowed from the following link:
 * https://nickcharlton.net/posts/terraform-aws-vpc.html
 */

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[0]}"
  description = "Security group for bastions"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[0]}"
    )
  )}"
}

resource "aws_security_group" "web" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[1]}"
  description = "Security group for web servers"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[1]}"
    )
  )}"
}

resource "aws_security_group" "app" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[2]}"
  description = "Security group for applications"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[2]}"
    )
  )}"
}

resource "aws_security_group" "db" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[3]}"
  description = "Security group for databases"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[3]}"
    )
  )}"
}

resource "aws_security_group" "cache" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[4]}"
  description = "Security group for caches"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = ["${aws_security_group.app.id}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[4]}"
    )
  )}"
}

resource "aws_security_group" "queue" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${local.name_prefix}-${var.vpc_sg_names[5]}"
  description = "Security group for queues"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 5672
    to_port = 5672
    protocol = "tcp"
    security_groups = ["${aws_security_group.app.id}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.name_prefix}-${var.vpc_sg_names[5]}"
    )
  )}"
}
