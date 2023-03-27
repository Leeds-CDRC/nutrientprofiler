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

assess_row <- data.frame(energy_score = c(5, 3, 4, 6),
                  sugar_score = c(4,4,6, 5), 
                  fat_score = c(8,1, 0, 2), 
                  protein_score = c(4,6,0,2), 
                  fvn_score = c(0,1, 5, 1), 
                  fibre_score = c(1,8, 5, 3), 
                  product_type = c("food","food","drink","drink"))

# Test 1: Test if the function returns a matrix
test_that("NPMAssess should return a dataframe", {
    expect_true(is.data.frame(NPMAssess(assess_row[1,])))
})

# Test 2: Test if the function returns columns named correctly
test_that("NPMAssess should return a dataframe with columns named correctly", {
    expect_named(NPMAssess(assess_row[1,]), c("A_score", "C_score", "NPM_score", "NPM_assessment"))
})

# Test 3: Test if the function correctly calculates the NPM score
test_that("NPMAssess should correctly calculate the NPM score", {

    out_df <- do.call("rbind", lapply(seq_len(nrow(assess_row)), function(i) NPMAssess(assess_row[i,])))

    expect_true(identical(out_df$NPM_score, c(16,0,9)))
})

# Test 4: Test if the function correctly assesses the NPM score for a food
test_that("NPMAssess should correctly assess the NPM score for a food", {
    expect_equal(NPMAssess(assess_row[2,])$NPM_assessment, "PASS")
})

# Test 5: Test if the function correctly assesses the NPM score for a drink
test_that("NPMAssess should correctly assess the NPM score for a drink", {
    expect_equal(NPMAssess(assess_row[3,])$NPM_assessment, "PASS")
})
