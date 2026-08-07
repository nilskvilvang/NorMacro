
clean_kostra_unit_name <- function(x) {
  if (!is.character(x)) {
    return(x)
  }
  
  sub(
    "\\s+-\\s+.*$",
    "",
    x
  )
}
