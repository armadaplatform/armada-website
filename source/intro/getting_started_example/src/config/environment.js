var expressValidator = require('express-validator');

exports.initialize = function (app, express) {
    app.enable('trust proxy');
    app.use(express.favicon());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(expressValidator());
    app.use(app.router);
};
