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

# === Wait for Metadata Service ===
until curl -s http://169.254.169.254/latest/meta-data/; do
  echo "Waiting for metadata service..."
  sleep 15
done

# === Basic Sleep to Stabilize Network ===
sleep 30

# === System Update ===
yum update -y
sleep 30

# === Wait for YUM Lock ===
while fuser /var/run/yum.pid >/dev/null 2>&1; do
  echo "Waiting for yum lock..."
  sleep 20
done

# === Install Node.js, Git, Apache (Essential Packages) ===
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
sleep 40

for i in {1..5}; do
  yum install -y nodejs git httpd && break
  echo "Retrying yum install packages ($i)..."
  sleep 60
done

# === Start Apache (with retry) ===
for i in {1..5}; do
  systemctl start httpd && break
  echo "Retrying systemctl start httpd ($i)..."
  sleep 30
done

# === Optional: Small Wait after Apache start ===
sleep 5

# === Enable Apache Auto-Start (with retry) ===
for i in {1..5}; do
  systemctl enable httpd && break
  echo "Retrying systemctl enable httpd ($i)..."
  sleep 40
done


# === Fix Permissions ===
chown -R ec2-user:ec2-user /home/ec2-user || true

# === Clone Frontend Code with Retry ===
cd /home/ec2-user/
for i in {1..20}; do
  sudo -u ec2-user git clone https://github.com/PavanKumar-sudo/simple_note_app.git && break
  echo "Retrying git clone (\$i)..."
  sleep 30
done

if [ ! -d "/home/ec2-user/simple_note_app/frontend" ]; then
  echo "Git clone failed after retries" >&2
  exit 1
fi

# === Move into Frontend and Build App ===
sudo -u ec2-user bash <<'EOU'
cd /home/ec2-user/simple_note_app/frontend
echo "REACT_APP_API_URL=/api" > .env.production

for i in {1..20}; do
  npm install && break
  echo "Retrying npm install frontend (\$i)..."
  sleep 30
done

sleep 60

for i in {1..20}; do
  npm run build && break
  echo "Retrying npm run build frontend (\$i)..."
  sleep 50
done
sleep 50
EOU

# === Apache Reverse Proxy Config ===
cat <<EOT > /etc/httpd/conf.d/api-proxy.conf
ProxyRequests Off
ProxyPass "/api" "http://${var.app_server_private_ip}:8080/api"
ProxyPassReverse "/api" "http://${var.app_server_private_ip}:8080/api"
EOT

# === Deploy Frontend to Apache ===
rm -rf /var/www/html/*
cp -r /home/ec2-user/simple_note_app/frontend/build/* /var/www/html/
sleep 50

# Retry restart Apache
for i in {1..5}; do
  sudo systemctl restart httpd && break
  echo "Retrying restart httpd ($i)..."
  sleep 30
done

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
