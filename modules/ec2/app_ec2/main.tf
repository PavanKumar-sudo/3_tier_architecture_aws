# resource "aws_instance" "app" {
#   count         = 1
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id     = element(var.subnet_ids, count.index)
#   key_name      = var.key_name

#   vpc_security_group_ids = [var.security_group_id]

#   associate_public_ip_address = false # Important: No public IP for Private Subnets

#   tags = merge(
#     var.common_tags,
#     {
#       Name = "${var.instance_name_prefix}-${count.index + 1}"
#     }
#   )
# }

// new code for app_ec2 module
resource "aws_instance" "app" {
  count         = 1
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = false

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

# === Wait for YUM Lock (important) ===
while fuser /var/run/yum.pid >/dev/null 2>&1; do
  echo "Waiting for yum lock..."
  sleep 10
done

# === Install Packages with Retry ===
for i in {1..10}; do
  yum install -y nodejs git mariadb105 python3-pip && break
  echo "Retrying yum install packages (\$i)..."
  sleep 30
done
sleep 30

# === Install Node.js 18 ===
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
sleep 15

# === Install PM2 Globally with Retry ===
for i in {1..10}; do
  npm install -g pm2 && break
  echo "Retrying npm install pm2 (\$i)..."
  sleep 30
done
sleep 20

# === Install Python PyMySQL with Retry ===
for i in {1..10}; do
  pip3 install PyMySQL && break
  echo "Retrying pip3 install PyMySQL (\$i)..."
  sleep 30
done
sleep 20

# === Clone Backend Code with Retry ===
cd /home/ec2-user/
for i in {1..20}; do
  git clone https://github.com/PavanKumar-sudo/simple_note_app.git && break
  echo "Retrying git clone (\$i)..."
  sleep 15
done

if [ ! -d "/home/ec2-user/simple_note_app/backend" ]; then
  echo "Git clone failed after retries" >&2
  exit 1
fi

# === Move and Set Permissions ===
cd /home/ec2-user/simple_note_app/backend
chown -R ec2-user:ec2-user /home/ec2-user/simple_note_app/backend
sleep 10

# === Install Backend Dependencies with Retry ===
for i in {1..20}; do
  npm install && break
  echo "Retrying npm install backend (\$i)..."
  sleep 30
done
sleep 30

# === Create .env File ===
cat <<EOT > /home/ec2-user/simple_note_app/backend/.env
DB_HOST=${var.rds_endpoint}
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
DB_NAME=${var.db_name}
DB_PORT=3306
PORT=8080
DB_TABLE=${var.table_name}
EOT

# === Start Backend with PM2 ===
pm2 start index.js --name notes-backend
pm2 save
pm2 startup systemd -u ec2-user --hp /home/ec2-user | grep sudo | bash
systemctl enable pm2-ec2-user
sleep 10

# === Create DB Table if Not Exists ===
python3 - <<EOPYTHON
import pymysql
import os

connection = pymysql.connect(
    host=os.getenv('DB_HOST', '${var.rds_endpoint}'),
    user=os.getenv('DB_USER', '${var.db_username}'),
    password=os.getenv('DB_PASSWORD', '${var.db_password}'),
    database=os.getenv('DB_NAME', '${var.db_name}'),
    port=3306
)

cursor = connection.cursor()
cursor.execute(f"""
CREATE TABLE IF NOT EXISTS ${var.table_name} (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""")
connection.commit()
cursor.close()
connection.close()
EOPYTHON

EOF
)



  tags = merge(
    var.common_tags,
    {
      Name = "${var.instance_name_prefix}-${count.index + 1}"
    }
  )
}

