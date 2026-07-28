# Custom specific gravity

This article walks through how you can apply custom specific gravity
conversion factors or adjusted volumes to your input data. Please ensure
you have read and understood the [Specific
gravity](https://leeds-cdrc.github.io/nutrientprofiler/articles/specific_gravity.md)
article and the workflow of the various underlying functions before
applying custom values.

Note that the examples given below show automatic calculation of the
majority of the data, and then adjustment of a single row with custom
values. This adjustment could be made more automated by building a loop
to check if the custom column contains a non-null value, and if so
applying the custom calculation. Similarly, the automated calculation
could be skipped entirely and a column filled with custom values could
instead be used.

These examples follow a very similar process to the examples given in
the
[Workflow](https://leeds-cdrc.github.io/nutrientprofiler/articles/workflows.html#example-workflow-for-processing-data-in-bulk)
article, except the analysis and calculation has been broken into two
stages: first, the specific gravity conversion is done, *then* the NPM
scoring and assessment is done. This allows for adjustment of specific
gravity values between these two steps.

## Where adjusted volume has been provided

As always, we need to load in the data set and the required libraries:

``` r

# load required libraries
library(tidyr)
library(dplyr)
library(nutrientprofiler)

# read in the data
example_data <- read.csv("data/example_data.csv")
```

This dataset has a column called `custom_sg_adjusted` that is empty
except for products where a final adjusted volume based on specific
gravity has been provided.

``` r

example_data
#>                  name brand product_category product_type food_type
#> 1              lembas    NA               NA         Food          
#> 2     zeno's icecream    NA               NA         Food Ice cream
#> 3         mystic rush    NA               NA        Drink          
#> 4  delta ringer drink    NA               NA        Drink          
#> 5        welter water    NA               NA        Drink          
#> 6       janus's drink    NA               NA         Food          
#> 7   beta ringer drink    NA               NA        Drink          
#> 8   zeta ringer drink    NA               NA        Drink          
#> 9   heavyweight water    NA               NA        Drink          
#> 10       bantam water    NA               NA        Drink          
#>    drink_format             drink_type                     nutrition_info
#> 1                                                                        
#> 2                                                                        
#> 3         Ready Carbonated/juice drink                                   
#> 4      Powdered                            Preparation instructions given
#> 5       Cordial                                               As consumed
#> 6                                                                        
#> 7      Powdered                                               As consumed
#> 8      Powdered                        Preparation instructions not given
#> 9       Cordial                            Preparation instructions given
#> 10      Cordial                        Preparation instructions not given
#>    energy_measurement_kj energy_measurement_kcal sugar_measurement_g
#> 1                    266                      NA                  50
#> 2                     NA                      24                  21
#> 3                     NA                     194                  11
#> 4                    188                      NA                  15
#> 5                     NA                     205                  19
#> 6                     NA                      24                  21
#> 7                    188                      NA                  15
#> 8                    188                      NA                  15
#> 9                     NA                     205                  19
#> 10                    NA                     205                  19
#>    satfat_measurement_g salt_measurement_g sodium_measurement_mg
#> 1                     3                 NA                   0.6
#> 2                    11               0.08                    NA
#> 3                     0                 NA                 100.0
#> 4                     0                 NA                 100.0
#> 5                     0               0.10                    NA
#> 6                    11               0.08                    NA
#> 7                     0                 NA                 100.0
#> 8                     0                 NA                 100.0
#> 9                     0               0.10                    NA
#> 10                    0               0.10                    NA
#>    fibre_measurement_nsp fibre_measurement_aoac protein_measurement_g
#> 1                      3                     NA                   7.0
#> 2                     NA                    0.7                   3.5
#> 3                     NA                    0.0                   0.0
#> 4                     NA                    0.0                   0.5
#> 5                     NA                    0.0                   0.1
#> 6                     NA                    0.7                   3.5
#> 7                     NA                    0.0                   0.5
#> 8                     NA                    0.0                   0.5
#> 9                     NA                    0.0                   0.1
#> 10                    NA                    0.0                   0.1
#>    fvn_measurement_percent weight_g volume_ml volume_water_ml
#> 1                        0      100        NA              NA
#> 2                        0       NA       100              NA
#> 3                        0       NA       100              NA
#> 4                        3       25        NA             100
#> 5                        6       NA       100              NA
#> 6                        0       NA       100              NA
#> 7                        3       NA        50              NA
#> 8                        3       25        NA              NA
#> 9                        6       NA        20             100
#> 10                       6       NA       100              NA
#>    custom_sg_adjusted
#> 1                  NA
#> 2                  NA
#> 3                  NA
#> 4                  NA
#> 5                  NA
#> 6                  NA
#> 7                  NA
#> 8                  NA
#> 9                 125
#> 10                 NA
```

Now, we calculate specific gravities as usual, initially ignoring the
custom values, before then modifying the output to include our custom
values:

``` r

example_data_sg_calc <- example_data %>% 
  rowwise() %>% 
  mutate( sg = SGConverter(pick(everything()))) %>% 
  select(everything(), sg)

print("Before setting custom values:")
#> [1] "Before setting custom values:"
print(example_data_sg_calc$sg)
#>  [1] 100.00 130.00 104.00 128.75 103.00 100.00  51.50  25.00 123.60 109.00

example_data_sg_calc$sg[[9]] <- example_data_sg_calc$custom_sg_adjusted[[9]]

print("After setting custom values:")
#> [1] "After setting custom values:"
print(example_data_sg_calc$sg)
#>  [1] 100.00 130.00 104.00 128.75 103.00 100.00  51.50  25.00 125.00 109.00
```

We can then continue with our analysis using the newly updated specific
gravity values:

``` r

example_data_results <- example_data_sg_calc %>% 
  rowwise() %>% 
  mutate(test = NPMScore(pick(everything()), sg_adjusted_label="sg")) %>% 
  unnest(test) %>% 
  rowwise() %>%
  mutate(assess = NPMAssess(pick(everything()))) %>%
  unnest(assess) %>%
  select(everything(), energy_score, sugar_score, salt_score, fvn_score,
  protein_score, satfat_score, fibre_score, NPM_score, NPM_assessment)
```

Our results table looks much the same as for previous examples, with the
addition of the `custom_sg_adjusted` column to record where manual
modification has occurred.

``` r

names(example_data_results)
#>  [1] "name"                    "brand"                  
#>  [3] "product_category"        "product_type"           
#>  [5] "food_type"               "drink_format"           
#>  [7] "drink_type"              "nutrition_info"         
#>  [9] "energy_measurement_kj"   "energy_measurement_kcal"
#> [11] "sugar_measurement_g"     "satfat_measurement_g"   
#> [13] "salt_measurement_g"      "sodium_measurement_mg"  
#> [15] "fibre_measurement_nsp"   "fibre_measurement_aoac" 
#> [17] "protein_measurement_g"   "fvn_measurement_percent"
#> [19] "weight_g"                "volume_ml"              
#> [21] "volume_water_ml"         "custom_sg_adjusted"     
#> [23] "sg"                      "energy_score"           
#> [25] "sugar_score"             "satfat_score"           
#> [27] "protein_score"           "salt_score"             
#> [29] "fvn_score"               "fibre_score"            
#> [31] "A_score"                 "C_score"                
#> [33] "NPM_score"               "NPM_assessment"

example_data_results[c("name", "sg", "custom_sg_adjusted", "NPM_score", "NPM_assessment")]
#> # A tibble: 10 × 5
#>    name                  sg custom_sg_adjusted NPM_score NPM_assessment
#>    <chr>              <dbl>              <dbl>     <dbl> <chr>         
#>  1 lembas             100                   NA         8 FAIL          
#>  2 zeno's icecream    130                   NA        11 FAIL          
#>  3 mystic rush        104                   NA         5 FAIL          
#>  4 delta ringer drink 129.                  NA         2 FAIL          
#>  5 welter water       103                   NA         6 FAIL          
#>  6 janus's drink      100                   NA        14 FAIL          
#>  7 beta ringer drink   51.5                 NA         9 FAIL          
#>  8 zeta ringer drink   25                   NA        16 FAIL          
#>  9 heavyweight water  125                  125         5 FAIL          
#> 10 bantam water       109                   NA         5 FAIL
```

## Where a custom conversion factor has been provided

Again, we load the required libraries and data:

``` r

# load required libraries
library(tidyr)
library(dplyr)
library(nutrientprofiler)

# read in the data
example_data_2 <- read.csv("data/example_data_2.csv")
```

This dataset has a column called `custom_sg_conversion` that is empty
except for products where a custom specific gravity conversion factor
has been provided.

``` r

example_data_2
#>                  name brand product_category product_type food_type
#> 1              lembas    NA               NA         Food          
#> 2     zeno's icecream    NA               NA         Food Ice cream
#> 3         mystic rush    NA               NA        Drink          
#> 4  delta ringer drink    NA               NA        Drink          
#> 5        welter water    NA               NA        Drink          
#> 6       janus's drink    NA               NA         Food          
#> 7   beta ringer drink    NA               NA        Drink          
#> 8   zeta ringer drink    NA               NA        Drink          
#> 9   heavyweight water    NA               NA        Drink          
#> 10       bantam water    NA               NA        Drink          
#>    drink_format             drink_type                     nutrition_info
#> 1                                                                        
#> 2                                                                        
#> 3         Ready Carbonated/juice drink                                   
#> 4      Powdered                            Preparation instructions given
#> 5       Cordial                                               As consumed
#> 6                                                                        
#> 7      Powdered                                               As consumed
#> 8      Powdered                        Preparation instructions not given
#> 9       Cordial                            Preparation instructions given
#> 10      Cordial                        Preparation instructions not given
#>    energy_measurement_kj energy_measurement_kcal sugar_measurement_g
#> 1                    266                      NA                  50
#> 2                     NA                      24                  21
#> 3                     NA                     194                  11
#> 4                    188                      NA                  15
#> 5                     NA                     205                  19
#> 6                     NA                      24                  21
#> 7                    188                      NA                  15
#> 8                    188                      NA                  15
#> 9                     NA                     205                  19
#> 10                    NA                     205                  19
#>    satfat_measurement_g salt_measurement_g sodium_measurement_mg
#> 1                     3                 NA                   0.6
#> 2                    11               0.08                    NA
#> 3                     0                 NA                 100.0
#> 4                     0                 NA                 100.0
#> 5                     0               0.10                    NA
#> 6                    11               0.08                    NA
#> 7                     0                 NA                 100.0
#> 8                     0                 NA                 100.0
#> 9                     0               0.10                    NA
#> 10                    0               0.10                    NA
#>    fibre_measurement_nsp fibre_measurement_aoac protein_measurement_g
#> 1                      3                     NA                   7.0
#> 2                     NA                    0.7                   3.5
#> 3                     NA                    0.0                   0.0
#> 4                     NA                    0.0                   0.5
#> 5                     NA                    0.0                   0.1
#> 6                     NA                    0.7                   3.5
#> 7                     NA                    0.0                   0.5
#> 8                     NA                    0.0                   0.5
#> 9                     NA                    0.0                   0.1
#> 10                    NA                    0.0                   0.1
#>    fvn_measurement_percent weight_g volume_ml volume_water_ml
#> 1                        0      100        NA              NA
#> 2                        0       NA       100              NA
#> 3                        0       NA       100              NA
#> 4                        3       25        NA             100
#> 5                        6       NA       100              NA
#> 6                        0       NA       100              NA
#> 7                        3       NA        50              NA
#> 8                        3       25        NA              NA
#> 9                        6       NA        20             100
#> 10                       6       NA       100              NA
#>    custom_sg_conversion
#> 1                    NA
#> 2                    NA
#> 3                    NA
#> 4                    NA
#> 5                    NA
#> 6                    NA
#> 7                    NA
#> 8                    NA
#> 9                  0.83
#> 10                   NA
```

Now, we calculate specific gravities as usual, initially ignoring the
custom values.

``` r

example_data_sg_calc_2 <- example_data_2 %>% 
  rowwise() %>% 
  mutate( sg = SGConverter(pick(everything()))) %>% 
  select(everything(), sg)
```

We can use the function
[`generic_specific_gravity()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/generic_specific_gravity.md)
to calculate the adjusted volumes. The value we want to modify is a
cordial, and the nutrition information provided assumes the product has
been prepared as instructed
(`nutrition_info == "Preparation instructions given"`); This means we
need to calculate the adjusted specific gravity weight by adding the
volume (ml) and the volume of water (ml) provided and using these as
parameters along with our custom conversion factor in the
[`generic_specific_gravity()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/generic_specific_gravity.md)
function.

``` r

print("Before setting custom values:")
#> [1] "Before setting custom values:"
print(example_data_sg_calc_2$sg)
#>  [1] 100.00 130.00 104.00 128.75 103.00 100.00  51.50  25.00 123.60 109.00

example_data_sg_calc_2[9,]
#> # A tibble: 1 × 23
#> # Rowwise: 
#>   name     brand product_category product_type food_type drink_format drink_type
#>   <chr>    <lgl> <lgl>            <chr>        <chr>     <chr>        <chr>     
#> 1 heavywe… NA    NA               Drink        ""        Cordial      ""        
#> # ℹ 16 more variables: nutrition_info <chr>, energy_measurement_kj <int>,
#> #   energy_measurement_kcal <int>, sugar_measurement_g <int>,
#> #   satfat_measurement_g <int>, salt_measurement_g <dbl>,
#> #   sodium_measurement_mg <dbl>, fibre_measurement_nsp <int>,
#> #   fibre_measurement_aoac <dbl>, protein_measurement_g <dbl>,
#> #   fvn_measurement_percent <int>, weight_g <int>, volume_ml <int>,
#> #   volume_water_ml <int>, custom_sg_conversion <dbl>, sg <dbl>
# example_data_sg_calc$sg[[9]] <- example_data_sg_calc$custom_sg_adjusted[[9]]

row <- example_data_sg_calc_2[9,]

example_data_sg_calc_2$sg[[9]] <- generic_specific_gravity((as.numeric(row[["volume_water_ml"]]) + as.numeric(row[["volume_ml"]])),
            row[["custom_sg_conversion"]])

print("After setting custom values:")
#> [1] "After setting custom values:"
print(example_data_sg_calc_2$sg)
#>  [1] 100.00 130.00 104.00 128.75 103.00 100.00  51.50  25.00  99.60 109.00
```

We can then continue with our analysis using the newly updated specific
gravity values:

``` r

example_data_results_2 <- example_data_sg_calc_2 %>% 
  rowwise() %>% 
  mutate(test = NPMScore(pick(everything()), sg_adjusted_label="sg")) %>% 
  unnest(test) %>% 
  rowwise() %>%
  mutate(assess = NPMAssess(pick(everything()))) %>%
  unnest(assess) %>%
  select(everything(), energy_score, sugar_score, salt_score, fvn_score,
  protein_score, satfat_score, fibre_score, NPM_score, NPM_assessment)
```

Our results table looks much the same as for previous examples, with the
addition of the `custom_sg_conversion` column to record where manual
modification has occurred.

``` r

names(example_data_results_2)
#>  [1] "name"                    "brand"                  
#>  [3] "product_category"        "product_type"           
#>  [5] "food_type"               "drink_format"           
#>  [7] "drink_type"              "nutrition_info"         
#>  [9] "energy_measurement_kj"   "energy_measurement_kcal"
#> [11] "sugar_measurement_g"     "satfat_measurement_g"   
#> [13] "salt_measurement_g"      "sodium_measurement_mg"  
#> [15] "fibre_measurement_nsp"   "fibre_measurement_aoac" 
#> [17] "protein_measurement_g"   "fvn_measurement_percent"
#> [19] "weight_g"                "volume_ml"              
#> [21] "volume_water_ml"         "custom_sg_conversion"   
#> [23] "sg"                      "energy_score"           
#> [25] "sugar_score"             "satfat_score"           
#> [27] "protein_score"           "salt_score"             
#> [29] "fvn_score"               "fibre_score"            
#> [31] "A_score"                 "C_score"                
#> [33] "NPM_score"               "NPM_assessment"

example_data_results_2[c("name", "sg", "custom_sg_conversion", "NPM_score", "NPM_assessment")]
#> # A tibble: 10 × 5
#>    name                  sg custom_sg_conversion NPM_score NPM_assessment
#>    <chr>              <dbl>                <dbl>     <dbl> <chr>         
#>  1 lembas             100                  NA            8 FAIL          
#>  2 zeno's icecream    130                  NA           11 FAIL          
#>  3 mystic rush        104                  NA            5 FAIL          
#>  4 delta ringer drink 129.                 NA            2 FAIL          
#>  5 welter water       103                  NA            6 FAIL          
#>  6 janus's drink      100                  NA           14 FAIL          
#>  7 beta ringer drink   51.5                NA            9 FAIL          
#>  8 zeta ringer drink   25                  NA           16 FAIL          
#>  9 heavyweight water   99.6                 0.83         6 FAIL          
#> 10 bantam water       109                  NA            5 FAIL
```
