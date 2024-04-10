# ec2 application security group allows only inbound traffic from loadbalancer

module "docker_host_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

    ingress_with_source_security_group_id = [
        {
            from_port = 80
            to_port   = 80
            protocol = "tcp"
            description = "allow traffic from alb"
            source_security_group_id = module.alb.security_group_id
        }
    ]

      egress_with_cidr_blocks = [
    
    {
            from_port = 0
            to_port = 65535
            protocol = "-1"
            description = "Allow all egress traffic"
            cidr_blocks = "0.0.0.0/0"
    }

  ]

}

