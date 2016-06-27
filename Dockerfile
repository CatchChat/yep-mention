FROM ruby:2.3.1

RUN apt-get update && apt-get -y install supervisor && rm -rf /var/lib/apt/lists/*

ENV WORKDIR /var/www
WORKDIR $WORKDIR
ADD . $WORKDIR
RUN bundle install --without development test --deployment
RUN mkdir -p tmp/pids
CMD /usr/bin/supervisord -c supervisord.conf
