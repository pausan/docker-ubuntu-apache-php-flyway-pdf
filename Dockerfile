FROM ubuntu:20.04

# -----------------------------------------------------------------------------
# install packages & PHP modules & tools
#  - zip
#  - nodejs
#  - pdo_mysql
#  - xdebug (dev only)
#  - xvfb wkhtmltopdf xauth required to generate pdf files
#  - wkhtmltopdf < v0.12.4 has a bug that makes it crash, so we download v0.12.5 instead
# -----------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
                       vim xvfb xauth wkhtmltopdf zlib1g-dev mysql-client logrotate \
                       curl wget unzip less supervisor libyaml-dev iputils-ping tmux ripgrep \
                       locales language-pack-es-base \
                       build-essential gnupg \
                       apache2 \
                       libapache2-mod-php7.4\
                       apachetop \
                       php7.4 \
                       php7.4-curl \
                       php7.4-fpm \
                       php7.4-mysql \
                       php7.4-zip \
                       php7.4-mbstring \
                       php7.4-opcache \
                       php-dev \
                       php-pear \
                       phpunit \
                       composer \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && wget -q -O /tmp/wkhtmltox_0.12.5-rc.deb "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb" \
    && apt install -y /tmp/wkhtmltox_0.12.5-rc.deb \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pecl channel-update pecl.php.net
RUN echo "" | pecl install -f yaml-2.0.4

# install flyway on a shared dir
ENV FLYWAY_DIR=/usr/local/lib/flyway-6.3.1
RUN wget -q -O /tmp/flyway-commandline-6.3.1-linux-x64.tar.gz \
         https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.3.1/flyway-commandline-6.3.1-linux-x64.tar.gz \
    && mkdir -p /usr/local/lib/ \
    && tar -C /usr/local/lib/ -xzf /tmp/flyway-commandline-6.3.1-linux-x64.tar.gz \
    && rm -rf /tmp/*

EXPOSE 80 443

# NOTE: ideally you should configure and run supervisor in foreground
