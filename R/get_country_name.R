
get_country_name <- function(country) {
  labels <- c(
    NO = "Norge",
    SE = "Sverige",
    DK = "Danmark",
    FI = "Finland",
    DE = "Tyskland",
    FR = "Frankrike",
    EA20 = "Euroomr\u00e5det",
    EU27_2020 = "EU-27"
  )
  
  result <- unname(labels[country])
  
  missing <- is.na(result)
  
  result[missing] <- country[missing]
  
  result
}
