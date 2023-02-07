library(methods)

# class BaseProduct
# 
# handles the common attributes expected across all products

setClass("BaseProduct",
    slots = c(
        name = "character",
        brand = "character",
        # could this be from a discrete set
        product_category = "character",
        product_type = "character",
        units = "character",
        energy_units = "character",
        energy_measurement = "numeric",
        sugar_measurement = "numeric",
        fat_measurement = "numeric",
        salt_measurement = "numeric",
        salt_units = "character",
        fibre_measurement = "numeric",
        fibre_units = "character",
        protein_measurement = "numeric",
        fruit_nut_measurement = "numeric"
    ),
    prototype = list(
        name = NA_character_,
        brand = NA_character_,
        # could this be from a discrete set
        product_category = NA_character_,
        product_type = NA_character_,
        units = NA_character_,
        energy_units = NA_character_,
        energy_measurement = NA_real_,
        sugar_measurement = NA_real_,
        fat_measurement = NA_real_,
        salt_measurement = NA_real_,
        salt_units = NA_character_,
        fibre_measurement = NA_real_,
        fibre_units = NA_character_,
        protein_measurement = NA_real_,
        fruit_nut_measurement = NA_real_
        
    )
)


show_BaseProduct <- function(object) {
        cat(is(object)[[1]], "\n",
            "  Name:                        ", object@name, "\n",
            "  Brand:                       ", object@brand, "\n",
            "  Product category:            ", object@product_category, "\n",
            "  Product type:                ", object@product_type, "\n",
            "  Units:                       ", object@units, "\n",
            "  Energy units:                ", object@energy_units, "\n",
            "  Energy measurement:          ", object@energy_measurement, "\n",
            "  Sugar measurement:           ", object@sugar_measurement, "\n",
            "  Fat measurement:             ", object@fat_measurement, "\n",
            "  Salt measurement:            ", object@salt_measurement, "\n",
            "  Salt units:                  ", object@salt_units, "\n",
            "  Fibre measurement:           ", object@fibre_measurement, "\n",
            "  Fibre units:                 ", object@fibre_units, "\n",
            "  Protein measurement:         ", object@protein_measurement, "\n",
            "  Fruit and nuts measurement:  ", object@fruit_nut_measurement, "\n",
      sep = ""
        )

}

setMethod("show", "BaseProduct", function(object) {
    show_BaseProduct(object)
})

#' 
#' 
baseProduct <- function(...) {

    data <- data.frame(...)

    stopifnot("Expected passed dataframe to have a single row" = nrow(data) == 1)

    new("BaseProduct", name = data$name,
                            brand = data$brand,
                            product_category = data$product_category,
                            product_type = data$product_type,
                            units = data$units,
                            energy_units = data$energy_units,
                            energy_measurement = data$energy_measurement,
                            sugar_measurement = data$sugar_measurement,
                            fat_measurement = data$fat_measurement,
                            salt_measurement = data$salt_measurement,
                            salt_units = data$salt_units,
                            fibre_measurement = data$fibre_measurement,
                            fibre_units = data$fibre_units,
                            protein_measurement = data$protein_measurement,
                            fruit_nut_measurement = data$fruit_nut_measurement
                            )

            
}