# Specific gravity food dispatcher

This function is run for data with the `product_type` "food" It checks
if the column `weight_g` contains NA values to assume whether the food
is liquid or solid and if solid returns the weight unadjusted or if
liquid dispatches to an additional function

## Usage

``` r
sg_food_converter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

either the value of `weight_g` column for row or dispatches row to
`sg_liquidfood_converter`
