# docker-gnur

A [Debian](https://hub.docker.com/_/debian)-based image for building documents
using [GNU R](https://www.r-project.org/) and [Pandoc](https://pandoc.org). This
includes [GNU make](https://www.gnu.org/software/make/).

The latest Docker image can be found on:

- [Docker Hub](https://hub.docker.com/r/frankhjung/gnur):
  `frankhjung/gnur:latest`
-
  [GitHub Container Registry](https://github.com/frankhjung/docker-gnur/pkgs/container/gnur):
  `ghcr.io/frankhjung/gnur:latest`

## R Versions

To check available R versions, refer to the package list for the Debian release.
For example, Trixie (13.3) uses the [R 4.3.1-1
package](https://packages.debian.org/search?suite=trixie&searchon=names&keywords=r-base).

## Updating the R Version

The R version is managed via a GitHub repository variable `R_VERSION`. This
should match the Debian package version available in the stable repository.

To update the version:

1. Check the available R version in the
   [Debian package repository](https://packages.debian.org/search?suite=stable&searchon=names&keywords=r-base)
2. Go to the repository's Settings → Secrets and variables → Actions → Variables
3. Update the `R_VERSION` variable to match the Debian package version (e.g.,
   `4.5.2`)
4. The next workflow run will automatically build and tag images with the new
   version

Note: The version label on the Docker image reflects the Debian package version,
which is installed via `apt-get`.

## Using the Docker Image

### Docker Hub

Pull and run the latest image from Docker Hub:

```bash
docker pull frankhjung/gnur:latest
docker run frankhjung/gnur:latest
```

Or use a specific version:

```bash
docker pull frankhjung/gnur:4.5.2
docker run frankhjung/gnur:4.5.2
```

### GitHub Container Registry

Pull and run the latest image from GHCR:

```bash
docker pull ghcr.io/frankhjung/gnur:latest
docker run ghcr.io/frankhjung/gnur:latest
```

Or use a specific version:

```bash
docker pull ghcr.io/frankhjung/gnur:4.5.2
docker run ghcr.io/frankhjung/gnur:4.5.2
```

## Login

For Docker Hub:

```bash
echo [token] | docker login -u frankhjung --password-stdin
```

For GitHub Container Registry:

```bash
echo [token] | docker login ghcr.io -u frankhjung --password-stdin
```

## Build

Build the image locally:

```bash
docker build --compress --rm --tag frankhjung/gnur:latest .
```

Build with a specific R version:

```bash
docker build --build-arg R_VERSION=4.5.2 --compress --rm --tag frankhjung/gnur:4.5.2 .
```

## Run

```bash
docker run frankhjung/gnur:latest
```

## Tag

### Tagging Images

The GitHub Actions workflows automatically tag images with both the version
number and `latest`:

- `frankhjung/gnur:4.5.2` (version-specific)
- `frankhjung/gnur:latest` (latest build)
- `ghcr.io/frankhjung/gnur:4.5.2` (version-specific)
- `ghcr.io/frankhjung/gnur:latest` (latest build)

### Manual Tagging

Get the version from the run output to set the tag:

```bash
export VERSION=4.5.2
```

```bash
docker tag frankhjung/gnur:latest frankhjung/gnur:${VERSION}
```

Verify with:

```bash
docker image inspect --format='{{json .Config.Labels}}' frankhjung/gnur:latest
```

### Example

```text
$ docker run frankhjung/gnur:latest
R version 4.5.2 (2025-10-31) -- "[Not] Part in a Rumble"
Copyright (C) 2025 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
https://www.gnu.org/licenses/.
```

## Push

Push image and all tags to Docker Hub:

```bash
docker push -a frankhjung/gnur
```

## Using in a Pipeline

You can use this image in your CI/CD pipeline to run R scripts. Here are some
examples:

### GitHub Actions

```yaml
name: Build Documentation
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Convert Markdown to PDF
        run: |
          docker run --rm -v $PWD:/opt/workspace \
            ghcr.io/frankhjung/gnur:latest \
            Rscript -e "rmarkdown::render('README.Rmd', output_file = 'README.pdf')"
      - name: Upload PDF
        uses: actions/upload-artifact@v3
        with:
          name: documentation
          path: '*.pdf'
```

### GitLab CI

```yaml
build-docs:
  image: ghcr.io/frankhjung/gnur:latest
  script:
    - Rscript -e "rmarkdown::render('README.Rmd', output_file = 'README.pdf')"
  artifacts:
    paths:
      - '*.pdf'
```

### Using with Make

If you have a Makefile in your project:

```yaml
build-docs:
  image: ghcr.io/frankhjung/gnur:latest
  script:
    - make docs
  artifacts:
    paths:
      - build/
```

## Pipeline Configuration

The Docker Hub pipeline (`.github/workflows/docker.yml`) requires the following
repository secrets:

- `DOCKERHUB_TOKEN`
- `DOCKERHUB_USERNAME`

The GHCR pipeline (`.github/workflows/ghcr.yml`) requires the following secret
environment value:

- `GH_PAT` - GitHub Personal Access Token with `write:packages` permission

The GHCR pipeline (`.github/workflows/ghcr.yml`) requires the following
repository secret:

- `GITHUB_TOKEN` - Automatically provided by GitHub Actions with
  `write:packages` permission

## Links

- [Docker: Debian](https://hub.docker.com/_/debian)
