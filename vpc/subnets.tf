//SUBNETS

#sample dns & dhcp code
/*
resource "aws_vpc_dhcp_options" "mydhcp" {
    domain_name = "${var.DnsZoneName}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "My internal name"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.terraformmain.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.mydhcp.id}"
}
*/

#vpc note: dhcp enabled by default, hostname dns disabled

#AZ1
#----public---
resource "aws_subnet" "subnet-pub-a" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-public-a-cidr}"

  tags {
    Name = "subnet-public-${var.aws-region}a"
  }

  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "subnet-pub-a" {
  subnet_id      = "${aws_subnet.subnet-pub-a.id}"
  route_table_id = "${aws_route_table.subnet-pub-a.id}"
}

#----private---
resource "aws_subnet" "subnet-pri-a" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-private-a-cidr}"

  tags {
    Name = "subnet-private-${var.aws-region}a"
  }

  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "subnet-pri-a" {
  subnet_id      = "${aws_subnet.subnet-pri-a.id}"
  route_table_id = "${aws_route_table.subnet-pri-a.id}"
}

#AZ2
#----public---
resource "aws_subnet" "subnet-pub-b" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-public-b-cidr}"

  tags {
    Name = "subnet-public-${var.aws-region}b"
  }

  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table_association" "subnet-pub-b" {
  subnet_id      = "${aws_subnet.subnet-pub-b.id}"
  route_table_id = "${aws_route_table.subnet-pub-b.id}"
}

#----private---
resource "aws_subnet" "subnet-pri-b" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-private-b-cidr}"

  tags {
    Name = "subnet-private-${var.aws-region}b"
  }

  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table_association" "subnet-pri-b" {
  subnet_id      = "${aws_subnet.subnet-pri-b.id}"
  route_table_id = "${aws_route_table.subnet-pri-b.id}"
}

#AZ3
#----public---
resource "aws_subnet" "subnet-pub-c" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-public-c-cidr}"

  tags {
    Name = "subnet-public-${var.aws-region}c"
  }

  availability_zone = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_route_table_association" "subnet-pub-c" {
  subnet_id      = "${aws_subnet.subnet-pub-c.id}"
  route_table_id = "${aws_route_table.subnet-pub-c.id}"
}

#----private---
resource "aws_subnet" "subnet-pri-c" {
  vpc_id     = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.subnet-private-c-cidr}"

  tags {
    Name = "subnet-private-${var.aws-region}c"
  }

  availability_zone = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_route_table_association" "subnet-pri-c" {
  subnet_id      = "${aws_subnet.subnet-pri-c.id}"
  route_table_id = "${aws_route_table.subnet-pri-c.id}"
}
