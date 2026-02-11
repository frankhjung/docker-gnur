# Dockerfile for Rmarkdown build tools
#
# Renders Rmd files to HTML (and PDF) using R, knitr, and
# rmarkdown with pandoc.
#
# Usage:
#   docker build -t rmarkdown .
#   docker run --rm -v "$PWD":/workspace rmarkdown -B <article>

# This is the fall-back default if R_VERSION is not set in build args
ARG R_VERSION=4.5.2
FROM rocker/r-ver:${R_VERSION}

ENV R_VERSION=${R_VERSION}

LABEL maintainer="Frank H Jung"
LABEL org.opencontainers.image.description="Render Rmarkdown (Rmd)"
LABEL org.opencontainers.image.source="https://github.com/frankhjung/docker-gnur"
LABEL org.opencontainers.image.authors="Frank H Jung"
LABEL org.opencontainers.image.version="${R_VERSION}"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
      make \
      pandoc \
      librsvg2-bin \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c( \
      'broom', \
      'dplyr', \
      'forcats', \
      'ggplot2', \
      'knitr', \
      'lubridate', \
      'magrittr', \
      'purrr', \
      'readr', \
      'rlang', \
      'rmarkdown', \
      'scales', \
      'stringr', \
      'tibble', \
      'tidyr' \
    ), repos = 'https://cloud.r-project.org')"

WORKDIR /workspace

ENTRYPOINT ["Rscript"]
