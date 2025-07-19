

# ======= Start of 1. smb.sh =======
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
# ======= End of 1. smb.sh =======


# ======= Start of 2. web.sh =======
#!/bin/bash

# Step 1: Install Apache
sudo apt update && sudo apt install -y apache2

# Step 2: Create index.html
cat << 'EOF' | sudo tee /var/www/html/index.html > /dev/null
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>The Final Battle</title>
  <style>
    body {
      background-color: #000;
      color: #fff;
      font-family: Arial, sans-serif;
      text-align: center;
      margin: 0;
      padding: 0;
    }

    h1 {
      margin-top: 20px;
    }

    .banner {
      width: 100%;
      max-width: 700px;
      height: auto;
      margin: 20px auto;
    }

    .team-container {
      display: flex;
      justify-content: center;
      gap: 40px;
      margin: 40px 0;
      flex-wrap: wrap;
    }

    .team-container a img {
      width: 350px;
      height: 100px;
      object-fit: cover;
      border: 2px solid white;
      border-radius: 10px;
      transition: transform 0.3s, box-shadow 0.3s;
    }

    .team-container a img:hover {
      transform: scale(1.05);
      box-shadow: 0 0 15px white;
    }
  </style>
</head>
<body>
  <h1>Challenge 4</h1>

  <img src="https://i.postimg.cc/VL1DzNBP/finalbattle.jpg" alt="Final Battle Banner" class="banner">

  <div class="team-container">
    <a href="opepice.html">
      <img src="https://i.postimg.cc/d1wLLgW3/onepieceteam.png" alt="One Piece Team">
    </a>
    <a href="naruto.html">
      <img src="https://i.postimg.cc/1zxgZ8wp/narutoteam.png" alt="Naruto Team">
    </a>
    <a href="bleach.html">
      <img src="https://i.postimg.cc/13FtMy24/bleachteam.png" alt="Bleach Team">
    </a>
  </div>
</body>
</html>
EOF

# Step 3: Create robots.txt
cat << EOF | sudo tee /var/www/html/robots.txt > /dev/null
User-agent: [user-agent-FinalBattel]
Disallow: /wordlists/rockyou.txt
EOF

