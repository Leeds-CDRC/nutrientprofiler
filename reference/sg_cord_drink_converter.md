# Specific gravity drink converter for cordial drinks

This function performs a specific gravity conversion for cordial drinks
the conversion performed is based on the value in the `nutrition_info`
column.

## Usage

``` r
sg_cord_drink_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

a numeric value of the specific gravity adjusted volume depending on
`nutrition_info` column.
