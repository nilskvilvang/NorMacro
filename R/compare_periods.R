
compare_periods <- function(
    variables,
    start_year,
    end_year,
    data = NULL
){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  missing <- setdiff(variables, names(data))
  
  if(length(missing) > 0){
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", ")
    )
  }
  
  metadata <- get_metadata()
  
  result <- purrr::map_dfr(
    variables,
    function(variable){
      
      x <- data |>
        dplyr::select(
          Aar,
          Verdi = dplyr::all_of(variable)
        )
      
      start_value <- x |>
        dplyr::filter(Aar == start_year) |>
        dplyr::pull(Verdi)
      
      end_value <- x |>
        dplyr::filter(Aar == end_year) |>
        dplyr::pull(Verdi)
      
      start_value <- if(length(start_value) == 0) NA_real_ else start_value
      end_value   <- if(length(end_value) == 0) NA_real_ else end_value
      
      tibble::tibble(
        Variabel = variable,
        Startaar = start_year,
        Sluttaar = end_year,
        Startverdi = start_value,
        Sluttverdi = end_value,
        Endring = end_value - start_value,
        Endring_prosent =
          ifelse(
            is.na(start_value) |
              start_value == 0,
            NA_real_,
            (end_value / start_value - 1) * 100
          )
      )
    }
  )
  
  result |>
    dplyr::left_join(
      metadata |>
        dplyr::select(
          Variabel,
          Kategori,
          Beskrivelse,
          Enhet
        ),
      by = "Variabel"
    ) |>
    dplyr::select(
      Variabel,
      Kategori,
      Beskrivelse,
      Enhet,
      dplyr::everything()
    )
}
