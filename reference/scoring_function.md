# a template scoring function

This function takes a value and a vector of thresholds It iterates over
the reversed vector of indexes in the thresholds vector And checks if
the value is less than the threshold value at the itered index
(comparing from smallest to largest). The threshold score is calculated
as the length of the thresholds minus every else branch iter of the
loop.

## Usage

``` r
scoring_function(value, thresholds)
```

## Arguments

- value:

  a passed numeric value

- thresholds:

  a vector of thresholds to use to score against in order of highest to
  lowest
