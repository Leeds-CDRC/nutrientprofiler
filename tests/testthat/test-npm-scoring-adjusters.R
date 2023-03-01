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

## generic_adjuster tests

# Test for valid input
test_that("generic_adjuster returns the correct output for valid input", {
  expect_equal(generic_adjuster(50, 1000), 5)
  expect_equal(generic_adjuster(2, 50), 4)
})

# Test for division by zero
test_that("generic_adjuster throws an error for zero denominator", {
  expect_error(generic_adjuster(50, 0), "Cannot divide by zero, please change 'adjusted_weight'")
})

# Test for negative input
test_that("generic_adjuster throws an error for negative input", {
  expect_error(generic_adjuster(-50, 100), "Cannot submit a negative value for either 'value' or 'adjusted_weight in generic_adjuster")
})

### a_value_adjuster tests

# Test for valid input with kj
test_that("a_value_adjuster returns the correct output for valid input with kj", {
  expect_equal(a_value_adjuster(50, 1000, "kj"), 5)
})

# Test for valid input with kcal
test_that("a_value_adjuster returns the correct output for valid input with kcal", {
  expect_equal(a_value_adjuster(2, 50, "kcal"), 16.736)
})

# Test for division by zero
test_that("a_value_adjuster throws an error for zero denominator", {
  expect_error(a_value_adjuster(50, 0, "kj"), "Cannot divide by zero, please change 'adjusted_weight'")
})

# Test for negative input
test_that("a_value_adjuster throws an error for negative input", {
  expect_error(a_value_adjuster(-50, 100, "kj"), "Cannot submit a negative value for either 'value' or 'adjusted_weight in generic_adjuster")
})