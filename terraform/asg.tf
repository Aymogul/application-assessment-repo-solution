# Create launch template
resource "aws_launch_template" "docker_lt" {
  name_prefix   = "docker_lt"
  image_id      = "ami-0c1c30571d2dae5c9"  # Update with your desired Docker AMI
  instance_type = "t2.micro"                # Update with your desired instance type
  vpc_security_group_ids = [ module.docker_host_sg.security_group_id ]
  

  user_data = filebase64("script.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "DockerInstance"
    }
  }
}

# resource "aws_autoscaling_policy" "bat" {
#   name                   = "docker_lt-policy"
#   policy_type        = "PredictiveScaling"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.docker_asg.name
#   predictive_scaling_configuration {
#     metric_specification {
#       target_value = 50
#       predefined_load_metric_specification {
#         predefined_metric_type = "ASGTotalCPUUtilization"
#       }
#     }
#   }
# }

# Create Auto Scaling Group
resource "aws_autoscaling_group" "docker_asg" {
  launch_template {
    id      = aws_launch_template.docker_lt.id
    version = aws_launch_template.docker_lt.latest_version
  }


  target_group_arns = [ module.alb.target_groups["ex-instance"].arn ]

  min_size                   = 1
  max_size                   = 2
  desired_capacity           = 1
  
  force_delete = true
  vpc_zone_identifier        = module.vpc.private_subnets
  health_check_type          = "EC2"
  health_check_grace_period  = 300
  termination_policies       = ["OldestInstance"]

  instance_refresh {
    strategy = "Rolling"
  }

}
