#---------------Load balancer---------------------

resource "aws_lb" "bslb" {
  name               = "bslb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.ec2_sg_group
  subnets            = [var.public_subnet , var.private_subnet]


  tags = {
    Enviroment = "test"
  }
}

