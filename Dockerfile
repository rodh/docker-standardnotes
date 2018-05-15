FROM alpine

RUN apk -U upgrade
RUN apk add --no-cache \
    tzdata \
    nodejs \
    ruby \
    ruby-io-console \
    ruby-json \
    ruby-bigdecimal
RUN apk add --no-cache -t build-dependencies \
    git \
    curl-dev \
    wget \
    ruby-dev \
    build-base \
    nodejs-npm \
    zlib-dev \
  && git clone https://github.com/standardnotes/web.git /standardnotes \
  && gem install -N rails --version "$RAILS_VERSION" \
  && echo 'gem: --no-document' >> ~/.gemrc \
  && cp ~/.gemrc /etc/gemrc \
  && chmod uog+r /etc/gemrc \
  && rm -rf ~/.gem \
  && cd /standardnotes \
  && bundle config --global silence_root_warning 1 \
  && bundle install --system \
  && npm install \
  && npm install -g bower grunt \
  && bundle exec rake bower:install \
  && grunt \
  && apk del build-dependencies \
  && rm -rf /tmp/* /var/cache/apk/* /tmp/* /root/.gnupg /root/.cache/ /standardnotes/.git 

COPY entrypoint /entrypoint

RUN chmod +x entrypoint

EXPOSE 3000
ENTRYPOINT ["/entrypoint"]
CMD ["start"]
