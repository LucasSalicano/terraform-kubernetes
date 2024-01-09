resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }  

  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = 2
  subnet_id = aws_subnet.subnets.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnets" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}
