resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.prefix}-vpc"
  }
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
