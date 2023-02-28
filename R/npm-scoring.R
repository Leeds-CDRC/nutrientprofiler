# define threshold constants
A_SCORE_THRESHOLDS <- c(3350, 3015, 2680, 2345, 2010, 1675, 1340, 1005, 670, 335)
SUGAR_SCORE_THRESHOLDS <- c(45, 40, 36, 31, 27, 22.5, 18, 13.5, 9, 4.5)
FAT_SCORE_THRESHOLDS <- c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)


#' a generic NPM scoring dispatcher
#'
#'
NPM_score_function <- function(row, type) {
    stopifnot(
        "The passed type to NPM_score_function does not match expected types " =
            type %in% c("a", "sugar","fat")
    )

    score <- switch(tolower(type),
        "a" = scoring_function(a_value_adjuster(row), A_SCORE_THRESHOLDS),
        "sugar" = scoring_function(sugar_adjuster(row), SUGAR_SCORE_THRESHOLDS),
        "fat" = scoring_function(fat_adjuster(row), FAT_SCORE_THRESHOLDS),
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

#' Function for calculating score for sugar content
#'
#' @param row a row in a dataframe containing
#'  "sg_adjusted_measurement" and "sugar_measurement_g" columns
#' @return a value from 1 to 10
sugar_adjuster <- function(row) {
    # could this `sg_adjusted_weight` column be an argument to be more flexible
    stopifnot(
        "The passed data to NPM_sugar_score does not have the required columns" =
            c("sg_adjusted_weight", "sugar_measurement_g") %in% names(row)
    )

    sugar_adjusted <- (row["sugar_measurement_g"]
    / row["sg_adjusted_weight"]) * 100

    return(sugar_adjusted)
}

#' Function for calculating score for fat content
#'
#' @param row a row in a dataframe containing
#'  "sg_adjusted_measurement" and "fat_measurement_g" columns
#' @return a value from 1 to 10
fat_adjuster <- function(row) {
    # could this `sg_adjusted_weight` column be an argument to be more flexible
    stopifnot(
        "The passed data to NPM_sugar_score does not have the required columns" =
            c("sg_adjusted_weight", "fat_measurement_g") %in% names(row)
    )

    fat_adjusted <- (row["fat_measurement_g"]
    / row["sg_adjusted_weight"]) * 100

    return(fat_adjusted)
}