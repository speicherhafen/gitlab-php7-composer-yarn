FROM php:7.1.33

ENV PHANTOM_JS "phantomjs-2.1.1-linux-x86_64"

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -x \
   && apt-get update -y \
   && apt-get install -y wget apt-transport-https gnupg2

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
   && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
   && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list 


RUN apt-get update -y \
   && apt-get install -y \
      git \
      zip \
      libmcrypt-dev \
      libcurl4-gnutls-dev \
      libicu-dev \
      libfreetype6-dev \
      libjpeg-dev \
      libpng-dev \
      libxml2-dev \
      libbz2-dev \
      libc-client-dev \
      libkrb5-dev 

RUN apt-get update -y \
   #this fixes installation for pdftk
   && mkdir -p /usr/share/man/man1 \ 
   && apt-get install -y \
      default-mysql-client \
      nodejs \
      yarn \
      google-chrome-stable \
      pdftk \
   && wget https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip -O /tmp/chromedriver.zip \
   && unzip /tmp/chromedriver.zip -d /usr/local/bin \
   && wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 -O /tmp/$PHANTOM_JS.tar.bz2 \
   && tar xvjf /tmp/$PHANTOM_JS.tar.bz2 -C /usr/local/bin --strip-components 2 $PHANTOM_JS/bin/phantomjs

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - 

COPY --from=composer:1.7.2 /usr/bin/composer /usr/local/bin/composer

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
   && docker-php-ext-install mbstring mcrypt curl json intl gd xml zip bz2 opcache pdo_mysql pcntl imap exif bcmath

RUN pecl install xdebug-2.9.0 \
   && docker-php-ext-enable xdebug \
   && echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini \
   && echo "memory_limit = -1" > /usr/local/etc/php/conf.d/memory.ini 

RUN set -x \
   && apt-get autoclean -y \
   && apt-get --purge autoremove -y \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php -i
