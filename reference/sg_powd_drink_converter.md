# Specific gravity drink converter for powdered drinks

This function performs a specific gravity conversion for powdered drinks
the conversion performed is based on the value in the `nutrition_info`
column.

## Usage

``` r
sg_powd_drink_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

a numeric value of the specific gravity adjusted volume/mass depending
on `nutrition_info` column.
