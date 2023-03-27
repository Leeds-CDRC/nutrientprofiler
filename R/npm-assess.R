

#' NPM assess function
NPMAssess <- function(row) {

    stopifnot("Score columns not detected. Please ensure you have called NPMScore on your data" = 
        c("energy_score", "sugar_score", "fat_score", 
        "protein_score", "fvn_score", "fibre_score") %in% names(row)
        
    )

    # will use below code as boilerplate
    A_score <- A_scorer(energy_score = row[['energy_score']],
                        sugar_score = row[['sugar_score']], 
                        fat_score = row[['fat_score']], 
                        sodium_score = row[['sodium_score']])

    C_score <- C_scorer(fvn_score = row[['fvn_score']],
                        protein_score = row[['protein_score']], 
                        fibre_score = row[['fibre_score']])   

    NPM_score <- NPM_total(A_score, C_score, row[['fvn_score']], row[['fibre_score']])

    NPM_assessment <- NPM_assess(NPM_score, row[['product_type']])

    npm_df <- data.frame("A_score" = A_score, "C_score" = C_score, "NPM_score" = NPM_score, "NPM_assessment" = NPM_assessment)

    return(npm_df)

}

#' A score function
#' 
#' A scores are defined as the scores for 
#' energy, sugars, fat and sodium summed together
#' 
#' @param energy_score, numeric value for energy score
#' @param sugar_score, numeric value for sugar score
#' @param fat_score, numeric value for fat score
#' @param sodium_score, numeric value for sodium score
#' @return a numeric value of the A score
A_scorer <- function(energy_score, sugar_score, fat_score, sodium_score) {
    return(sum(energy_score, sugar_score, fat_score, sodium_score))
}

#' C score function
#' 
#' C score is defined as the scores for fruit/veg/nut percentage,
#' protein and fibre summed together
#' 
#' @param fvn_score, numeric value for fruit/vegetables/nuts percentage score
#' @param protein_score, numeric value for protein score
#' @param fibre_score, numeric value for fibre score
#' @return a numeric value of the C score
C_scorer <- function(fvn_score, protein_score, fibre_score) {
    return(sum(fvn_score, protein_score, fibre_score))
}

#' NPM_total
#' 
#' A function to calculate total NPM score
#' Logic for this function is documented in 
#' [Nutrient Profiling Technical Guidance](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/216094/dh_123492.pdf)
#' page 6.
#' 
#' @param a_score, a numeric value for the A score
#' @param c_score, a numeric value for the C score
#' @param fvn_score, a numeric value for the specific score for fruit/veg/nuts percentage
#' @param fib_score, a numeric value for the fibre score
#' @return a numeric value for the overall NPM score
NPM_total <- function(a_score, c_score, fvn_score, fib_score) {

    npm_score <- if( a_score >= 11 && fvn_score < 5) {

        a_score - (fvn_score + fib_score)

    } else {
        a_score - c_score
    }
}

#' NPM Assess function
#' 
#' This function takes an NPM score and returns either "PASS" or "FAIL"
#' depending on the `type` argument. Where `type` is either "food" or "drink".
#' 
#' @param NPM_score, a numeric value for the NPM score
#' @param type, a character value of either "food" or "drink" to determine how to assess the score
#' @returns a character value of either "PASS" or "FAIL"
NPM_assess <- function(NPM_score, type) {

    stopifnot(
        "The passed type to NPM_assess does not match expected types " =
            type %in% c("food","drink")
    )

    assessment <- switch(tolower(type),
        "food" = ifelse(NPM_score >= 4, "FAIL", "PASS"),
        "drink" = ifelse(NPM_score >= 1, "FAIL", "PASS"),
        stop(paste0(
            "NPM_assess passed invalid type: ",
            type))
            )

    return(assessment)

}