FROM ruby:2.3.1

ENV WORKDIR /var/www
WORKDIR $WORKDIR
ADD . $WORKDIR
RUN bundle install --without development test --deployment
RUN mkdir -p tmp/pids
EXPOSE 3000
CMD bundle exec ruby yep_app.rb -e $RACK_ENV -p 3000 -d -l log/$RACK_ENV.log -P tmp/pids/3000.pid
