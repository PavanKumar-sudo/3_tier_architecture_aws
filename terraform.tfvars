aws_region               = "us-east-1"
vpc_cidr_block           = "10.0.0.0/16"
vpc_name                 = "3tier-vpc"
public_subnet_cidr_1     = "10.0.1.0/24"
public_subnet_cidr_2     = "10.0.2.0/24"
private_subnet_cidr_1    = "10.0.3.0/24"
private_subnet_cidr_2    = "10.0.4.0/24"
availability_zone_1      = "us-east-1a"
availability_zone_2      = "us-east-1b"
public_subnet_1_name     = "public-subnet-1"
public_subnet_2_name     = "public-subnet-2"
private_subnet_1_name    = "private-subnet-1"
private_subnet_2_name    = "private-subnet-2"
igw_name                 = "3tier-igw"
eip_name                 = "3tier-eip"
nat_gateway_name         = "3tier-nat-gateway"
public_route_table_name  = "3tier-public-rt"
private_route_table_name = "3tier-private-rt"
web_sg_name              = "3tier-web-sg"
app_sg_name              = "3tier-app-sg"
app_port                 = 8080
db_sg_name               = "3tier-db-sg"
db_port                  = 3306
web_ami_id               = "ami-00a929b66ed6e0de6" # Example Amazon Linux 2 AMI (update as needed)
web_instance_type        = "t2.micro"
web_instance_name_prefix = "3tier-web-server"
key_name                 = "keypair"               # Change to your existing keypair name
app_ami_id               = "ami-00a929b66ed6e0de6" # Same Amazon Linux 2 (or another if you want)
app_instance_type        = "t2.micro"
app_instance_name_prefix = "3tier-app-server"

db_subnet_group_name = "tier-db-subnet-group"
db_identifier        = "threetier-db"
db_engine            = "mysql"
db_instance_class    = "db.t3.micro"
db_engine_version    = "8.0.35"
db_allocated_storage = 20
db_name              = "mydb"
db_username          = "admin"
db_password          = "AdminPassword123"
# Add these also in tfvars
alb_name          = "three-tier-alb"
target_group_name = "three-tier-tg"

web_min_size         = 2
web_max_size         = 4
web_desired_capacity = 2
# Add this at the end of terraform.tfvars
web_health_check_grace_period = 1500
# terraform.tfvars
table_name = "noteappdb"   # or "user_notes" or "todo_list", anything

repositry_file = "https://github.com/PavanKumar-sudo/simple_note_app.git"