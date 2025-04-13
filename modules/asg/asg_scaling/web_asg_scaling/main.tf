resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.autoscaling_group_name}-scale-out"
  scaling_adjustment     = var.scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.autoscaling_cooldown
  autoscaling_group_name = var.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.autoscaling_group_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = var.cpu_scale_out_threshold
  alarm_description   = "Scale out when CPU > ${var.cpu_scale_out_threshold}%"
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}


resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.autoscaling_group_name}-scale-in"
  scaling_adjustment     = var.scale_in_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.autoscaling_cooldown
  autoscaling_group_name = var.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.autoscaling_group_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_scale_in_threshold
  alarm_description   = "Scale in when CPU < ${var.cpu_scale_in_threshold}%"
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
