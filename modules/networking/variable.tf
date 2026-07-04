variable "environment" {
    description = "The name of the environment(dev/prod)"
    type        = string
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}

variable "public_subnet" {
    description = "Map of public subnet configurations"
    type        = map(string)
}

variable "private_subnet" {
    description = "Map of private subnet configurations"
    type        = map(string)
}

variable "database_subnet" {
    description = "Map of database subnet configurations"
    type        = map(string)
}