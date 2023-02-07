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

