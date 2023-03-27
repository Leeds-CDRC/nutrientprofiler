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

test_data_protein <- data.frame(
  "sg_adjusted_weight" = c(120, 100, 180, 200),
  "protein_measurement_g" = c(1.5, 30, 9, 14.2),
  "expected_score" = c(0, 5, 3, 4)
)

test_data_fibre <- data.frame(
  "sg_adjusted_weight" = c(120, 100, 180, 200),
  "nsp_fibre_measurement_g" = c(1.5, NA, 4.2, NA),
  "aoac_fibre_measurement_g" = c(NA, 4, NA, 1),
  "expected_score" = c(1, 4, 3, 0)
)

# testing NPM A score
test_that("A NPM score for KJ data", {

    test_data_energy_kj <- test_data_energy[!is.na(test_data_energy$energy_measurement_kj),]

  out <- NPM_score_function(test_data_energy_kj[,"energy_measurement_kj"], adjusted_weight=test_data_energy_kj[,"sg_adjusted_weight"], "energy", adjuster_type = "kj")
  expect_equal(out, test_data_energy_kj[, "expected_score"])
})

test_that("A NPM score for kcal data", {

  test_data_energy_kcal <- test_data_energy[!is.na(test_data_energy$energy_measurement_kcal),]

  out <- NPM_score_function(test_data_energy_kcal[,"energy_measurement_kcal"], adjusted_weight=test_data_energy_kcal[,"sg_adjusted_weight"], "energy", adjuster_type = "kcal")
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
  out <- NPM_score_function(test_data_sugar[, "sugar_measurement_g"], adjusted_weight=test_data_sugar[,"sg_adjusted_weight"], "sugar")
  expect_equal(out, test_data_sugar[, "expected_score"])
})


# testing NPM_score_function for fat
test_that("NPM fat score that returns 0", {
  out <- NPM_score_function(test_data_fat[, "fat_measurement_g"],  "fat", adjusted_weight=test_data_fat[,"sg_adjusted_weight"])
  expect_equal(out, test_data_fat[, "expected_score"])
})

test_that("NPM scoring function for fruit, nuts and veg", {
  out <- NPM_score_function(test_data_fvn[, "fruit_veg_nut"], "fvn")
  expect_equal(out, test_data_fvn[, "expected_score"])
})

test_that("NPM scoring function for protein", {
  out <- NPM_score_function(test_data_protein[, "protein_measurement_g"], adjusted_weight=test_data_protein[,"sg_adjusted_weight"], "protein")
  expect_equal(out, test_data_protein[, "expected_score"])
})

# testing fibre scoring
test_that("A NPM score for nsp fibre data", {

    test_data_nsp <- test_data_fibre[!is.na(test_data_fibre$nsp_fibre_measurement_g),]

  out <- NPM_score_function(test_data_nsp[,"nsp_fibre_measurement_g"], adjusted_weight=test_data_nsp[,"sg_adjusted_weight"], "nsp")
  expect_equal(out, test_data_nsp[, "expected_score"])
})

test_that("A NPM score for aoac fibre data", {

    test_data_aoac <- test_data_fibre[!is.na(test_data_fibre$aoac_fibre_measurement_g),]

  out <- NPM_score_function(test_data_aoac[,"aoac_fibre_measurement_g"], adjusted_weight=test_data_aoac[,"sg_adjusted_weight"], "aoac")
  expect_equal(out, test_data_aoac[, "expected_score"])
})

## testing NPMScore wrapper function

test_that("NPMScore returns a data frame with correct column names", {
  row <- list(
    energy_measurement_kj = 10,
    sugar_measurement_g = 20,
    salt_measurement_g = 30,
    protein_measurement_g = 40,
    fibre_measurement_nsp = 50,
    fat_measurement_g = 60,
    fruit_nut_measurement_percent = 70,
    adjusted_weight = 104,
    name = "test product"
  )
  
  # call the function
  result <- NPMScore(row, "adjusted_weight")
  
  # check if the result is a matrix
  expect_true(is.data.frame(result))
  
  # check if the column names are correct
  expect_equal(colnames(result), c("energy_score", "sugar_score", "fat_score", "protein_score", "fvn_score", "fibre_score"))
})

test_that("NPMScore returns NA for invalid measurements", {
  # create a sample row with invalid measurements
  row <- list(
    energy_measurement_kj = NA,
    energy_measurement_kcal = NA,
    sugar_measurement_g = NA,
    salt_measurement_g = NA,
    sodium_measurement_mg = NA,
    protein_measurement_g = NA,
    fibre_measurement_nsp = NA,
    fibre_measurement_aoac = NA,
    fat_measurement_g = NA,
    fruit_nut_measurement_percent = NA,
    adjusted_weight = 104,
    name = "test NA product"
  )

  # expect warnings
  warns <- capture_warnings(NPMScore(row, "adjusted_weight"))

  expect_match(warns, "Unable to calculate 'energy' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'sugar' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'salt' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'protein' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'fibre' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'fat' score for product test NA product defaulting to NA", all = FALSE)
  expect_match(warns, "Unable to calculate 'fruit/veg/nut' score for product test NA product defaulting to NA", all = FALSE)    

  # call the function
  result <- suppressWarnings(NPMScore(row, "adjusted_weight"))
  
  # check if the result contains only NA values
  expect_equal(nrow(result), 1)
  expect_true(all(is.na(result)))
})