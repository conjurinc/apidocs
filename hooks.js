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

// Postfix variable names w/ testRunId to avoid collisions
hooks.beforeValidation('Variable > Create > Create a new variable', function(transaction) {
    if (transaction.real.statusCode == '409') {
        console.log('Skipping create test, variable already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// Trims newlines
function trim(input) {
    return input.replace(/^\s+|\s+$/g, "");
}