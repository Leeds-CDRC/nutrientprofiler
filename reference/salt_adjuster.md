# Function for adjusting the salt input value

Adjustments is required for calculating scores and depends on the type
of salt measurement provided.

## Usage

``` r
salt_adjuster(value, adjusted_weight, adjuster_type = "sodium")
```

## Arguments

- value:

  a numeric value corresponding to a salt measurement in a food/drink

- adjusted_weight:

  a numeric value corresponding to the total weight of the food/drink
  after specific gravity adjustment

- adjuster_type:

  a character of either "salt" or "sodium" to help determine the
  required adjustment

## Value

a numeric value with appropriate adjustment made
