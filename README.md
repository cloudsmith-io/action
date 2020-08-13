**This is a fork from https://github.com/AutoModality/action-cloudsmith/ - we're in the middle of repurposing it.**

# Cloudsmith Github Action

Interact with Cloudsmith repositories using the cloudmsith cli
to push packages, etc.

## Cloudsmith CLI

This action uses the Cloudsmith CLI and intends to be as similar
to its structure and terminology as possible.

**Implemented**

- Push
  - [Alpine format](https://cloudsmith.com/alpine-repository/)
  - [Debian format](https://cloudsmith.com/debian-repository/)
  - [Docker format](https://cloudsmith.com/docker-registry/)
  - [Raw format](https://cloudsmith.com/raw-repository/)

**Not Implemented**

- Everything else

## Cloudsmith API Key

The API key is required for the cloudsmith-cli to work.

Obtain the API Key from [Cloudsmith user settings](https://cloudsmith.io/user/settings/api/). You should use a less priveleged and generic account for Continuous Integration.

Add a secret named `CLOUDSMITH_API_KEY` and a value of the API Key obtained from cloudsmith. Secrets are maintained in the settings of each repository.

Pass your secret to the Action as seen in the Example usage.

## Examples

The following examples use static files located within `test/fixtures`. When republishing existing packages the `republish` flag must be set to `true`.

To pin to a specific release of this Github Action, replace `use: cloudsmith-io/action@master` with the version you require e.g. `uses: cloudsmith-io/action@0.3.0`.

### Alpine Push

```yaml
name: Push Alpine
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Alpine Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "alpine"
          owner: "cloudsmith"
          repo: "actions"
          distro: "alpine/v3.9"
          republish: "true"
          file: "test/fixture/cloudsmith-alpine-example-1.0.0-r0.apk"
```

### Raw File Push

```yaml
name: Push Raw
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Raw File Push Test
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "raw"
          owner: "cloudsmith"
          repo: "actions"
          file: "test/fixture/raw_file.txt"
          name: "Raw Test"
          summary: "Github Action test of raw pushes"
          description: "See https://github.com/AutoModality/action-cloudsmith/actions"
          version: ${{ github.sha}}
```

### Debian Package Push

```yaml
name: Push Debian
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Debian Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "deb"
          owner: "cloudsmith"
          repo: "actions"
          distro: "ubuntu"
          release: "xenial"
          republish: "true"
          file: "test/fixture/cloudsmith-debian-example_1.0.0_amd64.deb"
```

### Docker Image Push

**Note**: In most cases, it is better to use the native `docker cli` to push images to the Cloudsmith Repository. Search the Marketplace for many supporting implementations.

See [push-docker.yml](.github/workflows/push-docker.yml)

```yaml
name: Push Docker
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Docker Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "docker"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true"
          file: "test/fixture/alpine-docker-test.tar.gz"
```
