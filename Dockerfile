# Dockerfile for Rmarkdown build tools
#
# Renders Rmd files to HTML (and PDF) using R, knitr, and
# rmarkdown with pandoc.
#
# Usage:
#   docker build -t rmarkdown .
#   docker run --rm -v "$PWD":/workspace rmarkdown -B <article>

FROM rocker/r-ver:4

LABEL maintainer="Frank H Jung"
LABEL description="Rmarkdown build tools for rendering Rmd to HTML"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
      make \
      pandoc \
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
