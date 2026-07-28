# NPM Assess function

This function takes an NPM score and returns either "PASS" or "FAIL"
depending on the `type` argument. Where `type` is either "food" or
"drink".

## Usage

``` r
NPM_assess(NPM_score, type)
```

## Arguments

- NPM_score, :

  a numeric value for the NPM score

- type, :

  a character value of either "food" or "drink" to determine how to
  assess the score

## Value

a character value of either "PASS" or "FAIL"
