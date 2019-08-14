# Network
resource "aws_vpc" "demo-eks-vpc" {
  cidr_block = "${var.vpc-fullcidr}"

  # Used for the internal VPC DNS resolution
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                        = "demo-eks-${var.deployment-env}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}
