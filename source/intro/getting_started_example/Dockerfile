FROM dockyard.armada.sh/microservice_node

ADD src/package.json /opt/package.json
RUN cd /opt && npm install --no-bin-links

ADD ./supervisor/example.conf /etc/supervisor/conf.d/example.conf
ADD ./ /opt/example

EXPOSE 80
