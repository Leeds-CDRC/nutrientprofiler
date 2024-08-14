test_data <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,satfat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,")

test_data_incomplete <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,fat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,")

test_that("inputDataCheck assesses parameter names correctly", {
    expect_output(inputDataCheck(test_data),"All required column names found. Proceed with analysis.")
})

test_that("inputDataCheck finds missing parameter names", {
    expect_output(inputDataCheck(test_data_incomplete),"The provided dataframe is missing the following required column names:")
})

test_that("parameterRename replaces missing parameter names", {
    expect_output(parameterRename(missing_column_name = 'satfat_measurement_g', associated_data_column = "fat_measurement_g", data_frame = test_data_incomplete),"Replacing fat_measurement_g with satfat_measurement_g")
})

test_that("listMissingParameters lists missing parameter names", {
    expect_output(print(listMissingParameters(test_data_incomplete)), 
    "satfat_measurement_g")
})
