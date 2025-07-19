
#!/bin/bash

# Exit immediately if a command fails
set -e

USERNAME="admin"

# Step 1: Show team selection menu
echo "🎮 Choose your team:"
echo "1. Naruto"
echo "2. Bleach"
echo "3. One Piece"
read -p "Enter the number of your team choice: " TEAM_CHOICE

# Step 2: Define password lists
NARUTO_PASSWORDS=( "Rasengan" "resemblance" "phenomenon" "revolutionary" "battlefield" "Hiruzen" "Momochi" "climactic" "Shippuden" "catastrophic" )
BLEACH_PASSWORDS=( "Kubo" "Iconic" "reconciles" "powerlessness" "Grimmjow" "Visored" "Kenpachi" "Zaraki" "Uryu" "Urahara" )
ONEPIECE_PASSWORDS=( "Kuma" "Hancock" "brotherhood" "poneglyphs" "mastermind" "Forming" "everything" "navigator" "Katakuri" "Marineford" )

# Step 3: Pick password from the selected list
case $TEAM_CHOICE in
  1)
    TEAM_NAME="Naruto"
    PASSWORD_LIST=("${NARUTO_PASSWORDS[@]}")
    ;;
  2)
    TEAM_NAME="Bleach"
    PASSWORD_LIST=("${BLEACH_PASSWORDS[@]}")
    ;;
  3)
    TEAM_NAME="One Piece"
    PASSWORD_LIST=("${ONEPIECE_PASSWORDS[@]}")
    ;;
  *)
    echo "❌ Invalid choice. Exiting..."
    exit 1
    ;;
esac

USER_PASS="${PASSWORD_LIST[$RANDOM % ${#PASSWORD_LIST[@]}]}"

# Step 4: If user exists, delete them first
if id "$USERNAME" &>/dev/null; then
    echo "⚠️  User '$USERNAME' already exists. Deleting..."
    sudo pkill -u "$USERNAME" &>/dev/null || true
    sudo deluser --remove-home "$USERNAME" || { echo "❌ Failed to delete existing user."; exit 1; }
    echo "✅ Old user '$USERNAME' deleted."
fi

# Step 5: Create new user with selected password
echo "➕ Creating user '$USERNAME'..."
sudo adduser --disabled-password --gecos "" "$USERNAME" || { echo "❌ Failed to create user."; exit 1; }
echo "$USERNAME:$USER_PASS" | sudo chpasswd || { echo "❌ Failed to set password."; exit 1; }
echo "✅ User '$USERNAME' created with new password."

# Step 6: Prepare .ssh directory
echo "📁 Preparing SSH directory..."
sudo mkdir -p /home/$USERNAME/.ssh
sudo chown $USERNAME:$USERNAME /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh

# ✅ Step 6.5: Create Note.txt file and display message at login
echo "📝 Creating Note.txt for $USERNAME..."
echo "To Webadmin
I notice there is misconfiguration in our database file. fix it Urgently
admin" | sudo tee /home/$USERNAME/Note.txt > /dev/null || { echo "❌ Failed to create Note.txt"; exit 1; }

sudo chown $USERNAME:$USERNAME /home/$USERNAME/Note.txt
sudo chmod 644 /home/$USERNAME/Note.txt

# Add command to show the message at login
echo "cat ~/Note.txt" | sudo tee -a /home/$USERNAME/.bashrc > /dev/null

# Step 7: Enable SSH password login and root access
echo "🔧 Configuring SSH to allow password and root login..."
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Make sure the settings exist if not found
grep -q "^PasswordAuthentication" /etc/ssh/sshd_config || echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
grep -q "^PermitRootLogin" /etc/ssh/sshd_config || echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

# Step 8: Restart SSH service
echo "🔁 Restarting SSH service..."
sudo systemctl restart ssh || { echo "❌ Failed to restart SSH."; exit 1; }

# Final confirmation
echo "======================================="
echo "🚀 '$USERNAME' is now ready to SSH into the system!"
echo "🛡️  Team selected     : $TEAM_NAME"
echo "🔐 Password assigned  : $USER_PASS"
echo "📄 Note file location : /home/$USERNAME/Note.txt"
echo "📢 This message will show at login!"
echo "👉 SSH command: ssh $USERNAME@<your_server_ip>"
echo "🔑 Root login is enabled. You can also SSH as: ssh root@<your_server_ip>"
echo "======================================="
