
format_number <- function(x, digits = 2) {
  formatC(
    x,
    format = "f",
    digits = digits,
    big.mark = " ",
    decimal.mark = ","
  )
}

format_pvalue <- function(p) {
  
  dplyr::case_when(
    is.na(p)      ~ NA_character_,
    p < 0.001     ~ "<0,001",
    TRUE          ~ format_number(p, digits = 3)
  )
}

format_percent <- function(x, digits = 1) {
  paste0(format_number(x, digits), " %")
}