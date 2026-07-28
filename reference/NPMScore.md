# NPM scoring dispatcher

This function is written for calculating NPM scores across an entire row
in a dataframe. It is wrapper logic for the underlying
NPM_score_function when applied to an NPMCalculator input data frame as
such it is highly inflexible without expected column names. It expects
the specific gravity conversions to already have been performed and
values outputted to a new single column.

## Usage

``` r
NPMScore(row, sg_adjusted_label)
```

## Arguments

- row:

  the row from an NPMCalculator dataframe

- sg_adjusted_label:

  a character value specifying the name of the specific gravity adjusted
  column

## Value

a matrix of NPM scores
