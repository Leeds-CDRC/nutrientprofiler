# Fill the missing parameters function

This function creates columns filled with `NA` for a provided vector of
missing parameter names. Please attempt to rename parameters before
filling in columns.

## Usage

``` r
fillMissingParameters(data_frame, missing_parameters)
```

## Arguments

- data_frame:

  a data.frame object, loaded from a csv or Excel

- missing_parameters:

  a vector object of missing column/parameter names

## Value

data_frame a data.frame object, with new columns added filled with NA

## See also

[`inputDataCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/inputDataCheck.md)
