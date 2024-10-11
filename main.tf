terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.70.0"
        }
    }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "amazon-linux-instance" {
    instance_type = "t2.micro"
    ami = "ami-0592c673f0b1e7665"

    tags = {
        Name = "amazon-linux-instance"
    }
}

resource "aws_instance" "ubuntu-instance" {
    instance_type = "t2.micro"
    ami = "ami-0084a47cc718c111a"

    tags = {
        Name = "ubuntu-instance"
    }
}
