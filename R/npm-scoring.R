NPM_a_score <- function(row) {
    stopifnot(
        "The passed data to NPM_a_score does not have the required columns" =
            c("energy_measurement_kj", "energy_measurement_kcal") %in% names(row)
    )

    a_value <- if (!is.na(row[["energy_measurement_kj"]])) {
        (row["energy_measurement_kj"] / row["sg_adjusted_weight"]) * 100
    } else {
        ((row["energy_measurement_kcal"] / row["sg_adjusted_weight"]) * 100) * 4.184
    }

    return(a_scorer(a_value))
}

a_scorer <- function(value) {
    score <- if (value > 3350) {
        10
    } else if (value > 3015) {
        9
    } else if (value > 2680) {
        8
    } else if (value > 2345) {
        7
    } else if (value > 2010) {
        6
    } else if (value > 1675) {
        5
    } else if (value > 1340) {
        4
    } else if (value > 1005) {
        3
    } else if (value > 670) {
        2
    } else if (value > 335) {
        1
    } else {
        0
    }
    return(score)
}
