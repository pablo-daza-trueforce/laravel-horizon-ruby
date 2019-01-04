# DOCKER
FROM hitalos/php:latest
LABEL maintainer="Aketza Daza <muchachopolo@gmail.com>"

# Download and install NodeJS
ADD install-node.sh /usr/sbin/install-node.sh
RUN ["chmod", "+x", "/usr/sbin/install-node.sh"]
RUN /usr/sbin/install-node.sh


# basics
RUN apk add openssh-server openssh-client curl
RUN apk add nano
RUN apk add openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config

# install RVM, Ruby, and Bundler
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"


# Install pre-required extensions libraries
RUN apk add --update libxml2-dev

# Install extensions
RUN docker-php-ext-install soap bcmath pcntl

WORKDIR /var/www
CMD composer  --port=80 --host=0.0.0.0
CMD php ./artisan serve --port=80 --host=0.0.0.0
EXPOSE 80
HEALTHCHECK --interval=1m CMD curl -f http://localhost/ || exit 1
