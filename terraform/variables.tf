#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "practice"
}

variable "environment" {
    description = "Environment for service"
    default     = "practice"
}

variable "availability_zone" {
  default = "us-west-2"
}

variable "aws_access_key" {
  description = "Your aws access key"
}

variable "aws_secret_key" {
  description = "Your aws secret key"
}

variable "my_ip_address" {
  description = "My white ip address"
}

#---------------------------------------------------------------
# Task definition
#---------------------------------------------------------------

variable "ecs_image" {
  description = "docker image"
  default     = "primaart/practice:apache"
}

variable "ecs_essential" {
  description = "Essential"
  default     = "true"
}

variable "ecs_container_port" {
  description = "Container Port"
  default     = "80"
}

variable "ecs_host_port" {
  description = "Host Port"
  default     = "80"
}

variable "task_definition_memory" {
  description = "Memory for container"
  default     = "512"
}

variable "task_definition_cpu" {
  description = "CPU for container"
  default     = "256"
}

variable "task_definition_network_mode" {
  description  = "network mode for task definition"
  default     = "awsvpc"
}

variable "td_requires_compatibilities" {
  description = "Requires_compatibilities"
  default     = "FARGATE"
}

#---------------------------------------------------------------
# ECS Service
#---------------------------------------------------------------

variable "ecs_assign_public_ip" {
  description = "Assign public ip"
  default     = "true"
}

#---------------------------------------------------------------
# Subnet
#---------------------------------------------------------------

variable "subnet_a" {
  description = "Default subnet"
  default     = "us-west-2a"
}

#---------------------------------------------------------------
# IAM role
#---------------------------------------------------------------

variable "iam_name" {
  description = "Name of iam role"
  default     = "ecsTaskExecutionRole"
}

variable "iam_policy_arn" {
  description = "Policy ARN for policy attachment"
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#---------------------------------------------------------------
# Tags
#---------------------------------------------------------------

variable "data_creation" {
    description = "Data creation"
    default     = "9/6/2021"
}

variable "your_first_name" {
    description = "first name"
    default     = "Artyom"
}

variable "your_last_name" {
    description = "last name"
    default     = "Prima"
}

variable "aws_account_id" {
    description = "account id"
    default     = "263199259485"
}

#---------------------------------------------------------------
# SG variables
#---------------------------------------------------------------
variable "vpc" {
  description  = "VPC id"
  default      = "vpc-dcc9c9a4"
}

variable "allowed_ports" {
  description = "Allowed ports from/to host"
  type        = list
  default     = ["22", "80", "443", "8080", "8443"]
}

variable "enable_all_egress_ports" {
    description = "Allows all ports from host"
    default     = false
}

