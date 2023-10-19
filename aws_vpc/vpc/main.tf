resource "aws_vpc" "my-vpc-1" {
  cidr_block = var.cidr_block
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "my-igw-1" {
  vpc_id = aws_vpc.my-vpc-1.id
  tags = {
    Name = "my-in-gate-way"
  }
}

resource "aws_route_table" "my_rt_1" {
  vpc_id = aws_vpc.my-vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw-1.id
  }
  tags = {
    Name = "my-rt"
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.my-vpc-1.id
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}


resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.my-vpc-1.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}


resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.my_rt_1.id
}

resource "aws_instance" "my-instance" {
  ami           = "ami-0df435f331839b2d6"
  instance_type = "t2.micro"
  key_name      = "mk"
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    name = "modi_ec2"
  }
}
