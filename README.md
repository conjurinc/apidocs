# apidocs

Define the Conjur API in [API Blueprint](https://github.com/apiaryio/api-blueprint).

Using [hercule](https://github.com/jamesramsay/hercule) to keep organization sane.

Testbed is up on [Apiary](http://docs.conjur.apiary.io/).

Apiary email/password are stored in Conjur:

```
apiary.io/email
apiary.io/password
```

The docs are pushed to [Apiary](http://docs.conjur.apiary.io/) when the tests pass in Jenkins.
The API page on the devsite has an embedded iframe referencing https://jsapi.apiary.io/apis/conjur.apib.

## Development

**Don't edit `./api.md` directly!**

Edit the files in `src/`. You can then compile the source files into `./api.md` run a local server that renders the API docs:

```
$ make preview
```

## Testing

Tests are run with [dredd](http://dredd.readthedocs.org/en/latest/) in a Docker container against a Conjur appliance
also running in Docker.

Locally, first run the Jenkins script in NOKILL mode:

```
$ NOKILL=1 ./jenkins.sh
...
Container id:
a147265fc9d99701f0d3836313f2c607c287a5768ed42c77fd144669dc35bb09
```

Then export the container id:

```
$ export CONJUR_CONTAINER=a147265fc9d99701f0d3836313f2c607c287a5768ed42c77fd144669dc35bb09
```

Then you can re-run the tests without re-launching Conjur:

```
$ make test
```
