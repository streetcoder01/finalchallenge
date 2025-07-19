
#!/bin/bash

# Exit on any error
set -e

echo "======================================="
echo "🔧 Starting CTF SMB Challenge Setup..."
echo "======================================="

# Step 1: System update
echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install required packages
echo "📥 Installing samba, zip, apache2..."
sudo apt install samba zip apache2 -y

# Step 3: Create the SMB shared folder
echo "📁 Creating shared directory /srv/smb/ctfshare..."
sudo mkdir -p /srv/smb/ctfshare
sudo chown nobody:nogroup /srv/smb/ctfshare
sudo chmod 755 /srv/smb/ctfshare

# Step 4: Create Notes.txt as a clue
echo "📝 Creating Notes.txt..."
cat <<EOF | sudo tee /srv/smb/ctfshare/Notes.txt > /dev/null
To: webmaster  
I noticed something concerning while checking the website content. Please review everything carefully.
Also, make sure the search engines aren’t indexing sensitive areas — we are using this list to password-protect our ZIP files. 
admin
EOF

# Step 5: Create email_message.txt and zip it
echo "📨 Creating password-protected Email.zip..."
cd /srv/smb/ctfshare

cat <<EOF > email_message.txt
To: webmaster

Just noticed that one of the words in the website content matches a password I use to access the system. Please review the text and remove it ASAP.

admin
EOF

# Step 6: Pick a random password from the list
PASSWORD_LIST=(
  "dragonlord"
  "DRAGONLORD"
  "dragonlordxiant"
  "dragonlordatwork"
  "dragonlord768503"
  "dragonlord420"
  "dragonlord2318"
  "dragonlord21"
  "dragonlord2"
  "dragonlord1978"
  "dragonlord13"
  "dragonlord12"
  "dragonlord11"
  "dragonlord08"
  "dragonlord001"
  "Dragonlord26"
)

RANDOM_PASSWORD="${PASSWORD_LIST[$RANDOM % ${#PASSWORD_LIST[@]}]}"

# Create the password-protected zip
zip -P "$RANDOM_PASSWORD" Email.zip email_message.txt
rm email_message.txt

# Step 7: Configure Samba share
echo "⚙️ Configuring Samba share..."
sudo bash -c 'cat <<EOF >> /etc/samba/smb.conf

[Finalwar]
   comment = CTF Final War Challenge
   path = /srv/smb/ctfshare
   browsable = yes
   guest ok = yes
   read only = yes
   force user = nobody
EOF'

# Step 8: Restart Samba service
echo "🔄 Restarting Samba service..."
sudo systemctl restart smbd

# Done
echo "======================================="
echo "✅ CTF SMB Challenge setup complete!"
echo "➡️  Access the share at: smb://<your-ip>/Finalwar"
echo "🔐 Password used for Email.zip: $RANDOM_PASSWORD"
echo "======================================="
