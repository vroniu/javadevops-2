output "private_key" {
    description = "Private key for logging into the EC2 instances"
    value = tls_private_key.rsa.private_key_pem
    sensitive = true
}

output "ubuntu_public_ip" {
    description = "Public IP to connect to the Ubuntu EC2 instance"
    value = aws_instance.ubuntu-instance.public_ip
}

output "ubuntu_private_ip" {
    description = "Private IP of the Ubuntu EC2 instance"
    value = aws_instance.ubuntu-instance.private_ip
}

output "amazon_linux_private_ip" {
    description = "Private IP of the Amazon Linux EC2 instance"
    value = aws_instance.amazon-linux-instance.private_ip
}