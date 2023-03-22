test_data_energy <- data.frame(
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

test_data_fvn <- data.frame(
  "fruit_veg_nut" = c(88, 40, 70, 43),
  "expected_score" = c(5, 0, 2, 1)
)

# testing NPM A score
test_that("A NPM score for KJ data", {

    test_data_energy_kj <- test_data_energy[!is.na(test_data_energy$energy_measurement_kj),]

  out <- NPM_score_function(test_data_energy_kj[,"energy_measurement_kj"], test_data_energy_kj[,"sg_adjusted_weight"], "energy", adjuster_type = "kj")
  expect_equal(out, test_data_energy_kj[, "expected_score"])
})

test_that("A NPM score for kcal data", {

  test_data_energy_kcal <- test_data_energy[!is.na(test_data_energy$energy_measurement_kcal),]

  out <- NPM_score_function(test_data_energy_kcal[,"energy_measurement_kcal"], test_data_energy_kcal[,"sg_adjusted_weight"], "energy", adjuster_type = "kcal")
  expect_equal(out, test_data_energy_kcal[, "expected_score"])
})

### scoring_function tests

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


# testing NPM_score_function for sugar
test_that("NPM sugar score that returns 0", {
  out <- NPM_score_function(test_data_sugar[, "sugar_measurement_g"], test_data_sugar[,"sg_adjusted_weight"], "sugar")
  expect_equal(out, test_data_sugar[, "expected_score"])
})


# testing NPM_score_function for fat
test_that("NPM fat score that returns 0", {
  out <- NPM_score_function(test_data_fat[, "fat_measurement_g"], test_data_fat[,"sg_adjusted_weight"], "fat")
  expect_equal(out, test_data_fat[, "expected_score"])
})

test_that("NPM scoring function for fruit, nuts and veg", {
  out <- NPM_score_function(test_data_fvn[, "fruit_veg_nut"], "fvn")
  expect_equal(out, test_data_fvn[, "expected_score"])
})

