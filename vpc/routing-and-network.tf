# IGW, Route Table, NAT GW

###############
# IGW
###############
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  tags = {
    Name = "${var.deployment-env} IGW"
  }
}

###############
# ACL
###############
resource "aws_network_acl" "all" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Allow all ACL"
  }
}

###############
# Route Tables
###############
# AZ1
resource "aws_route_table" "subnet-public-a" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "public-routes-${var.aws-region}a"
    Type = "public"
    AZ   = "A"
  }
}

resource "aws_route_table" "subnet-private-a" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  tags = {
    Name = "private-routes-${var.aws-region}a"
    Type = "private"
    AZ   = "A"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-public-a.id}"
  }
}

# AZ2
resource "aws_route_table" "subnet-public-b" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "public-routes-${var.aws-region}b"
    Type = "public"
    AZ   = "B"
  }
}

resource "aws_route_table" "subnet-private-b" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  tags = {
    Name = "private-routes-${var.aws-region}b"
    Type = "private"
    AZ   = "B"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-public-b.id}"
  }
}

# AZ3
resource "aws_route_table" "subnet-public-c" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "public-routes-${var.aws-region}c"
    Type = "public"
    AZ   = "C"
  }
}

resource "aws_route_table" "subnet-private-c" {
  vpc_id = "${aws_vpc.demo-eks-vpc.id}"

  tags = {
    Name = "private-routes-${var.aws-region}c"
    Type = "private"
    AZ   = "C"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet-public-c.id}"
  }
}

###############
# NAT GW
###############
# AZ1
resource "aws_eip" "eip-nat-az1" {
  vpc = true

  tags = {
    Name = "eip-nat-${var.aws-region}a"
  }
}

resource "aws_nat_gateway" "subnet-public-a" {
  allocation_id = "${aws_eip.eip-nat-az1.id}"
  subnet_id     = "${aws_subnet.subnet-public-a.id}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags = {
    Name = "nat-${var.aws-region}a"
  }
}

# AZ2
resource "aws_eip" "eip-nat-az2" {
  vpc = true

  tags = {
    Name = "eip-nat-${var.aws-region}b"
  }
}

resource "aws_nat_gateway" "subnet-public-b" {
  allocation_id = "${aws_eip.eip-nat-az2.id}"
  subnet_id     = "${aws_subnet.subnet-public-b.id}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags = {
    Name = "nat-${var.aws-region}b"
  }
}

# AZ3
resource "aws_eip" "eip-nat-az3" {
  vpc = true

  tags = {
    Name = "eip-nat-${var.aws-region}c"
  }
}

resource "aws_nat_gateway" "subnet-public-c" {
  allocation_id = "${aws_eip.eip-nat-az3.id}"
  subnet_id     = "${aws_subnet.subnet-public-c.id}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags = {
    Name = "nat-${var.aws-region}c"
  }
}
