variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_a_cidr_block" {
  description = "The CIDR block for Subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr_block" {
  description = "The CIDR block for Subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_a_az" {
  description = "The availability zone for Subnet A"
  type        = string
  default     = "us-east-2a"
}

variable "subnet_b_az" {
  description = "The availability zone for Subnet B"
  type        = string
  default     = "us-east-2b"
}

variable "node_group_desired_size" {
  description = "The desired size for the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "The maximum size for the node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "The minimum size for the node group"
  type        = number
  default     = 1
}

variable "node_group_instance_types" {
  description = "The instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

