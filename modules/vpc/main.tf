resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true 
    
    tags = merge(
        var.tags,
        { 
        Name = var.name     
    })
}

resource "aws_internet_gateway" "main_igw" {
   vpc_id = aws_vpc.main_vpc.id 
 
   tags = {
      Name = "${var.name}-igw"  
   } 
}

resource "aws_subnet" "main_public_subnet" {
    count = length(var.public_subnets)

    vpc_id = aws_vpc.main_vpc.id 
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = true 

    tags = merge(
      var.tags,
      {
        Name = "${var.name}-public-subnet-${count.index}"
      },
      var.cluster_name != null &&   var.cluster_name !="" ? {
         "kubernetes.io/role/elb"                    = "1"
         "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
      } : {} 
    )
}

resource "aws_subnet" "main_private_subnet" {
    count = length(var.private_subnets)

    vpc_id = aws_vpc.main_vpc.id 
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.azs[count.index]

    tags = merge(
        var.tags,
        {
            Name = "${var.name}-private-subnet-${count.index}"
        },
        var.cluster_name != null &&   var.cluster_name !="" ? {
         "kubernetes.io/role/elb"                    = "1"
         "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
        } : {} 
    )
}

resource "aws_eip" "nat" {
   count = var.enable_nat_gateway ? 1 : 0 
   domain = "vpc" 
}

resource "aws_nat_gateway" "main_nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0  
  allocation_id = aws_eip.nat[0].id 
  subnet_id = aws_subnet.main_public_subnet[0].id  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id 

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id 

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route" "public_igw" {
  route_table_id = aws_route_table.public_rt.id 
  destination_cidr_block = "0.0.0.0/0" 
  gateway_id = aws_internet_gateway.main_igw.id 
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0  
  route_table_id = aws_route_table.private_rt.id 
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main_nat_gateway[0].id 
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.main_public_subnet)
  subnet_id = aws_subnet.main_public_subnet[count.index].id 
  route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.main_private_subnet)
  subnet_id = aws_subnet.main_private_subnet[count.index].id 
  route_table_id = aws_route_table.private_rt.id 
}