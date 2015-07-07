FROM microservice
MAINTAINER Peter Gibbons <peter@initech.com>

RUN apt-get install -y python python-dev python-pip
RUN pip install -U web.py

ADD . /opt/coffee-counter
ADD ./supervisor/coffee-counter.conf /etc/supervisor/conf.d/

EXPOSE 80
