#' Data check function
#'
#' This function checks that all required parameter names or
#' spreadsheet "column" names are present, and provides
#' a code snippet to change any parameter names required.
#'
#' @param data_frame a data.frame object, loaded from a csv or Excel
#' @return Prints code snippets to help you rename variables if needed
#' @seealso [parameterRename()]
#' @export
inputDataCheck <- function(data_frame){
    expected_column_names <- c("name", "brand", "product_category",
    "product_type", "food_type", "drink_format","drink_type",
    "nutrition_info", "energy_measurement_kj", "energy_measurement_kcal",
    "sugar_measurement_g", "satfat_measurement_g", "salt_measurement_g",
    "sodium_measurement_mg", "fibre_measurement_nsp", "fibre_measurement_aoac",
    "protein_measurement_g", "fvn_measurement_percent", "weight_g",
    "volume_ml", "volume_water_ml")
    data_names <- names(data_frame)
    missing_column_names <- setdiff(expected_column_names, data_names)
    extra_data_names <- setdiff(data_names, expected_column_names)
    df_title <- deparse(substitute(data_frame))
    warning1 <- "The provided dataframe is missing the following required column names:"
    warning2 <- "The provided dataframe contains these unmatched columns names:"
    warning3 <- "Please use the parameter rename function as indicated:"
    warning4 <- " <- parameterRename(missing_column_name = '"
    warning5 <- "', associated_data_column = '<INSERT DATA COLUMN NAME HERE>', data_frame = "
    warning6 <- ")"
    warning7 <- "Please check the package documentation for clarification on these parameters."
    if (length(missing_column_names) >=1) {
        print(warning1)
        print(missing_column_names)
        print(warning2)
        print(extra_data_names)
        print(paste(df_title, warning4, missing_column_names, warning5, df_title, warning6, sep=""))
    } else {
        print("All required column names found. Proceed with analysis.")
    }
}

#' Parameter rename function
#'
#' This function renames specified parameters/columns in your dataframe
#' to match the expected parameters required by nutrientprofiler.
#'
#' @param missing_column_name a chr object with the missing nutrientprofiler parameter
#' @param associated_data_column a chr object with the associated column header from the loaded data
#' @param data_frame a data.frame object, loaded from a csv or Excel
#' @return data_frame a data.frame object with updated column names
#' @seealso [inputDataCheck()]
#' @export
parameterRename <- function(missing_column_name, associated_data_column, data_frame){
    expected_column_names <- c("name", "brand", "product_category",
    "product_type", "food_type", "drink_format","drink_type",
    "nutrition_info", "energy_measurement_kj", "energy_measurement_kcal",
    "sugar_measurement_g", "satfat_measurement_g", "salt_measurement_g",
    "sodium_measurement_mg", "fibre_measurement_nsp", "fibre_measurement_aoac",
    "protein_measurement_g", "fvn_measurement_percent", "weight_g",
    "volume_ml", "volume_water_ml")
    if (missing_column_name %in% expected_column_names){
        print(paste("Replacing", associated_data_column, "with", missing_column_name))
        names(data_frame)[names(data_frame) == associated_data_column] <- missing_column_name
    } else {
        print("Please check function arguments; provided parameter does not exist.")
        print(paste("Run inputDataCheck(", deparse(substitute(data_frame)), ") to list missing data.", sep=""))
    }
    return(data_frame)
}