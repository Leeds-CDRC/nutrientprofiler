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

# class SolidFood(BaseProduct)
# 
# variant of BaseProduct for solid foods 
# has a weight attribute and sets units to grams
setClass("SolidFood", 
    contains = "BaseProduct",
    slots = c(
        weight = "numeric"
    ),
    prototype = list(
        units = "g",
        weight = NA_real_
    )
)

# class LiquidFood(BaseProduct)
# 
# variant of BaseProduct for liquid foods 
# has a volume attribute and sets units to ml, also has a food_type for calculating specific gravity
setClass("LiquidFood", 
    contains = "BaseProduct",
    slots = c(
        food_type = "character",
        volume = "numeric"
    ),
    prototype = list(
        food_type = NA_character_,
        volume = NA_real_,
        units = "ml"
    )
)

# class Drink(BaseProduct)
# 
# variant of BaseProduct for drinks 
# sets common attribute of drink_format shared by all drink subclasses
setClass("Drink", 
    contains = "BaseProduct",
    slots = c(
        drink_format = "character"
    ),
    prototype = list(
        drink_format = NA_character_
    )
)

# class ReadyDrink(Drink)
# 
# variant of Drink for ready-to-drink drinks
# has a volume attribute, sets drink_format to `ready` and adds a drink_type attribute for specific gravity
setClass("ReadyDrink", 
    contains = "Drink",
    slots = c(
        drink_type = "character",
        volume = "numeric"
    ),
    prototype = list(
        drink_format = "ready",
        drink_type = NA_character_,
        volume = NA_real_
    )
)

# class PowderedDrink(Drink)
# 
# variant of Drink for powdered drinks
# has a volume and weight attributes, sets drink_format to `powder` and adds a nutrition_info attribute
setClass("PowderedDrink", 
    contains = "Drink",
    slots = c(
        nutrition_info = "character",
        volume = "numeric",
        weight = "numeric"
    ),
    prototype = list(
        drink_format = "powder",
        nutrition_info = NA_character_,
        volume = NA_real_,
        weight = NA_real_
    )
)

# class CordialDrink(Drink)
# 
# variant of Drink for cordial drinks
# has a volume and volume_water attributes, sets drink_format to `cordial` and adds a nutrition_info attribute
setClass("CordialDrink", 
    contains = "Drink",
    slots = c(
        nutrition_info = "character",
        volume = "numeric",
        volume_water = "numeric"
    ),
    prototype = list(
        drink_format = "cordial",
        nutrition_info = NA_character_,
        volume = NA_real_,
        volume_water = NA_real_
    )
)
