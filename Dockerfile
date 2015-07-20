#
# Ohmbrewer - The web application for a happy brewday
# See http://ohmbrewer.org for more information
#
 
FROM ruby:2.2.1
MAINTAINER Kyle Oliveira <kyle.oliveira@cornell.edu>

ENV APP_HOME /ohmbrewer

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir $APP_HOME

# Provide a cache for the Gemfile, etc. so Docker builds faster
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install

# Add the web application
ADD . $APP_HOME
WORKDIR $APP_HOME
RUN bundle exec rake jobs:work &
#RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
#CMD ["rails","server","-b","0.0.0.0"]

