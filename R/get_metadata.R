
get_metadata <- function(data = NULL) {
  
  metadata <- get_normacro_metadata()
  
  if (is.null(data)) {
    return(metadata)
  }
  
  dataset_type <- attr(
    data,
    "dataset_type"
  )
  
  has_kostra_structure <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar"
    ) %in% names(data)
  )
  
  if (
    identical(dataset_type, "kostra") ||
    has_kostra_structure
  ) {
    return(
      get_kostra_metadata(
        data = data
      )
    )
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

