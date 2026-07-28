# Manual parameter update function

This function allows updating/setting of a parameter manually where one
is missing or incorrect. Additionally, it records which parameters have
been manually added. This function allows multiple rows of data to be
changed at once by supplying a list of index values.

## Usage

``` r
ManualParamUpdate(data_frame, parameter_name, index_list, value)
```

## Arguments

- data_frame:

  a data.frame object with product data

- parameter_name:

  a chr object with name of parameter to be changed

- index_list:

  a vector object of index values of parameters to be changed

- value:

  the value to enter for the parameter

## Value

data_frame the product data with an additional column recording manual
param editing

## See also

[`AutoDefaultParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamCheck.md),[`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md)
