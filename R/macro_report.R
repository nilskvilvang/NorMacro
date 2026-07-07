
macro_report <- function(data = NULL, year = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  if(is.null(year)){
    year <- max(data$Aar, na.rm = TRUE)
  }
  
  metadata <- get_metadata()
  
  cycle <- business_cycle(data = data) |>
    dplyr::filter(Aar == year)
  
  get_value <- function(variable){
    data |>
      dplyr::filter(Aar == year) |>
      dplyr::pull(dplyr::all_of(variable)) |>
      dplyr::first()
  }
  
  key_vars <- c(
    "BNP_Fastland_vekst",
    "Inflasjon",
    "Arbledighetsrate_NAV",
    "Styringsrente",
    "Pengemarkedsrente_3mnd",
    "Statsrente_10aar",
    "Rentekurve",
    "Industriproduksjon",
    "Byggeaktivitet",
    "Tjenesteproduksjon",
    "Detaljhandel",
    "Konjunkturindikator",
    "Kapasitetsutnytting",
    "Ressursknapphet",
    "Ordrebeholdning"
  )
  
  available <- intersect(key_vars, names(data))
  
  report_table <- tibble::tibble(
    Variabel = available,
    Verdi = purrr::map_dbl(available, get_value)
  ) |>
    dplyr::left_join(
      metadata |>
        dplyr::select(
          Variabel,
          Display_navn,
          Kategori,
          Beskrivelse,
          Enhet,
          Kilde
        ),
      by = "Variabel"
    ) |>
    dplyr::mutate(
      Display_navn = dplyr::if_else(
        is.na(Display_navn) | Display_navn == "",
        Variabel,
        Display_navn
      )
    ) |>
    dplyr::select(
      Display_navn,
      Verdi,
      Enhet,
      Kategori,
      Kilde,
      Variabel
    )
  
  cat("\n")
  cat("NorMacro makrorapport\n")
  cat("=====================\n\n")
  cat("År: ", year, "\n\n", sep = "")
  
  if(nrow(cycle) > 0){
    cat("Konjunkturfase\n")
    cat("--------------\n")
    cat("Fase:  ", cycle$Fase[1], "\n", sep = "")
    cat("Score: ", cycle$Score[1], "\n\n", sep = "")
  }
  
  cat("Nøkkeltall\n")
  cat("----------\n")
  print(
    report_table |>
      dplyr::select(
        Display_navn,
        Verdi,
        Enhet,
        Kategori,
        Kilde
      )
  )
  
  invisible(
    list(
      year = year,
      business_cycle = cycle,
      key_indicators = report_table
    )
  )
}
