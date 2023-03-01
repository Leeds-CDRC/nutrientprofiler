test_data_a <- data.frame(
  "sg_adjusted_weight" = c(123, 100, 30),
  "energy_measurement_kj" = c(250, NA, 550),
  "energy_measurement_kcal" = c(NA, 1000, NA),
  "expected_score" = c(0, 10, 5)
)

test_data_sugar <- data.frame(
  "sg_adjusted_weight" = c(150, 56, 125, 125),
  "sugar_measurement_g" = c(6, 30, 29, 28),
  "expected_score" = c(0, 10, 5, 4)
)

test_data_fat <- data.frame(
  "sg_adjusted_weight" = c(120, 50, 80, 30),
  "fat_measurement_g" = c(20, 4, 3.8, 0),
  "expected_score" = c(10, 7, 4, 0)
)

# testing NPM A score
test_that("A NPM score for KJ that returns 0", {
  out <- NPM_score_function(test_data_a[1, ], "a")
  expect_equal(out, test_data_a[1, "expected_score"])
})

test_that("A NPM score for kcal that returns 10", {
  out <- NPM_score_function(test_data_a[2, ], "a")
  expect_equal(out, test_data_a[2, "expected_score"])
})


test_that("A NPM score for KJ that returns 5 ", {
  out <- NPM_score_function(test_data_a[3, ], "a")
  expect_equal(out, test_data_a[3, "expected_score"])
})

test_that("test scoring_function on a boundary", {
  out <- scoring_function(5, c(10, 5, 1))
  expect_equal(out, 1)
})

# testing the generic scoring function
test_that("test scoring_function", {
  out <- scoring_function(0, c(10, 5, 1))
  expect_equal(out, 0)
})

# testing the generic scoring function
test_that("test scoring_function", {
  out <- scoring_function(2, c(10, 5, 1))
  expect_equal(out, 1)
})

test_that("test scoring_function", {
  out <- scoring_function(25, c(10, 5, 1))
  expect_equal(out, 3)
})

test_that("test scoring_function with vec of length 6", {
  out <- scoring_function(24, c(25, 20, 15, 10, 5, 1))
  expect_equal(out, 5)
})


test_that("test scoring_function on top end value ", {
  thresholds <- c()
  out <- scoring_function(25, c(1, 5, 10))
  expect_equal(out, 3)
})


# testing NPM sugar score
test_that("NPM sugar score that returns 0", {
  out <- NPM_score_function(test_data_sugar[1, ], "sugar")
  expect_equal(out, 0)
})

test_that("NPM sugar score for kcal that returns 10", {
  out <- NPM_score_function(test_data_sugar[2, ], "sugar")
  expect_equal(out, 10)
})


test_that("NPM sugar score that returns 5 ", {
  out <- NPM_score_function(test_data_sugar[3, ], "sugar")
  expect_equal(out, 5)
})

test_that("NPM sugar score that returns 5 ", {
  out <- NPM_score_function(test_data_sugar[4, ], "sugar")
  expect_equal(out, 4)
})


# testing NPM fat score
test_that("NPM fat score that returns 10", {
  out <- NPM_score_function(test_data_fat[1, ], "fat")
  expect_equal(out, test_data_fat[1, "expected_score" ])
})

test_that("NPM fat score for returns 9", {
  out <- NPM_score_function(test_data_fat[2, ], "fat")
  expect_equal(out, test_data_fat[2, "expected_score" ])
})

test_that("NPM fat score for returns 5", {
  out <- NPM_score_function(test_data_fat[3, ], "fat")
  expect_equal(out, test_data_fat[3, "expected_score" ])
})

test_that("NPM fat score for returns 0", {
  out <- NPM_score_function(test_data_fat[4, ], "fat")
  expect_equal(out, test_data_fat[4, "expected_score" ])
})


