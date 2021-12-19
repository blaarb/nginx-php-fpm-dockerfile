FROM nginx:1.20

RUN set -x \
    && apt update \
    && apt install -y wget supervisor gnupg2 ca-certificates \
    && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ bullseye main" | tee /etc/apt/sources.list.d/php.list \
    && apt update \
    && apt install -y php8.0 php8.0-fpm php8.0-mysql php8.0-imap php8.0-xml php8.0-curl php8.0-mbstring php8.0-zip

COPY fpm-pool-file /etc/php/8.0/fpm/pool.d/www.conf
COPY nginx-vhost-file /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY index.php /usr/share/nginx/html/

CMD ["/usr/bin/supervisord", "-n"]
