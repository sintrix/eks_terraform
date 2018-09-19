//ig, route table, nat gw

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "${var.deployment_env} internet gw"
  }
}

resource "aws_network_acl" "all" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  egress {
    protocol   = "-1"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "allow all acl"
  }
}

#route tables
#az1
resource "aws_route_table" "subnet-pub-a" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-public-${var.aws-region}a"
    Type = "public"
    AZ   = "A"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "subnet-pri-a" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-private-${var.aws-region}a"
    Type = "private"
    AZ   = "A"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-pub-a.id}"
  }
}

#az2
resource "aws_route_table" "subnet-pub-b" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-public-${var.aws-region}b"
    Type = "public"
    AZ   = "B"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "subnet-pri-b" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-private-${var.aws-region}b"
    Type = "private"
    AZ   = "B"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-pub-b.id}"
  }
}

#az3
resource "aws_route_table" "subnet-pub-c" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-public-${var.aws-region}c"
    Type = "public"
    AZ   = "C"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "subnet-pri-c" {
  vpc_id = "${aws_vpc.terraformmain.id}"

  tags {
    Name = "rt-private-${var.aws-region}c"
    Type = "private"
    AZ   = "C"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-pub-c.id}"
  }
}

#nat gw
#az1
resource "aws_eip" "eip-nat-aza" {
  vpc = true

  tags {
    Name = "eip-nat-${var.aws-region}a"
  }
}

resource "aws_nat_gateway" "subnet-pub-a" {
  allocation_id = "${aws_eip.eip-nat-aza.id}"
  subnet_id     = "${aws_subnet.subnet-pub-a.id}"
  depends_on    = ["aws_internet_gateway.gw"]

  tags {
    Name = "nat-${var.aws-region}a"
  }
}

#az2
resource "aws_eip" "eip-nat-azb" {
  vpc = true

  tags {
    Name = "eip-nat-${var.aws-region}b"
  }
}

resource "aws_nat_gateway" "subnet-pub-b" {
  allocation_id = "${aws_eip.eip-nat-azb.id}"
  subnet_id     = "${aws_subnet.subnet-pub-b.id}"
  depends_on    = ["aws_internet_gateway.gw"]

  tags {
    Name = "nat-${var.aws-region}b"
  }
}

#az3
resource "aws_eip" "eip-nat-azc" {
  vpc = true

  tags {
    Name = "eip-nat-${var.aws-region}c"
  }
}

resource "aws_nat_gateway" "subnet-pub-c" {
  allocation_id = "${aws_eip.eip-nat-azc.id}"
  subnet_id     = "${aws_subnet.subnet-pub-c.id}"
  depends_on    = ["aws_internet_gateway.gw"]

  tags {
    Name = "nat-${var.aws-region}c"
  }
}
