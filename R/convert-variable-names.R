#' Imported data variable name converter function
#'
#' This function renames column headers in datasets that use
#' old header titles `fat_measurement_g` and `fruit_nut_measurement_percent`
#' to instead read `satfat_measurement_g` and `fvn_measurement_percent`
#'
#' @param data.frame a data.frame object
#' @returns a data.frame object with updated column names
#' @export
replace_var_names <- function(data_frame){
    if ("fat_measurement_g" %in% names(data_frame)){
        data_frame <- rename(data_frame, satfat_measurement_g = fat_measurement_g)
    }
    if ("fruit_nut_measurement_percent" %in% names(data_frame)){
        data_frame <- rename(data_frame, fvn_measurement_percent = fruit_nut_measurement_percent)
    }
}