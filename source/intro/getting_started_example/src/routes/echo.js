
exports.index = function(request, response)
{
    response.end(request.params[0])
};
