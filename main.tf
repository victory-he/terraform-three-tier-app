terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "my-tf-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TF Demo VPC"
  }
}

# Create Web Public Subnet
resource "aws_subnet" "tf-web-subnet-1" {
  vpc_id                  = aws_vpc.my-tf-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-1a"
  }
}

resource "aws_subnet" "tf-web-subnet-2" {
  vpc_id                  = aws_vpc.my-tf-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-2b"
  }
}

# Create Application Private Subnet
resource "aws_subnet" "tf-app-subnet-1" {
  vpc_id                  = aws_vpc.my-tf-vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Application-1a"
  }
}

resource "aws_subnet" "tf-app-subnet-2" {
  vpc_id                  = aws_vpc.my-tf-vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Application-2b"
  }
}

# Create Database Private Subnet
resource "aws_subnet" "tf-db-subnet-1" {
  vpc_id            = aws_vpc.my-tf-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database-1a"
  }
}

resource "aws_subnet" "tf-db-subnet-2" {
  vpc_id            = aws_vpc.my-tf-vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database-2b"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.my-tf-vpc.id

  tags = {
    Name = "Demo IGW"
  }
}

# Create Web layber route table
resource "aws_route_table" "tf-web-rt" {
  vpc_id = aws_vpc.my-tf-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "WebRT"
  }
}

# Create Web Subnet association with Web route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.tf-web-subnet-1.id
  route_table_id = aws_route_table.tf-web-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.tf-web-subnet-2.id
  route_table_id = aws_route_table.tf-web-rt.id
}
