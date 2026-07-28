# Specific Gravity converter function

This function is the key entry point for performing specific gravity
conversions It works by processing data from a dataframe row and
dispatching based on column values to a series of additional sub
functions These return back an SG-adjusted number

## Usage

``` r
SGConverter(row)
```

## Arguments

- row:

  a row from a data.frame object

## Value

A number.
