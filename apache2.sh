# Apache2 Install
# --------------------------
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>welcome to MAHESH ! aws infra created using terraform in us-east-1 region </h1>"/sudo tee var/www/html/index.html 