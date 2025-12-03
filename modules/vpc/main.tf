resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.project}-${terraform.workspace}"
  }
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

resource "aws_subnet" "private" {
  count             = length(var.subnet_cidrs_private)
  cidr_block        = element(var.subnet_cidrs_private, count.index)
  availability_zone = element(var.availability_zone, count.index)
  vpc_id            = aws_vpc.main.id
  # map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${terraform.workspace}-private-subnet-${count.index + 1}"
    AZ   = "${element(var.availability_zone, count.index)}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidrs_public)
  cidr_block              = element(var.subnet_cidrs_public, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${terraform.workspace}-public-subnet-${count.index + 1}"
    AZ   = "${element(var.availability_zone, count.index)}"
  }
}

### internet gateway

resource "aws_internet_gateway" "igw" {
  count  = var.igw ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${terraform.workspace}-igw"
  }
}


# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "natgw" {
  count  = var.ngw ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.project}-${terraform.workspace}-natgw"
  }

  # depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  count  = var.ngw ? 1 : 0
  domain = "vpc"
}

### Route Tables

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${terraform.workspace}-public-route-table"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${terraform.workspace}-private-route-table"
  }
}

# Route to Internet Gateway(public)
resource "aws_route" "public" {
  count                  = var.igw ? 1 : 0
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route" "private" {
  count                  = var.ngw ? 1 : 0
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id             = aws_nat_gateway.natgw[0].id
}

# Route table subnet assossiation
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidrs_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "private" {
  count = var.ngw ? length(var.subnet_cidrs_private) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-igw" {
  count = var.ngw ? 0 : length(var.subnet_cidrs_private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.public_rt.id
}