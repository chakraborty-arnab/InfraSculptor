variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# variable "public_subnet_cidr_blocks" {
#   description = "Available cidr blocks for public subnets."
#   type        = list(string)
#   default = [
#     "10.0.1.0/24",
#     "10.0.2.0/24",
#     "10.0.3.0/24",
#   ]
# }

# variable "private_subnet_cidr_blocks" {
#   description = "Available cidr blocks for private subnets."
#   type        = list(string)
#   default = [
#     "10.0.101.0/24",
#     "10.0.102.0/24",
#     "10.0.103.0/24",
#   ]
# }


variable "availability_zones" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-",
    "10.0.103.0/24",
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile"{
  type = string
  default = "dev"
}

variable "subnet_private_count"{
  type=number
  default=8
}

variable "subnet_public_count"{
  type=number
  default=8
}