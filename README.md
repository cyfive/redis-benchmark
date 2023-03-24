# A Redis benchmark toolset docker image


## Build
### Prerequisite
* Podman
* make

### Build and publish

Run build:

```
make VERSION=0.1 build
```

Available configuration options:

`PULL_DOCKER_REPO` - registry where you want to pull the images from, the default is `quay.io`.

`PUSH_DOCKER_REPO` - registry where you want to put the images, the default is `quay.io`.

`DOCKER_REPO_USER` - auth user name on registry, default value is `please-set-user-name`.

`DOCKER_REPO_PASS` - auth password on registry, default value is `please-set-password`.

`VERSION` - image tag, default value is `0.0`

If you want to publish builded image to own registry you must set `DOCKER_REPO_USER` and `DOCKER_REPO_PASS`, like this:

```
make VERSION=0.1 DOCKER_REPO_USER=johndoe DOCKER_REPO_PASS=S3cR3t publish
```

## Usage
Available configuration options:

`REDIS_HOST` - Redis host for benchmark, default value is `127.0.0.1`. The option used is -h.

`REDIS_PORT` - Redis port, default value is `6379` The option used is -p.

`REDIS_PASSWORD` - Redis auth password, if needed, default value is empty. The option used is -a.

`REDIS_TEST_CLIENT` - how many parallel connection, default value is `50`. The option used is -c.

`REDIS_TEST_REQUESTS` - now many requests send, default value is `100000` The option used is -n.

`REDIS_TEST_SIZE` - data size in bytes, default value is `3`. The option used is -d.

`REDIS_TEST_CONNECTION` - 1 - keepalive 0 - reconnect, default value is `1`. The option used is -k.

`REDIS_TESTS` Only run the comma separated list of tests. The test names are the same as the ones produced as output. Default value is empty. The option used is -t.

`REDIS_CUSTOM_ARGS` You can pass addition parameters to `redis-benchmark` command, default value is empty.


Run Redis and run benchmark like this:

```
podman run -ti --rm -e REDIS_HOST=redis.example.com redis-benchmark
```

## Examples
See `examples` folder.


