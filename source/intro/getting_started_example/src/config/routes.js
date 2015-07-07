var underscore = require('underscore');
var routes = require('./routes');


routes.health = underscore.extend(
    require('../routes/health')
);

routes.echo = underscore.extend(
    require('../routes/echo')
);

routes.index = underscore.extend(
    require('../routes/index')
);

exports.initialize = function(app){
    app.get('/health', routes.health.index);
    app.get('/echo/*', routes.echo.index);
    app.get('/', routes.index.index);
};
