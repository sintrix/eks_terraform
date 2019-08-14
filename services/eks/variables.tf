# Deployment
variable "deployment-env" {}

variable "cluster-name" {}

# Security Groups
variable "sg-kube-masters-id" {}

variable "sg-kube-nodes-id" {}

# Networking
variable "subnet-public-a-id" {}

variable "subnet-public-b-id" {}

variable "subnet-public-c-id" {}

# Keypair
variable "kubenodes-public-key" {}
