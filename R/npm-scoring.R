# define threshold constants
A_SCORE_THRESHOLDS <- c(3350, 3015, 2680, 2345, 2010, 1675, 1340, 1005, 670, 335)
SUGAR_SCORE_THRESHOLDS <- c(45, 40, 36, 31, 27, 22.5, 18, 13.5, 9, 4.5)
FAT_SCORE_THRESHOLDS <- c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
SODIUM_SCORE_THRESHOLDS <- c(900, 810, 720, 630, 540, 450, 360, 270, 180, 90)

#' a generic NPM scoring dispatcher
#'
#'
NPM_score_function <- function(row, type) {
    stopifnot(
        "The passed type to NPM_score_function does not match expected types " =
            type %in% c("a", "sugar","fat","salt")
    )

    score <- switch(tolower(type),
        "a" = scoring_function(a_value_adjuster(row), A_SCORE_THRESHOLDS),
        "sugar" = scoring_function(sugar_adjuster(row), SUGAR_SCORE_THRESHOLDS),
        "fat" = scoring_function(fat_adjuster(row), FAT_SCORE_THRESHOLDS),
        "salt" = scoring_function(salt_adjuster(row), SODIUM_SCORE_THRESHOLDS),
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

a_value_adjuster <- function(row) {
    stopifnot(
        "The passed data to NPM_a_score does not have the required columns" =
            c("energy_measurement_kj", "energy_measurement_kcal") %in% names(row)
    )

    a_value <- if (!is.na(row[["energy_measurement_kj"]])) {
        (row["energy_measurement_kj"] / row["sg_adjusted_weight"]) * 100
    } else {
        ((row["energy_measurement_kcal"] / row["sg_adjusted_weight"]) * 100) * 4.184
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
salt_adjuster <- function(value, adjusted_weight, type = "sodium") {
    stopifnot(
        "Invalid type passed to salt_adjuster, can only be 'salt' or 'sodium'" =
            any(c("sodium", "salt") %in% tolower(type))
    )

    stopifnot(
        "Cannot divide by zero, please change 'adjusted_weight'" = 
        adjusted_weight != 0
    )

    salt_adjusted <- if (type == "sodium") {
        (value / adjusted_weight) * 100
    } else {
        (( value * 1000) / adjusted_weight) 
    }

    return(salt_adjusted)
}