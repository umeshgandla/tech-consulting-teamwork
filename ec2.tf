# TLS Private Key for Key Pair
resource "tls_private_key" "techConsultingKeyPair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS Key Pair using the TLS Public Key
resource "aws_key_pair" "techConsultingKeyPair" {
  key_name   = var.key_name
  public_key = tls_private_key.techConsultingKeyPair.public_key_openssh
}

# Security Group
resource "aws_security_group" "techConsultingSG" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.techConsultingVpc.id  # Updated reference to VPC

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }
}

# Launch Template
resource "aws_launch_template" "techConsultingLaunchTemplate" {
  name_prefix   = "techConsulting-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.techConsultingKeyPair.key_name

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y httpd

# Set up instance-specific data
if [ "\$INSTANCE_TYPE" == "web_server_1" ]; then
    echo "Tech Consulting Web Server 1" > /var/www/html/index.html
elif [ "\$INSTANCE_TYPE" == "web_server_2" ]; then
    echo "Tech Consulting Web Server 2" > /var/www/html/index.html
fi

service httpd start
chkconfig httpd on
EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "techConsultingASG" {
  launch_template {
    id      = aws_launch_template.techConsultingLaunchTemplate.id
    version = "$Latest"
  }

  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = [
    aws_subnet.techConsultingPublicSubnet1.id,  # Updated references
    aws_subnet.techConsultingPublicSubnet2.id,
  ]
  health_check_type   = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "techConsultingWebServer"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = "dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "InstanceType"
    value               = "web_server"
    propagate_at_launch = true
  }

  depends_on = [
    aws_security_group.techConsultingSG,
    aws_key_pair.techConsultingKeyPair,
  ]
}

# Load Balancer
resource "aws_lb" "techConsultingLB" {
  name               = "techConsultingLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.techConsultingSG.id]
  subnets            = [
    aws_subnet.techConsultingPublicSubnet1.id,
    aws_subnet.techConsultingPublicSubnet2.id,
  ]

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "techConsultingLB"
    },
  )

  depends_on = [
    aws_security_group.techConsultingSG,
  ]
}

# Target Group
resource "aws_lb_target_group" "techConsultingTG" {
  name     = "techConsultingTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.techConsultingVpc.id  # Updated reference to VPC

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}

# Attach Auto Scaling Group to Target Group
resource "aws_autoscaling_attachment" "techConsultingASGAttachment" {
  autoscaling_group_name = aws_autoscaling_group.techConsultingASG.id
  lb_target_group_arn   = aws_lb_target_group.techConsultingTG.arn

  depends_on = [
    aws_autoscaling_group.techConsultingASG,
    aws_lb_target_group.techConsultingTG,
  ]
}

# Listener for Load Balancer
resource "aws_lb_listener" "techConsultingListener" {
  load_balancer_arn = aws_lb.techConsultingLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.techConsultingTG.arn
  }

  depends_on = [
    aws_lb.techConsultingLB,
  ]
}



