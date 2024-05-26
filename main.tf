terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

}
// Configure the AWS Provider
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}
// Criando o Bucket
resource "aws_s3_bucket" "meu_bucket" {
  bucket = var.bucket_name
  tags = {
    Nome = "Meu Bucket Terraform"
  }
}
// Criando o EC2 RabbitMQ
resource "aws_instance" "aws_rabbitmq" {
  ami           = "ami-036c2987dfef867fb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  user_data     = <<-EOF
    #!/bin/bash
    sudo yum -y install wget
    sudo yum -y install epel-release
    sudo yum -y update
    wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
    sudo rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
    sudo yum -y install erlang
    sudo rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    sudo yum -y install rabbitmq-server
    sudo systemctl start rabbitmq-server
    sudo systemctl enable rabbitmq-server
    EOF
  tags = {
    Name = "EC2 server rabbitmq"
  }
}
// Criando o EC2 Redis
resource "aws_instance" "aws_redis" {
  ami           = "ami-036c2987dfef867fb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  depends_on    = [aws_s3_bucket.meu_bucket]
  user_data     = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y gcc
    sudo yum install -y redis
    sudo systemctl start redis
    sudo systemctl enable redis
    EOF
  tags = {
    Name = "EC2 server redis"
  }
}
// Criando o EC2 Minio
resource "aws_instance" "aws_minio" {
  ami           = "ami-036c2987dfef867fb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  depends_on    = [aws_s3_bucket.meu_bucket]
  user_data     = <<-EOF
    #!/bin/bash
    wget https://dl.min.io/server/minio/release/linux-amd64/minio
    chmod +x minio
    ./minio server /data
    EOF
  tags = {
    Name = "EC2 server minio"
  }
}
// Criando o EC2 Send
resource "aws_instance" "aws_send" {
  ami           = "ami-036c2987dfef867fb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = "EC2 server send"
  }
}
// Criando o EC2 Received
resource "aws_instance" "aws_received" {
  ami           = "ami-036c2987dfef867fb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = "EC2 server received"
  }
}
// Criando a subnet
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.subnet.id
  cidr_block = "10.0.1.0/24"

}
// Criando o VPC
resource "aws_vpc" "subnet" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "VPC subnet"
  }
}

