resource "aws_vpc" "dragons_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "deploydragons-vpc" }
}

resource "aws_subnet" "dragons_subnet" {
  vpc_id                  = aws_vpc.dragons_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"
  tags = { Name = "deploydragons-subnet" }
}

resource "aws_internet_gateway" "dragons_igw" {
  vpc_id = aws_vpc.dragons_vpc.id
}

resource "aws_route_table" "dragons_route_table" {
  vpc_id = aws_vpc.dragons_vpc.id
}

resource "aws_route" "dragons_route" {
  route_table_id         = aws_route_table.dragons_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dragons_igw.id
}

resource "aws_route_table_association" "dragons_association" {
  subnet_id      = aws_subnet.dragons_subnet.id
  route_table_id = aws_route_table.dragons_route_table.id
}

resource "aws_security_group" "dragons_sg" {
  vpc_id = aws_vpc.dragons_vpc.id
  name   = "dragons-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}