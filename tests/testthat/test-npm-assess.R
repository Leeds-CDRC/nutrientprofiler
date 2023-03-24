# Test for A_scorer function
test_that("A_scorer returns the sum of all scores", {
    expect_equal(A_scorer(1, 2, 3, 4), 10)
})

# Test for C_score function
test_that("C_score returns the sum of all scores", {
    expect_equal(C_scorer(1, 2, 3), 6)
})

# Test for NPM_total function
test_that("NPM_total calculates the overall NPM score correctly", {

    expect_equal(NPM_total(12, 4, 4, 2), 6)
    expect_equal(NPM_total(10, 5, 2, 1), 5)
})

# Test for NPM_assess function
test_that("NPM_assess assesses the NPM score correctly", {
    expect_equal(NPM_assess(3, "food"), "PASS")
    expect_equal(NPM_assess(0, "drink"), "PASS")
    expect_equal(NPM_assess(1, "drink"), "FAIL")
    expect_equal(NPM_assess(7, "food"), "FAIL")
    expect_error(NPM_assess(2, "snack"), "The passed type to NPM_assess does not match expected types")
})

## testing NPMAssess

library(testthat)

# Test 1: Test if the function returns a dataframe
test_that("NPMAssess should return a dataframe", {
    row <- data.frame(energy_score = 5, sugar_score = 10, fat_score = 15, protein_score = 20, fvn_score = 25, fibre_score = 30, product_type = "food")
    expect_is(NPMAssess(row), "matrix")
})

# Test 2: Test if the function returns columns named correctly
test_that("NPMAssess should return a dataframe with columns named correctly", {
    row <- data.frame(energy_score = 5, sugar_score = 10, fat_score = 15, protein_score = 20, fvn_score = 25, fibre_score = 30, product_type = "food")
    expect_named(NPMAssess(row), c("A_score", "C_score", "NPM_score", "NPM_assessment"))
})

# Test 3: Test if the function correctly calculates the NPM score
test_that("NPMAssess should correctly calculate the NPM score", {
    row <- data.frame(energy_score = 5, sugar_score = 10, fat_score = 15, protein_score = 20, fvn_score = 25, fibre_score = 30, product_type = "food")
    expect_equal(NPMAssess(row)$NPM_score, 90)
})

# Test 4: Test if the function correctly assesses the NPM score for a food
test_that("NPMAssess should correctly assess the NPM score for a food", {
    row <- data.frame(energy_score = 5, sugar_score = 10, fat_score = 15, protein_score = 20, fvn_score = 25, fibre_score = 30, product_type = "food")
    expect_equal(NPMAssess(row)$NPM_assessment, "PASS")
})

# Test 5: Test if the function correctly assesses the NPM score for a drink
test_that("NPMAssess should correctly assess the NPM score for a drink", {
    row <- data.frame(energy_score = 5, sugar_score = 10, fat_score = 15, protein_score = 20, fvn_score = 25, fibre_score = 30, product_type = "drink")
    expect_equal(NPMAssess(row)$NPM_assessment, "FAIL")
})
