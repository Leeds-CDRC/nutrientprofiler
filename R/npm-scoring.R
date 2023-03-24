# define threshold constants
ENERGY_SCORE_THRESHOLDS <- c(3350, 3015, 2680, 2345, 2010, 1675, 1340, 1005, 670, 335)
SUGAR_SCORE_THRESHOLDS <- c(45, 40, 36, 31, 27, 22.5, 18, 13.5, 9, 4.5)
FAT_SCORE_THRESHOLDS <- c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
SODIUM_SCORE_THRESHOLDS <- c(900, 810, 720, 630, 540, 450, 360, 270, 180, 90)
PROTEIN_SCORE_THRESHOLDS <- c(8, 6.4, 4.8, 3.2, 1.6)
NSP_FIBRE_SCORE_THRESHOLDS <- c(3.5, 2.8, 2.1, 1.4, 0.7)
AOAC_FIBRE_SCORE_THRESHOLDS <- c(4.7, 3.7, 2.8, 1.9, 0.9)

#' NPM scoring dispatcher
#' 
#' This function is written for calculating NPM scores across an entire row
#' in a dataframe. It is wrapper logic for the underlying NPM_score_function 
#' when applied to an NPMCalculator input data frame as such it is highly inflexible without 
#' expected column names. It expects the specific gravity conversions to already have been performed
#' and values outputted to a new single column.
#' 
#' @param row the row from an NPMCalculator dataframe
#' @param sg_adjusted_label a character value specifying the name of the specific gravity adjusted column
#' @return a matrix of NPM scores
NPMScore <- function(row, sg_adjusted_label) {

    energy_score <- if(!is.na(row[['energy_measurement_kj']])) {
                        
                        NPM_score_function(row[['energy_measurement_kj']], "energy", 
                        adjusted_weight=row[[sg_adjusted_label]], adjuster_type="kj")

                    } else if (!is.na(row[['energy_measurement_kcal']])) {
                        NPM_score_function(row[['energy_measurement_kcal']], "energy", 
                        adjusted_weight=row[[sg_adjusted_label]], adjuster_type="kcal")

                    } else {
                        warning(paste0("Unable to calculate 'energy' score for product ", row[['name']], " defaulting to NA"))
                        NA
                    }

    sugar_score <- if(!is.na(row[['sugar_measurement_g']])) {
                    
                    NPM_score_function(row[['sugar_measurement_g']], "sugar", 
                    adjusted_weight=row[[sg_adjusted_label]])

                 } else {
                    warning(paste0("Unable to calculate 'sugar' score for product ", row[['name']], " defaulting to NA"))
                    NA
                }

    salt_score <- if(!is.na(row[['salt_measurement_g']])) {
                
                    NPM_score_function(row[['salt_measurement_g']], "salt", 
                    adjusted_weight=row[[sg_adjusted_label]], adjuster_type="salt")
                
                } else if (!is.na(row[['sodium_measurement_mg']])) {
                        NPM_score_function(row[['sodium_measurement_mg']], "salt", 
                        adjusted_weight=row[[sg_adjusted_label]], adjuster_type="sodium")

                } else {
                warning(paste0("Unable to calculate 'salt' score for product ", row[['name']], " defaulting to NA"))
                NA
            }

    protein_score <- if(!is.na(row[['protein_measurement_g']])) {
                
                NPM_score_function(row[['protein_measurement_g']], "protein", 
                adjusted_weight=row[[sg_adjusted_label]])

                } else {
                warning(paste0("Unable to calculate 'protein' score for product ", row[['name']], " defaulting to NA"))
                NA
            }

    fibre_score <- if(!is.na(row[['fibre_measurement_nsp']])) {
                
                NPM_score_function(row[['fibre_measurement_nsp']], "nsp", 
                adjusted_weight=row[[sg_adjusted_label]])

                } else if (!is.na(row[['fibre_measurement_aoac']])) {
                        NPM_score_function(row[['fibre_measurement_aoac']], "aoac", 
                        adjusted_weight=row[[sg_adjusted_label]])

                } else {
                warning(paste0("Unable to calculate 'fibre' score for product ", row[['name']], " defaulting to NA"))
                NA
            }

    fat_score <- if(!is.na(row[['fat_measurement_g']])) {
                
                NPM_score_function(row[['fat_measurement_g']], "fat", 
                adjusted_weight=row[[sg_adjusted_label]])

                } else {
                warning(paste0("Unable to calculate 'fat' score for product ", row[['name']], " defaulting to NA"))
                NA
            }

    fvn_score <- if(!is.na(row[['fruit_nut_measurement_percent']])) {
                
                NPM_score_function(row[['fruit_nut_measurement_percent']], "fvn")

                } else {
                warning(paste0("Unable to calculate 'sugar' score for product ", row[['name']], " defaulting to NA"))
                NA
            }

    score_df <- cbind(energy_score, sugar_score, fat_score, protein_score, fvn_score, fibre_score)

    return(score_df)

}

#' The NPM scoring dispatch function
#'
#' This function serves as the main entry point for getting 
#' nutrient profiling model scores. It takes a value (or vector of values) and a type
#' using the type it determines which scoring function to use based on constant thresholds.
#' Adjustments to the value passed are also performed for all types except `fvn`.
#' These adjustments take into account the adjusted_weight of the product (specific gravity transformations)
#' and calculate a new value which is applied to the scoring thresholds.
#' `...` is provided to allow the passing of additional arguments for adjuster functions.
#' This code is based off the logic within https://github.com/Leeds-CDRC/NPM-Calculator/blob/main/server.R
#' 
#' @param value, a numeric value or vector of values to score against
#' @param type, a character string that specifies the type of the value passed to control scoring logic
#' @param ..., option named arguments to pass to adjuster functions, most commonly `adjusted_weight`
#' @returns a numeric score value or vector of scores 

