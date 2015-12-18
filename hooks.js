var hooks = require('hooks');

var stash = {};

// Run these before every transaction
hooks.beforeEach(function(transaction) {
    // Remove trailing newline character in plain text bodies
    if (transaction.expected.headers['Content-Type'] !== 'application/json') {
        transaction.expected.body = trim(transaction.expected.body);
    }
    if (transaction.request.headers['Content-Type'] === 'text/plain') {
        transaction.request.body = trim(transaction.request.body)
    }

    // Strip the trailing slashes off request paths, they're sometimes added for formatting
    var fullPath = transaction.fullPath;
    if (fullPath[fullPath.length - 1] === '/') {
        transaction.fullPath = fullPath.substring(0, fullPath.length - 1);
    }
});

// Trim response bodies, role#create returns ' ' as text/html ...wtf?
hooks.beforeEachValidation(function(transaction) {
   transaction.real.body = trim(transaction.real.body);
});

// The API key is randomly generated, so only check for 200 on route
hooks.beforeValidation("Authentication > Login > Exchange a user login and password for an API key (refresh token)", function(transaction) {
    if (transaction.real.statusCode == '200') {
        transaction.expected.body = transaction.real.body;
    }
});

// Stash the Conjur API key to use in following routes
hooks.after("Authentication > Login > Exchange a user login and password for an API key (refresh token)", function(transaction) {
    stash['apikey'] = trim(transaction.real.body);
});

// Retrieve the stashed API key and use it to obtain an API token
hooks.before("Authentication > Authenticate > Exchange a user login and API key for an access token", function(transaction) {
    transaction.request.body = stash['apikey'];
});

// Stash the API token for future requests
hooks.after("Authentication > Authenticate > Exchange a user login and API key for an access token", function(transaction) {
    stash['apitoken'] = new Buffer(trim(transaction.real.body)).toString('base64');
});

// Retrieve the stashed API token and use it in all future requests
hooks.beforeEach(function(transaction) {
    if (stash['apitoken'] != undefined) {
        // We don't want to swap the auth token when updating a user's password
        if (transaction.name !== "Authentication > Update Password > Update a user's password") {
            transaction.request['headers']['Authorization'] = 'Token token="' + stash['apitoken'] + '"';
        }
    }
});

// If we get a already-created conflict, continue on
hooks.beforeEachValidation(function(transaction) {
    if (transaction.real.statusCode === 409) {
        console.log('Skipping create, object already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// Don't actually update the user's password, set it to the same value so tests can be re-run
hooks.before("Authentication > Update Password > Update a user's password", function(transaction) {
    transaction.request.body = '9p8nfsdafbp';
});

// Stash the host-factory tokens on creation, so use them later
hooks.after('Host Factory > Create Token > Create a new host factory token', function(transaction) {
    var body = JSON.parse(transaction.real.body);
    stash['hftoken1'] = body[0]['token'];
    stash['hftoken2'] = body[1]['token'];
});

// Modify the token ID in the path of these routes to use the first HF token stashed during creation
[
    "Host Factory > Show Token > Retrieve a host factory token's metadata",
    'Host Factory > Revoke Token > Revoke a host factory token'
].forEach(function(route) {
    hooks.before(route, function(transaction) {
        var uriTokens = transaction.fullPath.split('/');
        uriTokens[uriTokens.length -1] = stash['hftoken1'];
        transaction.fullPath = uriTokens.join('/');
    });
});

// Use a stashed host-factory token to create a host
hooks.before('Host Factory > Create Host > Create a new host using a host factory token', function(transaction) {
    transaction.request['headers']['Authorization'] = 'Token token="' + stash['hftoken2'] + '"';
});

/*
 Work-arounds for 'misbehaving' routes
 */

// API Blueprint doesn't like the brackets in the layers[] param, so they're encoded in the doc
// Unencode them before sending the request to Conjur
hooks.before('Host Factory > Create > Create a new host factory', function(transaction) {
    transaction.fullPath = transaction.fullPath.replace('%5B%5D', '[]');
});

// role#create throws "405 Method not allowed" on duplicate insert, catch this and ignore it
hooks.beforeValidation('Role > Create > Create a new role', function(transaction) {
    if (transaction.real.statusCode === 405) {
        console.log('Skipping create, object already created');
        transaction.real.statusCode = transaction.expected.statusCode;
        transaction.real.body = transaction.expected.body;
    }
});

// These routes throws "422 UnprocessableEntity" on duplicate insert, catch this and ignore it
[
    'Resource > Create > Create a new resource',
    'Host Factory > Create > Create a new host factory',
    'Host Factory > Create Host > Create a new host using a host factory token'
].forEach(function(route) {
    hooks.beforeValidation(route, function(transaction) {
        if (transaction.real.statusCode === 422) {
            console.log('Skipping create, object already created');
            transaction.real.statusCode = transaction.expected.statusCode;
            transaction.real.body = transaction.expected.body;
        }
    });
});

// Audit events don't have a standard format, so JSON validation doesn't work
['All > Fetch all audit events', 'Single > Fetch audit events for a single role/resource'].forEach(function(transactionName) {
    hooks.beforeValidation('Audit > ' + transactionName, function(transaction) {
        if (transaction.real.statusCode === 200) {
            console.log('Skipping body comparison');
            transaction.real.body = transaction.expected.body;
        }
    });
});

/*
    Helper functions
 */

// Trims newlines from a string
function trim(input) {
    return input.replace(/^\s+|\s+$/g, "");
}