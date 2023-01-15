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

cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
<head>
<title>Serving index.html with Nginx</title>
</head>
<body>
<h1> Serving from Nginx server </h1>
<p>Demoing how to serve Nginx from GCP</p>
</body>
</html>
EOF

mv /var/www/html/index.html /var/www/html/index.html.old || echo "Old index doesn't exist"

[[ -n "${PROXY_PATH}" ]] && mkdir -p /var/www/html/${PROXY_PATH} && cp /var/www/html/index.html /var/www/html/${PROXY_PATH}/index.html

chkconfig nginx on || systemctl enable nginx || systemctl start nginx
systemctl restart nginx && journalctl -xe

