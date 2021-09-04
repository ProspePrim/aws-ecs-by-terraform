#
# MAINTAINER Prima Artyom "artyom.prima@yandex.kz"
#
terraform {
  required_version = "> 0.12.0"
}

provider "aws" {
    region               	= var.availability_zone
    access_key          	= var.aws_access_key
    secret_key          	= var.aws_secret_key
}

#---------------------------------------------------
#  Create ecs cluster
#---------------------------------------------------

resource "aws_ecs_cluster" "practice" {
  name = var.name # Naming the cluster
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
    }
}

#---------------------------------------------------
#  Create task definition
#---------------------------------------------------

resource "aws_ecs_task_definition" "practice" {
  family                = var.name
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.name}",
      "image": "${var.ecs_image}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.ecs_container_port},
          "hostPort": ${var.ecs_host_port}
        }
      ],
      "memory": ${var.task_definition_memory},
      "cpu": ${var.task_definition_cpu}
    }
  ]
  DEFINITION


  requires_compatibilities = [var.td_requires_compatibilities]   # Stating that we are using ECS Fargate
  network_mode             = var.task_definition_network_mode    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.task_definition_memory          # Specifying the memory our container requires
  cpu                      = var.task_definition_cpu             # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
  }
}

#---------------------------------------------------
#  Create IAM role
#---------------------------------------------------

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = var.iam_name
  description        = "IAM Role ${var.name}-iam-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = var.iam_policy_arn
}

#---------------------------------------------------
#  Create ECS service
#---------------------------------------------------

resource "aws_ecs_service" "practice" {
  name            = var.name                                            # Naming our first service
  cluster         = "${aws_ecs_cluster.practice.id}"                    # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.practice.arn}"           # Referencing the task our service will spin up
  launch_type     = var.td_requires_compatibilities
  desired_count   = 1                                                   # Setting the number of containers we want deployed to 1
  
  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}"]
    assign_public_ip = var.ecs_assign_public_ip                         # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
  }
}

#---------------------------------------------------
#  Resources for VPC and subnet
#---------------------------------------------------

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
  }
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.subnet_a
  tags = {
        Data_Creation           = var.data_creation
        Your_First_Name         = var.your_first_name
        Your_Last_Name          = var.your_last_name
        AWS_Account_ID          = var.aws_account_id
  }
}

#---------------------------------------------------
#  Create security group
#---------------------------------------------------
resource "aws_security_group" "service_security_group" {
    name                 	= "${var.name}-sg-${var.environment}"
    description          	= "Security Group ${var.name}-sg-${var.environment}"
    vpc_id               	= var.vpc
    lifecycle {
        create_before_destroy   = true
    }
    # allow traffic for TCP 22 to host
    dynamic "ingress" {
      for_each = var.allowed_ports
      content {   
        from_port        	= ingress.value
        to_port          	= ingress.value
        protocol         	= "tcp"
        cidr_blocks      	=  ["${var.my_ip_address}/32"] 
      }
    }
    # allow traffic for TCP 22 from host
    egress {
        from_port        	= 0
        to_port          	= 0
        protocol         	= "-1"
        cidr_blocks      	= ["0.0.0.0/0"]
    }

    tags = {
        Data_Creation    	= var.data_creation
        Your_First_Name  	= var.your_first_name
        Your_Last_Name   	= var.your_last_name
        AWS_Account_ID   	= var.aws_account_id
    }
}
