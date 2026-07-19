
new_comparison_series <- function(
    x,
    normalized = FALSE,
    base_year = NULL
) {
  
  if (!inherits(x, "data.frame")) {
    stop(
      "`x` må være en data.frame eller tibble.",
      call. = FALSE
    )
  }
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Datasett",
    "Land",
    "Variabel",
    "Display_navn",
    "Verdi",
    "Enhet",
    "Kilde"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(x)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }
  
  if (!is.logical(normalized) ||
      length(normalized) != 1 ||
      is.na(normalized)) {
    
    stop(
      "`normalized` må være TRUE eller FALSE.",
      call. = FALSE
    )
  }
  
  if (normalized && is.null(base_year)) {
    stop(
      "`base_year` må oppgis når `normalized = TRUE`.",
      call. = FALSE
    )
  }
  
  if (!is.null(base_year)) {
    
    if (!is.numeric(base_year) ||
        length(base_year) != 1 ||
        is.na(base_year)) {
      
      stop(
        "`base_year` må være ett gyldig årstall.",
        call. = FALSE
      )
    }
    
    base_year <- as.integer(base_year)
  }
  
  x <- tibble::as_tibble(x)
  
  attr(x, "normalized") <- normalized
  attr(x, "base_year") <- base_year
  
  class(x) <- c(
    "comparison_series",
    class(x)
  )
  
  x
}
