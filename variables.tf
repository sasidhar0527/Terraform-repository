variable "vpc_cidr" {
}

variable "vpc_name" {
}

variable "IGW_name" {
}

variable "public_subnet1_cidr" {
}

variable "public_subnet1_name" {
}

variable "public_subnet2_cidr" {
}

variable "public_subnet2_name" {
}

variable "public_subnet3_cidr" {
}

variable "public_subnet3_name" {
}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "ec2_name" {
}




