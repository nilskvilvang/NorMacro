
plot_series <- function(variable, data = NULL, metadata = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  if(is.null(metadata)){
    metadata <- get_metadata()
  }
  
  if(!variable %in% names(data)){
    stop("Fant ikke variabelen i datasettet: ", variable)
  }
  
  meta <- metadata |>
    dplyr::filter(Variabel == variable)
  
  if(nrow(meta) == 0){
    title <- variable
    subtitle <- NULL
    y_label <- NULL
    caption <- NULL
  } else {
    title <- meta$Display_navn[1]
    subtitle <- meta$Beskrivelse[1]
    y_label <- meta$Enhet[1]
    caption <- paste0("Kilde: ", meta$Kilde[1])
    
    if(is.na(title) || title == ""){
      title <- variable
    }
  }
  
  plot_data <- data |>
    dplyr::select(Aar, Verdi = dplyr::all_of(variable)) |>
    dplyr::filter(!is.na(Verdi))
  
  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = Aar, y = Verdi)
  ) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(
        big.mark = " ",
        decimal.mark = ","
      )
    ) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = y_label,
      caption = caption
    ) +
    ggplot2::theme_minimal()
  
  if(grepl("vekst|inflasjon|rente|rentekurve|andel", variable, ignore.case = TRUE)){
    p <- p +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "dashed",
        linewidth = 0.3
      )
  }
  
  p
}
