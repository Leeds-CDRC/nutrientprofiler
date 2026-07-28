# Introduction to nutrientprofiler

The `nutrientprofiler` package aims to provide a series of R functions
that implement UK Nutrient Profiling Model scoring that can be applied
across product datasets.

This is broken up into 3 parts within the package:

- Specific gravity conversions
- Scoring the different nutritional components of the NPM score
- Calculating the NPM score and NPM assessment logic

To start we load the package the with command below.

``` r

library(nutrientprofiler)
```

We can also load some example data to help us with the following
examples. This data was created specifically for this package and so is
potentially quite different to how your real world data might look.

``` r

dim(cdrcdrinks)
#> [1] 10 21
cdrcdrinks[1, ]
#>     name brand product_category product_type food_type drink_format drink_type
#> 1 lembas    NA               NA         Food                                  
#>   nutrition_info energy_measurement_kj energy_measurement_kcal
#> 1                                  266                      NA
#>   sugar_measurement_g satfat_measurement_g salt_measurement_g
#> 1                  50                    3                 NA
#>   sodium_measurement_mg fibre_measurement_nsp fibre_measurement_aoac
#> 1                   0.6                     3                     NA
#>   protein_measurement_g fvn_measurement_percent weight_g volume_ml
#> 1                     7                       0      100        NA
#>   volume_water_ml
#> 1              NA
```

## Specific gravity conversions

When trying to determine the NPM score the volume or weight of the
product needs to be adjusted to account for it’s specific gravity.

To adjust product weights or volumes for specific gravity we use the
`SGConverter` function. This is a high level function that is designed
to operate on each row of a data.frame parsing multiple columns to
determine how to calculate the adjusted specific gravity score.

``` r
Warning: The `SGConverter` function has been specifically designed with an
existing dataset in mind and expects specific column names to work.
```

``` r

# using dplyr
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
cdrcdrinks %>%
  rowwise() %>%
  mutate(out = SGConverter(pick(everything()))) %>%
  select(out)
#> # A tibble: 10 × 1
#> # Rowwise: 
#>      out
#>    <dbl>
#>  1 100  
#>  2 130  
#>  3 104  
#>  4 129. 
#>  5 103  
#>  6 100  
#>  7  51.5
#>  8  25  
#>  9 124. 
#> 10 109

# using base R
cdrcdrinks["sg"] <- unlist(lapply(seq_len(nrow(cdrcdrinks)), function(i) SGConverter(cdrcdrinks[i, ])))
```

The below figure attempts to outline the hierarchy of function calls
that `SGConverter` initiates. The logic for determining how to adjust
values for specific gravity is complicated by the potential options
around whether a drink is ready-to-drink, a powdered preparation, or a
cordial, within both the powdered and cordial options additional
consideration must be given to the preparation instructions that are
provided. In the below figure each function is named in each node and
each column name the function uses to dispatch to underlying functions
is specified in single quotes. If a function returns a value it is
marked with an empty diamond.

SGConverter logic

## Nutrient profile model scoring

The next part of this package is a series of functions for handling
Nutrient Profile Model scoring. These specifically look at functions for
adjusting units into the expected unit as documented for the [Nutrient
Profile
Model](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/216094/dh_123492.pdf),
a generic scoring function for returning a score for a value given a
number of thresholds, a scoring dispatcher function that determines what
adjuster and scoring thresholds to use for a given value and a high
level `NPMScore` wrapper function that shows the logic for calculating
the NPM score across multiple nutritional groups for a data.frame of
data.

A quick example of running `NPMScore` across a single row of data is
shown below:

``` r

NPMScore(cdrcdrinks[1,], sg_adjusted_label="sg")
#>   energy_score sugar_score satfat_score protein_score salt_score fvn_score
#> 1            0          10            2             4          0         0
#>   fibre_score
#> 1           4
```

An example of building a tidyverse pipeline to calculate scores across
all rows of a data.frame using `NPMScore` and `SGConverter` is shown
below:

``` r

library(tidyr)

cdrcdrinks %>% 
  rowwise() %>% 
  mutate( sg = SGConverter(pick(everything()))) %>% 
  mutate(test = NPMScore(pick(everything()), sg_adjusted_label="sg")) %>% 
  unnest(test) %>% select(energy_score, sugar_score, salt_score, fvn_score,
  protein_score, satfat_score, fibre_score)
#> # A tibble: 10 × 7
#>    energy_score sugar_score salt_score fvn_score protein_score satfat_score
#>           <dbl>       <dbl>      <dbl>     <dbl>         <dbl>        <dbl>
#>  1            0          10          0         0             4            2
#>  2            0           3          0         0             1            8
#>  3            2           2          1         0             0            0
#>  4            0           2          0         0             0            0
#>  5            2           4          0         0             0            0
#>  6            0           4          0         0             2           10
#>  7            1           6          2         0             0            0
#>  8            2          10          4         0             1            0
#>  9            2           3          0         0             0            0
#> 10            2           3          0         0             0            0
#> # ℹ 1 more variable: fibre_score <dbl>
```

## Nutrient Profile Model assessment

After calculating the scores for specific nutrients for our product next
we need to perform the actual Nutrient Profile Model assessment. This
involves combining individual nutrient scores to calculate an A score
and a C score and use these compound to calculate a total Nutrient
Profile Model score and assess this to determine a pass or fail.

This package implements this logic in a high-level wrapper function
called `NPMAssess` which operates on a row of a data.frame. It expects
the columns generated in the previous `NPMScore` step to allow it to
calculate the A score and C score and can be used as follows:

``` r

# create NPM_score data.frame from NPMScore
# using the specific gravity `sg` column created above
npm_scores <- do.call(
        "rbind",
        lapply(
            seq_len(nrow(cdrcdrinks)),
            function(i) NPMScore(cdrcdrinks[i, ], sg_adjusted_label = "sg")
        )
    )

# append NPM Score columns to original data
combo_df <- cbind(cdrcdrinks, npm_scores)

# test NPMAssess on this data
NPMAssess(combo_df[1, ])
#>   A_score C_score NPM_score NPM_assessment
#> 1      12       8         8           FAIL
```

We can also use tidyverse functions to build an entire pipeline for
running Nutrient Profile Model assessments.

``` r

# using tidyr
library(tidyr)

cdrcdrinks %>% 
  rowwise() %>% 
  mutate( sg = SGConverter(pick(everything()))) %>% 
  mutate(test = NPMScore(pick(everything()), sg_adjusted_label="sg")) %>% 
  unnest(test) %>% 
  rowwise() %>%
  mutate(assess = NPMAssess(pick(everything()))) %>%
  unnest(assess) %>%
  select(product_type, NPM_score, NPM_assessment)
#> # A tibble: 10 × 3
#>    product_type NPM_score NPM_assessment
#>    <chr>            <dbl> <chr>         
#>  1 Food                 8 FAIL          
#>  2 Food                11 FAIL          
#>  3 Drink                5 FAIL          
#>  4 Drink                2 FAIL          
#>  5 Drink                6 FAIL          
#>  6 Food                14 FAIL          
#>  7 Drink                9 FAIL          
#>  8 Drink               16 FAIL          
#>  9 Drink                5 FAIL          
#> 10 Drink                5 FAIL
```

The building blocks of `NPMAssess` are explained in more detail in the
[Nutrient Profile Model Assessment
vignette](https://leeds-cdrc.github.io/nutrientprofiler/articles/nutrientprofile_assessment.md)
