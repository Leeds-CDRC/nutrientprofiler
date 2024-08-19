test_data <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,satfat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,")

test_data_incomplete <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,fat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,,,,,,266,,,3,,0.6,3,,7,0,100,,")

# ReqParamCheck(test_data)
test_that("ReqParamCheck assesses parameter values correctly", {
    expect_output(ReqParamCheck(test_data),"Please note that the following parameters are optional and are not checked here:")
    rep_data <- ReqParamCheck(test_data)
    expect_output(print(class(rep_data)),
    "data.frame")
    expect_output(print(rep_data$volume_water_ml),
    "1")
    expect_output(print(rep_data$product_type),
    "[[1]]\ninteger(0)\n")
})

# ReqParamCheck(test_data_incomplete)
test_that("ReqParamCheck assesses missing parameter values correctly", {
    expect_output(ReqParamCheck(test_data_incomplete),"Please note that the following parameters are optional and are not checked here:")
    rep_data <- ReqParamCheck(test_data_incomplete)
    expect_output(print(class(rep_data)),
    "data.frame")
    expect_output(print(rep_data$product_type),
    "1")
})


