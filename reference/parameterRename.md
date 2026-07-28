# Parameter rename function

This function renames specified parameters/columns in your dataframe to
match the expected parameters required by nutrientprofiler.

## Usage

``` r
parameterRename(missing_column_name, associated_data_column, data_frame)
```

## Arguments

- missing_column_name:

  a chr object with the missing nutrientprofiler parameter

- associated_data_column:

  a chr object with the associated column header from the loaded data

- data_frame:

  a data.frame object, loaded from a csv or Excel

## Value

data_frame a data.frame object with updated column names

## See also

[`inputDataCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/inputDataCheck.md)
