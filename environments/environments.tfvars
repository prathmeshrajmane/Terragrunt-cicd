# Variables used in module ECS
project                       = "Test"

# Variables used in module VPC
vpc-name                      = "test-dev-vpc"
vpc-cidr                      = "10.0.8.0/24"
public-subnet-name            = "test-dev-public-subnet"
public-subnets-cidr           = ["10.0.8.0/28","10.0.8.16/28"]
internet-gateway-name         = "test-dev-internet-gateway"
public-rt-name                = "test-dev-public-routetable"
private-subnets-cidr          = ["10.0.8.128/28","10.0.8.144/28"]
private-subnet-name           = "test-dev-private-subnet"
nat-gateway-name              = "test-dev-nat-gateway"
private-rt-name               = "test-dev-private-routetable"
sg-name                       = "test-sg"

# Variables of Project and Environment tagging
tags={
"Environment" = "dev"
"Project" = "Test"}
