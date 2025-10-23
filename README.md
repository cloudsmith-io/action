# ⚠️ Repository Archived

This repository is archived and no longer maintained. Please use our new supported Cloudsmith GitHub Action instead:
https://github.com/cloudsmith-io/cloudsmith-cli-action

---

# Cloudsmith Push Action

Push packages easily to your [Cloudsmith](https://cloudsmith.com) repositories, using the [Cloudsmith CLI](https://pypi.org/project/cloudsmith-cli/).

## Cloudsmith CLI and Executable

This action now supports both the Cloudsmith CLI and the new Cloudsmith executable. The Cloudsmith executable allows you to use Cloudsmith without needing to install it via pip, making it easier to integrate into your workflows.

From v0.6.9, we default the action to use the executable instead of having to install python, if you wish to use the old workflow, you can do so by specifying `executable: "false"`. This will attempt to download python and use pip to install the Cloudsmith-cli instead.

```yaml
...
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "maven"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true"
          file: "test/fixture/cloudsmith-maven-example-1.0.0.jar"
          executable: "false" # Add this to use pip instead
```

**Supported:**

- Push:
  - [Alpine](#alpine-package-push)
  - [Cargo](#cargo-crate-push)
  - [CocoaPods](#cocoapods-package-push)
  - [Composer](#composer-package-push)
  - [Dart](#dart-package-push)
  - [Debian](#debian-package-push)
  - [Docker](#docker-image-push)
  - [GO](#go-push)
  - [Helm](#helm-chart-push)
  - [Hex](#hex-push)
  - [Maven](#maven-package-push)
  - [npm](#npm-package-push)
  - [NuGet](#nuget-package-push)
  - [Python](#python-package-push)
  - [RedHat/RPM](#redhatrpm-package-push)
  - [Raw](#raw-file-push)

**Not Supported, But May Work:**

- Push:
  - Other package formats may work but official support has not yet been added to the Action.

Please feel free to contribute pull requests to add additional support!

Learn more about hosting format registries at Cloudsmith:

[Alpine](https://cloudsmith.com/alpine-repository) | [Cargo](https://cloudsmith.com/cargo-registry/) | [CocoaPods](https://cloudsmith.com/cocoapods-repository/) | [Composer](https://cloudsmith.com/composer-repository/) | [Dart](https://cloudsmith.com/dart-repository/) | [Debian](https://cloudsmith.com/debian-repository/) | [Docker](https://cloudsmith.com/docker-registry/) | [Go](https://cloudsmith.com/go-repository/) | [Helm](https://cloudsmith.com/helm-repository/) | [Hex](https://cloudsmith.com/product/formats/hex-repository) | [Maven](https://cloudsmith.com/maven-repository/) | [npm](https://cloudsmith.com/npm-registry/) | [NuGet](https://cloudsmith.com/nuget-feed) | [Python](https://cloudsmith.com/python-repository/) | [RedHat/RPM](https://cloudsmith.com/rpm-repository/) | [Raw](https://cloudsmith.com/raw-repository/)


## Cloudsmith API Key

The API key is required for the cloudsmith-cli to work.

Obtain the API Key from [Cloudsmith user settings](https://cloudsmith.io/user/settings/api/). You should use a least-privilege account for Continuous Integration.

Add a secret named `CLOUDSMITH_API_KEY` and a value of the API Key obtained from cloudsmith. Secrets are maintained in the settings of each repository.

Pass your secret to the Action as seen in the Example usage.

## Examples

The following examples use static files located within `test/fixtures`. When republishing existing packages the `republish` flag must be set to `true`, but is otherwise recommended to not use this since it overwrites (and causes longer publish times).

To pin to a specific release of this Github Action, replace `use: cloudsmith-io/action@master` with the version you require e.g. `uses: cloudsmith-io/action@0.4.0`.

You can also add "tags" to your upload process by specifying `tags` in your workflow, this is a comma separated string. (Some special characters like `:` are not allowed).

### Alpine Package Push

```yaml
name: Push Alpine
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Alpine Push Demo
    steps:
      - uses: actions/checkout@v4
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
          tags: "tag1, tag2, tag3"
```

### Cargo Crate Push

```yaml
name: Push Cargo
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Cargo Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "cargo"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-cargo-example-0.1.0.crate"
```

### Composer Package Push

```yaml
name: Push Composer
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Composer Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "composer"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-composer-package-archive-0.1.0.zip"
          tags: "tag1, tag2, tag3"
```

### CocoaPods Package Push

```yaml
name: Push Cocoapods
on: push
jobs:
   push:
     runs-on: ubuntu-latest
     name: Cocoapods Push Demo
     steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: cloudsmith-io/action@master
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "cocoapods"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-cocoapods-example-1.0.0.zip"
          tags: "tag1, tag2, tag3"
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
      - uses: actions/checkout@v4
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
      - uses: actions/checkout@v4
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
      - uses: actions/checkout@v4
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

### GO Push

```yaml
name: Push GO
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Go Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "go"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-go-example.zip" #real file that will repeat versions
```

### Helm Chart Push

```yaml
name: Push Helm
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Helm Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "helm"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-chart-example-1.0.0.tar.gz" #real file that will repeat versions

```

### Hex Push

```yaml
name: Push Hex
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Hex Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "hex"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-hex-example-1.0.0.tar" #real file that will repeat versions
```

### Maven Package Push

```yaml
name: Push Maven
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Maven Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "maven"
          owner: "cloudsmith"
          repo: "actions"
          pom-file: "test/fixture/cloudsmith-maven-example-1.0-SNAPSHOT.pom"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-maven-example-1.0-SNAPSHOT.jar" #real file that will repeat versions
```

### NPM Package Push

```yaml
name: Push NPM
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: NPM Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "npm"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-npm-example-1.0.0.tgz" #real file that will repeat versions
```

### Nuget Package Push

```yaml
name: Push Nuget
on: push
jobs:
  push:
    runs-on: ubuntu-latest
    name: Nuget Push Demo
    steps:
      - uses: actions/checkout@v4
      - name: Push
        id: push
        uses: ./
        with:
          api-key: ${{ secrets.CLOUDSMITH_API_KEY }}
          command: "push"
          format: "nuget"
          owner: "cloudsmith"
          repo: "actions"
          republish: "true" # needed ONLY if version is not changing
          file: "test/fixture/cloudsmith-nuget-example.1.0.0.nupkg" #real file that will repeat versions
          symbols-file: "test/fixture/cloudsmith-nuget-example.1.0.0.snupkg"
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
      - uses: actions/checkout@v4
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
      - uses: actions/checkout@v4
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
      - uses: actions/checkout@v4
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

## Thanks

A huge thank you to @aroller (Aaron) at @AutoModality for creating the original GitHub action for Cloudsmith.

## Contributing

Yes! Please do contribute, this is why we love open source. Please see `CONTRIBUTING.md` for contribution guidelines when making code changes or raising issues for bug reports, ideas, discussions and/or questions (i.e. help required).

## EOF

This quality product was brought to you by [Cloudsmith](https://cloudsmith.io) and the [fine folks who have contributed](https://github.com/cloudsmith-io/action/blob/master/.github/CONTRIBUTORS.md).
