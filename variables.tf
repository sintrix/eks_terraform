//VARIABLES MAIN

#auth variables
variable "aws-region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

#env variables
variable "deployment_env" {
  default = "test"
}

variable "root_domain_name" {
  default     = "test.cloud"
  description = "internal dns name"
}

#network variables
variable "vpc-fullcidr" {
  default = "10.30.0.0/16"
}

variable "subnet-public-a-cidr" {
  default = "10.30.1.0/24"
}

variable "subnet-public-b-cidr" {
  default = "10.30.2.0/24"
}

variable "subnet-public-c-cidr" {
  default = "10.30.3.0/24"
}

variable "subnet-private-a-cidr" {
  default = "10.30.101.0/24"
}

variable "subnet-private-b-cidr" {
  default = "10.30.102.0/24"
}

variable "subnet-private-c-cidr" {
  default = "10.30.103.0/24"
}

variable "AWS_VPC_enable_nat_gateway" {
  default = "true"
}

#eks vars
variable "cluster-name" {
  default = "eks-test"
  type    = "string"
}
