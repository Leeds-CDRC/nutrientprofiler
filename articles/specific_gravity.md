# Specific Gravity Adjustment

When attempting to calculate a Nutrient Profile Model volumes and masses
need to be adjusted by the specific gravity of the product to ensure a
correct reading. This is managed directly by the `SGConverter` high
level function that operates row-by-row on a data.frame with a series of
expected columns. This function is composed of a series of different
dispatcher function which will be outlined below (see figure for
hierarchy).

SGConverter logic

``` r

library(nutrientprofiler)
```

The central logic for specific gravity conversion is multiplying the
volume/weight of a product by a specific gravity multiplier. This is
distilled in he `generic_specific_gravity` function.

``` r

generic_specific_gravity(100, 1.01)
#> [1] 101
```

In practise this package uses the `SGtab` named vector which contains a
series of named products and their associated specific gravity. This
variable is not directly accessible to users but is used by other
specific gravity functions to determine the appropriate specific gravity
adjustments.

## Breaking down `SGConverter`

`SGConverter` works by taking the row of a data.frame as it’s argument.
It checks that row for a column called `product_type`. This column is
used to define whether the product is either a `"food"` or `"drink"`.
The value in this column is used by `SGConverter` to determine whether
to pass the row to either an `sg_food_converter` function or a
`sg_drink_converter` function.

### Calculating specific gravity for food

If `SGConverter` is passed a `product_type` that is `"food"` it passes
the row to `sg_food_converter`. This function does a simple test of
whether the row contains a column called `weight_g`, if this column
doesn’t contain `NA` it returns the value contained in `weight_g` as we
don’t have to adjust this for a specific gravity. If the `weight_g`
column does contain `NA` the row is dispatches to the
`sg_liquidfood_converter` function. The `sg_liquidfood_converter` checks
for a `food_type` column which contains a type value that should match a
product included in our `SGtab` vector. The `sg_liquidfood_converter`
checks if the `food_type` column is not an empty string, if this is true
it calculates the specific gravity adjusted volume by getting the value
from the `volume_ml` column in the row and multiplying it by the
specific gravity value in the `SGtab` which is indexed out of the vector
using the `food_type` column value from the passed row.

``` r

# example of how sg_food_converter behaves
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

data <- data.frame(weight_g = c(100, NA, NA), 
                  volume_ml = c(NA, 10, 100),  
                  product_type = c("food","food","food"), 
                  food_type = c("","Ice cream", "Semi-skimmed milk"))

sg_food_converter(data[1, ])
#> [1] 100

# on all rows with dplyr
data %>%
  rowwise() %>%
  mutate(sg = sg_food_converter(pick(everything()))) %>%
  select(sg)
#> # A tibble: 3 × 1
#> # Rowwise: 
#>      sg
#>   <dbl>
#> 1   100
#> 2    13
#> 3   103
```

### Calculating specific gravity for drinks

The logic for calculating specific gravity for drinks is slightly more
complicated. If the `SGConverter` function found that `"drink"` was
specified in the `product_type` column it dispatches the row to the
`sg_drink_converter` function. This checks the row for a column called
`drink_format` that specifies whether the drink is either: ready to
drink, a cordial or a powdered drink (`"ready"`, `"cordial"`,
`"powdered"`). For each of these options the `sg_drink_converter`
dispatches the row to an additional function.

For `"ready"` it dispatches to `sg_ready_drink_converter`. This function
checks if the row contains a `drink_type` column and if that row
contains an empty string. If it does not contain an empty string it
calls the `generic_specific_gravity` function passing the `volume_ml`
column value and the specific gravity multiplier indexed from `SGtab`
based on the value in `drink_type`. If `drink_type` does contain an
empty string it just returns the `volume_ml` column value.

``` r

# example of how sg_ready_drink_converter behaves
data <- data.frame(volume_ml = c(30, 10, 100),
                  drink_type = c("Energy drink","Ice cream", "Semi-skimmed milk"))
             
sg_ready_drink_converter(data[1, ])
#> [1] 32.1

# on all rows with dplyr
data %>%
  rowwise() %>%
  mutate(sg = sg_ready_drink_converter(pick(everything()))) %>%
  select(sg)
#> # A tibble: 3 × 1
#> # Rowwise: 
#>      sg
#>   <dbl>
#> 1  32.1
#> 2  13  
#> 3 103
```

