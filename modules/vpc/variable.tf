variable "cluster_name" {
  type = string
  description = "Name of EKS cluster"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDER Block"
}

variable "name" {
  type = string 
  description = "VPC Name"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "public_subnets" {
  type = list(string)
  description = "Public Subnet CIDRs"
}

variable "private_subnets" {
  type = list(string)
  description = "Private Subnet CIDRs"
}

variable "azs" {
  type = list(string)
  description = "Availability zones"
}

variable "enable_nat_gateway" {
  type = bool 
  default = false
}