terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.70.0"
        }
        tls = {
            source = "hashicorp/tls"
            version = "4.0.6"
        }
        local = {
            source = "hashicorp/local"
            version = "2.5.2"
        }
    }
}

provider "aws" {
    region = "eu-central-1"
}

// Set up a VPC with a public subnet for instances
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/28"
    enable_dns_hostnames = true

    tags = {
        Name = "VPC for Task 2"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/28"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet for Task 2"
    }
}

// Connect the public subnet to the internet via Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "Internet Gateway for Task 2"
    }
}

resource "aws_route_table" "internet-access-route" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "public-subnet-internet-gateway-connection" {
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.internet-access-route.id
}

// Security group that allows access in/out
resource "aws_security_group" "sg-allow-internet-access" {
    name = "allow-internet-access"
    vpc_id = aws_vpc.main.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

// Set up key-pair to log in to the instances via SSH
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "ssh-keypair" {
    key_name = "ssh-keypair"
    public_key = tls_private_key.rsa.public_key_openssh
}

// Export the private key to a file so that you can log in
resource "local_file" "ssh-keypair-private-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "e2-key.pem"
}

resource "aws_instance" "amazon-linux-instance" {
    instance_type = "t2.micro"
    ami = "ami-0592c673f0b1e7665"
    subnet_id = aws_subnet.public-subnet.id
    key_name = "ssh-keypair"

    tags = {
        Name = "amazon-linux-instance"
    }
}

resource "aws_instance" "ubuntu-instance" {
    instance_type = "t2.micro"
    ami = "ami-0084a47cc718c111a"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.sg-allow-internet-access.id]
    key_name = "ssh-keypair"

    tags = {
        Name = "ubuntu-instance"
    }
}
