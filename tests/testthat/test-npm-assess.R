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