# Handling input data

Input data is likely to be messy and to not contain the required column
names for `nutrientprofiler`. This vignette provides some advice and
guidelines on how to pre-process your data to allow analysis and
assessment with `nutrientprofiler`.

You can see what parameters are expected in more detail in the
[Parameter guide
documentation](https://leeds-cdrc.github.io/nutrientprofiler/articles/parameter_guide.md)
or the [Example dataset
reference](https://leeds-cdrc.github.io/nutrientprofiler/reference/cdrcdrinks.md).
The order of parameters/columns in the loaded data do not matter.

## Loading an example template

When possible, it is a good idea to ensure your data is in the required
format before yourload it in to R. This can be achieved by using a
template.

The `nutrientprofiler` package offers an example dataset, `cdrcdrinks`.
This can be saved out as an example csv file and then edited and loaded
with real data:

``` r

# Save an example csv file to your current working directory
write.csv(cdrcdrinks, "template_full.csv", row.names = FALSE)
```

Alternatively, just the headers can be saved, providing a blank csv file
which can be opened in Excel or your editor of choice:

``` r

# Save an example csv file to your current working directory
write.csv(t(names(cdrcdrinks)), "template_headings.csv", row.names = FALSE)
```

## Checking column names and renaming parameters

If raw data has been acquired with different column names than required,
a reproducible workflow can be set up to rename these parameters as
required.

The first step is to check the existing column names:

``` r

inputDataCheck(cdrcdrinks)
#> [1] "All required column names found. Proceed with analysis."
```

If the dataframe contains names as expected, you’ll get a message
telling you to proceed with analysis, as with the example dataset above.

However, lets say we have loaded in a dataset from csv `irregular_data`
that does not contain the exact columns required:

``` r

inputDataCheck(irregular_data)
#> [1] "The provided dataframe is missing the following required column names:"
#> [1] "fvn_measurement_percent"
#> [1] "The provided dataframe contains these unmatched columns names:"
#> [1] "fruit_nutrition_percent"
#> [1] "irregular_data <- parameterRename(missing_column_name = 'fvn_measurement_percent', associated_data_column = '<INSERT DATA COLUMN NAME HERE>', data_frame = irregular_data)"
```

This provides you with the name of the column(s) that do not match an
expected column name (`"fruit_nutrition_percent"` in this example), and
provides you with a prompt to use the
[`parameterRename()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/parameterRename.md)
function.

You can copy this hint and replace `<INSERT DATA COLUMN NAME HERE>` with
the data that matches the listed `missing_column_name`:

``` r

irregular_data <- parameterRename(missing_column_name = 'fvn_measurement_percent', associated_data_column = 'fruit_nutrition_percent', data_frame = irregular_data)
#> [1] "Replacing fruit_nutrition_percent with fvn_measurement_percent"
```

You can now check again if the required parameters are available.

``` r

inputDataCheck(irregular_data)
#> [1] "All required column names found. Proceed with analysis."
```

## Missing parameters

Some of the parameters are optional, but still need an allocated column
in the input data table. This column can be simply filled with `NA`
values. `nutrientprofiler` provides some simple functions to help
achieve this quickly.

You can see if we run the `inputDataCheck` there are no returns for
“unmatched columns”, suggesting that the data is missing as opposed to
unlabelled:

``` r

inputDataCheck(missing_data)
#> [1] "The provided dataframe is missing the following required column names:"
#> [1] "brand"            "product_category"
#> [1] "The provided dataframe contains these unmatched columns names:"
#> character(0)
#> [1] "missing_data <- parameterRename(missing_column_name = 'brand', associated_data_column = '<INSERT DATA COLUMN NAME HERE>', data_frame = missing_data)"           
#> [2] "missing_data <- parameterRename(missing_column_name = 'product_category', associated_data_column = '<INSERT DATA COLUMN NAME HERE>', data_frame = missing_data)"
```

We can store the list of missing parameters by using the
`listMissingParameters` function:

``` r

missing_params <- listMissingParameters(missing_data)

print(missing_params)
#> [1] "brand"            "product_category"
```

If we are happy that these are optional parameters that can be filled
with `NA` values, we can pass this list (or a subset of it) to the
`fillMissingParameters` function:

``` r

filled_data <- fillMissingParameters(missing_data, missing_params)

filled_data
#>                  name product_type food_type drink_format
#> 1              lembas         Food                       
#> 2     zeno's icecream         Food Ice cream             
#> 3         mystic rush        Drink                  Ready
#> 4  delta ringer drink        Drink               Powdered
#> 5        welter water        Drink                Cordial
#> 6       janus's drink         Food                       
#> 7   beta ringer drink        Drink               Powdered
#> 8   zeta ringer drink        Drink               Powdered
#> 9   heavyweight water        Drink                Cordial
#> 10       bantam water        Drink                Cordial
#>                drink_type                     nutrition_info
#> 1                                                           
#> 2                                                           
#> 3  Carbonated/juice drink                                   
#> 4                             Preparation instructions given
#> 5                                                As consumed
#> 6                                                           
#> 7                                                As consumed
#> 8                         Preparation instructions not given
#> 9                             Preparation instructions given
#> 10                        Preparation instructions not given
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
#>    fvn_measurement_percent weight_g volume_ml volume_water_ml brand
#> 1                        0      100        NA              NA    NA
#> 2                        0       NA       100              NA    NA
#> 3                        0       NA       100              NA    NA
#> 4                        3       25        NA             100    NA
#> 5                        6       NA       100              NA    NA
#> 6                        0       NA       100              NA    NA
#> 7                        3       NA        50              NA    NA
#> 8                        3       25        NA              NA    NA
#> 9                        6       NA        20             100    NA
#> 10                       6       NA       100              NA    NA
#>    product_category
#> 1                NA
#> 2                NA
#> 3                NA
#> 4                NA
#> 5                NA
#> 6                NA
#> 7                NA
#> 8                NA
#> 9                NA
#> 10               NA
```

This then allows the data to be processed in bulk without triggerring
errors related to missing data.

## Data validity

Please see the article on [Preprocessing input
data](https://leeds-cdrc.github.io/nutrientprofiler/articles/preprocessing.md)
to see advice on how to check whether parameters are valid and within
the range expected, and to fix any typos in the dataset.

## Missing data

Certain parameters are only required for certain product types, so we
have included some functions to check if the necessary parameters are
present for each specific product.

### Find out what data is missing

``` r

report_table <- ReqParamCheck(incomplete_data)
#> [1] "Please note that the following parameters are optional and are not checked here:"
#> [1] "name"             "brand"            "product_category"
#> [1] "Please note that the following parameters have automatically applied defaults if missing and are not checked by this function:"
#> [1] "drink_format" "food_type"    "drink_type"  
#> [1] "If you wish to check the presence of these parameters and record when defaults are used,"
#> [1] "please see the `AutoDefaultParamCheck()` and `AutoDefaultParamNote()` functions"
#> [1] "Please see the `SaveReport()` function to output a csv version of this report table."
```

We can transpose and print this table to see how many rows are missing
values for each parameter:

``` r

t(report_table)
#>                         [,1]     
#> name                    NA       
#> brand                   NA       
#> product_category        NA       
#> product_type            integer,0
#> food_type               NA       
#> drink_format            NA       
#> drink_type              NA       
#> nutrition_info          integer,0
#> energy_measurement_kj   integer,0
#> energy_measurement_kcal NA       
#> sugar_measurement_g     integer,3
#> satfat_measurement_g    integer,0
#> salt_measurement_g      integer,0
#> sodium_measurement_mg   NA       
#> fibre_measurement_nsp   integer,0
#> fibre_measurement_aoac  NA       
#> protein_measurement_g   integer,0
#> fvn_measurement_percent integer,0
#> weight_g                integer,0
#> volume_ml               NA       
#> volume_water_ml         integer,0
```

In addition, there are certain parameters that have automatically
assigned defaults if they are missing
(`"drink_format", "food_type", "drink_type"`). You can also check if
these parameters are missing using the
[`AutoDefaultParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamCheck.md)
function. This adds the indices of rows missing these values to the
report dataframe object:

``` r

report_table <- AutoDefaultParamCheck(incomplete_data, report_table)
```

These “automatic defaults” can be recorded in the dataframe of product
data by using the
[`AutoDefaultParamNote()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamNote.md)
function, in the `default_params_used` column:

``` r

incomplete_data <- AutoDefaultParamNote(incomplete_data, report_table)
#> [1] "Checking drink_format"
#> [1] "Checking food_type"
#> [1] "Checking drink_type"

incomplete_data
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
#> 1                    266                      NA                    
#> 2                     NA                      24                    
#> 3                     NA                     194                  11
#> 4                    188                      NA                    
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
#>    default_params_used
#> 1            food_type
#> 2                 <NA>
#> 3                 <NA>
#> 4           drink_type
#> 5           drink_type
#> 6            food_type
#> 7           drink_type
#> 8           drink_type
#> 9           drink_type
#> 10          drink_type
```

We can use the report generated by
[`ReqParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ReqParamCheck.md)
and
[`AutoDefaultParamCheck()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/AutoDefaultParamCheck.md)
to discover what parameters are missing in more detail. When we printed
the transposed report table above (using `t(report_table)`), we saw that
some parameters read `NA` - these are optional parameters that were not
checked. Some parameters read `integer, 0` meaning that these parameters
were checked, and no data is missing from product entries where that
parameter is required. Where data is missing, `integer, NUM` is repeated
with a non-zero value in place of `NUM`, for example
`sugar_measurement_g` reads `integer, 3`. You can interogate which
product entries are missing data for `sugar_measurement_g` using the
double bracket notation:

``` r

report_table$sugar_measurement_g[[1]]
#> [1] 1 2 4
```

### Fill missing data

We can enter data for `sugar_measurement_g` in products with the indices
`1 2 4` using the
[`ManualParamUpdate()`](https://leeds-cdrc.github.io/nutrientprofiler/reference/ManualParamUpdate.md)
function. This function takes the following arguments: `data_frame`, the
product data.frame object being analysed, in this case
`incomplete_data`; `parameter_name` - in this case
`"sugar_measurement_g"`; `index_list` - these can be supplied manually
or from the report as shown above; `value` - the value to set the
parameter to for these rows. We are going to use an unrealistically high
value of `100.0` in order to clearly see where this has been applied.

``` r

updated_data <- ManualParamUpdate(
  incomplete_data,
  "sugar_measurement_g",
  report_table$sugar_measurement_g[[1]],
  100.0)
```

Where values are required to be numeric, we can coerce the values to a
numeric type:

``` r

updated_data$sugar_measurement_g <- as.numeric(updated_data$sugar_measurement_g)
```

We can see the updated `sugar_measurement_g` values in our dataframe,
before and after the coercion:

``` r

# Update sugar values:
print(updated_data$sugar_measurement_g)
#>  [1] "100" "100" "11"  "100" "19"  "21"  "15"  "15"  "19"  "19"

updated_data$sugar_measurement_g <- as.numeric(updated_data$sugar_measurement_g)

# Record of where parameters have been manually edited/applied:
print(updated_data$manual_params_used)
#>  [1] "sugar_measurement_g" "sugar_measurement_g" NA                   
#>  [4] "sugar_measurement_g" NA                    NA                   
#>  [7] NA                    NA                    NA                   
#> [10] NA
```

This updated dataframe can then be used in the analysis workflow
examples given in this documentation:

``` r

library(tidyr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

updated_data_results <- updated_data %>% 
  rowwise() %>% 
  mutate( sg = SGConverter(pick(everything()))) %>% 
  mutate(test = NPMScore(pick(everything()), sg_adjusted_label="sg")) %>% 
  unnest(test) %>% 
  rowwise() %>%
  mutate(assess = NPMAssess(pick(everything()))) %>%
  unnest(assess) %>%
  select(everything(), energy_score, sugar_score, salt_score, fvn_score,
  protein_score, satfat_score, fibre_score, NPM_score, NPM_assessment)
```

## Checking for incorrect data