NPM_score_function <- function(value, type, ...) {
    stopifnot(
        "The passed type to NPM_score_function does not match expected types " =
            type %in% c("energy", "sugar","fat","salt","fvn","protein","nsp","aoac")
    )

    score <- switch(tolower(type),
        "energy" = sapply(energy_value_adjuster(value, ...), scoring_function, ENERGY_SCORE_THRESHOLDS),
        "sugar" = sapply(generic_adjuster(value, ...), scoring_function, SUGAR_SCORE_THRESHOLDS),
        "fat" = sapply(generic_adjuster(value, ...), scoring_function, FAT_SCORE_THRESHOLDS),
        "salt" = sapply(salt_adjuster(value, ...), scoring_function, SODIUM_SCORE_THRESHOLDS),
        "fvn" = sapply(value, fruit_veg_nut_scorer),
        "protein" = sapply(generic_adjuster(value, ...), scoring_function, PROTEIN_SCORE_THRESHOLDS),
        "nsp" = sapply(generic_adjuster(value, ...), scoring_function, NSP_FIBRE_SCORE_THRESHOLDS),
        "aoac" = sapply(generic_adjuster(value, ...), scoring_function, AOAC_FIBRE_SCORE_THRESHOLDS),
        stop(paste0(
            "NPM_score_function can't determine thresholds type from ",
            type, " that has been passed"
        ))
    )

    return(score)
}

#' a template scoring function
#'
#' This function takes a value and a vector of thresholds
#' It iterates over the reversed vector of indexes in the thresholds vector
#' And checks if the value is less than the threshold value at the itered index 
#' (comparing from smallest to largest).
#' The threshold score is calculated as the length of the thresholds minus every else branch iter
#' of the loop.
#' 
#' @param value a passed numeric value
#' @param thresholds a vector of thresholds to use to score against in order of highest to lowest
scoring_function <- function(value, thresholds) {
    stopifnot("thresholds has no length" = length(thresholds) > 1)
    # TODO: linter warning to use seq_along
    score <- length(thresholds)
    for (x in 1:length(thresholds)) {
        if (value > thresholds[x]) {
            break
        } else {
            score <- score - 1
            next
        }
    }
    return(score)
}

#' Fruit, Vegetable and nut scorer
#'
#' The scoring logic for the percentage of fruit, vegetables and nuts
#' in a product is different to other scorers. Therefore, we can't use
#' the generic scoring function and have to write a specific one here.
#' 
#' @param value a numeric value of the percentage of fruit, nuts and vegetables
#' @return a numeric score value
fruit_veg_nut_scorer <- function(value) {
    score <- if(value > 80) {
        5
    } else if (value > 60) {
       2 
    } else if (value > 40) {
       1
    } else {
        0
    }
    return(score)
}


#' Function for adjusting energy information for A score calculation
#'
#' Adjustment is required for calculating scores based on nutritional measurements.
#'
#' @param value a numeric value corresponding to a energy measurement in a food/drink
#' @param adjusted_weight a numeric value corresponding to the total 
#' weight of the food/drink after specific gravity adjustment
#' @param adjuster_type a character value of either `kj` or `kcal` to determine 
#' which adjustment to perform
#' @return a numeric value of adjusted nutritional data
energy_value_adjuster <- function(value, adjusted_weight, adjuster_type = "kj") {
    stopifnot(
        "Invalid type passed to energy_value_adjuster, can only be 'kj' or 'kcal'" =
            any(c("kj", "kcal") %in% tolower(adjuster_type))
    )

    # set default adjuster_type as kcal
    a_value <- if (adjuster_type == "kj") {
        generic_adjuster(value, adjusted_weight)
    } else {
        generic_adjuster((value), adjusted_weight)  * 4.184
    }

    return(a_value)
}

#' Function for generically adjusting nutritional measurement by total weight
#'
#' Adjustment is required for calculating scores based on nutritional measurements.
#'
#' @param value a numeric value corresponding to a nutritional measurement in a food/drink
#' @param adjusted_weight a numeric value corresponding to the total 
#' weight of the food/drink after specific gravity adjustment
#' @return a numeric value of adjusted nutritional data
generic_adjuster <- function(value, adjusted_weight) {

    stopifnot(
        "Cannot divide by zero, please change 'adjusted_weight'" = 
        adjusted_weight != 0
    )

    stopifnot(
        "Cannot submit a negative value for either 'value' or 'adjusted_weight in generic_adjuster" = 
        any(value >= 0 & adjusted_weight > 0)
    )

    measurement_adj <- (value / adjusted_weight) * 100

    return(measurement_adj)
}

#' Function for adjusting the salt input value
#' 
#' Adjustments is required for calculating scores and depends on the type of salt measurement provided.
#'
#' @param value a numeric value corresponding to a salt measurement in a food/drink
#' @param adjusted_weight a numeric value corresponding to the total 
#' weight of the food/drink after specific gravity adjustment
#' @param adjuster_type a character of either "salt" or "sodium" to help determine the required adjustment
#' @return a numeric value with appropriate adjustment made
salt_adjuster <- function(value, adjusted_weight, adjuster_type = "sodium") {
    stopifnot(
        "Invalid type passed to salt_adjuster, can only be 'salt' or 'sodium'" =
            any(c("sodium", "salt") %in% tolower(adjuster_type))
    )

    salt_adjusted <- if (adjuster_type == "sodium") {
        generic_adjuster(value, adjusted_weight)
    } else {
        # x10 here because salt adjustment should multiply value by 1000 not 100
        generic_adjuster((value * 10), adjusted_weight)  
    }

    return(salt_adjusted)
}

