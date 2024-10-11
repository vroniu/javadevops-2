variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/28"
}

variable "subnet_cidr" {
    description = "CIDR block for the public subnet, must be within the VPC CIDR block"
    type = string
    default = "10.0.0.0/28"
}