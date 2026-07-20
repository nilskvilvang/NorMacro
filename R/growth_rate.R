
growth_rate <- function(x, period) {
  dplyr::if_else(period - dplyr::lag(period) == 1,
                 (x / dplyr::lag(x) - 1) * 100,
                 NA_real_)
  
}
