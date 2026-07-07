
growth_table <- function(
    variables,
    data = NULL,
    periods = c(1, 5, 10)
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
  
  one_variable <- function(variable){
    
    x <- data |>
      dplyr::select(Aar, Verdi = dplyr::all_of(variable)) |>
      dplyr::filter(!is.na(Verdi)) |>
      dplyr::arrange(Aar)
    
    if(nrow(x) == 0){
      return(
        tibble::tibble(
          Variabel = variable,
          Siste_aar = NA_integer_,
          Siste_verdi = NA_real_
        )
      )
    }
    
    latest_year <- max(x$Aar)
    latest_value <- x$Verdi[x$Aar == latest_year][1]
    
    out <- tibble::tibble(
      Variabel = variable,
      Siste_aar = latest_year,
      Siste_verdi = latest_value
    )
    
    for(p in periods){
      
      previous <- x |>
        dplyr::filter(Aar == latest_year - p)
      
      growth <- if(nrow(previous) == 0 || is.na(previous$Verdi[1])){
        NA_real_
      } else {
        (latest_value / previous$Verdi[1] - 1) * 100
      }
      
      cagr <- if(nrow(previous) == 0 || is.na(previous$Verdi[1])){
        NA_real_
      } else {
        (latest_value / previous$Verdi[1])^(1 / p) - 1
      }
      
      out[[paste0("Vekst_", p, "aar")]] <- growth
      out[[paste0("CAGR_", p, "aar")]] <- cagr * 100
    }
    
    out
  }
  
  result <- purrr::map_dfr(variables, one_variable)
  
  metadata <- get_metadata()
  
  result |>
    dplyr::mutate(
      Display_navn = get_display_name(Variabel, metadata)
    ) |>
    dplyr::select(
      Display_navn,
      dplyr::everything(),
      -Variabel
    )
}
