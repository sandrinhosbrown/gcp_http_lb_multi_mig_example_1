#!/bin/bash -xe

RPM_INSTALL_ARGS="install -y nginx"

if [ -f "/etc/redhat-release" ]; then
  yum update -y || dnf update -y
  yum $RPM_INSTALL_ARGS || dnf $RPM_INSTALL_ARGS
else
  apt-get update
  apt-get install -y nginx
  ufw allow '${ufw_allow_nginx}'
fi

#echo "Welcome to Google Compute VM Instance deployed using Terraform!!!" > /var/www/html/index.html

cat <<EOF > /var/www/html/index.html
<html><body>
<h1>Demo from Sandro</h1>
<p>Serving Nginx from GCP deployed in multiple zones</p>
<p><?php printf($_SERVER["HTTP_HOST"]); ?></p>
</body></html>
EOF

echo 

chkconfig nginx on || systemctl enable nginx || systemctl start nginx
systemctl restart nginx

