variable "vpc-name"               {}
variable "vpc-cidr"               {}
variable "public-subnet-name"     {}
variable "public-subnets-cidr"    {}
variable "tags"                   {}
variable "internet-gateway-name"  {}
variable "public-rt-name"         {}
variable "sg-name"                {}
variable "private-subnets-cidr"   {}
variable "private-subnet-name"    {}
variable "nat-gateway-name"       {}
variable "private-rt-name"        {}
# end of variables.tf
variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b"]
}
