provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_security_group" "www_group" {

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["156.17.4.0/24"]
  }

  # I don't have fixed ip :<
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


}

resource "aws_instance" "www" {
  ami             = "ami-7d482305" # ubuntu with python
  instance_type   = "t2.micro"
  key_name        = "cloud2018"
  subnet_id       = "subnet-c620229e" # 172.31.0.0/20
  vpc_security_group_ids = ["${aws_security_group.www_group.id}"]

  tags {
    Name = "www"
  }
}

resource "aws_security_group" "db_group" {

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_instance.www.public_ip}/32"]
  }

}

resource "aws_db_instance" "db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = "foo"
  password               = "foobarbaz"
  vpc_security_group_ids = ["${aws_security_group.db_group.id}"]
}
