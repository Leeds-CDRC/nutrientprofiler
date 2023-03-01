# Test for valid input
test_that("salt_adjuster returns the correct output for valid input", {
  expect_equal(salt_adjuster(50, 1000, "sodium"), 5)
  expect_equal(salt_adjuster(2, 50, "salt"), 40)
})

# Test for invalid type
test_that("salt_adjuster throws an error for invalid type", {
  expect_error(salt_adjuster(50, 1000, "invalid_type"), 
               "Invalid type passed to salt_adjuster, can only be 'salt' or 'sodium'")
})

# Test for division by zero
test_that("salt_adjuster throws an error for zero denominator", {
  expect_error(salt_adjuster(50, 0, "sodium"), "Cannot divide by zero, please change 'adjusted_weight'")
  expect_error(salt_adjuster(2, 0, "salt"), "Cannot divide by zero, please change 'adjusted_weight'")
})