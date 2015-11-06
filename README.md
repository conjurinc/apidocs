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

**Don't edit `api.md` directly!**

Edit the files in `src/` and then run

```
hercule src/api.md -o api.md
```

to compile them into `api.md`.

## Testing

Tests are run with dredd in a Docker container

```
docker build -t apidocs .
docker run --rm -v $PWD:/app apidocs dredd
```