# Contributing

This document outlines a rough approach for local setup and contributing to this project.

## Local setup

To work with this project locally you will need [Git](https://git-scm.com/) and [R](https://www.r-project.org/about.html) installed locally.
It is also recommended that you install [Docker](https://www.docker.com/) and [VSCode](https://code.visualstudio.com/) to enable you to utilise the [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers) setup.

To get working on this project you will need the [`devtools`](https://devtools.r-lib.org/) package which you can install with the following R command:

```R
# Install devtools from CRAN
install.packages("devtools")
```

### Development workflow

When working locally you should use the following workflow to help develop the code:

1. Open an R session
2. Load `devtools`
3. Make a change to the package files
4. Test this in your R session by running `load_all()` to load the package (check here for any errors)
5. Check your changes pass tests by running `test()`