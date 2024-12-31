aws_region               = "us-east-1"
vpc_cidr_block          = "10.0.0.0/16"
subnet_a_cidr_block     = "10.0.1.0/24"
subnet_b_cidr_block     = "10.0.2.0/24"
subnet_a_az             = "us-east-1a"
subnet_b_az             = "us-east-1b"
node_group_desired_size = 2
node_group_max_size     = 3
node_group_min_size     = 1
node_group_instance_types = ["t3.medium"]

