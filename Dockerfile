FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y build-essential 

# vim editor (required for rails secrets:edit)
RUN apt-get install -y vim
ENV EDITOR=vim

# postgres
RUN apt-get install -y libpq-dev

# nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# JS runtime
RUN apt-get install -y nodejs

WORKDIR /app/
COPY Gemfile* ./
RUN bundle install
