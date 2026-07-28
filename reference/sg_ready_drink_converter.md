# Specific gravity drink converter for ready to consume drinks

This function performs a specific gravity conversion for ready to
consume drinks based on the specific gravity value for the value in the
`drink_type` column. If this column is empty it returns the `volume_ml`
unadjusted.

## Usage

``` r
sg_ready_drink_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

a numeric value of the specific gravity adjusted `volume_ml` column of
row based on `drink_type column`
