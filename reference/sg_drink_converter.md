# Specific gravity drink dispatcher

This function is run for data with the `product_type` "drink" It
dispatches to additional functions based on the matched value in the
`drink_format` column

## Usage

``` r
sg_drink_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

dispatches row to another converter function based on value in
`drink_format` column of row
