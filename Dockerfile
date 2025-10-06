FROM ghcr.io/rkojedzinszky/webhost-images/php84:20251006

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source https://github.com/kubernetize/postfixadmin

ARG POSTFIXADMIN_VER=4.0.1

USER 0

RUN \
    apk --no-cache add -t build-deps curl tar && \
    mkdir -p /var/www/html && \
    curl -sL https://github.com/postfixadmin/postfixadmin/archive/refs/tags/postfixadmin-${POSTFIXADMIN_VER}.tar.gz | \
    tar xzf - -C /var/www/html --strip-components=1 && \
    ln -sf php84 /usr/bin/php && \
    sh /var/www/html/install.sh && \
    rm /var/www/html/composer.phar /usr/bin/php && \
    apk --no-cache del build-deps && \
    sed -i -e "s,/var/www/html,/var/www/html/public,g" /etc/apache2/conf.d/00-default.conf && \
    chown 8080:8080 /var/www/html/templates_c

USER 8080
