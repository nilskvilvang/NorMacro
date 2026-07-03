
conjuncture_dashboard <- function(data = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  indicators <- c(
    "Industriproduksjon",
    "Byggeaktivitet",
    "Detaljhandel",
    "Tjenesteproduksjon",
    "Konjunkturindikator",
    "Kapasitetsutnytting",
    "Ressursknapphet",
    "Ordrebeholdning",
    "Arbledighetsrate_NAV",
    "Rentekurve"
  )
  
  existing <- intersect(indicators, names(data))
  
  plot_data <- data |>
    dplyr::select(Aar, dplyr::all_of(existing)) |>
    tidyr::pivot_longer(
      cols = -Aar,
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::filter(!is.na(Verdi)) |>
    dplyr::left_join(
      get_metadata() |>
        dplyr::select(Variabel, Beskrivelse, Enhet),
      by = "Variabel"
    )
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = Aar, y = Verdi)
  ) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(
      ggplot2::vars(Variabel),
      scales = "free_y"
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = "Konjunkturdashboard",
      subtitle = "Utvalgte aktivitets-, rente- og konjunkturindikatorer",
      x = NULL,
      y = NULL,
      caption = "Kilde: NorMacro"
    ) +
    ggplot2::theme_minimal()
}
