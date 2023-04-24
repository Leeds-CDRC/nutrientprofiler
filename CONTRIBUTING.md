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
8. If you're package passes the tests and you've updated the appropriate
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
