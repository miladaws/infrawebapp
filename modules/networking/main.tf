resource "aws_vpc" "InfraWebAppVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "InfraWebAppVPC"
  }
}

resource "aws_subnet" "InfraWebAppSubnet_a" {
  vpc_id = aws_vpc.InfraWebAppVPC.id
  cidr_block = "10.0.1.0/24" 
  availability_zone = "eu-central-1a"

  tags = {
    Name = "InfraWebAppSubnet_a"
  }
}

resource "aws_subnet" "InfraWebAppSubnet_b" {
  vpc_id = aws_vpc.InfraWebAppVPC.id
  cidr_block = "10.0.2.0/24" 
  availability_zone = "eu-central-1b"

  tags = {
    Name = "InfraWebAppSubnet_b"
  }
}
