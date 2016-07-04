FROM ruby:2.3.1

ENV WORKDIR /var/www
WORKDIR $WORKDIR
ADD . $WORKDIR
RUN bundle install --without development test --deployment
RUN mkdir -p tmp/pids
EXPOSE 3000
CMD bundle exec ruby yep_app.rb -e $RACK_ENV -p 3000 -l log/$RACK_ENV.log -s -v -P tmp/pids/3000.pid
