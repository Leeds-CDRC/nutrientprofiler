# Specific gravity liquid converter

This function is run for data that is identified by `sg_food_converter`
as liquid food It checks for a value in the `food_type` column and if
present retrieves a specific gravity multiplier which is multiplies
against the `volume_ml` column value. If `food_type` is empty is returns
an unadjusted `volume_ml` value

## Usage

``` r
sg_liquidfood_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

a numeric value of the specific gravity adjusted `volume_ml` column in
`row`
