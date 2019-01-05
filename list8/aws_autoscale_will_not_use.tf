provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

data "aws_ami" "hello_autoscale" {
  most_recent = true

  filter {
    name   = "name"
    values = ["image-for-lc"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["962691467482"] # Me
}

resource "aws_launch_configuration" "http_launch_conf" {
  name_prefix   = "http_launch_conf-lc-"
  image_id      = "${data.aws_ami.hello_autoscale.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "http_group" {
  name                 = "http_group"
  launch_configuration = "${aws_launch_configuration.http_launch_conf.name}"
  min_size             = 2
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}