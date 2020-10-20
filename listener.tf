#-----------Listener--------
resource "aws_lb_listener" "bslis" {
  load_balancer_arn = aws_lb.bslb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.bstg.arn
    type             = "forward"

  }
}

#----------Attaching instance to target group----------

resource "aws_lb_target_group_attachment" "bstgat" {
  target_group_arn = aws_lb_target_group.bstg.arn
  target_id        = aws_instance.bsins.id
  port             = 80
}

