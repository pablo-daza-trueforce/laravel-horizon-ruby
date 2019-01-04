# DOCKER
FROM hitalos/php:latest
LABEL maintainer="Aketza Daza <muchachopolo@gmail.com>"

# Download and install NodeJS
ADD install-node.sh /usr/sbin/install-node.sh
RUN ["chmod", "+x", "/usr/sbin/install-node.sh"]
RUN /usr/sbin/install-node.sh


# basics
RUN apk update && apk upgrade && apk --update add \
    build-base libc-dev linux-headers ruby ruby-dev ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc

RUN apk add openssh-server openssh-client curl
RUN apk add nano
RUN apk add openssl curl libxml2-dev libxslt-dev autoconf ncurses-dev automake libtool bison subversion


# Install pre-required extensions libraries
RUN apk add --update libxml2-dev



# Install extensions
RUN docker-php-ext-install soap bcmath pcntl

WORKDIR /var/www
RUN gem install rake
RUN gem install zendesk_apps_tools
CMD composer  --port=80 --host=0.0.0.0
CMD php ./artisan serve --port=80 --host=0.0.0.0
EXPOSE 80
HEALTHCHECK --interval=1m CMD curl -f http://localhost/ || exit 1
