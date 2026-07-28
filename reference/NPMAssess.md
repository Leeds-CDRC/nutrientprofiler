# NPMAssess function

This function aims to apply the various scoring functions across a
data.frame on a row by row basis. It is expected that you would use this
function in conjunction with a call to `lapply` or on a single row. The
function returns a data.frame containing the A score, C score, NPM score
and NPM assessment.

## Usage

``` r
NPMAssess(row)
```

## Arguments

- row, :

  the row from an NPMScore call

## Value

a data.frame containing A score, C score, NPM score, and NPM assessment
for each row
