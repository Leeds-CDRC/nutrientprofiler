# Required parameter with automatic defaults checking function

This function checks whether values for `drink_format`, `drink_type`, or
`food_type` are provided. These have default settings which are
automatically applied if a value is not supplied. Please read the
documentation for further detail. To record use of default parameters,
please see
[`AutoDefaultParamNote()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamNote.md).

## Usage

``` r
AutoDefaultParamCheck(data_frame, report_data)
```

## Arguments

- data_frame:

  a data.frame object with product data

- report_data:

  a data.frame object produced by
  [`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md)
  with information on missing parameters

## Value

report_data a data.frame object updated with information on missing
parameters

## See also

[`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md),[`AutoDefaultParamNote()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamNote.md),[`ManualParamUpdate()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ManualParamUpdate.md)
