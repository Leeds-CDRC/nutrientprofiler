test_data <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,satfat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,")

test_data_incomplete <- read.csv(text = "
name,brand,product_category,product_type,food_type,drink_format,drink_type,nutrition_info,energy_measurement_kj,energy_measurement_kcal,sugar_measurement_g,fat_measurement_g,salt_measurement_g,sodium_measurement_mg,fibre_measurement_nsp,fibre_measurement_aoac,protein_measurement_g,fvn_measurement_percent,weight_g,volume_ml,volume_water_ml
lembas,,,Food,,,,,266,,50,3,,0.6,3,,7,0,100,,")

test_that("inputDataCheck assesses parameter names correctly", {
    expect_output(inputDataCheck(test_data),"All required column names found. Proceed with analysis.")
})


