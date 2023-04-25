#' specific gravity conversion named vector
SGtab <- c(
    "Semi-skimmed milk" = 1.03,
    "Carbonated/juice drink" = 1.04,
    "Diet carbonated drink" = 1.00,
    "Energy drink" = 1.07,
    "Cordial/squash ready to drink" = 1.03,
    "Cordial/squash undiluted" = 1.09,
    "Ice cream" = 1.30,
    "Ice lolly" = 0.90,
    "Mayonnaise" = 0.91,
    "Maple syrup" = 1.32,
    "Single cream" = 1.00,
    "Double cream" = 0.94,
    "Whipping cream" = 0.96,
    "Evaporated milk" = 1.07
)

#' Specific Gravity converter function
#'
#' This function is the key entry point for performing specific gravity conversions
#' It works by processing data from a dataframe row and dispatching based on
#' column values to a series of additional sub functions
#' These return back an SG-adjusted number
#'
#' @param row a row from a data.frame object
#' @return A number.
#' @export
SGConverter <- function(row) {
    stopifnot(
        "The passed data to SGConverter does not have the required columns" =
            "product_type" %in% names(row)
    )

    switch(tolower(row[["product_type"]]),
        "food" = sg_food_converter(row),
        "drink" = sg_drink_converter(row),
        stop(paste0(
            "SGConverter: Unable to determine food type from value: ",
            row["product_type"], " from `product_type` column"
        ))
    )
}

#' Specific gravity food dispatcher
#'
#' This function is run for data with the `product_type` "food"
#' It checks if the column `weight_g` contains NA values to assume whether the food is
#' liquid or solid and if solid returns the weight unadjusted or if liquid dispatches
#' to an additional function
#' @param row a row from a data.frame object
#' @returns either the value of `weight_g` column for row or dispatches row to
#' `sg_liquidfood_converter`
#' @export
sg_food_converter <- function(row) {
    return(
        ifelse(!is.na(row[["weight_g"]]),
            as.numeric(row[["weight_g"]]),
            sg_liquidfood_converter(row)
        )
    )
}

#' Specific gravity liquid converter
#'
#' This function is run for data that is identified by `sg_food_converter` as liquid food
#' It checks for a value in the `food_type` column and if present retrieves a
#' specific gravity multiplier which is multiplies against the `volume_ml` column
#' value. If `food_type` is empty is returns an unadjusted `volume_ml` value
#' @param row a row from a data.frame object
#' @returns a numeric value of the specific gravity adjusted `volume_ml`
#' column in `row`
#' @export
sg_liquidfood_converter <- function(row) {
    # if food type is not an empty string
    if (row[["food_type"]] != "") {
        return(SGtab[[row[["food_type"]]]] * as.numeric(row[["volume_ml"]]))
    } else {
        return(as.numeric(row[["volume_ml"]]))
    }
}

#' Specific gravity drink dispatcher
#'
#' This function is run for data with the `product_type` "drink"
#' It dispatches to additional functions based on the matched value in the
#' `drink_format` column
#' @param row a row from a data.frame object
#' @returns dispatches row to another converter function based on value in
#' `drink_format` column of row
#' @export
sg_drink_converter <- function(row) {
    stopifnot(
        "The passed data to sg_drink_converter does not have the required columns" =
            "drink_format" %in% names(row)
    )

    switch(tolower(row[["drink_format"]]),
        "ready" = sg_ready_drink_converter(row),
        "powdered" = sg_powd_drink_converter(row),
        "cordial" = sg_cord_drink_converter(row),
        stop(paste0(
            "sg_drink_converter: Unable to determine drink type from value: ",
            row["drink_format"], " from `drink_format` column"
        ))
    )
}

#' Specific gravity drink converter for ready to consume drinks
#'
#' This function performs a specific gravity conversion for ready to consume
#' drinks based on the specific gravity value for the value in the `drink_type`
#' column. If this column is empty it returns the `volume_ml` unadjusted.
#' @param row a row from a data.frame object
#' @returns a numeric value of the specific gravity adjusted `volume_ml`
#' column of row based on `drink_type column`
#' @export
sg_ready_drink_converter <- function(row) {
    # if drink type is not an empty string
    if (row[["drink_type"]] != "") {
        return(
            generic_specific_gravity(
                row[["volume_ml"]],
                SGtab[[row[["drink_type"]]]]
            )
        )
    } else {
        return(as.numeric(row[["volume_ml"]]))
    }
}

#' Specific gravity drink converter for powdered drinks
#'
#' This function performs a specific gravity conversion for powdered drinks
#' the conversion performed is based on the value in the `nutrition_info`
#' column.
#'
#' @param row a row from a data.frame object
#' @returns a numeric value of the specific gravity adjusted volume/mass
#' depending on `nutrition_info` column.
#' @export
sg_powd_drink_converter <- function(row) {
    stopifnot(
        "The passed data to sg_powd_drink_converter does not have the required columns" =
            "nutrition_info" %in% names(row)
    )

    switch(tolower(row[["nutrition_info"]]),
        "as consumed" = generic_specific_gravity(
            row[["volume_ml"]],
            SGtab[["Cordial/squash ready to drink"]]
        ),
        "preparation instructions given" =
            generic_specific_gravity(
                (as.numeric(row[["volume_water_ml"]]) + as.numeric(row[["weight_g"]])),
                SGtab[["Cordial/squash ready to drink"]]
            ),
        "preparation instructions not given" = as.numeric(row[["weight_g"]]),
        stop(paste0(
            "sg_drink_converter: Unable to determine nutritional information from value: ",
            row["nutrition_info"], " from `nutrition_info` column"
        ))
    )
}

#' Specific gravity drink converter for cordial drinks
#'
#' This function performs a specific gravity conversion for cordial drinks
#' the conversion performed is based on the value in the `nutrition_info`
#' column.
#'
#' @param row a row from a data.frame object
#' @returns a numeric value of the specific gravity adjusted volume
#' depending on `nutrition_info` column.
#' @export
sg_cord_drink_converter <- function(row) {
    stopifnot(
        "The passed data to sg_cord_drink_converter does not have the required columns" =
            "nutrition_info" %in% names(row)
    )

    switch(tolower(row[["nutrition_info"]]),
        "as consumed" = generic_specific_gravity(
            row[["volume_ml"]],
            SGtab[["Cordial/squash ready to drink"]]
        ),
        "preparation instructions given" = generic_specific_gravity(
            (as.numeric(row[["volume_water_ml"]]) + as.numeric(row[["volume_ml"]])),
            SGtab[["Cordial/squash ready to drink"]]
        ),
        "preparation instructions not given" = generic_specific_gravity(
            as.numeric(row[["volume_ml"]]),
            SGtab[["Cordial/squash undiluted"]]
        ),
        stop(paste0(
            "sg_drink_converter: Unable to determine nutritional information from value: ",
            row["nutrition_info"],
            " from `nutrition_info` column"
        ))
    )
}

#' Generic specific gravity converter
#'
#' This function specifies the generic specific gravity conversion
#'
#' @param volume, a value representing the volume to adjust by
#' a specific gravity
#' @param specific_gravity, a multiplier representing the specific
#' gravity of the product
#' @returns a value adjusted by the specific_gravity
#' @export
generic_specific_gravity <- function(volume, specific_gravity) {
    return(
        volume * specific_gravity
    )
}
