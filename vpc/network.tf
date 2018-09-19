//network 
resource "aws_vpc" "terraformmain" {
  cidr_block = "${var.vpc-fullcidr}"

  #2 true values = use the internal vpc dns resolution
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "mylab-${var.deployment_env}"
  }
}
