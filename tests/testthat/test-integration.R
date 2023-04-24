test_data <- read.csv(text = "
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


test_that("test full workflow", {
    test_data["sg_adjusted"] <- unlist(
        lapply(
            seq_len(nrow(test_data)),
            function(i) SGConverter(test_data[i, ])
        )
    )

    # grateful for help with this function from https://stackoverflow.com/questions/75825126/conditionally-running-a-function-on-a-row-based-on-values-in-another-column-usin/75825163#75825163

    npm_scores <- do.call(
        "rbind",
        lapply(
            seq_len(nrow(test_data)),
            function(i) NPMScore(test_data[i, ], sg_adjusted_label = "sg_adjusted")
        )
    )

    # append NPM Score columns
    test_data <- cbind(test_data, npm_scores)

    # do an NPM Assessment
    npm_assess <- do.call(
        "rbind",
        lapply(
            seq_len(nrow(test_data)),
            function(i) NPMAssess(test_data[i, ])
        )
    )

    test_data <- cbind(test_data, npm_assess)

    expect_true(is.data.frame(test_data))
})
