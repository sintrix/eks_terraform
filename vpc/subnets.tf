# Subnets

# Data source
data "aws_availability_zones" "available" {}

#######
# AZ1
#######
# Public
resource "aws_subnet" "subnet-public-a" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-public-a-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name                                        = "subnet-public-${var.aws-region}a"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-public-a" {
  subnet_id      = "${aws_subnet.subnet-public-a.id}"
  route_table_id = "${aws_route_table.subnet-public-a.id}"
}

# Private
resource "aws_subnet" "subnet-private-a" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-private-a-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name                                        = "subnet-private-${var.aws-region}a"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-private-a" {
  subnet_id      = "${aws_subnet.subnet-private-a.id}"
  route_table_id = "${aws_route_table.subnet-private-a.id}"
}


#######
# AZ2
#######
# Public
resource "aws_subnet" "subnet-public-b" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-public-b-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name                                        = "subnet-public-${var.aws-region}b"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-public-b" {
  subnet_id      = "${aws_subnet.subnet-public-b.id}"
  route_table_id = "${aws_route_table.subnet-public-b.id}"
}

# Private
resource "aws_subnet" "subnet-private-b" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-private-b-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name                                        = "subnet-private-${var.aws-region}b"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-private-b" {
  subnet_id      = "${aws_subnet.subnet-private-b.id}"
  route_table_id = "${aws_route_table.subnet-private-b.id}"
}

#######
# AZ3
#######
# Public
resource "aws_subnet" "subnet-public-c" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-public-c-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name                                        = "subnet-public-${var.aws-region}c"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-public-c" {
  subnet_id      = "${aws_subnet.subnet-public-c.id}"
  route_table_id = "${aws_route_table.subnet-public-c.id}"
}

# Private
resource "aws_subnet" "subnet-private-c" {
  vpc_id            = "${aws_vpc.demo-eks-vpc.id}"
  cidr_block        = "${var.subnet-private-c-cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name                                        = "subnet-private-${var.aws-region}c"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "subnet-private-c" {
  subnet_id      = "${aws_subnet.subnet-private-c.id}"
  route_table_id = "${aws_route_table.subnet-private-c.id}"
}

# Sample DNS & DHCP code
# VPC note: DHCP enabled by default, hostname DNs disabled

# resource "aws_vpc_dhcp_options" "mydhcp" {
#     domain_name = "${var.DnsZoneName}"
#     domain_name_servers = ["AmazonProvidedDNS"]
#     tags = {
#       Name = "My internal name"
#     }
# }
# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#     vpc_id = "${aws_vpc.terraformmain.id}"
#     dhcp_options_id = "${aws_vpc_dhcp_options.mydhcp.id}"
# }
