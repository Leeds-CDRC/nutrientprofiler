# Function for adjusting energy information for A score calculation

Adjustment is required for calculating scores based on nutritional
measurements.

## Usage

``` r
energy_value_adjuster(value, adjusted_weight, adjuster_type = "kj")
```

## Arguments

- value:

  a numeric value corresponding to a energy measurement in a food/drink

- adjusted_weight:

  a numeric value corresponding to the total weight of the food/drink
  after specific gravity adjustment

- adjuster_type:

  a character value of either `kj` or `kcal` to determine which
  adjustment to perform

## Value

a numeric value of adjusted nutritional data
