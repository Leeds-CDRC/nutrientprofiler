# Preprocessing input data

For this guidance, we are going to use an example dataset called
`example_data`. Please see the detailed documentation on what parameter
names and values are expected or required, and to see the workflows
explaining how to load in data.

This example data has a few typos in certain categories. This
documentations steps through one example workflow for filtering and
checking your input data before using the `nutrientprofiler` library to
analyse it.

``` r

# load in required libraries
library(nutrientprofiler)
# read in the data
example_data <- read.csv("data/example_data.csv")
```

## Checking input data column names

While there are an array of functions to check parameter names and
missing parameters, it is useful to be able to manually check your input
data with base R or a library like tidyr or dplyr additionally.

You can check what column names are in your loaded dataframe using base
R:

``` r

# Print out your data column names
names(example_data)
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
#> [21] "volume_water_ml"
```

You can compare these parameter names to the expected parameters that
`nutrientprofiler` uses for analysis using the
[`inputDataCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/inputDataCheck.md)
function:

``` r

inputDataCheck(example_data)
#> [1] "All required column names found. Proceed with analysis."
```

If required, parameter names can be fixed at this point using the
[`parameterRename()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/parameterRename.md)
and
[`fillMissingParameters()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/fillMissingParameters.md)
functions.

## Checking input data values

Next, you can use the
[`CheckValues()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/CheckValues.md)
function to produce an overview of the values stored in your dataframe:

``` r

overview_of_values <- CheckValues(example_data)
print(overview_of_values)
#>             Parameter_name Count_unique_values
#> 1                     name                  10
#> 2                    brand                   1
#> 3         product_category                   1
#> 4             product_type                   2
#> 5                food_type                   2
#> 6             drink_format                   5
#> 7               drink_type                   2
#> 8           nutrition_info                   5
#> 9    energy_measurement_kj                   3
#> 10 energy_measurement_kcal                   4
#> 11     sugar_measurement_g                   5
#> 12    satfat_measurement_g                   3
#> 13      salt_measurement_g                   3
#> 14   sodium_measurement_mg                   3
#> 15   fibre_measurement_nsp                   2
#> 16  fibre_measurement_aoac                   3
#> 17   protein_measurement_g                   5
#> 18 fvn_measurement_percent                   3
#> 19                weight_g                   3
#> 20               volume_ml                   4
#> 21         volume_water_ml                   2
#>                                                                                                                                                   Unique_values
#> 1  lembas, zeno's icecream, mystic rush, delta ringer drink, welter water, janus's drink, beta ringer drink, zeta ringer drink, heavyweight water, bantam water
#> 2                                                                                                                                                            NA
#> 3                                                                                                                                                            NA
#> 4                                                                                                                                                   Food, Drink
#> 5                                                                                                                                                   , Ice cream
#> 6                                                                                                                            , Ready, Powdered, Cordial, Powder
#> 7                                                                                                                                         , Carbted/juice drink
#> 8                                               , Preparation instructions given, As consumed, Prep. instructions not given, Preparation instructions not given
#> 9                                                                                                                                                  266, NA, 188
#> 10                                                                                                                                             NA, 24, 194, 205
#> 11                                                                                                                                           50, 21, 11, 15, 19
#> 12                                                                                                                                                     3, 11, 0
#> 13                                                                                                                                                NA, 0.08, 0.1
#> 14                                                                                                                                                 0.6, NA, 100
#> 15                                                                                                                                                        3, NA
#> 16                                                                                                                                                   NA, 0.7, 0
#> 17                                                                                                                                          7, 3.5, 0, 0.5, 0.1
#> 18                                                                                                                                                      0, 3, 6
#> 19                                                                                                                                                  100, NA, 25
#> 20                                                                                                                                              NA, 100, 50, 20
#> 21                                                                                                                                                      NA, 100
```

You can read these and compare them to the parameter table provided in
the documentation, and can save the output to a csv file for future
reference:

``` r

write.csv(overview_of_values, "path/to/output/file.csv", row.names=FALSE)
```

In this example, we have a few values with typos that will cause issues:

``` r

print(overview_of_values[6,])
#>   Parameter_name Count_unique_values                      Unique_values
#> 6   drink_format                   5 , Ready, Powdered, Cordial, Powder
print(overview_of_values[7,])
#>   Parameter_name Count_unique_values         Unique_values
#> 7     drink_type                   2 , Carbted/juice drink
print(overview_of_values[8,])
#>   Parameter_name Count_unique_values
#> 8 nutrition_info                   5
#>                                                                                                     Unique_values
#> 8 , Preparation instructions given, As consumed, Prep. instructions not given, Preparation instructions not given
```

We have `Powder` instead of `Powdered`; `Carbted/juice drink` instead of
`Carbonated/juice drink`; and `Prep. instructions not given` instead of
`Preparation instructions not given`. For clear cases of typos like
this, we can easily replace all incorrect values.

## Fixing typos

