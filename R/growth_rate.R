
growth_rate <- function(x, time) {
  
  dplyr::if_else(
    time - dplyr::lag(time) == 1,
    (x / dplyr::lag(x) - 1) * 100,
    NA_real_
  )
  
}
