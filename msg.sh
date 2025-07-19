
#!/bin/bash

# Exit on error
set -e

echo "🔧 Disabling SSH login messages system-wide..."

# 1. Backup PAM SSHD config
PAM_FILE="/etc/pam.d/sshd"
if [ -f "$PAM_FILE" ]; then
    cp "$PAM_FILE" "${PAM_FILE}.bak"
    echo "📄 Backup created: ${PAM_FILE}.bak"
fi

# 2. Comment out pam_motd lines
sed -i 's/^session\s\+optional\s\+pam_motd\.so/#&/' "$PAM_FILE"

# 3. Disable motd-news (Ubuntu-specific)
if systemctl list-units --type=service | grep -q "motd-news"; then
    systemctl disable motd-news.service motd-news.timer || true
    echo "📰 motd-news service disabled"
fi

# 4. Create .hushlogin in /etc/skel so all new users get it
touch /etc/skel/.hushlogin
chmod 644 /etc/skel/.hushlogin
echo "✅ Created /etc/skel/.hushlogin for future users"

# 5. Create .hushlogin for all existing home users
for dir in /home/*; do
    if [ -d "$dir" ]; then
        touch "$dir/.hushlogin"
        chown $(basename "$dir"):$(basename "$dir") "$dir/.hushlogin"
        echo "🧑‍💻 Applied .hushlogin to $dir"
    fi
done

# 6. Restart SSH service
systemctl restart ssh || systemctl restart sshd
echo "✅ SSH service restarted"

echo "🎉 All login messages disabled for all users."
