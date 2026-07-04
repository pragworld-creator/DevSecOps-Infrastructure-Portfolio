resource "aws_vpc" "main" {
cidr_block = var.vpc_cidr
enable_dns_support   = true
enable_dns_hostnames = true

tags = {
    name = "${var.environment}-vpc"
    environment = var.environment
 }
}

resource "aws_subnet" "public_subnet" {
    for_each = var.public_subnet
    vpc_id = aws_vpc.main.id
    availability_zone = each.key
    cidr_block = each.value

    map_public_ip_on_launch = true

    tags = {
        name = "${var.environment}-public_subnet"
        environment = var.environment
    }
}

resource "aws_subnet" "private_subnet" {
    for_each = var.private_subnet
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = each.key

    tags = {
        name = "$(var.environment)-private_subnet"
        environment = var.environment
    }
}

resource "aws_subnet" database_subnet {
    for_each = var.database_subnet
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = each.key

    tags = {
        name = "$(var.environment)-database_subnet"
        environmet = var.environment
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

   tags = {
        name = "$(var.environment)-igw"
        environmet = var.environment
    }
}

resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        name = "$(var.environment)-eip"
        environmet = var.environment
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = values(aws_subnet.public_subnet)[0].id

    depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
     }
    tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public_subnet

    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
    for_each = aws_subnet.private_subnet

    subnet_id = each.value.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database_subnet

  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "main" {
    name = "${var.environment}-db-subnet-gp"
    subnet_ids = [for subnet in aws_subnet.database_subnet : subnet.id]

    tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

