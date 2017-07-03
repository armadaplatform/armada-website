FROM microservice_php
MAINTAINER Cerebro <cerebro@ganymede.eu>

ENV ARMADA_WEBSITE_APT_GET_UPDATE_DATE 2015-12-07

RUN apt-get update
RUN apt-get install -y make build-essential g++ ruby-dev nodejs zlib1g-dev zip

RUN gem install bundler
RUN gem install eventmachine -v '1.0.7'

ADD Gemfile /opt/armada-website/
RUN cd /opt/armada-website && bundler install
RUN sed -i 's/\(LogFormat "%v:%p\)\(.* vhost_combined\)/\1 %{X-Forwarded-For}i\2/' /etc/apache2/apache2.conf

ADD ./ /opt/armada-website/
RUN cd /opt/armada-website/source/intro/getting_started_example && zip -r ../example.zip * && cd .. && rm -rf getting_started_example
RUN cd /opt/armada-website/source/docs/coffee-counter && zip -r ../coffee-counter.zip * && cd .. && rm -rf coffee-counter

RUN cd /opt/armada-website && bundler exec middleman build --verbose

RUN chmod 777 /opt/www/www/.* -R
