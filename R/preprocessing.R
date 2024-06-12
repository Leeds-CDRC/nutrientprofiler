ReqParamCheck <- function(data_frame) {
    expected_column_names <- c("name", "brand", "product_category",
    "product_type", "food_type", "drink_format","drink_type",
    "nutrition_info", "energy_measurement_kj", "energy_measurement_kcal",
    "sugar_measurement_g", "satfat_measurement_g", "salt_measurement_g",
    "sodium_measurement_mg", "fibre_measurement_nsp", "fibre_measurement_aoac",
    "protein_measurement_g", "fvn_measurement_percent", "weight_g",
    "volume_ml", "volume_water_ml")
    auto_defaults <- c("drink_format","food_type","drink_type")
    optional_names <- c("name", "brand", "product_category")
    report_data <- setNames(data.frame(matrix(ncol = length(expected_column_names),nrow = 1)), expected_column_names)
    print(paste("Checking for required data.", optional_names, "are optional parameters and are not checked."))
    print(paste(auto_defaults, "are also optional parameters and not checked, but are required for calculation so defaults will be applied if data is missing."))
    print(paste("Please read documentation for discussion of these defaults and to use functions to check for these optional parameters."))
    # the basic required parameters
    report_data$product_type[1] <- list(
        which((data_frame$product_type == "") | is.na(data_frame$product_type))
        )
    report_data$sugar_measurement_g[1] <- list(
        which((data_frame$sugar_measurement_g == "") | is.na(data_frame$sugar_measurement_g))
        )
    report_data$satfat_measurement_g[1] <- list(
        which((data_frame$satfat_measurement_g == "") | is.na(data_frame$satfat_measurement_g))
        )
    report_data$protein_measurement_g[1] <- list(
        which((data_frame$protein_measurement_g == "") | is.na(data_frame$protein_measurement_g))
        )
    report_data$fvn_measurement_percent[1] <- list(
        which((data_frame$fvn_measurement_percent == "") | is.na(data_frame$fvn_measurement_percent))
        )
    # categories where one option or another is required
    # "energy_measurement_kj", "energy_measurement_kcal",
    report_data$energy_measurement_kj[1] <- list(
        which(((data_frame$energy_measurement_kj == "") | is.na(data_frame$energy_measurement_kj)) & 
        ((data_frame$energy_measurement_kcal == "") | is.na(data_frame$energy_measurement_kcal)))
    )
    # "salt_measurement_g", "sodium_measurement_mg",
    report_data$salt_measurement_g[1] <- list(
        which(((data_frame$salt_measurement_g == "") | is.na(data_frame$salt_measurement_g)) & 
        ((data_frame$sodium_measurement_mg == "") | is.na(data_frame$sodium_measurement_mg)))
    )
    #"fibre_measurement_nsp", "fibre_measurement_aoac",#
    report_data$fibre_measurement_nsp[1] <- list(
        which(((data_frame$fibre_measurement_nsp == "") | is.na(data_frame$fibre_measurement_nsp)) & 
        ((data_frame$fibre_measurement_aoac == "") | is.na(data_frame$fibre_measurement_aoac)))
    )
    #"weight_g", "volume_ml",
    report_data$weight_g[1] <- list(
        which(((data_frame$weight_g == "") | is.na(data_frame$weight_g)) & 
        ((data_frame$volume_ml == "") | is.na(data_frame$volume_ml)))
    )
    # parameters dependent on categories
    # "nutrition_info"
    report_data$nutrition_info[1] <- list(
        which(((data_frame$nutrition_info == "") | is.na(data_frame$nutrition_info)) & 
        ((data_frame$drink_format == "Cordial") | (data_frame$drink_format == "Powdered")))
    )
    # "volume_water_ml"
    report_data$volume_water_ml[1] <- list(
        which(((data_frame$volume_water_ml == "") | is.na(data_frame$volume_water_ml)) & 
        ((data_frame$drink_format == "Cordial") | (data_frame$drink_format == "Powdered")) &
        ((data_frame$nutrition_info != "As consumed")))
    )
    return(report_data)
}

SaveReport <- function(data_frame, file_path) {
    write.csv(t(data_frame), file_path)
}

AutoDefaultParamCheck <- function(data_frame, report_data) {
    report_data$drink_format[1] <- list(
        which(((data_frame$drink_format == "") | is.na(data_frame$drink_format)) & 
        ((data_frame$product_type == "Drink")))
    )
    report_data$drink_type[1] <- list(
        which(((data_frame$drink_type == "") | is.na(data_frame$drink_type)) & 
        ((data_frame$product_type == "Drink")))
    )
    report_data$food_type[1] <- list(
        which(((data_frame$food_type == "") | is.na(data_frame$food_type)) & 
        ((data_frame$product_type == "Food")))
    )
    return(report_data)
}

AutoDefaultParamNote <- function(data_frame, test_report) {
    auto_defaults <- c("drink_format","food_type","drink_type")
    if (!("default_params_used" %in% names(data_frame))) {
        data_frame[,"default_params_used"] = NA
    }
    for (i in auto_defaults) {
        print(paste("Checking", i))
        if (!(is.na(test_report[[i]]) | as.character(test_report[[i]]) == "integer(0)" | as.character(test_report[[i]]) == "NA")) {
            index_values <- test_report[[i]][[1]]
            for (j in index_values) {
                if (is.na(data_frame[j, "default_params_used"])) {
                    data_frame[j, "default_params_used"] <- list(i)
                } else {
                    data_frame[j, "default_params_used"] <- paste(
                        as.character(c(data_frame[j, "default_params_used"], i)), collapse=", "
                        )
                }
                
            }
        }

    }
    return(data_frame)
}