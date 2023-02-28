test_that("salt_adjuster returns correct result with salt measurement in grams", {
  row <- list("salt_measurement_g" = 2.5, "sodium_measurement_mg" = 1000, "sg_adjusted_weight" = 100)
  result <- salt_adjuster(row)
  expect_equal(result, 2.5)
})

# Test 2: Valid input with salt measurement missing
test_that("salt_adjuster returns correct result with missing salt measurement", {
  test_row <- data.frame("sodium_measurement_mg" = 1000, "sg_adjusted_weight" = 100)
  result <- salt_adjuster(test_row)
  expect_equal(result, 2.5)
})

# Test 3: Valid input with sodium measurement missing
test_that("salt_adjuster returns correct result with missing sodium measurement", {
  test_row <- data.frame("salt_measurement_g" = 2.5, "sg_adjusted_weight" = 100)
  result <- salt_adjuster(test_row)
  expect_equal(result, 2500)
})

# Test 4: Invalid input with missing required columns
test_that("salt_adjuster throws an error with missing required columns", {
  test_row <- data.frame("sugar_measurement_g" = 2.5, "sg_adjusted_weight" = 100)
  expect_error(salt_adjuster(test_row), "The passed data to NPM_a_score does not have the required columns")
})