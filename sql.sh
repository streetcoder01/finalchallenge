
#!/bin/bash

# Exit on error
set -e

# === Config ===
MYSQL_ROOT_PASS="iamhackforfun"
DB_NAME="FinalWareData"
FLAG_BASE="CyberSecurityCamp2025Mentors"
FLAG_SUFFIX=$(shuf -i 100-999 -n 1)
FINAL_FLAG="${FLAG_BASE}${FLAG_SUFFIX}"

echo "📦 Installing MySQL Server..."
sudo apt update
sudo apt install -y mysql-server

echo "🚀 Starting MySQL service..."
sudo systemctl start mysql
sudo systemctl enable mysql

echo "🔐 Setting MySQL root password and forcing password login..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASS'; FLUSH PRIVILEGES;"

echo "🧹 Removing any login bypasses..."
sudo sed -i '/^\[client\]/,/^\[.*\]/d' /etc/mysql/my.cnf || true
rm -f ~/.my.cnf 2>/dev/null || true

echo "🗝 Writing MySQL login credentials to /etc/mysql/my.cnf (as a CTF clue)..."
sudo tee -a /etc/mysql/my.cnf > /dev/null <<EOF

# === CTF Hint Credentials ===
# You found this? Great!
# Use them manually with mysql -u root -p

[client_hint]
user=root
password=$MYSQL_ROOT_PASS
EOF

sudo chmod 644 /etc/mysql/my.cnf

echo "🧱 Creating challenge database and tables..."
mysql -u root -p"$MYSQL_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;

USE $DB_NAME;

CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS regular_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS FinalFlag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flag VARCHAR(255) NOT NULL
);

INSERT INTO admin_users (username, password) VALUES ('admin1', 'adminpass');
INSERT INTO regular_users (username, password) VALUES ('user1', 'userpass');
INSERT INTO FinalFlag (flag) VALUES ('$FINAL_FLAG');
EOF

echo ""
echo "✅ MySQL CTF environment ready!"
echo "🗝 Credentials are now stored in: /etc/mysql/my.cnf (as a CTF clue)"
echo "❌ Auto-login is disabled. Use: mysql -u root -p"
echo ""
echo "🎯 FINAL FLAG:"
echo "flag{$FINAL_FLAG}"
