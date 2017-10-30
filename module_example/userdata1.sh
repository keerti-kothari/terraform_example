
#!/bin/bash
yum install httpd -y
echo "I'm testing Terraform" > /var/www/html/index.html
service httpd start
