
#' factory function
#' 
#' This function will parse provided nutrient profiler input
#' and generate a suitable object corresponding to the input
#' 
factory <- function(...) {

    if product_type == "food" {
        return Food(name, brand, units, measurement)
    } elif product_type == "drink" {
        return drink_factory(...)
    }
}

#' drink_factory function
#' 
#' This function will help determine which function to return for creating
#' an object for drinks
#' 
drink_factory(...) {

}