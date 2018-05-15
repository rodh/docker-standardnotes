FROM alpine

RUN apk -U upgrade \
    && apk add -t build-dependencies \
    git \
    curl-dev \
    wget \
    ruby-dev \
    build-base \
    nodejs \
    nodejs-npm \
    zlib-dev \
    && apk add \
    tzdata \
    ruby \
    ruby-io-console \
    ruby-json \
    ruby-bigdecimal \
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

EXPOSE 3000
ENTRYPOINT ["/entrypoint"]
CMD ["start"]
