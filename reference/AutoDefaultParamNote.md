# Required parameter with automatic defaults recording function

This function checks whether values for `drink_format`, `drink_type`, or
`food_type` are provided and records in the product data frame if
defaults will be used for analysis.

## Usage

``` r
AutoDefaultParamNote(data_frame, report_data)
```

## Arguments

- data_frame:

  a data.frame object with product data

- report_data:

  a data.frame object produced by
  [`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md)
  with information on missing parameters

## Value

data_frame the product data with an additional column recording default
use

## See also

[`AutoDefaultParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamCheck.md),[`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md)
