# Data check function

This function checks that all required parameter names or spreadsheet
"column" names are present, and provides a code snippet to change any
parameter names required.

## Usage

``` r
inputDataCheck(data_frame)
```

## Arguments

- data_frame:

  a data.frame object, loaded from a csv or Excel

## Value

Prints code snippets to help you rename variables if needed

## See also

[`parameterRename()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/parameterRename.md)
