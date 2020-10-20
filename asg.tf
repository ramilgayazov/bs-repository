#----------Auto Scaling Group -----
resource "aws_autoscaling_group" "bsasg" {
  name = "bsasg"
  max_size = var.asg_max
  min_size = var.asg_min
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 1
  force_delete = true
  launch_configuration = aws_launch_configuration.bslc.name
  vpc_zone_identifier = [var.private_subnet]

  tag {
    key = "Name"
    value = "bs"
    propagate_at_launch = true
  }

  lifecycle {
      create_before_destroy = true
  }
}

#------------ASG attaching to TargetGroup---------

resource "aws_autoscaling_attachment" "bstgasgat" {
  autoscaling_group_name = aws_autoscaling_group.bsasg.id
  alb_target_group_arn   = aws_lb_target_group.bstg.arn
}

#------------ASG Policy-----------------------------
# scale up alarm

resource "aws_autoscaling_policy" "as-policy-up" {
  name                   = "as-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bsasg.name
  policy_type = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name = "cpu_alarm"
  alarm_description = "cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = var.scale_up
  dimensions = {
  "AutoScalingGroupName" = aws_autoscaling_group.bsasg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.as-policy-up.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu-policy-down" {
  name = "cpu-policy-down"
  autoscaling_group_name = aws_autoscaling_group.bsasg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = 300
  policy_type = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name = "cpu-alarm-scaledown"
  alarm_description = "cpu-alarm-scaledown"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 600
  statistic = "Average"
  threshold = var.scale_down
  dimensions = {
  "AutoScalingGroupName" = aws_autoscaling_group.bsasg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.cpu-policy-down.arn]
}
                                                                 
