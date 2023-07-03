resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc-cidr
    instance_tenancy      = "default"
    enable_dns_hostnames  = true
  tags = merge(
  var.tags,
  tomap({"Name" = var.vpc-name})
    )
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id                  = aws_vpc.vpc.id
  tags = merge(
  var.tags,
  tomap({"Name" = var.internet-gateway-name})
    )
}

resource "aws_route_table" "public-rt" {
  vpc_id                  = aws_vpc.vpc.id

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.internet-gateway.id
  }

  route {
    ipv6_cidr_block       = "::/0"
    gateway_id            = aws_internet_gateway.internet-gateway.id
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = var.public-rt-name })
  )
}

resource "aws_subnet" "public-subnet" {
  count                   = length(var.public-subnets-cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public-subnets-cidr, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags = merge(
  var.tags,
  tomap({"Name" = var.public-subnet-name})
    )
}

resource "aws_route_table_association" "public-rt-association" {
  count                 = length(var.public-subnets-cidr)
  subnet_id             = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id        = aws_route_table.public-rt.id
}

resource "aws_subnet" "private-subnet" {
  count                   = length(var.private-subnets-cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private-subnets-cidr, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = merge(
  var.tags,
  tomap({"Name" = var.private-subnet-name})
   )
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gateway" {
  connectivity_type       = "public"
  allocation_id           = aws_eip.nat.id
  subnet_id               = aws_subnet.public-subnet.*.id[0]

  tags = merge(
  var.tags,
  tomap({"Name" = var.nat-gateway-name })
    )
}

resource "aws_route_table" "private-rt" {
  depends_on = [aws_subnet.private-subnet, aws_nat_gateway.nat-gateway]
  vpc_id                  = aws_vpc.vpc.id

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.nat-gateway.id
  }
  tags = merge(
    var.tags,
    tomap({ "Name" = var.private-rt-name })
  )
}

resource "aws_route_table_association" "private-rt-association" {
    count                 = length(var.private-subnets-cidr)
    subnet_id             = element(aws_subnet.private-subnet.*.id, count.index)
    route_table_id        = aws_route_table.private-rt.id
}

resource "aws_security_group" "security-group" {
  name                    = var.sg-name
  description             = "Creating a security group"
  vpc_id                  = aws_vpc.vpc.id

  ingress {
    description           = "TLS from VPC"
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    cidr_blocks           = [var.vpc-cidr]

  }
  ingress {
    description           = "TLS from VPC"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]

  }

  ingress {
    description           = "Container Port Range"
    from_port             = 5000
    to_port               = 5200
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    description           = "TLS from VPC"
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    description           = "TLS from VPC"
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }

    egress {
    description           = "Container Port Range"
    from_port             = 5000
    to_port               = 5200
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }


  tags = merge(
    var.tags,
    tomap({ "Name" = var.sg-name })
  )
}
