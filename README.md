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

To run these tests you will need to be sure to have [Summon](https://github.com/cyberark/summon) installed, as well as a summon provider. A convenient provider to use for these tests is the [Conjur](https://github.com/cyberark/summon-conjur) provider.

In addition to installing Summon and a valid provider, you'll need to set the `SUMMON_PROVIDER` environment variable (e.g. to `summon-conjur` if you select that as your summon provider) and you may need to run `export CONJUR_MAJOR_VERSION=4`.

Tests are run with [dredd](http://dredd.readthedocs.org/en/latest/) in a Docker container against a Conjur appliance
also running in Docker.

First, update `/etc/hosts` like so:

```
# On linux, running Docker natively
localhost
# On OSX, value should be `docker-machine ip default`
192.168.99.102 conjur
```

Then run the Jenkins script in NOKILL mode:

```
$ NOKILL=1 ./jenkins.sh
...
Container id:
a147265fc9d99701f0d3836313f2c607c287a5768ed42c77fd144669dc35bb09
```

Finally, export the container id:

```
$ export CONJUR_CONTAINER=a147265fc9d99701f0d3836313f2c607c287a5768ed42c77fd144669dc35bb09
```

Now you can re-run the tests without re-launching Conjur:

```
$ make test
```

## Selecting tests by Conjur server version

The `dredd` wrapper script inspects the Conjur server version using the server [/info](http://docs.conjur.apiary.io/#reference/utilities/server-info) URL. If a corresponding "transactions-[version].txt" file exists, then only the tests specified in this file will be run.

To print the names of all the available tests, run `make names`.
