
get_metadata <- function(data = NULL) {
  
  metadata <- get_normacro_metadata()
  
  if (is.null(data)) {
    return(metadata)
  }
  
  if (
    all(
      c(
        "Land",
        "Aar"
      ) %in% names(data)
    )
  ) {
    variable_names <- setdiff(
      names(data),
      c(
        "Land",
        "Aar"
      )
    )
    
    return(
      metadata |>
        dplyr::filter(
          .data$Omraade == "Internasjonal",
          .data$Variabel %in% variable_names
        )
    )
  }
  
  if ("Aar" %in% names(data)) {
    variable_names <- setdiff(
      names(data),
      "Aar"
    )
    
    return(
      metadata |>
        dplyr::filter(
          .data$Omraade == "Norge",
          .data$Variabel %in% variable_names
        )
    )
  }
  
  stop(
    "`data` har en ukjent struktur.",
    call. = FALSE
  )
}

