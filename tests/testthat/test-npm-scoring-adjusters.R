# Test for valid input
# Incorrect test?: expect_equal(salt_adjuster(2, 50, "salt"), 40)
test_that("salt_adjuster returns the correct output for valid input", {
  expect_equal(salt_adjuster(50, 1000, "sodium"), 5)
  expect_equal(salt_adjuster(2.4, 200, "salt"), 480)
})

# Test for invalid type
test_that("salt_adjuster throws an error for invalid type", {
  expect_error(salt_adjuster(50, 1000, "invalid_type"))
})

# Test for division by zero
test_that("salt_adjuster throws an error for zero denominator", {
  expect_error(salt_adjuster(50, 0, "sodium"))
  expect_error(salt_adjuster(2, 0, "salt"))
})

## generic_adjuster tests

# Test for valid input
test_that("generic_adjuster returns the correct output for valid input", {
  expect_equal(generic_adjuster(50, 1000), 5)
  expect_equal(generic_adjuster(2, 50), 4)
})

# Test for division by zero
test_that("generic_adjuster throws an error for zero denominator", {
  expect_error(generic_adjuster(50, 0))
})

# Test for negative input
test_that("generic_adjuster throws an error for negative input", {
  expect_error(generic_adjuster(-50, 100))
})

### energy_value_adjuster tests

# Test for valid input with kj
test_that("energy_value_adjuster returns the correct output for valid input with kj", {
  expect_equal(energy_value_adjuster(50, 1000, "kj"), 5)
})

# Test for valid input with kcal
test_that("energy_value_adjuster returns the correct output for valid input with kcal", {
  expect_equal(energy_value_adjuster(2, 50, "kcal"), 16.736)
})

# Test for division by zero
test_that("energy_value_adjuster throws an error for zero denominator", {
  expect_error(energy_value_adjuster(50, 0, "kj"))
})

# Test for negative input
test_that("energy_value_adjuster throws an error for negative input", {
  expect_error(energy_value_adjuster(-50, 100, "kj"))
})