For `"cordial"` it dispatches to `sg_cord_drink_converter`. This
function checks the row for a `nutrition_info` column to help determine
how it should proceed. This column contains information about how the
drink has been consumed, whether it has been directly consumed,
following some preparation instructions that dilute the cordial or if no
instructions were provided (`"as consumed"`,
`"preparation instructions given"`,
`"preparation instructions not given"`). If `nutrition_info` is
`"as consumed"` the `volume_ml` column value and the specific gravity
multipler from the `SGtab` for `"Cordial/squash ready to drink"` is
passed to the `generic_specific_gravity` function. For
`"preparation instructions given"` the expectation is that there is an
additional column in the row `volume_water_ml` that specifies the volume
of water used to dilute the cordial. If
`"preparation instructions given"` is found in `nutrition_info` column
it computes the sum of `volume_ml` and `volume_water_ml` columns and
passes those to `generic_specific_gravity` along with the specific
gravity multipler from the `SGtab` for
`"Cordial/squash ready to drink"`. For
`"preparation instructions not given"` the `volume_ml` column value is
passed to `generic_specific_gravity` function along with the specific
gravity multiplier indexed from `SGtab` for
`"Cordial/squash undiluted"`.

``` r

# example of how sg_cord_drink_converter behaves
data <- data.frame(volume_ml = c(30, 10, 100),
                   volume_water_ml = c(0, 90, NA),
                   nutrition_info = c("as consumed","preparation instructions given", "preparation instructions not given"))

sg_cord_drink_converter(data[1,])
#> [1] 30.9

data %>%
  rowwise() %>%
  mutate(sg = sg_cord_drink_converter(pick(everything()))) %>%
  select(sg)     
#> # A tibble: 3 × 1
#> # Rowwise: 
#>      sg
#>   <dbl>
#> 1  30.9
#> 2 103  
#> 3 109
```

If the `drink_format` column value is `"powdered"` it dispatches to the
`sg_powd_drink_converter` function. This again checks the row for values
in the `nutrition_info` column to help determine how to compute the
specific gravity adjustment using the same 3 potential values defined
above in the `cordial` section. If `nutrition_info` is `"as consumed"`
the `volume_ml` column value and the specific gravity multipler from the
`SGtab` for `"Cordial/squash ready to drink"` is passed to the
`generic_specific_gravity` function. For
`"preparation instructions given"` the expectation is that there is an
additional column in the row `weight_g` that specifies the weight in
grams of the powdered drink used. If `"preparation instructions given"`
is found in `nutrition_info` column it computes the sum of `weight_g`
and `volume_water_ml` columns and passes those to
`generic_specific_gravity` along with the specific gravity multipler
from the `SGtab` for `"Cordial/squash ready to drink"`. For
`"preparation instructions not given"` the `weight_g` column value is
returned unadjusted.

``` r

# example of how sg_powd_drink_converter behaves
data <- data.frame(volume_ml = c(90, NA, NA),
                   weight_g = c(NA, 10, 100),
                   volume_water_ml = c(0, 90, NA),
                   nutrition_info = c("as consumed","preparation instructions given", "preparation instructions not given"))

sg_powd_drink_converter(data[1,])
#> [1] 92.7

data %>%
  rowwise() %>%
  mutate(sg = sg_powd_drink_converter(pick(everything()))) %>%
  select(sg)     
#> # A tibble: 3 × 1
#> # Rowwise: 
#>      sg
#>   <dbl>
#> 1  92.7
#> 2 103  
#> 3 100
```

## Summary

Overall most of the functions in `SGConverter` are quite constrictive.
They expect particular column names to work and won’t just work with any
data. However, the building blocks to all these functions is the
`generic_specific_gravity` which can be used to develop your own
functions for building a specific gravity conversion pipeline. The
existing steps shown here should serve as a template to build your own
specific gravity conversion pipeline.
