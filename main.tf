resource "aws_vpc" "borosil" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.borosil.id
  cidr_block = "10.0.0.0/18"

  tags = {
    Name = "dmz_public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.borosil.id
  cidr_block = "10.0.64.0/18"

  tags = {
    Name = "dmz_private"
  }
}

resource "aws_subnet" "protected" {
  vpc_id     = aws_vpc.borosil.id
  cidr_block = "10.0.128.0/18"

  tags = {
    Name = "dmz_protected"
  }
}

resource "aws_subnet" "secure" {
  vpc_id     = aws_vpc.borosil.id
  cidr_block = "10.0.192.0/18"

  tags = {
    Name = "dmz_secure"
  }
}

resource "aws_internet_gateway" "borosil_igw" {
  vpc_id = aws_vpc.borosil.id

  tags = {
    Name = "borosil_IGW"
  }
}

resource "aws_route_table" "dmz_public_rt" {
  vpc_id = aws_vpc.borosil.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.borosil_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  route_table_id = aws_route_table.dmz_public_rt.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.borosil.id

  # to and from public subnet
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/18"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 120
    action     = "allow"
    cidr_block = "10.0.0.0/18"
    from_port  = 0
    to_port    = 0
  }

  # to and from protected subnet
  egress {
    protocol   = "-1"
    rule_no    = 110
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }


  ingress {
    protocol   = "-1"
    rule_no    = 130
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "private_NACL"
  }
}

resource "aws_network_acl" "protected_nacl" {
  vpc_id = aws_vpc.borosil.id

  # to and from secure subnet
  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.192.0/18"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 220
    action     = "allow"
    cidr_block = "10.0.192.0/18"
    from_port  = 0
    to_port    = 0
  }

  # to and from protected subnet
  egress {
    protocol   = "-1"
    rule_no    = 210
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 230
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "protected_NACL"
  }
}


resource "aws_network_acl" "secure_nacl" {
  vpc_id = aws_vpc.borosil.id

  # to and from protected subnet
  egress {
    protocol   = "-1"
    rule_no    = 310
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 320
    action     = "allow"
    cidr_block = "10.0.128.0/18"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "secure_NACL"
  }
}

# NACL associations 

resource "aws_network_acl_association" "private_nacl_association" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_network_acl_association" "protected_nacl_association" {
  network_acl_id = aws_network_acl.protected_nacl.id
  subnet_id      = aws_subnet.protected.id
}

resource "aws_network_acl_association" "secure_nacl_association" {
  network_acl_id = aws_network_acl.secure_nacl.id
  subnet_id      = aws_subnet.secure.id
}

# resource "aws_instance" "borosil_compute_engine" {

# }
