# Required parameter checking function

This function processes the data.frame object with product data and
check for required parameters. It returns a report table which contains
row indices of missing required parameters. Please see guidance on
required and default parameters for more information and before
processing your data.

## Usage

``` r
ReqParamCheck(data_frame)
```

## Arguments

- data_frame:

  a data.frame object

## Value

report_data a data.frame object with information on missing parameters

## See also

[`SaveReport()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/SaveReport.md),[`AutoDefaultParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamCheck.md),[`AutoDefaultParamNote()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamNote.md),[`ManualParamUpdate()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ManualParamUpdate.md)