# Step 4: Create opepice.html
cat << 'EOF' | sudo tee /var/www/html/opepice.html > /dev/null
<!DOCTYPE html>
<html>
<head>
  <title>One Piece Team</title>
  <style>
    body {
      background-color: black;
      color: white;
      text-align: center;
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <h1>Welcome to the One Piece Team!</h1>
  <p>This is where the pirates begin their hacking journey!</p>
  <img src="https://i.postimg.cc/d1wLLgW3/onepieceteam.png" alt="One Piece Team">
<p></p>
  <p><strong>Monkey D. Luffy</strong>, a cheerful and brave pirate with the power of the Gum-Gum Fruit, leads the Straw Hat Pirates on a quest to find the legendary treasure known as "One Piece." His loyal crew includes swordsman Zoro, navigator Nami, sniper Usopp, chef Sanji, and others. Together they sail the Grand Line, battling powerful foes and forging bonds of friendship as they chase their dreams of freedom and adventure.</p>

  <h2>The Great Pirate Era Begins</h2>
  <p>The execution of the Pirate King, Gol D. Roger, marked the start of a new era. Just before his death, Roger declared that he left all his treasure—the legendary “One Piece”—in one place, waiting to be found. These final words sparked the Great Pirate Era.</p>
  <blockquote>“My treasure? If you want it, I’ll let you have it. Look for it! I left everything I gathered together in one place!”<br>— Gol D. Roger</blockquote>
  <p>People from all over the world took to the seas, hoping to claim the title of Pirate King. Among them would be a boy named Monkey D. Luffy, who would change the world.</p>

  <h2>Luffy’s Childhood and the Dream</h2>
  <p>Born in East Blue, Luffy idolized the Red-Haired Shanks, a pirate captain who often visited his village. After defending Luffy from bandits and losing his arm to save him from a sea monster, Shanks gave Luffy his treasured straw hat.</p>
  <blockquote>“I’m lending you this hat. Bring it back to me someday… when you become a great pirate.”<br>— Shanks</blockquote>
  <p>This moment defined Luffy’s destiny. From then on, he trained, endured pain, and grew strong. At age 17, he set off on a tiny boat with one goal:</p>
  <blockquote>“I’m gonna be King of the Pirates!”<br>— Luffy</blockquote>

  <h2>Forming the Straw Hat Crew</h2>
  <p>Luffy soon begins assembling a diverse and powerful crew, each member carrying their own burdens and dreams:</p>
  <ul>
    <li>Roronoa Zoro, a swordsman who vows to become the world’s strongest.</li>
    <li>Nami, a cunning thief who seeks to draw a map of the entire world.</li>
    <li>Usopp, a liar with a brave heart and the dream of becoming a great warrior of the sea.</li>
    <li>Sanji, a cook in search of the All Blue, a mythical sea with fish from every ocean.</li>
  </ul>
  <p>Each member joins Luffy not just for adventure, but because they believe in him.</p>
  <blockquote>“I don’t care if I die… I made a promise to my captain!”<br>— Zoro</blockquote>
  <p>Together, they sail on the Going Merry and later the Thousand Sunny, facing the challenges of the Grand Line.</p>

  <h2>Arlong Park: Breaking Chains</h2>
  <p>Nami’s past is revealed in Arlong Park, where she’s forced to work for the tyrannical fish-man Arlong to save her village. When she breaks down, begging Luffy for help, he silently places his hat on her head and leads the assault.</p>
  <blockquote>“Nami, you are my friend.”<br>— Luffy</blockquote>

  <h2>Alabasta: The Battle for a Kingdom</h2>
  <p>The Straw Hats aid Princess Vivi in saving the desert kingdom of Alabasta from Crocodile, a Warlord of the Sea. Luffy defeats Crocodile after losing to him twice, proving his resolve and resilience.</p>
  <blockquote>“I don’t want to conquer anything. I just think the guy with the most freedom in the world… is the Pirate King!”<br>— Luffy</blockquote>

  <h2>Skypiea: Land in the Sky</h2>
  <p>The crew reaches Skypiea and confronts Enel, a self-proclaimed god. Luffy, immune to lightning, defeats him and liberates the island. Skypiea introduces poneglyphs and the "Voice of All Things."</p>

  <h2>Water 7 and Enies Lobby: Declaring War on the World</h2>
  <p>Robin is captured by CP9. The Straw Hats declare war on the World Government and rescue her at Enies Lobby.</p>
  <blockquote>“I want to live! Take me with you!”<br>— Nico Robin</blockquote>
  <blockquote>“We are friends! And we’re gonna rescue our friend no matter what!”<br>— Luffy</blockquote>

  <h2>Thriller Bark: Shadows and Sacrifice</h2>
  <p>On Thriller Bark, the crew faces Gecko Moria. Zoro offers to take Luffy’s pain to save him.</p>
  <blockquote>“Nothing happened.”<br>— Zoro</blockquote>

  <h2>Sabaody Archipelago: The Cruel World</h2>
  <p>Luffy punches a Celestial Dragon. Kuma defeats the crew and scatters them across the world.</p>
  <blockquote>“I don’t care who you are… I’m gonna beat you up!”<br>— Luffy</blockquote>

  <h2>Amazon Lily to Impel Down</h2>
  <p>Luffy learns Ace is captured. He infiltrates Impel Down with help from Boa Hancock and old allies.</p>

  <h2>Marineford War: The Death of Ace</h2>
  <p>Whitebeard and Luffy try to save Ace. Ace dies protecting Luffy.</p>
  <blockquote>“I’m your brother! I’m gonna save you!”<br>— Luffy</blockquote>
  <blockquote>“Thank you for loving me.”<br>— Ace</blockquote>
  <blockquote>“One Piece… does exist!”<br>— Whitebeard</blockquote>

  <h2>The Time Skip and Two-Year Training</h2>
  <p>Luffy trains with Rayleigh to master Haki and vows to protect his crew.</p>
  <blockquote>“I still have my crew. I won’t lose anyone again!”<br>— Luffy</blockquote>

  <h2>Return to Sabaody and Fishman Island</h2>
  <p>The crew reunites and travels to Fishman Island. Luffy earns the island’s respect and hope.</p>
  <blockquote>“Someday, we’ll be equals.”<br>— Jinbei</blockquote>

  <h2>Punk Hazard and Dressrosa: The Rise of Doflamingo</h2>
  <p>The crew uncovers Doflamingo’s tyranny. Luffy defeats him and gains global recognition.</p>
  <blockquote>“I’m Luffy. The man who’s gonna defeat you!”<br>— Luffy</blockquote>

  <h2>Whole Cake Island: Family and Sacrifice</h2>
  <p>Luffy tries to save Sanji from Big Mom. He fights Katakuri in one of his greatest duels.</p>
  <blockquote>“You’re the one who fed me. I’ll wait here until you say you’re coming back.”<br>— Luffy</blockquote>
  <blockquote>“I will not fall! I will surpass you!”<br>— Luffy (to Katakuri)</blockquote>

  <h2>Wano Country: Revolution and Rebirth</h2>
  <p>Luffy allies with samurai to take down Kaido. He awakens Gear 5, revealing the Sun God Nika.</p>
  <blockquote>“I feel like… I can do anything!”<br>— Luffy</blockquote>

  <h2>Laugh Tale, Ancient Weapons, and the Final War</h2>
  <p>With three Road Poneglyphs, the Straw Hats approach the final island. The world braces for the final war.</p>
  <blockquote>“Inherited will, the swelling of the changing times, and the dreams of people—these are things that cannot be stopped.”<br>— Gol D. Roger</blockquote>

  <h2>The Dream Lives On</h2>
  <p>As the Straw Hats continue their journey, the world watches.</p>
  <blockquote>“I’m Monkey D. Luffy! And I’m the man who will become King of the Pirates!”<br>— Luffy</blockquote>
  <p>Their journey is not over. The seas are vast. The world still hides its truths. But one thing is certain:<br><strong>Their dreams will never die.</strong></p>

</body>
</html>
EOF

# Step 5: Create naruto.html
cat << 'EOF' | sudo tee /var/www/html/naruto.html > /dev/null
<!DOCTYPE html>
<html>
<head>
  <title>Naruto Team</title>
  <style>
    body {
      background-color: black;
      color: white;
      text-align: center;
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <h1>Welcome to the Naruto Team!</h1>
  <p>Stealth, strategy, and shadow clones!</p>
  <img src="https://i.postimg.cc/1zxgZ8wp/narutoteam.png" alt="Naruto Team">
<p></p>
  <p><strong>Naruto Uzumaki</strong>, a spirited ninja from the Hidden Leaf Village, dreams of becoming the Hokage — the strongest ninja leader. Alongside his teammates Sasuke Uchiha and Sakura Haruno under the mentorship of Kakashi Hatake, they form Team 7. Together, they face deadly enemies, uncover deep secrets, and grow stronger through perseverance, friendship, and an unbreakable will to protect their home.</p>

  <h2>Prologue: The Legacy of the Nine-Tails</h2>
  <p>On a dark and fateful night, the Hidden Leaf Village (Konoha) is attacked by a monstrous force—the Nine-Tailed Fox, known as Kurama. This catastrophic event threatens to annihilate the entire village. To stop the beast, the Fourth Hokage, Minato Namikaze, and his wife, Kushina Uzumaki, sacrifice their lives by sealing the Nine-Tails inside their newborn son: Naruto Uzumaki.</p>
  <p>With his parents gone, Naruto grows up orphaned, ostracized, and shunned by the village. The people of Konoha see him not as a boy, but as the demon that destroyed their homes and families. Naruto, unaware of the true reason for their hatred, suffers silently—masking his pain with pranks, loud declarations, and an unbreakable dream: to become Hokage, the village’s strongest ninja.</p>
  <blockquote>“I’m Naruto Uzumaki! And I’m gonna be Hokage one day, just you wait!”<br>— Naruto Uzumaki</blockquote>

  <h2>The Academy and Team 7</h2>
  <p>Naruto eventually graduates from the Ninja Academy and is placed in Team 7 with Sasuke Uchiha and Sakura Haruno under their enigmatic teacher, Kakashi Hatake.</p>
  <p>Their first real mission—protecting a bridge builder in the Land of Waves—turns deadly when they face Zabuza Momochi and his apprentice Haku. This mission forces Naruto and his teammates to confront the brutal reality of the ninja world. It is here that Naruto vows to fight for those who have no one.</p>
  <blockquote>“I won’t run away anymore… I won’t go back on my word… that is my ninja way!”<br>— Naruto Uzumaki</blockquote>
  <p>Zabuza and Haku’s tragic story teaches Naruto that being a ninja is not just about strength—it’s about understanding pain, protecting comrades, and making hard choices.</p>

  <h2>Chūnin Exams and the Curse of Hatred</h2>
  <p>Naruto, Sasuke, and Sakura enter the Chūnin Exams, a tournament for ninja promotion. The exams are interrupted when Orochimaru, a traitorous Sannin, attacks Sasuke and marks him with the cursed seal.</p>
  <p>This arc introduces Gaara of the Sand, a boy like Naruto who is also a Jinchūriki. In their climactic battle, Naruto defeats Gaara not with brute force alone, but with empathy and willpower.</p>
  <blockquote>“Because they saved me from myself, they rescued me from my loneliness! They were the first to accept me for who I am. They’re my friends!”<br>— Naruto Uzumaki</blockquote>
  <p>The invasion of Konoha leads to the death of the Third Hokage, Hiruzen Sarutobi, and the rise of new threats: Orochimaru and the mysterious Akatsuki.</p>

  <h2>Search for Tsunade and the Legendary Sannin</h2>
  <p>Naruto joins Jiraiya to find Tsunade, the last of the three Legendary Sannin. Naruto learns the Rasengan and bonds with Jiraiya. Tsunade, though hesitant, becomes the Fifth Hokage, inspired by Naruto's spirit.</p>
  <blockquote>“He’s a fool, but he’s not just any fool… he’s a fool with the guts to never give up.”<br>— Tsunade about Naruto</blockquote>

  <h2>Sasuke Retrieval Arc: Bonds Broken</h2>
  <p>Sasuke defects to Orochimaru seeking power to kill Itachi. Naruto and a team of Genin try to retrieve him, leading to a final clash at the Valley of the End.</p>
  <blockquote>“Why do you care so much about me?”<br>— Sasuke Uchiha<br>“Because we’re friends!”<br>— Naruto Uzumaki</blockquote>
  <p>Sasuke wins but spares Naruto. Naruto promises to bring him back.</p>

  <h2>Naruto’s Training Journey</h2>
  <p>Naruto leaves Konoha with Jiraiya to train. Akatsuki begins capturing Jinchūriki.</p>

  <h2>Naruto Shippuden Begins</h2>
  <p>Naruto returns, stronger and determined. Team 7, now including Sai, fails to bring Sasuke back from Orochimaru.</p>
  <blockquote>“I walk the path of no return… and I’ll gain power my own way.”<br>— Sasuke Uchiha</blockquote>

  <h2>Akatsuki’s Reign of Terror</h2>
  <p>Akatsuki captures Jinchūriki. Gaara dies but is revived thanks to Chiyo’s sacrifice.</p>
  <blockquote>“Naruto… you changed me.”<br>— Gaara</blockquote>

  <h2>The Death of Jiraiya and Pain’s Assault</h2>
  <p>Jiraiya dies confronting Pain. Pain destroys Konoha, but Naruto defeats him with Sage Mode and brings peace through forgiveness.</p>
  <blockquote>“I will break the cycle of hatred.”<br>— Naruto Uzumaki<br>“You are the bridge to peace, Naruto.”<br>— Nagato</blockquote>

  <h2>The Five Kage Summit and Sasuke’s Descent</h2>
  <p>Sasuke attacks the Kage Summit. Naruto confronts him, ready to die with him if necessary.</p>
  <blockquote>“If you attack Konoha, I’ll have no choice… I’ll bear the burden of your hatred and die with you.”<br>— Naruto Uzumaki</blockquote>

  <h2>The Fourth Great Ninja War</h2>
  <p>All villages unite. Naruto befriends Kurama and gains immense power. Madara and Obito appear. Naruto and Sasuke fight together.</p>
  <blockquote>“You’re no longer a demon fox… you’re my friend!”<br>— Naruto Uzumaki<br>“I always knew… you were my only friend.”<br>— Sasuke Uchiha</blockquote>
  <p>They battle Kaguya Ōtsutsuki and seal her away.</p>

  <h2>Final Battle: Naruto vs Sasuke</h2>
  <p>Naruto and Sasuke clash again. Sasuke wants revolution; Naruto seeks peace. They end up acknowledging each other, losing an arm each.</p>
  <blockquote>“I’ve always hated you… but you were the one I always wanted to be like.”<br>— Sasuke Uchiha<br>“I never gave up on you, Sasuke. That’s my ninja way.”<br>— Naruto Uzumaki</blockquote>

  <h2>Epilogue: The Next Generation</h2>
  <p>Sasuke is pardoned. Naruto marries Hinata. He becomes the Seventh Hokage.</p>
  <blockquote>“I’m home!”<br>— Naruto Uzumaki</blockquote>

  <h2>Famous Quotes Recap</h2>
  <ul>
    <li>“I’m not gonna run away, I never go back on my word! That’s my ninja way!” — Naruto</li>
    <li>“Those who break the rules are scum, but those who abandon their friends are worse than scum.” — Kakashi</li>
    <li>“A hero always arrives late.” — Minato Namikaze</li>
    <li>“Power is not will, it is the phenomenon of physically making things happen.” — Madara Uchiha</li>
    <li>“In this world, wherever there is light—there are also shadows.” — Itachi Uchiha</li>
    <li>“The pain of being alone is completely out of this world, isn’t it?” — Naruto</li>
    <li>“Sometimes you must hurt in order to know, fall in order to grow, lose in order to gain.” — Pain</li>
    <li>“You’re wrong, I’m not alone! I have people who care about me!” — Naruto</li>
    <li>“You and I are flesh and blood. I'm always going to be there for you, even if it's only as an obstacle for you to overcome.” — Naruto</li>
  </ul>

</body>
</html>
EOF

# Step 6: Create bleach.html
cat << 'EOF' | sudo tee /var/www/html/bleach.html > /dev/null
<!DOCTYPE html>
<html>
<head>
  <title>Bleach Team</title>
  <style>
    body {
      background-color: black;
      color: white;
      text-align: center;
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <h1>Welcome to the Bleach Team!</h1>
  <p>Speed and precision in every strike!</p>
  <img src="https://i.postimg.cc/13FtMy24/bleachteam.png" alt="Bleach Team">
<p></p>
  <p><strong>Ichigo Kurosaki</strong> is a teenager who gains the powers of a Soul Reaper — a guardian of spirits who defends the living world from evil Hollows. Alongside allies like Rukia Kuchiki, Orihime Inoue, Uryu Ishida, and Yasutora Sado, Ichigo faces fierce enemies from different realms. With courage, loyalty, and his immense spiritual strength, he protects both the world of the living and the Soul Society.</p>

  <h2>Prologue – The World of the Living and the Dead</h2>
  <p>In the quiet town of Karakura, lives a seemingly ordinary high school student, Ichigo Kurosaki. But Ichigo is anything but ordinary—he can see ghosts. His life changes forever when he meets Rukia Kuchiki, a Soul Reaper (Shinigami), tasked with sending souls to the afterlife and slaying malevolent spirits known as Hollows.</p>
  <p>When a powerful Hollow attacks Ichigo's family, Rukia is injured and transfers her powers to Ichigo.</p>
  <blockquote>“I didn’t become a Soul Reaper to die. I became a Soul Reaper to protect!”<br>— Ichigo Kurosaki</blockquote>
  <p>Ichigo assumes her duties, gaining immense spiritual power. Thus begins his journey between the worlds of the living and the dead.</p>

  <h2> Substitute Soul Reaper Arc</h2>
  <p>Ichigo juggles school life and the dangerous task of fighting Hollows. Along the way, he awakens the spiritual abilities of his friends:</p>
  <ul>
    <li>Orihime Inoue, with powers of healing and defense.</li>
    <li>Yasutora “Chad” Sado, with immense spiritual strength.</li>
    <li>Uryū Ishida, a Quincy archer with a hatred for Soul Reapers.</li>
  </ul>
  <p>Ichigo becomes known as the Substitute Soul Reaper. However, when Rukia is arrested and taken back to the Soul Society—the afterlife’s ruling realm—for illegally transferring her powers, Ichigo vows to save her.</p>
  <blockquote>“If you give me wings, I will soar for you. If you give me a sword, I will fight for you!”<br>— Ichigo to Rukia</blockquote>

  <h2>Soul Society Arc: The Rescue Mission</h2>
  <p>Ichigo and his friends infiltrate Soul Society, facing the powerful Gotei 13, the organization of Soul Reapers. Each Division is led by a unique and powerful Captain.</p>
  <p>Ichigo clashes with legendary figures like:</p>
  <ul>
    <li>Zaraki Kenpachi, a battle-crazed captain.</li>
    <li>Byakuya Kuchiki, Rukia’s stoic brother.</li>
    <li>Renji Abarai, Rukia’s childhood friend and lieutenant.</li>
  </ul>
  <blockquote>“Sanctify… Zabimaru!”<br>— Renji Abarai</blockquote>
  <p>In an iconic battle, Ichigo unlocks his Bankai, a powerful advanced form of his sword, Zangetsu, and defeats Byakuya.</p>
  <blockquote>“Bankai… Tensa Zangetsu!”<br>— Ichigo Kurosaki</blockquote>
  <p>Eventually, the truth surfaces: Rukia’s execution was a cover-up by Sōsuke Aizen, a traitorous captain who faked his death and plans to overthrow Soul Society using the Hōgyoku, a reality-bending orb hidden in Rukia’s body.</p>
  <blockquote>“Admire the moon… for soon, it shall belong to me.”<br>— Sōsuke Aizen</blockquote>
  <p>Aizen escapes to Hueco Mundo, the Hollow realm, leaving Soul Society stunned.</p>

  <h2>Arrancar and Hueco Mundo Arcs: Rise of the Espada</h2>
  <p>Aizen allies with Hollows, creating powerful hybrid beings called Arrancar, led by the Espada—ten elite warriors.</p>
  <p>Ichigo, haunted by his Inner Hollow, trains with the Visored—former Soul Reapers with Hollow powers. He must master his Hollow mask to protect those he loves.</p>
  <blockquote>“I'm not fighting because I want to win. I’m fighting because I have to protect them!”<br>— Ichigo Kurosaki</blockquote>
  <p>When Orihime is kidnapped and taken to Hueco Mundo, Ichigo and his friends go to rescue her. They fight Espada like:</p>
  <ul>
    <li>Grimmjow, a wild panther-like fighter.</li>
    <li>Ulquiorra, emotionless and powerful.</li>
  </ul>
  <p>Ichigo reaches new heights of power, unlocking Vasto Lorde, an uncontrollable form that fuses his Hollow and Soul Reaper powers. In a brutal showdown, he defeats Ulquiorra.</p>
  <blockquote>“You don’t understand hearts, Ulquiorra. That’s why you lost.”<br>— Ichigo Kurosaki</blockquote>

  <h2>The Fake Karakura Town Arc: The Battle Against Aizen</h2>
  <p>Aizen launches an assault on the human world. The captains and lieutenants battle his Espada in a fake version of Karakura Town. Meanwhile, Ichigo trains with his father, Isshin, a former Soul Reaper captain, to learn Final Getsuga Tenshō—a last-resort power.</p>
  <blockquote>“If I use this technique… I will lose my powers.”<br>— Ichigo Kurosaki</blockquote>
  <p>In the climactic battle, Ichigo uses his final form, becoming one with Zangetsu. He overwhelms Aizen with sheer force and spiritual pressure.</p>
  <blockquote>“Getsuga… Tenshō!”<br>— Ichigo</blockquote>
  <p>A weakened Aizen is sealed by Kisuke Urahara, and Ichigo loses all of his Soul Reaper powers. Peace returns—for a time.</p>

  <h2>The Lost Agent Arc</h2>
  <p>Ichigo returns to a normal life, but struggles with powerlessness. He meets Kūgo Ginjō and the Fullbringers, humans with unique powers derived from spiritual energy.</p>
  <p>They offer Ichigo a way to regain his abilities—but betray him. Ginjō seeks to use Ichigo’s powers for revenge against Soul Society.</p>
  <p>With help from the captains, Ichigo regains his Soul Reaper powers, stronger than ever. He defeats Ginjō and reconciles his place between two worlds.</p>

  <h2>The Thousand-Year Blood War Arc</h2>
  <p>The final war begins.</p>
  <p>The Wandenreich, a secret empire of Quincies led by Yhwach, the father of all Quincies, declares war on Soul Society.</p>
  <blockquote>“We are the shadow beneath your light.”<br>— Yhwach</blockquote>
  <p>Yhwach's army, the Sternritter, decimates the Soul Reapers. Captains lose their Bankai. Yamamoto, the fiery commander, is killed by Yhwach himself.</p>
  <blockquote>“Farewell… old flame.”<br>— Yhwach</blockquote>
  <p>Ichigo learns shocking truths: his mother was a Quincy. His sword has two spirits—Zangetsu (his Shinigami power) and Yhwach’s essence (his Quincy heritage). He reforges his blades, wielding dual Zanpakutō.</p>
  <blockquote>“My sword… has always been me!”<br>— Ichigo Kurosaki</blockquote>
  <p>Ichigo and his allies—Rukia, Renji, Byakuya, and more—battle the Sternritter. Rukia unlocks her true Bankai, freezing her enemies in a second of death. Uryū joins Yhwach but ultimately sides with his friends.</p>
  <p>In the final battle, Yhwach threatens to erase the future itself. Ichigo, combining all his powers, shatters fate.</p>
  <blockquote>“Even if fate says otherwise… I will protect everything!”<br>— Ichigo Kurosaki</blockquote>

  <h2>Epilogue: A New Era Begins</h2>
  <p>Years later, peace reigns.</p>
  <p>Ichigo marries Orihime. Rukia becomes a captain. They each have children—Kazui Kurosaki and Ichika Abarai—hinting that the cycle continues.</p>
  <p>Bleach ends not with an end—but with a beginning.</p>
  <blockquote>“Thank you, Rukia… for giving me the power to protect.”<br>— Ichigo Kurosaki</blockquote>

  <h2>Iconic Quotes Recap</h2>
  <ul>
    <li>“Bankai… Tensa Zangetsu!” — Ichigo Kurosaki</li>
    <li>“Aizen… I’m going to defeat you. No matter what it takes.” — Ichigo</li>
    <li>“Admire the moon, Soul Society… soon it shall be mine.” — Aizen</li>
    <li>“You are worthy, Ichigo. You wield the blade that cuts fate.” — Yhwach</li>
    <li>“Even if I can’t protect them, I still want to try.” — Orihime Inoue</li>
    <li>“Nothing in this world happens by chance.” — Urahara Kisuke</li>
    <li>“The world is not beautiful. Therefore it is.” — Kubo Tite (manga insert)</li>
  </ul>

</body>
</html>
EOF

# Step 7: Restart Apache
sudo systemctl restart apache2

# Step 8: Show Info
IP=$(hostname -I | awk '{print $1}')
echo "✅ Website deployed: http://$IP"
echo "📁 Pages:"
echo "   - http://$IP/opepice.html"
echo "   - http://$IP/naruto.html"
echo "   - http://$IP/bleach.html"
echo "🤖 Robots.txt: http://$IP/robots.txt"
# ======= End of 2. web.sh =======


# ======= Start of 3. ssh.sh =======
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
# ======= End of 3. ssh.sh =======


# ======= Start of 4. msg.sh =======
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
# ======= End of 4. msg.sh =======


# ======= Start of 5. sql.sh =======
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
# ======= End of 5. sql.sh =======
