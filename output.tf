output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.techConsultingVpc.id
}

output "public_subnet_1_id" {
  description = "ID of Public Subnet 1"
  value       = aws_subnet.techConsultingPublicSubnet1.id
}

output "public_subnet_2_id" {
  description = "ID of Public Subnet 2"
  value       = aws_subnet.techConsultingPublicSubnet2.id
}

output "private_subnet_1_id" {
  description = "ID of Private Subnet 1"
  value       = aws_subnet.techConsultingPrivateSubnet1.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.techConsultingIGW.id
}

output "public_route_table_1_id" {
  description = "ID of Public Route Table 1"
  value       = aws_route_table.techConsultingPublicRT1.id
}

output "public_route_table_2_id" {
  description = "ID of Public Route Table 2"
  value       = aws_route_table.techConsultingPublicRT2.id
}

output "private_route_table_id" {
  description = "ID of Private Route Table"
  value       = aws_route_table.techConsultingPrivateRT.id
}

output "eip_id" {
  description = "ID of the Elastic IP (EIP)"
  value       = aws_eip.NATEIP.id
}

output "availability_zones" {
  description = "List of Availability Zones used"
  value       = var.availability_zones
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.techConsultingLaunchTemplate.id
}

output "auto_scaling_group_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.techConsultingASG.id
}

output "load_balancer_dns" {
  description = "DNS of the Load Balancer"
  value       = aws_lb.techConsultingLB.dns_name
}

output "private_key" {
  value     = tls_private_key.techConsultingKeyPair.private_key_pem
  sensitive = true
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.techConsultingNATGW.id
}

# Output for ASG Instance IDs
output "asg_instance_ids" {
  description = "IDs of the instances in the Auto Scaling Group"
  value       = aws_autoscaling_group.techConsultingASG.id
}
