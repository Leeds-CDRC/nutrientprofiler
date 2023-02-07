

test_that("baseProduct returns a BaseProduct object from data.frame object", {


  lembas.df <- data.frame(name = "lembas",
                     product_type = "Food",
                     units = "g",
                     energy_units = "KJ",
                     energy_measurement = 266,
                     sugar_measurement = 50,
                     fat_measurement = 3,
                     salt_measurement = 0.6, 
                     salt_units = "sodium",
                     fibre_units = "NSP",
                     fibre_measurement = 3,
                     protein_measurement = 7,
                     fruit_nut_measurement = 0,
                     weight = 100)

  lembas.prod <- baseProduct(lembas.df)

  expect_s4_class(lembas.prod, "BaseProduct")
})


test_that("baseProduct returns a BaseProduct object from arg names", {

  base_prod <- baseProduct(
        name = "Burger bob",
        brand = "Big Burgers",
        # could this be from a discrete set
        product_category = "Fast food",
        product_type = "Food",
        units = "g",
        energy_units = "kcl",
        energy_measurement = 300,
        sugar_measurement = 100,
        fat_measurement = 30,
        salt_measurement = 6,
        salt_units = "g",
        fibre_measurement = 30,
        fibre_units = "g",
        protein_measurement = 40,
        fruit_nut_measurement = 0)

  expect_s4_class(base_prod, "BaseProduct")
})

