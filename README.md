# Cloudsmith Push Action

Push packages easily to your [Cloudsmith](https://cloudsmith.com) repositories, using the [Cloudsmith CLI](https://pypi.org/project/cloudsmith-cli/).

## Cloudsmith CLI

This action uses the Cloudsmith CLI and intends to be as similar
to its structure and terminology as possible.

**Supported:**

- Push:
  - [Alpine format](https://cloudsmith.com/alpine-repository/)
  - [Dart format](https://cloudsmith.com/dart-repository/)
  - [Debian format](https://cloudsmith.com/debian-repository/)
  - [Docker format](https://cloudsmith.com/docker-registry/)
  - [Python format](https://cloudsmith.com/python-repository/)
  - [RedHat/RPM format](https://cloudsmith.com/rpm-repository/)
  - [Raw format](https://cloudsmith.com/raw-repository/)

**Not Supported, But May Work:**

- Push:
  - Other package formats may work but official support has not yet been added to the Action.

Please feel free to contribute pull requests to add additional support!

## Cloudsmith API Key

The API key is required for the cloudsmith-cli to work.

Obtain the API Key from [Cloudsmith user settings](https://cloudsmith.io/user/settings/api/). You should use a least-privilege account for Continuous Integration.

Add a secret named `CLOUDSMITH_API_KEY` and a value of the API Key obtained from cloudsmith. Secrets are maintained in the settings of each repository.

Pass your secret to the Action as seen in the Example usage.

## Examples

The following examples use static files located within `test/fixtures`. When republishing existing packages the `republish` flag must be set to `true`, but is otherwise recommended to not use this since it overwrites (and causes longer publish times).

To pin to a specific release of this Github Action, replace `use: cloudsmith-io/action@master` with the version you require e.g. `uses: cloudsmith-io/action@0.4.0`.

### Alpine Package Push

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
          distro: "alpine"
          release: "v3.9"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-alpine-example-1.0.0-r0.apk"
```

### Dart Package Push

```yaml
name: Push Dart
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Dart Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "dart"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-dart-example-1.0.0.tar.gz"
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
          republish: "true" # needed ONLY if version is not changing
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
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/alpine-docker-test.tar.gz"
```

### Python Package Push

```yaml
name: Push Python
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Python Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "python"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-python-example-1.0.0.tar.gz"
```

### RedHat/RPM Package Push

```yaml
name: Push RedHat/RPM
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: RedHat/RPM Push Demo
    steps:
      - uses: actions/checkout@v1
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "rpm"
          owner: "cloudsmith"
          repo: "actions"
          distro: "any-distro"
          version: "any-version"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-rpm-example-1.0-1.x86_64.rpm" #real file that will repeat versions
```

### Raw File Push

```yaml
name: Push Raw
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Raw File Push Demo
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
          description: "See https://github.com/cloudsmith-io/action"
          version: ${{ github.sha}}
```

## Contributing

Yes! Please do contribute, this is why we love open source. Please see `CONTRIBUTING.md` for contribution guidelines when making code changes or raising issues for bug reports, ideas, discussions and/or questions (i.e. help required).

## EOF

This quality product was brought to you by [Cloudsmith](https://cloudsmith.io) and the [fine folks who have contributed](https://github.com/cloudsmith-io/action/blob/master/.github/CONTRIBUTORS.md).
