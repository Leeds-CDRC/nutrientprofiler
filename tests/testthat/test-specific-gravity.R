
test_data <- read.csv(text =  "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,fat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fruit_nut_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,
zeno's icecream,,,Food,Ice cream,,,,,24,21,11,0.08,,,0.7,3.5,0,,100,
mystic rush,,,Drink,,Ready,Carbonated/juice drink,,,194,11,0,,100,,0,0,0,,100,
delta ringer drink,,,Drink,,Powdered,,Preparation instructions given,188,,15,0,,100,,0,0.5,3,25,,100
welter water,,,Drink,,Cordial,,As consumed,,205,19,0,0.1,,,0,0.1,6,,100,
janus's drink,,,Food,,,,,,24,21,11,0.08,,,0.7,3.5,0,,100,
beta ringer drink,,,Drink,,Powdered,,As consumed,188,,15,0,,100,,0,0.5,3,,50,
zeta ringer drink,,,Drink,,Powdered,,Preparation instructions not given,188,,15,0,,100,,0,0.5,3,25,,
heavyweight water,,,Drink,,Cordial,,Preparation instructions given,,205,19,0,0.1,,,0,0.1,6,,20,100
bantam water,,,Drink,,Cordial,,Preparation instructions not given,,205,19,0,0.1,,,0,0.1,6,,100,")


test_that("SG conversion for solid food", {
  out <- SGConverter(test_data[1, ])
  expect_equal(out, 100)
})

test_that("SG conversion for liquid food", {
  out <- SGConverter(test_data[2, ])
  expect_equal(out, 130)
})

test_that("SG conversion for liquid food with no category", {
  out <- SGConverter(test_data[6, ])
  expect_equal(out, 100)
})

test_that("SG conversion for ready drink", {
  out <- SGConverter(test_data[3, ])
  expect_equal(out, 104)
})

test_that("SG conversion for powdered drink with instructions", {
  out <- SGConverter(test_data[4, ])
  expect_equal(out, 128.75)
})

test_that("SG conversion for powdered drink without instructions", {
  out <- SGConverter(test_data[8, ])
  expect_equal(out, 25)
})

test_that("SG conversion for powdered drink as consumed", {
  out <- SGConverter(test_data[7, ])
  expect_equal(out, 51.5)
})

test_that("SG conversion for cordial drink as consumed", {
  out <- SGConverter(test_data[5, ])
  expect_equal(out, 103)
})

test_that("SG conversion for cordial drink with instructions", {
  out <- SGConverter(test_data[9, ])
  expect_equal(out, 123.6)
})

test_that("SG conversion for cordial drink without instructions", {
  out <- SGConverter(test_data[10, ])
  expect_equal(out, 109)
})


test_that("Check for error is invalid product type", {
  expect_error(SGConverter(data.frame(product_type = c("Juice"))))
})

test_that("Check for error if invalid data passed", {
  expect_error(SGConverter("Not correct"))
})