test_data <- data.frame(
  "sg_adjusted_weight" = c(123, 100, 30),
  "energy_measurement_kj" = c(250, NA, 550),
  "energy_measurement_kcal" = c(NA, 1000, NA),
  "expected_score" = c(0, 10, 5)
)

test_that("A NPM score for KJ that returns 0", {
  out <- NPM_a_score(test_data[1, ])
  expect_equal(out, 0)
})

test_that("A NPM score for kcal that returns 10", {
  out <- NPM_a_score(test_data[2, ])
  expect_equal(out, 10)
})


test_that("A NPM score for KJ that returns 5 ", {
  out <- NPM_a_score(test_data[3, ])
  expect_equal(out, 5)
})
