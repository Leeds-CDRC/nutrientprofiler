# 🍎📦 nutrientprofiler R package

Welcome to the nutrientprofiler R package repository!

This package provides functions to help assess product information against the [UK Nutrient Profiling Model (2004/5)](https://www.gov.uk/government/publications/the-nutrient-profiling-model) and scope for [HFSS legislation](https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance) around product placement.

It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

## Installation

At present this R package is not available via CRAN. 
You can however install it direct from GitHub using [`remotes`](https://remotes.r-lib.org/).

```R
install.packages("remotes")

remotes::install_github("Leeds-CDRC/nutrientprofiler")
```

You can also download the package as an archive from GitHub and install them
from source using the following steps. The steps below show how to do this
directly within R but you can also download an archive of the respository
directly from the [GitHub releases](https://github.com/Leeds-CDRC/nutrientprofiler/releases) page.

```R
# download the repository as a .tar.gz archive
# to your current directory
download.file("https://github.com/Leeds-CDRC/nutrientprofiler/archive/refs/tags/v0.2.2.tar.gz",
              dest = "./nutrientprofiler-v0.2.2.tar.gz")

# install the package directly from source
install.packages("./nutrientprofiler-v0.2.2.tar.gz", repos = NULL, type="source")
```
