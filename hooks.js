var hooks = require('hooks');

var stash = {};

// Remove trailing newline character in plain text bodies
hooks.beforeEach(function(transaction) {
    if (transaction.expected.headers['Content-Type'] !== 'application/json') {
        transaction.expected.body = trim(transaction.expected.body);
    }
    if (transaction.request.headers['Content-Type'] === 'text/plain') {
        transaction.request.body = trim(transaction.request.body)
    }
});

// Trim response bodies, role#create returns ' ' as text/html ...wtf?
hooks.beforeEachValidation(function(transaction) {
   transaction.real.body = trim(transaction.real.body);
});

// The API key is randomly generated, so only check for 200 on route
hooks.beforeValidation("Authentication > Login > Exchange a user login and password for an API key", function(transaction) {
    if (transaction.real.statusCode == '200') {
        transaction.expected.body = transaction.real.body;
    }
});

// Stash the Conjur API key to use in following routes
hooks.after("Authentication > Login > Exchange a user login and password for an API key", function(transaction) {
    stash['apikey'] = trim(transaction.real.body);
});

// Retrieve the stashed API key and use it to obtain an API token
hooks.before("Authentication > Authenticate > Exchange a user login and API key for an API token", function(transaction) {
    transaction.request.body = stash['apikey'];
});

// Stash the API token for future requests
hooks.after("Authentication > Authenticate > Exchange a user login and API key for an API token", function(transaction) {
    stash['apitoken'] = new Buffer(trim(transaction.real.body)).toString('base64');
});

// Retrieve the stashed API token and use it in all future requests
hooks.beforeEach(function(transaction) {
    if (stash['apitoken'] != undefined) {
        transaction.request['headers']['Authorization'] = 'Token token="' + stash['apitoken'] + '"';
    }
});

// If we get a name conflict, continue on
hooks.beforeEachValidation(function(transaction) {
    if (transaction.real.statusCode === 409) {
        console.log('Skipping create, object already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// Reset the password for 'alice' user, not 'admin'
hooks.before("User > Update Password > Update a user's password", function(transaction) {
   transaction.request['header']['Authorization'] = 'Basic' + new Buffer(trim('alice:9p8nfsdafbp')).toString('base64');
});
hooks.after("User > Update Password > Update a user's password", function(transaction) {
    transaction.request['header']['Authorization'] = 'Token token="' + stash['apitoken'] + '"';
});

// role#create throws "405 Method not allowed" on duplicate insert, catch this and ignore it
hooks.beforeValidation('Role > Create > Create a new role', function(transaction) {
    if (transaction.real.statusCode === 405) {
        console.log('Skipping create, object already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// resource#create throws "422 UnprocessableEntity" on duplicate insert, catch this and ignore it
hooks.beforeValidation('Resource > Create > Create a new resource', function(transaction) {
    if (transaction.real.statusCode === 422) {
        console.log('Skipping create, object already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// Trims newlines from a string
function trim(input) {
    return input.replace(/^\s+|\s+$/g, "");
}