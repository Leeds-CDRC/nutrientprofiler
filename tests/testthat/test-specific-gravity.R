
test_data <- read.csv(text =  "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,fat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fruit_nut_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,
zeno's icecream,,,Food,Ice cream,,,,,24,21,11,0.08,,,0.7,3.5,0,,100,
mystic rush,,,Drink,,Ready,Carbonated/juice drink,,,194,11,0,,100,,0,0,0,,100,
delta ringer drink,,,Drink,,Powdered,,As consumed,188,,15,0,,100,,0,0.5,3,25,,100
welter water,,,Drink,,Cordial,,Preparation instructions given,,205,19,0,0.1,,,0,0.1,6,,100,")


test_that("SG conversion for liquid food", {
  out <- SGConverter(test_data[2, ])
  expect_equal(out, 130)
})

test_that("SG conversion for ready drink", {
  out <- SGConverter(test_data[3, ])
  expect_equal(out, 130)
})

test_that("SG conversion for powdered drink", {
  out <- SGConverter(test_data[4, ])
  expect_equal(out, 130)
})

test_that("SG conversion for cordial drink", {
  out <- SGConverter(test_data[5, ])
  expect_equal(out, 130)
})


test_that("Check for error is invalid product type", {
  expect_error(SGConverter(data.frame(product_type = c("Juice"))))
})

test_that("Check for error if invalid data passed", {
  expect_error(SGConverter("Not correct"))
})