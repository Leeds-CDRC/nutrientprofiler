# define threshold constants
ENERGY_SCORE_THRESHOLDS <- c(3350, 3015, 2680, 2345, 2010, 1675, 1340, 1005, 670, 335)
SUGAR_SCORE_THRESHOLDS <- c(45, 40, 36, 31, 27, 22.5, 18, 13.5, 9, 4.5)
FAT_SCORE_THRESHOLDS <- c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
SODIUM_SCORE_THRESHOLDS <- c(900, 810, 720, 630, 540, 450, 360, 270, 180, 90)

#' a generic NPM scoring dispatcher
#'
#'
NPM_score_function <- function(value, type, ...) {
    stopifnot(
        "The passed type to NPM_score_function does not match expected types " =
            type %in% c("energy", "sugar","fat","salt","fvn")
    )

    score <- switch(tolower(type),
        "energy" = sapply(energy_value_adjuster(value, ...), scoring_function, ENERGY_SCORE_THRESHOLDS),
        "sugar" = sapply(generic_adjuster(value, ...), scoring_function, SUGAR_SCORE_THRESHOLDS),
        "fat" = sapply(generic_adjuster(value, ...), scoring_function, FAT_SCORE_THRESHOLDS),
        "salt" = sapply(salt_adjuster(value, ...), scoring_function, SODIUM_SCORE_THRESHOLDS),
        "fvn" = sapply(value, fruit_veg_nut_scorer),
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
        any(value > 0 & adjusted_weight > 0)
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
#' @param type a character of either "salt" or "sodium" to help determine the required adjustment
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

