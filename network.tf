resource "aws_vpc" "techConsultingVpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = var.instance_tenancy

  tags = merge(
    var.tags,
    {
      Name = "tech_consulting_Vpc"
    },
  )
}

resource "aws_internet_gateway" "techConsultingIGW" {
  vpc_id = aws_vpc.techConsultingVpc.id

  tags = merge(
    var.tags,
    {
      Name = "techConsultingIGW"
    },
  )
}

resource "aws_subnet" "techConsultingPublicSubnet1" {
  cidr_block = var.pub_subnet1_cidr_block
  vpc_id = aws_vpc.techConsultingVpc.id
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "techConsultingPublicSubnet1"
    },
  )
}

resource "aws_subnet" "techConsultingPublicSubnet2" {
  cidr_block = var.pub_subnet2_cidr_block
  vpc_id = aws_vpc.techConsultingVpc.id
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "techConsultingPublicSubnet2"
    },
  )
}

resource "aws_subnet" "techConsultingPrivateSubnet1" {
  cidr_block = var.pvt_subnet1_cidr_block
  vpc_id = aws_vpc.techConsultingVpc.id

  tags = merge(
    var.tags,
    {
      Name = "techConsultingPrivateSubnet1"
    },
  )
}

resource "aws_route_table" "techConsultingPublicRT1" {
  vpc_id = aws_vpc.techConsultingVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techConsultingIGW.id
  }

  tags = merge(
    var.tags,
    {
      Name = "PublicRT1"
    },
  )
}

resource "aws_route_table" "techConsultingPublicRT2" {
  vpc_id = aws_vpc.techConsultingVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techConsultingIGW.id
  }

  tags = merge(
    var.tags,
    {
      Name = "PublicRT2"
    },
  )
}

resource "aws_route_table_association" "PublicRTAssociation1" {
  subnet_id      = aws_subnet.techConsultingPublicSubnet1.id
  route_table_id = aws_route_table.techConsultingPublicRT1.id
}

resource "aws_route_table_association" "PublicRTAssociation2" {
  subnet_id      = aws_subnet.techConsultingPublicSubnet2.id
  route_table_id = aws_route_table.techConsultingPublicRT2.id
}

resource "aws_eip" "NATEIP" {
  domain = "vpc"
}

resource "aws_nat_gateway" "techConsultingNATGW" {
  allocation_id = aws_eip.NATEIP.id
  subnet_id     = aws_subnet.techConsultingPublicSubnet1.id

  tags = merge(
    var.tags,
    {
      Name = "techConsultingNATGW"
    },
  )

  depends_on = [aws_internet_gateway.techConsultingIGW]
}

resource "aws_route_table" "techConsultingPrivateRT" {
  vpc_id = aws_vpc.techConsultingVpc.id

  route {
    cidr_block     = "0.0.0.0/0"  # Allow all outbound traffic
    nat_gateway_id = aws_nat_gateway.techConsultingNATGW.id
  }

  tags = merge(
    var.tags,
    {
      Name = "PrivateRT"
    },
  )
}

resource "aws_route_table_association" "PrivateRTAssociation1" {
  subnet_id      = aws_subnet.techConsultingPrivateSubnet1.id
  route_table_id = aws_route_table.techConsultingPrivateRT.id
}
