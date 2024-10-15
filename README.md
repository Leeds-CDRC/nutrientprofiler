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

You can also specify a version of the nutrientprofiler package:

```R
install.packages("remotes")

remotes::install_github("leeds-cdrc/nutrientprofiler@v1.0.0")
```

You can also download the package as an archive from GitHub and install 
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

## Navigating the documentation

Please see [Getting started](../articles/nutrientprofiler.html) for an overview of how the `nutrientprofiler` package works.

To learn to prepare your data for analysis, please first see [Preprocessing](../articles/preprocessing.html) then [Handling input data](../articles/handling_input_data.html). For more details on valid data types for different parameters, see [Parameter guide](../articles/parameter_guide.html).

To learn the logic of the specific gravity adjustment workflow, see [Specific Gravity](../articles/specific_gravity.html), and to implement custom values for this adjustment, see the guidance in the article [Custom Specific Gravity](../articles/custom_specific_gravity.html).

# Contributing

This document outlines a rough approach for local setup and contributing to this project.

## Local setup

To work with this project locally you will need [Git](https://git-scm.com/) and [R](https://www.r-project.org/about.html) installed locally.
It is also recommended that you install [Docker](https://www.docker.com/) and
[VSCode](https://code.visualstudio.com/) to enable you to utilise the
[devcontainer](https://code.visualstudio.com/docs/devcontainers/containers)
setup or edit the code directly via GitHub Codespaces.

If you're unfamiliar with using `git` why not check out the fantastic
[Carpentries introductory course](https://swcarpentry.github.io/git-novice/).

To get working on this project you will need the [`devtools`](https://devtools.r-lib.org/) package which you can install with the following R command:

```R
# Install devtools from CRAN
install.packages("devtools")
```

### Development workflow

When working locally you should use the following workflow to help develop the code:

1. Create a [fork of the GitHub
   repository](https://github.com/Leeds-CDRC/nutrientprofiler/fork) to create
   your own personal copy of this repository to which you can push changes to
2. Locally clone your fork so that you can start working on it
3. Open an R session
4. Load `devtools` with:
    ```R
    library(devtools)
    ```
5. Make a change to the package files
6. Test this in your R session by running `load_all()` to load the package (check here for any errors)
7. Check your changes pass tests by running `test()`
8. If your package passes the tests and you've updated the appropriate
   documentation you should now run `check()` locally to make sure all
   appropriate roxygen2 files are created/update and any functions you've now
   tagged with @export are exported to NAMESPACE
9. Commit all the changes from the `check()` run and push these to GitHub
10. Open a [pull
    request](https://github.com/Leeds-CDRC/nutrientprofiler/compare) against the
    `main` branch from your development branch.
   This will trigger a GitHub action that also runs the equivalent of `check()`
   to make sure you didn't miss anything and ensure the package still works
   against different versions of R.
11. Once the checks pass on the pull request your changes can be accepted by the
   maintainer.

# License

The nutrientprofiler package provides functions to help assess product information against the UK Nutrient Profiling Model (2004/5) and scope for HFSS legislation around product placement. It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

Copyright (C) 2024 University of Leeds

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

A copy of the GNU Affero General Public License is supplied
along with this program in the `LICENSE` file in the [repository](https://github.com/Leeds-CDRC/nutrientprofiler/).
You can also find the full text at https://www.gnu.org/licenses.

You can contact us by raising an issue on our GitHub repository (https://github.com/Leeds-CDRC/nutrientprofiler/issues/new - login required) or by emailing
us at info@cdrc.ac.uk.