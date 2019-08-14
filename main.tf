# Auth Provider
# Authentication utilizes credentials in ~/.aws/credentials
provider "aws" {
  profile = "default"
  region  = "${var.aws-region}"
}

# VPC Module
module "vpc-network" {
  source                = "./vpc/"
  aws-region            = "${var.aws-region}"
  cluster-name          = "${var.cluster-name}"
  deployment-env        = "${var.deployment-env}"
  root-domain-name      = "${var.root-domain-name}"
  vpc-fullcidr          = "${var.vpc-fullcidr}"
  subnet-public-a-cidr  = "${var.subnet-public-a-cidr}"
  subnet-public-b-cidr  = "${var.subnet-public-b-cidr}"
  subnet-public-c-cidr  = "${var.subnet-public-c-cidr}"
  subnet-private-a-cidr = "${var.subnet-private-a-cidr}"
  subnet-private-b-cidr = "${var.subnet-private-b-cidr}"
  subnet-private-c-cidr = "${var.subnet-private-c-cidr}"
}

# EC2 Module
module "ec2" {
  source         = "./services/ec2/"
  deployment-env = "${var.deployment-env}"
}

# EKS Module
module "eks" {
  source               = "./services/eks/"
  cluster-name         = "${var.cluster-name}"
  deployment-env       = "${var.deployment-env}"
  kubenodes-public-key = "${module.ec2.kubenodes-public-key}"
  subnet-public-a-id   = "${module.vpc-network.subnet-public-a-id}"
  subnet-public-b-id   = "${module.vpc-network.subnet-public-b-id}"
  subnet-public-c-id   = "${module.vpc-network.subnet-public-c-id}"
  sg-kube-masters-id   = "${module.vpc-network.sg-kube-masters-id}"
  sg-kube-nodes-id     = "${module.vpc-network.sg-kube-nodes-id}"
}
