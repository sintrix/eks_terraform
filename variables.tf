# Auth
variable "aws-region" {
  default = "us-east-2"
}

# ENV
variable "deployment-env" {
  default = "test"
}

variable "root-domain-name" {
  default     = "demo.eks"
  description = "Internal DNS name"
}

# Network
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

# EKS
variable "cluster-name" {
  default = "demo-eks"
  type    = "string"
}
