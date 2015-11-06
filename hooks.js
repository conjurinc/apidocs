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

// Stash the Conjur API key to use in following routes
hooks.after("Authentication > Login > Exchange a user login and password for an API key", function(transaction) {
    stash['apikey'] = trim(transaction.real.body);
});

// Retrieve the stashed API key and use it to obtain and API token
hooks.before("Authentication > Authenticate > Exchange a user login and API key for an API token", function(transaction) {
    transaction.request.body = stash['apikey'];
});

// Stash the API token for future requests
hooks.after("Authentication > Authenticate > Exchange a user login and API key for an API token", function(transaction) {
    transaction.request.body = stash['apikey'];
});

// Trims newlines
function trim(input) {
    return input.replace(/^\s+|\s+$/g, "");
}