FROM debian
COPY libsodium-1.0.12 /usr/src/libsodium
COPY php-7.1.9 /usr/src/php
COPY php-7.1.9/php.ini-development /usr/local/lib/php.ini

#Link up the evp.h location.
RUN mkdir -p //usr/lib/x86_64-linux-gnu/include/
RUN ln -s /usr/include/openssl/ /usr/lib/x86_64-linux-gnu/include/

#Loop back the lib directory to its parent, because that's where libssl.a is.
RUN ln -s /usr/lib/x86_64-linux-gnu/ /usr/lib/x86_64-linux-gnu/lib

RUN apt-get update && apt-get install -y \
 git \
 apache2-dev \
 libxml2-dev \
 libbz2-dev \
 libreadline-dev \
 libmcrypt-dev \
 libssl-dev \
 libcurl4-openssl-dev \
 libfreetype6-dev \
 libjpeg-dev \
 libzip-dev \
 apache2

RUN cd /usr/src/php && ./configure --with-config-file-path=/usr/local/lib/ \
  --with-pear=/usr/share/php \
  --with-bz2 \
  --with-curl \
  --with-gd \
  --enable-calendar \
  --enable-mbstring \
  --enable-bcmath \
  --enable-sockets \
  --with-libxml-dir \
  --with-mysql-sock=/var/run/mysqld/mysqld.sock \
  --with-openssl=/usr/lib/x86_64-linux-gnu \
  --with-readline \
  --with-zlib \
  --with-libzip \
  --enable-zip \
  --with-apxs2=/usr/bin/apxs2 \
  --enable-soap \
  --with-freetype-dir=/usr/include/freetype2/ \
  --with-mcrypt=/usr/src/mcrypt-2.6.8 \
  --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
  --with-png-dir=/usr/lib/x86_64-linux-gnu/

RUN cd /usr/src/php && make && make install
RUN cd /usr/src/libsodium && ./configure && make && make install

RUN cd /usr/src/libsodium ln -s /usr/local/lib/libsodium.la /usr/lib/x86_64-linux-gnu/libsodium.la
RUN ldconfig
RUN pecl install libsodium-1.0.6

#Clean out the documentroot
RUN rm -v /var/www/html/index.html

#Copy in the current, stable version of PHP-Ant
COPY php-ant /var/www/html/

EXPOSE 80
EXPOSE 22
EXPOSE 443