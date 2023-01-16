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

cat <<EOF > /var/www/html/index.html
<html><body>
<h1>Demo from Sandro</h1>
<p>Serving Nginx from GCP deployed in multiple zones</p>
</body></html>
EOF


chkconfig nginx on || systemctl enable nginx || systemctl start nginx
systemctl restart nginx

