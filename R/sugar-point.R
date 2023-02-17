#' Function for calculating score for sugar content
#'
#' @param row a row in a dataframe containing
#'  "sg_adjusted_measurement" and "sugar_measurement_g" columns
#' @return a value from 1 to 10
NPM_sugar_score <- function(row) {
    # could this `sg_adjusted_weight` column be an argument to be more flexible
    stopifnot(
        "The passed data to NPM_sugar_score does not have the required columns" =
            c("sg_adjusted_weight", "sugar_measurement_g") %in% names(row)
    )

    sugar_adjusted <- (row["sugar_measurement_g"]
                        / row["sg_adjusted_weight"]) * 100

    return(sugar_scorer(sugar_adjusted))
}

#' Function for returning a score for a given adjusted sugar value
#'
#' @param value an numeric value
#' @return a number from 1 to 10
sugar_scorer <- function(value) {
    score <- if (value > 45) {
        10
    } else if (value > 40) {
        9
    } else if (value > 36) {
        8
    } else if (value > 31) {
        7
    } else if (value > 27) {
        6
    } else if (value > 22.5) {
        5
    } else if (value > 18) {
        4
    } else if (value > 13.5) {
        3
    } else if (value > 9) {
        2
    } else if (value > 4.5) {
        1
    } else {
        0
    }
    return(score)
}
