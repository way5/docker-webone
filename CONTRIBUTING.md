# WebOne HTTP 1.X Proxy on Docker
This project is solely about containerizing WebOne. If you want to contribute to WebOne itself, please [read about contributing on WebOne](https://github.com/atauenis/webone/blob/master/CONTRIBUTING.md).

## Building and testing
Instructions on building and testing. Although it's possible to build packages without `dockerd` running, using [`buildah`](https://buildah.io/), the focus here is on [`buildx`](https://docs.docker.com/reference/cli/docker/buildx/). You're welcome to contribute with instructions for `buildah`. You may also go back to an earlier revision of the [README.md] and [CONTRIBUTING.md] and find instructions using `docker build`

### Prerequisites
- `docker` is installed in your development environment.
- `dockerd` the docker deamon is installed (and [started](https://docs.docker.com/config/daemon/start/))
- `buildx` is installed in your development environment.

### Building the docker image locally
1. Start the docker daemon if it's not already started: `sudo dockerd`
2. Run the build command: `docker buildx build --platform linux/amd64 -t webone-local --load .`
    - replace the platform (`linux/amd64`) if you're building for another platform
    - replace `webone-local` with any name you would like to give your local image
    - `--load` loads the image into your local docker, so you can use it as a container image.
3. Once the image is loaded, you may run it like explained in the [README](README.md), replacing `u306060/webone:latest` with `webone-local` or the name you gave the image in the build command above.

### Building from another [WebOne branch](https://github.com/atauenis/webone/branches)

Same instructions as above but add `--build-arg BRANCH=dev` to the `build`-command. Then it will use the `dev` branch instead of the `master` branch. You may use any branch name available at https://github.com/atauenis/webone/branches.

### Building from another (forked) repo
Same instructions as above but add `--build-arg REPO=https://github.com/otheruser/webone.git` to the `build`-command. Then it will use the forked repo instead of the original [atauenis repo](https://github.com/atauenis/webone). This is useful if you want to contribute and want to use docker for testing.

### Building from another repo and branch
Combining the above a full command could look like this:

```
docker buildx build --platform linux/amd64 -t webone-local \
  --build-arg REPO=https://github.com/otheruser/webone.git \
  --build-arg BRANCH=dev --load .
```

### Linting
Whenever you change the Dockerfile (or Dockerfile.ubuntu) it is good to keep best practices. You check if you have done that by running hadolint:

1. Start the docker daemon if it's not already started: `sudo dockerd`
2. Run hadolint (containerized): `docker run --rm -i -v ./.config/hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < Dockerfile` (repeat for Dockerfile.ubuntu)
3. Fix errors and warnings or add them to ignore list of the [hadolint configuration file](./.config/hadolint.yml) if there is a good reason for that. Read more [here](https://github.com/hadolint/hadolint).
