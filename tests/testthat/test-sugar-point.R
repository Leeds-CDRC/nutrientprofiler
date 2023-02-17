test_data <- data.frame(
  "sg_adjusted_weight" = c(150, 56, 125, 125),
  "sugar_measurement_g" = c(6, 30, 29, 28),
  "expected_score" = c(0, 10, 5, 4)
)

test_that("NPM sugar score that returns 0", {
  out <- NPM_sugar_score(test_data[1, ])
  expect_equal(out, 0)
})

test_that("NPM sugar score for kcal that returns 10", {
  out <- NPM_sugar_score(test_data[2, ])
  expect_equal(out, 10)
})


test_that("NPM sugar score that returns 5 ", {
  out <- NPM_sugar_score(test_data[3, ])
  expect_equal(out, 5)
})

test_that("NPM sugar score that returns 5 ", {
  out <- NPM_sugar_score(test_data[4, ])
  expect_equal(out, 4)
})
