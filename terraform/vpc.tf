
resource "aws_vpc" "projVpc" {
    cidr_block = "10.10.0.0/16"
    tags = {
       Name = "lightfeather-vpc"
    }
}

resource "aws_internet_gateway" "lfGateway" {
  vpc_id = aws_vpc.projVpc.id
  tags = {
    Name = "lightfeather-internet-gateway"
  }
}

resource "aws_subnet" "publicSubnet1" {
  vpc_id = aws_vpc.projVpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1a-subnet"
  }
}
resource "aws_subnet" "publicSubnet2" {
  vpc_id = aws_vpc.projVpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1b-subnet"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.projVpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lfGateway.id
  }

  tags = {
    Name = "lightfeather-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc_1" {
    subnet_id = aws_subnet.publicSubnet1.id
    route_table_id = aws_route_table.publicRouteTable.id
}
resource "aws_route_table_association" "public_assoc_2" {
    subnet_id = aws_subnet.publicSubnet2.id
    route_table_id = aws_route_table.publicRouteTable.id
}