We can easily fix typos in the dataset using the following script. This
is kept separate from applying new values or applying defaults as is
described in the [Handling Input Data
article](https://leeds-cdrc.github.io/nutrientprofiler/articles/handling_input_data.html#fill-missing-data),
where an additional column is added to record where values were
overwritten.

``` r

example_data$drink_format[example_data$drink_format=="Powder"] <- "Powdered"
example_data$drink_type[example_data$drink_type=="Carbted/juice drink"] <- "Carbonated/juice drink"
example_data$nutrition_info[example_data$nutrition_info=="Prep. instructions not given"] <- "Preparation instructions not given"
```

After updating these in place, you can check again if you have captured
all the incorrect values:

``` r

CheckValues(example_data)
#>             Parameter_name Count_unique_values
#> 1                     name                  10
#> 2                    brand                   1
#> 3         product_category                   1
#> 4             product_type                   2
#> 5                food_type                   2
#> 6             drink_format                   4
#> 7               drink_type                   2
#> 8           nutrition_info                   4
#> 9    energy_measurement_kj                   3
#> 10 energy_measurement_kcal                   4
#> 11     sugar_measurement_g                   5
#> 12    satfat_measurement_g                   3
#> 13      salt_measurement_g                   3
#> 14   sodium_measurement_mg                   3
#> 15   fibre_measurement_nsp                   2
#> 16  fibre_measurement_aoac                   3
#> 17   protein_measurement_g                   5
#> 18 fvn_measurement_percent                   3
#> 19                weight_g                   3
#> 20               volume_ml                   4
#> 21         volume_water_ml                   2
#>                                                                                                                                                   Unique_values
#> 1  lembas, zeno's icecream, mystic rush, delta ringer drink, welter water, janus's drink, beta ringer drink, zeta ringer drink, heavyweight water, bantam water
#> 2                                                                                                                                                            NA
#> 3                                                                                                                                                            NA
#> 4                                                                                                                                                   Food, Drink
#> 5                                                                                                                                                   , Ice cream
#> 6                                                                                                                                    , Ready, Powdered, Cordial
#> 7                                                                                                                                      , Carbonated/juice drink
#> 8                                                                             , Preparation instructions given, As consumed, Preparation instructions not given
#> 9                                                                                                                                                  266, NA, 188
#> 10                                                                                                                                             NA, 24, 194, 205
#> 11                                                                                                                                           50, 21, 11, 15, 19
#> 12                                                                                                                                                     3, 11, 0
#> 13                                                                                                                                                NA, 0.08, 0.1
#> 14                                                                                                                                                 0.6, NA, 100
#> 15                                                                                                                                                        3, NA
#> 16                                                                                                                                                   NA, 0.7, 0
#> 17                                                                                                                                          7, 3.5, 0, 0.5, 0.1
#> 18                                                                                                                                                      0, 3, 6
#> 19                                                                                                                                                  100, NA, 25
#> 20                                                                                                                                              NA, 100, 50, 20
#> 21                                                                                                                                                      NA, 100
```

**Note that for a large dataset with thousands of values, the number of
unique values for numerical parameters such as `weight_g` will be very
high. Instead of printing the full table, you should instead use subsets
for your initial overview.** You can subset the overview table using
code like this:

``` r

overview_of_values[c("Parameter_name", "Count_unique_values")]
#>             Parameter_name Count_unique_values
#> 1                     name                  10
#> 2                    brand                   1
#> 3         product_category                   1
#> 4             product_type                   2
#> 5                food_type                   2
#> 6             drink_format                   5
#> 7               drink_type                   2
#> 8           nutrition_info                   5
#> 9    energy_measurement_kj                   3
#> 10 energy_measurement_kcal                   4
#> 11     sugar_measurement_g                   5
#> 12    satfat_measurement_g                   3
#> 13      salt_measurement_g                   3
#> 14   sodium_measurement_mg                   3
#> 15   fibre_measurement_nsp                   2
#> 16  fibre_measurement_aoac                   3
#> 17   protein_measurement_g                   5
#> 18 fvn_measurement_percent                   3
#> 19                weight_g                   3
#> 20               volume_ml                   4
#> 21         volume_water_ml                   2
```

This allows you to identify the categorical parameters (with manageable
numbers of unique values) and to print these rows individually:

``` r

# Printing using the row index
print(overview_of_values[6,])
#>   Parameter_name Count_unique_values                      Unique_values
#> 6   drink_format                   5 , Ready, Powdered, Cordial, Powder

# Printing using the parameter name
print(overview_of_values[which(overview_of_values$Parameter_name == "drink_format"),])
#>   Parameter_name Count_unique_values                      Unique_values
#> 6   drink_format                   5 , Ready, Powdered, Cordial, Powder
```

## Check validity of numeric data

In order to check numeric values, you can use max and minimum values
(and measures of average if desired) to check that the values are within
the expected bounds by using basic mathematical functions on the column
of interest in the original product data dataframe:

``` r

print("protein_measurement_g values")
#> [1] "protein_measurement_g values"
print(paste("Max:", max(example_data$protein_measurement_g)))
#> [1] "Max: 7"
print(paste("Min.:", min(example_data$protein_measurement_g)))
#> [1] "Min.: 0"
print(paste("Mean:", mean(example_data$protein_measurement_g)))
#> [1] "Mean: 1.58"
print(paste("Median:", median(example_data$protein_measurement_g)))
#> [1] "Median: 0.5"
```

Individual values can be interrogated, plotted against other parameters
using a graphics library like `ggplot`, and replaced in a similar way to
described above for the character-type entries.

Please see the [Handling Input
Data](https://leeds-cdrc.github.io/nutrientprofiler/articles/handling_input_data.md)
for further pre-processing steps beyond this point.
