####################
# ALB
####################
resource "aws_lb" "alb" {
  name               = "alb-terraformer-dev"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb.id
  ]
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]

  tags = {
    Environment = "dev"
  }
}

####################
# Target Group
####################
resource "aws_lb_target_group" "alb" {
  name                 = "terraformer-dev-tg"
  port                 = "80"
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = "60"

  health_check {
    interval            = "10"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "4"
    healthy_threshold   = "2"
    unhealthy_threshold = "10"
    matcher             = "200"
  }

  tags = {
    Environment = "dev"
  }
}

####################
# Listener
####################
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}
