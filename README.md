# apidocs

Define the Conjur API in [API Blueprint](https://github.com/apiaryio/api-blueprint).

Using [hercule](https://github.com/jamesramsay/hercule) to keep organization sane.

Testbed is up on [Apiary](http://docs.conjur.apiary.io/).

Apiary email/password are stored in Conjur:

```
apiary.io/email
apiary.io/password
```

## Development

**Don't edit `./api.md` directly!**

Edit the files in `src/` and then run

```
hercule src/api.md -o api.md
```

to compile them into `./api.md`.

You can then use the Apiary CLI to run a local server that renders the CLI:

```
gem install apiaryio
apiary preview --server --port=8081 --path api.md
```

## Testing

Tests are run with [dredd](http://dredd.readthedocs.org/en/latest/) in a Docker container against a Conjur appliance
also running in Docker.

Run them with:

```
./jenkins.sh
```

For local development, pass the NOKILL flag. 
Then you can run the tests without launching a new appliance each time.

```
NOKILL=1 ./jenkins.sh
./dredd.sh https://$(docker-machine ip default):61000
```