variable "region" {
  description = "Default region for my manifest"
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    "Name1" = "umesh"
    "Name2" = "karam"
    "Name3" = "habtamu"
    "Name4" = "ashley"
    "Env"   = "dev"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "Tenancy of instances in the VPC"
  default     = "default"
}

variable "pub_subnet1_cidr_block" {
  description = "CIDR block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "pub_subnet2_cidr_block" {
  description = "CIDR block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

variable "pvt_subnet1_cidr_block" {
  description = "CIDR block for Private Subnet 1"
  default     = "10.0.3.0/24"
}

variable "my_ipaddress" {
  description = "Your public IP address for SSH access"
  default     = "98.252.188.217/32"
}

variable "ami" {
  description = "AMI ID for the web server"
  default     = "ami-06b21ccaeff8cd686"
}

variable "instance_type" {
  description = "Instance type for the web server"
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP with the instance"
  default     = true
}

variable "availability_zones" {
  description = "List of Availability Zones for creating subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "key_name" {
  description = "Key pair name for SSH access to the web server"
  default     = "techConsulting-keypair"
}

variable "security_group_name" {
  description = "Name of the security group for the web server"
  default     = "techConsultingSG"
}

variable "security_group_description" {
  description = "Description for the web server's security group"
  default     = "Allow HTTP and SSH access"
}

variable "security_group_ingress" {
  description = "Ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow incoming HTTP traffic on port 80"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = []  # Placeholder
      description = "Allow SSH access"
    }
  ]
}

variable "security_group_egress" {
  description = "Egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

