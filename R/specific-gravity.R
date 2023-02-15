SGtab <- c('Semi-skimmed milk' = 1.03,
                'Carbonated/juice drink' = 1.04,
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

    stopifnot( "The passed data to SGConverter does not have the required columns" = "product_type" %in% names(row))

    switch(tolower(row[['product_type']]),
            "food" = sg_food_converter(row),
            "drink" = sg_drink_converter(row),
            stop(paste0("SGConverter: Unable to determine food type from value: ",row['product_type']," from `product_type` column"))
    )
}


sg_food_converter <- function(row) {
    return(ifelse(!is.na(row[['weight_g']]), row[['weight_g']], sg_liquidfood_converter(row)))
}

sg_liquidfood_converter <- function(row) {
    
    # if food type is not an empty string
    if(row[['food_type']] != "")  {
    return(SGtab[[ row[['food_type']] ]] * as.numeric(row[['volume_ml']]))
    } else {
        return(as.numeric(row[['volume_ml']]))
}

}


sg_drink_converter <- function(row) {

    stopifnot( "The passed data to sg_drink_converter does not have the required columns" = "drink_format" %in% names(row))

    switch(tolower(row[['drink_format']]),
            "ready" = sg_ready_drink_converter(row),
            "powdered" = sg_powd_drink_converter(row),
            "cordial" = sg_cord_drink_converter(row),
            stop(paste0("sg_drink_converter: Unable to determine drink type from value: ",row['drink_format']," from `drink_format` column"))
    )
}

sg_ready_drink_converter <- function(row) {

    # if drink type is not an empty string
    if(row[['drink_type']] != "")  {
        return(SGtab[[ row[['drink_type']] ]] * as.numeric(row[['volume_ml']]))
    } else {
        return(as.numeric(row[['volume_ml']]))
    }

}

sg_powd_drink_converter <- function(row) {
    stopifnot( "The passed data to sg_powd_drink_converter does not have the required columns" = "nutrition_info" %in% names(row))

    switch(tolower(row[['nutrition_info']]),
            "as consumed" = as.numeric(row[['volume_ml']]) * SGtab[['Cordial/squash ready to drink']],
            "preparation instructions given" = (as.numeric(row[['volume_water_ml']]) + as.numeric(row[['weight_g']])) * SGtab[['Cordial/squash ready to drink']],
            "preparation instructions not given" = as.numeric(row[['weight_g']]),
            stop(paste0("sg_drink_converter: Unable to determine nutritional information from value: ",row['nutrition_info']," from `nutrition_info` column"))
    )
}

