var express = require('express');
var http = require('http');
var routes = require('./config/routes');
var environment = require('./config/environment');

var SERVICE_PORT = 80;

var app = express();
environment.initialize(app, express);
routes.initialize(app);

http.createServer(app).listen(SERVICE_PORT, function () {
    console.log('Express server listening on port ' + SERVICE_PORT + '.');
});
