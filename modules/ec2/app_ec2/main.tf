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

# Wait for instance metadata service to be reachable (network ready)
until curl -s http://169.254.169.254/latest/meta-data/; do
  echo "Waiting for metadata service..."
  sleep 15
done

# === Update System ===
yum update -y

# === Install Node.js 18.x and Git, MariaDB Client, Python3 Pip with Retry ===
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -

for i in {1..5}; do
  yum install -y nodejs git mariadb105 python3-pip && break
  echo "Retrying yum install packages (\$i)..."
  sleep 15
done

# === Install PM2 Globally with Retry ===
for i in {1..5}; do
  npm install -g pm2 && break
  echo "Retrying npm install pm2 (\$i)..."
  sleep 15
done

# === Install Python PyMySQL with Retry ===
for i in {1..5}; do
  pip3 install PyMySQL && break
  echo "Retrying pip3 install PyMySQL (\$i)..."
  sleep 15
done


# === Sleep to allow network, yum updates, and internet stabilization ===
sleep 30

# === Clone Backend Code with Retry ===
cd /home/ec2-user/
for i in {1..10}; do
  git clone https://github.com/PavanKumar-sudo/simple_note_app.git && break
  echo "Retrying git clone (\$i)..."
  sleep 10
done

# === Check if Cloning was Successful ===
if [ ! -d "/home/ec2-user/simple_note_app/backend" ]; then
  echo "Git clone failed even after retries" >&2
  exit 1
fi

# === Move into Backend Directory ===
cd /home/ec2-user/simple_note_app/backend

# === Install Node.js Backend Dependencies with Retry ===
for i in {1..10}; do
  npm install && break
  echo "Retrying npm install (\$i)..."
  sleep 10
done

# === Sleep after install (optional buffer) ===
sleep 15

# === Fix Permissions ===
chown -R ec2-user:ec2-user /home/ec2-user/simple_note_app/backend

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

# === Start Backend Server with PM2 ===
pm2 start index.js --name notes-backend
pm2 save

# === Setup PM2 Startup on Boot ===
pm2 startup systemd -u ec2-user --hp /home/ec2-user | grep sudo | bash
systemctl enable pm2-ec2-user

# === Create Table in RDS if not exists ===
python3 - <<EOF2
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
EOF2

EOF
)


  tags = merge(
    var.common_tags,
    {
      Name = "${var.instance_name_prefix}-${count.index + 1}"
    }
  )
}

