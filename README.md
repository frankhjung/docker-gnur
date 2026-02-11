# docker-gnur

A [Debian](https://hub.docker.com/_/debian)-based image for building documents
using [GNU R](https://www.r-project.org/) and [Pandoc](https://pandoc.org). This
includes [GNU make](https://www.gnu.org/software/make/).

The latest Docker image can be found on:

* [Docker Hub](https://hub.docker.com/r/frankhjung/gnur):
  `frankhjung/gnur:latest` -
  [GitHub Container Registry](https://github.com/frankhjung/docker-gnur/pkgs/container/gnur):
  `ghcr.io/frankhjung/gnur:latest`

## R Versions

The image is based on [rocker/r-ver](https://hub.docker.com/r/rocker/r-ver),
which provides versioned R environments. To check available R versions, refer to
the [rocker/r-ver tags](https://hub.docker.com/r/rocker/r-ver/tags).

## Updating the R Version

The R version is managed via a GitHub repository variable `R_VERSION`. This
variable determines which `rocker/r-ver` base image is used during the build.

To update the version:

1. Check the available R version in the
   [rocker/r-ver tags](https://hub.docker.com/r/rocker/r-ver/tags).
2. Go to the repository's Settings → Secrets and variables → Actions →
   Variables.
3. Update the `R_VERSION` variable to match the desired version (e.g., `4.5.2`).
4. The next workflow run will automatically build and tag images with the new
   version.

Note: The version label on the Docker image reflects the `R_VERSION` build
argument.

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
docker run --rm -v $PWD:/workspace -w /workspace \
  frankhjung/gnur:latest \
  make.R test.Rmd public/test.html
```

Note: the image uses `Rscript` as its entrypoint, so you must pass the script
and its arguments when running the container.

## Makefile

### test-container

Build the image and run a sanity check that renders `test.Rmd` to
`public/test.html` inside the container. The target also creates the `public/`
directory if it does not exist.

## Tag

### Tagging Images

The GitHub Actions workflows automatically tag images with both the version
number and `latest`:

* `frankhjung/gnur:4.5.2` (version-specific)
* `frankhjung/gnur:latest` (latest build)
* `ghcr.io/frankhjung/gnur:4.5.2` (version-specific)
* `ghcr.io/frankhjung/gnur:latest` (latest build)

### Manual Tagging

Get the version from the run output to set the tag:

```bash
export R_VERSION=4.5.2
```

```bash
docker tag frankhjung/gnur:latest frankhjung/gnur:${R_VERSION}
```

Verify with:

```bash
docker image inspect --format='{{json .Config.Labels}}' frankhjung/gnur:latest
```

### Example

```text
$ docker run frankhjung/gnur:latest --version
Rscript (R) version 4.5.2 (2025-10-31)
```

## Push

Push image and all tags to Docker Hub:

```bash
docker push -a frankhjung/gnur
```

## make.R

`make.R` renders R Markdown to HTML or PDF using `rmarkdown::render()`. It
supports two invocation modes:

1. Legacy mode: pass a single output file (for example, `public/test.html`). The
   source is inferred by replacing the extension with `.Rmd`.
2. Explicit mode: pass `source.Rmd` and `output.{html|pdf}` as two arguments.

HTML output uses `files/article.css`. PDF output uses LaTeX with the
`files/preamble.tex` header and includes a table of contents.

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
      - name: shallow checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 1
      - name: build html from rmd
        uses: docker://ghcr.io/frankhjung/gnur:4.5.2
        with:
          args: >-
            test/make.R
            test/article.Rmd
            ../article.html
      - name: archive article
        uses: actions/upload-artifact@v4
        with:
          name: article
          path: article.html
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

The Docker Hub pipeline (`.github/workflows/docker-hub.yml`) requires the
following repository secrets:

* `DOCKERHUB_TOKEN`
* `DOCKERHUB_USERNAME`

The GHCR pipeline (`.github/workflows/ghcr.yml`) requires the following
repository secret:

* `GITHUB_TOKEN` - Automatically provided by GitHub Actions with
  `write:packages` permission

## Links

* [Docker: rocker/r-ver](https://hub.docker.com/r/rocker/r-ver)
* [Pandoc](https://pandoc.org)
* [GNU R](https://www.r-project.org/)
