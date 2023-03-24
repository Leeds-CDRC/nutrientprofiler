# nutrientprofiler R package

> :warning: This project is a working-in-progress so breaking changes may be introduced without notice

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

