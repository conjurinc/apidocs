# Retries

In certain scenarios Conjur may become overloaded with client requests.
When this happens Conjur returns a `503 Service Unavailable` response.
The 503 return code can be used as a signal to a client application that
the request should be retried.

Note that handling 503 retries is required only in uncommon
circumstances; when a service regularly issues hundreds of concurrent requests
to Conjur.

Conjur load test example results, showing 503 responses on heavy load:

<img src="https://info.conjur.net/hubfs/Security-Secrets-Performance-Benchmark-2.png"/>

See [our blog post](https://blog.conjur.net/scaling-security-4-million-secrets)
on scaling and benchmarks for more detail.
