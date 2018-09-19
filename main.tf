//MAIN (main terraform .tf)

//AUTH (authentication for aws account if not using aws authenticator)
#auth
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws-region}"
}

//REGIONAL SERVICES
#vpc
module "vpc-network" {
  source                = "./vpc/"
  aws_access_key        = "${var.aws_access_key}"
  aws_secret_key        = "${var.aws_secret_key}"
  aws-region            = "${var.aws-region}"
  vpc-fullcidr          = "${var.vpc-fullcidr}"
  root_domain_name      = "${var.root_domain_name}"
  deployment_env        = "${var.deployment_env}"
  subnet-private-a-cidr = "${var.subnet-private-a-cidr}"
  subnet-private-b-cidr = "${var.subnet-private-b-cidr}"
  subnet-private-c-cidr = "${var.subnet-private-c-cidr}"
  subnet-public-a-cidr  = "${var.subnet-public-a-cidr}"
  subnet-public-b-cidr  = "${var.subnet-public-b-cidr}"
  subnet-public-c-cidr  = "${var.subnet-public-c-cidr}"
}

#ec2
module "ec2" {
  source         = "./services/ec2/"
  deployment_env = "${var.deployment_env}"
}

#eks
module "eks" {
  source               = "./services/eks/"
  cluster-name         = "${var.cluster-name}"
  subnet_pri_a_id      = "${module.vpc-network.subnet_pri_a_id}"
  subnet_pri_b_id      = "${module.vpc-network.subnet_pri_b_id}"
  subnet_pri_c_id      = "${module.vpc-network.subnet_pri_c_id}"
  sg_kube_masters_id   = "${module.vpc-network.sg_kube_masters_id}"
  sg_kube_nodes_id     = "${module.vpc-network.sg_kube_nodes_id}"
  kubenodes-public-key = "${module.ec2.kubenodes-public-key}"
}
