# Image for wkhtmltopdf with patched qt.
FROM ruby:2.7-alpine3.11
LABEL maintainer "Petteri Heinonen <petu.heinonen@gmail.com>"

ARG RAILS_ENV=development

RUN apk update && apk --update add \
    pkgconfig \
    tzdata \
    potrace \
    ttf-freefont \
    font-noto \
    fontconfig \
    nodejs-lts

# Setup Rails application
# =======================
WORKDIR /tmp

ADD Gemfile Gemfile.lock /tmp/

RUN echo "gem: --no-document" >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && chmod uog+r /etc/gemrc && \
    apk update && \
    apk --update add --virtual build-dependencies gcc g++ make \
    postgresql-dev && \
    gem update --system 3.1.4 && \
    gem install bundler -v '2.1.4' && \
    bundle install && \
    apk del build-dependencies

ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR
ADD . $APP_DIR

RUN RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=dummy REDIS_ENDPOINT=dummy DATABASE_URL=postgres://dummy:dummy@dummy/dummy bundle exec rake assets:clobber assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "[::]"]