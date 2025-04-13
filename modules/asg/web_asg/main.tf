#new code which i will do next
resource "aws_launch_template" "this" {
  name_prefix   = "${var.instance_name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }

 user_data = base64encode(<<EOF
#!/bin/bash
set -e

# Wait for instance metadata service to be reachable (network ready)
until curl -s http://169.254.169.254/latest/meta-data/; do
  echo "Waiting for metadata service..."
  sleep 15
done

# Wait extra for system boot, yum repo ready
sleep 30

# Update and install essentials
yum update -y
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git httpd

# Start Apache
systemctl start httpd
systemctl enable httpd

# Fix home permissions
chown -R ec2-user:ec2-user /home/ec2-user || true

# Clone frontend app with retries
cd /home/ec2-user/
for i in {1..15}; do
  sudo -u ec2-user git clone https://github.com/PavanKumar-sudo/simple_note_app.git && break
  echo "Retrying git clone ($i)..."
  sleep 10
done

# Check if cloned successfully
if [ ! -d "/home/ec2-user/simple_note_app/frontend" ]; then
  echo "Git clone failed even after retries" >&2
  exit 1
fi

# Move into frontend and build app
sudo -u ec2-user bash <<'EOU'
cd /home/ec2-user/simple_note_app/frontend

# Create .env.production
echo "REACT_APP_API_URL=/api" > .env.production

# Retry npm install
for i in {1..15}; do
  npm install && break
  echo "Retrying npm install ($i)..."
  sleep 10
done

# Sleep after install
sleep 20

# Retry npm run build
for i in {1..15}; do
  npm run build && break
  echo "Retrying npm run build ($i)..."
  sleep 10
done

# Sleep after build
sleep 10
EOU

# Apache reverse proxy for backend API
cat <<EOT > /etc/httpd/conf.d/api-proxy.conf
ProxyRequests Off
ProxyPass "/api" "http://${var.app_server_private_ip}:8080/api"
ProxyPassReverse "/api" "http://${var.app_server_private_ip}:8080/api"
EOT

# Deploy frontend to Apache
rm -rf /var/www/html/*
cp -r /home/ec2-user/simple_note_app/frontend/build/* /var/www/html/
sudo systemctl restart httpd
sleep 10
EOF
)

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
}



# resource "aws_launch_template" "this" {
#   name_prefix   = "${var.instance_name_prefix}-lt-"
#   image_id      = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.key_name

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [var.security_group_id]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags          = var.common_tags
#   }
# }

resource "aws_autoscaling_group" "this" {
  name_prefix          = "${var.instance_name_prefix}-asg-"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnet_ids
  health_check_type    = "EC2" #change to ec2 so that it will not terminate the instances if the instance is not healthy
   health_check_grace_period = var.health_check_grace_period

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    triggers = ["launch_template"]
  }

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

 tag {
  key                 = "Name"
  value               = "${var.instance_name_prefix}"
  propagate_at_launch = true
}


  lifecycle {
    create_before_destroy = true
  }
}
