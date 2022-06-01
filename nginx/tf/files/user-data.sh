#!/bin/bash
sudo amazon-linux-extras install epel
sudo amazon-linux-extras enable nginx1
sudo yum clean metadata
sudo yum -y install nginx
sudo yum install -y certbot-apache
sudo yum install -y python-certbot-nginx
cat<<EOF > /etc/nginx/conf.d/${AUTH0_CUSTOM_DOMAIN}.conf
server {
    server_name ${AUTH0_CUSTOM_DOMAIN};

    location / {
      # Proxy_pass configuration
      proxy_pass https://${AUTH0_EDGE_RECORD}/;
      proxy_set_header cname-api-key "${CNAME_API_KEY}";
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_pass_header Set-Cookie;
      proxy_pass_header User-Agent;
      proxy_pass_header Origin;
      proxy_pass_header Referer;
      proxy_pass_header Authorization;
      proxy_pass_header Accept;
      proxy_pass_header Accept-Language;
      proxy_cookie_path / "/; Path=/; SameParty";
    }
}
EOF
sudo certbot --nginx -d ${AUTH0_CUSTOM_DOMAIN} --non-interactive --agree-tos --no-eff-email --no-redirect --email \'${EMAIL}\'
