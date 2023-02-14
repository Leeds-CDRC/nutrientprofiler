SGtab <- c('Semi-skimmed milk' = 1.03,
                'Carbonated drink/fruit juice' = 1.04,
                'Diet carbonated drink' = 1.00,
                'Energy drink' = 1.07,
                'Cordial/squash ready to drink' = 1.03,
                'Cordial/squash undiluted' = 1.09,
                'Ice cream' = 1.30,
                'Ice lolly' = 0.90,
                'Mayonnaise' = 0.91,
                'Maple syrup' = 1.32,
                'Single cream' = 1.00,
                'Double cream' = 0.94,
                'Whipping cream' = 0.96,
                'Evaporated milk' = 1.07)


SGConverter <- function(row) {
    switch(row['product_type'],
            "Food" = sg_food_converter(row),
            "Drink" = "drink drink", #sg_drink_converter(row),
            stop(paste0("SGConverter: Unable to determine food type from value: ",row['product_type']," from `product_type` column"))
    )

}


sg_food_converter <- function(row) {
    switch(row['units'],
            "g" = "food",
            "ml" = sg_liquidfood_converter(row),
            stop(paste0("sg_food_converter: Unable to determine food type from value: ",row['units']," from `units` column"))
    )

}

sg_liquidfood_converter <- function(row) {
    
    return(SGtab[[ row['food_type'] ]] * as.numeric(row['volume']))
}


# sg_food_converter <- function(row) {

#     switch(row$)

# }