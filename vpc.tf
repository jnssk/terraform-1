resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = "true"

  tags = {
    Name = var.vpc_name

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}

# route tables

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.pub_rt_name
  }
}



#public subnets

resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "public_subnet-${count.index+1}"


  }
}
resource "aws_route_table_association" "public-rt-ass" {
  count = length(var.subnet_cidr)
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}



